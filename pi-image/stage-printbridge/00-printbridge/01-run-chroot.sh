#!/bin/bash -e
# Bakt een eerste-boot oneshot in het image: zodra er netwerk is, installeert de
# Pi automatisch de nieuwste Print Bridge-release via de publieke one-liner (als
# de uid-1000 gebruiker, die op Pi OS passwordless sudo heeft), en schakelt zich
# daarna uit. Idempotent via ConditionPathExists. pi-gen levert per flash een
# verse machine-id + SSH-host-keys, dus geen identiteit-botsing tussen kaartjes.
on_chroot << 'EOF'
cat > /usr/local/sbin/cooltools-autoinstall <<'SCRIPT'
#!/bin/bash
set -e
U="$(getent passwd 1000 | cut -d: -f1)"
[ -n "$U" ] || U=cooltools
# White-label: pas hieronder de merknaam aan die tijdens de installatie verschijnt.
export PRINT_BRAND="Cooltools Print Server"
exec runuser -u "$U" --whitelist-environment=PRINT_BRAND -- bash -c \
  'curl -fsSL https://github.com/Coolentools/cooltools-print-releases/releases/latest/download/install.sh | bash'
SCRIPT
chmod 0755 /usr/local/sbin/cooltools-autoinstall

cat > /etc/systemd/system/cooltools-autoinstall.service <<'UNIT'
[Unit]
Description=Cool Tools Print Bridge eerste-boot installatie
After=network-online.target
Wants=network-online.target
ConditionPathExists=!/opt/cooltools-print/run.py

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/sbin/cooltools-autoinstall
ExecStartPost=/bin/systemctl disable cooltools-autoinstall.service
TimeoutStartSec=1800

[Install]
WantedBy=multi-user.target
UNIT
systemctl enable cooltools-autoinstall.service
EOF
