#!/usr/bin/env python3
"""Send approved PowerShell over the existing CPC SSH alias. Never prints payload."""
import base64
import subprocess
import sys

def main():
    script = sys.stdin.read()
    if not script.strip():
        print('PowerShell input required', file=sys.stderr)
        return 2
    wrapped = "$ErrorActionPreference='Stop';$ProgressPreference='SilentlyContinue';\n" + script
    encoded = base64.b64encode(wrapped.encode('utf-16le')).decode('ascii')
    try:
        result = subprocess.run(
            ['ssh', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10', 'cpc',
             'powershell -NoProfile -NonInteractive -EncodedCommand ' + encoded],
            timeout=90, check=False)
        return result.returncode
    except subprocess.TimeoutExpired:
        print('CPC request timed out; inspect owned remote process before retry', file=sys.stderr)
        return 124

if __name__ == '__main__':
    sys.exit(main())
