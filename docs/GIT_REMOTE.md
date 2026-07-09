# Git remote (Stage 1.5)

## Deploy key

- Private key: `/var/lib/vpn-project/secrets/git_deploy_ed25519` (mode 600, not in git)
- Public key: `/var/lib/vpn-project/secrets/git_deploy_ed25519.pub`
- SSH client config: `/root/.ssh/config-vpn-project-git`

Add the **public** key to the private remote as a **deploy key with write access**
(GitHub: Settings → Deploy keys → Allow write access).

## What is tracked

Only templates under `configs/**/*.template` and docs/scripts/tests.
Live host configs, secrets, backup manifests, and `*.pub` keys are gitignored.

## Push

```bash
cd /opt/vpn-project
git remote add origin git@github.com:OWNER/REPO.git   # or gitlab
GIT_SSH_COMMAND="ssh -i /var/lib/vpn-project/secrets/git_deploy_ed25519 -o IdentitiesOnly=yes" \
  git push -u origin main
```
