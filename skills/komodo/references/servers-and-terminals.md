# Komodo servers and terminals

Each managed server runs **Periphery**, an agent that establishes a bidirectional WebSocket connection to Komodo Core. Core does not manage a host merely because it can reach SSH or Docker. Periphery is the host boundary for server state, Docker resources, and terminal access, so treat it as privileged software.

## Connecting another server

The documented onboarding flow is: create an onboarding key in Core, install Periphery on the target host with the Core address and key, then confirm the server reports **OK**. The official docs describe systemd, a container, and direct process-manager approaches; they recommend systemd as the simplest option and note container-specific complications. Choose with awareness of the host's service-management and Docker model.

Before onboarding, establish the exact host and Core URL, the route and firewall policy for the WebSocket connection, expected server identity, Periphery version, and how the onboarding key will be handled. Use the smallest appropriate permissions. Do not paste an onboarding key into logs, shell history, source control, or a public issue. Confirm connectivity and host identity in the UI after install. If the status is not OK, check the current connection docs, address/TLS trust, network path, and Periphery logs without exposing tokens or private config.

## Server and container terminals

Komodo provides browser terminal sessions for a connected server and for running containers. A server session is a shell on the host. A container session can use **Exec**, which starts a new process in the container, or **Attach**, which connects to its main process. Exec is the usual interactive shell mode; Attach interacts with the primary process and has different consequences.

Sessions are named per target, have independent PTYs and output history, and can be shared by multiple connected users. The inspected docs say sessions persist until deleted or Periphery restarts. Treat terminal output and history as potentially sensitive, and remember that a terminal can make direct host or workload changes outside the usual resource configuration review. Prefer read-only inspection where possible. Do not use a terminal for password resets.

## Choose the right surface

- To see host health or Docker objects, use the server/resource view rather than opening a shell by default.
- To inspect a running container interactively, choose Exec unless interacting with the main process is specifically intended.
- To execute or automate a command, do not assume the browser terminal's interactive behavior or persistence maps to a safe scheduled workflow. Use a documented, reviewed automation path and verify its behavior separately.

Canonical references:

- [Connect servers](https://komo.do/docs/setup/connect-servers)
- [Terminals](https://komo.do/docs/terminals)
- [Resources](https://komo.do/docs/resources)

The captured official pages date to 2026-09-28. Verify current onboarding steps, key handling, default terminal command, permissions, and session behavior for the installed Komodo version. No live server or terminal was accessed for this reference.