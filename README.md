# Print Bridge — print server releases

Public releases of the **Print Bridge print server**: the self-hosted
companion (typically a Raspberry Pi) for the Odoo app
**Print Bridge** (`cooltools_print_bridge`). Odoo queues print jobs; this
server fetches them outbound (pull) and drives your Zebra / Brother / DYMO /
CUPS printers. No cloud, no port-forwarding.

## Quick start (Raspberry Pi OS / Debian)

```bash
curl -fsSL https://github.com/Coolentools/cooltools-print-releases/releases/latest/download/install.sh | bash
```

The installer downloads the latest tarball, verifies its SHA-256, installs
dependencies and registers a systemd service. Then open the web UI
(`http://<pi>:8000`), go to **Settings → Connect to Odoo** and enter the
URL + token from the connect wizard in Odoo (Print Bridge dashboard →
*Connect print server*).

## Updating

Re-run the same one-liner — the installer detects an existing installation
and upgrades in place.

## Verifying a download

Every release ships `cooltools-print.tar.gz.sha256`:

```bash
sha256sum -c cooltools-print.tar.gz.sha256
```

## Compatibility

| Print server | Odoo module | Notes |
|---|---|---|
| 1.8.x | 19.0.51+ | API 1.1 (per-label rotation, per-node tokens) |
| 1.2.x | 19.0.27+ | API 1.0 |

Older combinations keep printing — unknown payload keys are ignored; the
Odoo connection diagnosis warns when a print server is older than the
recommended minimum.
