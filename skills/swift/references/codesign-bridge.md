# GUI-session code-signing bridge

Load this reference before attempting a signed build or device installation from a background
SSH session on macOS.

## Why a bridge may be required

Apple code signing can depend on the interactive login security context. A signing identity that
works from Terminal in the logged-in desktop session may fail from a background SSH session with
`errSecInternalComponent`, even when the login keychain is unlocked.

Confirm the session difference before changing keychain permissions:

```bash
launchctl managername
security find-identity -v -p codesigning
```

If the identity works interactively but not through SSH, route the signed operation through a
user LaunchAgent that already runs in the desktop session.

## Portable bridge shape

1. Install a repository-owned LaunchAgent for the logged-in developer account.
2. Have the SSH-side wrapper write non-secret request data to a repository-owned state directory.
3. Reset a status marker and kick-start the GUI-scoped agent.
4. Let the agent regenerate, build, install, and optionally launch the app.
5. Write an atomic `OK`, `SKIP`, or `FAIL` result and keep detailed logs in a user-owned log path.
6. Have the SSH-side wrapper poll with a timeout and return the agent's result.

Resolve the GUI domain dynamically rather than hard-coding a user id:

```bash
console_uid="$(id -u)"
launchctl print "gui/$console_uid/$LAUNCH_AGENT_LABEL"
launchctl kickstart -k "gui/$console_uid/$LAUNCH_AGENT_LABEL"
```

The repository should provide a checked-in LaunchAgent template and wrapper scripts while keeping
developer-specific labels, paths, destinations, and signing values in ignored configuration.

## Build and install sequence

Inside the GUI-session agent:

```bash
xcodegen generate
xcodebuild build \
  -scheme "$SCHEME" \
  -destination 'generic/platform=iOS' \
  -allowProvisioningUpdates \
  -xcconfig "$SIGNING_XCCONFIG"
xcrun devicectl device install app --device "$DEVICE_ID" "$BUILT_APP"
```

Treat application launch as best-effort: installation can succeed while a locked device refuses
to launch the app. Report those two outcomes separately.

## Safety requirements

- Never place private keys, passwords, or token values in request files, process arguments, or
  logs.
- Require restrictive permissions on state and log directories.
- Validate the requested scheme, destination, and artifact path before executing them.
- Set a finite polling timeout and surface the agent log path when the operation fails.
- Do not use passwordless privilege escalation as a substitute for the correct user session.
