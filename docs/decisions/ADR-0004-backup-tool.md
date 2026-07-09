# ADR-0004: Backup tool (placeholder)

- **Status:** proposed
- **Date:** 2026-07-09

## Context

Need encrypted, restorable backups beyond `tar`/`cp`. Plan default is restic.

## Decision

TBD Stage 3: accept restic unless evaluation prefers borg.

## Consequences

TBD

## Alternatives considered

| Option | Notes |
|--------|-------|
| restic | Encrypt, dedup, prune, simple CLI |
| borgbackup | Strong; slightly heavier UX |
| plain tar | Insufficient alone |
