# configs/

Only `*.template`, `*.example`, and README files are tracked by git.

Live files under `/etc/vpn-project` and host paths (`/etc/ssh`, `/etc/fail2ban`, UFW)
are applied from templates by Stage scripts — never commit live dumps or secrets.
