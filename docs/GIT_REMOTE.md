# Git remote (Stage 1.5)

## Remote

- URL: `git@github.com:cheesewhe/pilot-vpn.git`
- Branch: `main` tracks `origin/main`
- Visibility: private

## Deploy key

- Private key: `/var/lib/vpn-project/secrets/git_deploy_ed25519` (mode 600, **not in git**)
- Public key: `/var/lib/vpn-project/secrets/git_deploy_ed25519.pub`
- SSH helper config: `/root/.ssh/config-vpn-project-git`

## Push

```bash
cd /opt/vpn-project
GIT_SSH_COMMAND="ssh -i /var/lib/vpn-project/secrets/git_deploy_ed25519 -o IdentitiesOnly=yes" \
  git push
```

## Tracked vs ignored

Tracked: docs, scripts, tests, `configs/**/*.template`, ADRs.
Ignored: secrets, live conf dumps, backup manifests, `*.pub`, `.env`, restic data.
