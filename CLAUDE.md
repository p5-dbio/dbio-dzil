# CLAUDE.md -- Dist::Zilla::PluginBundle::DBIO

## Project Vision

The standard Dist::Zilla plugin bundle for all DBIO distributions. Provides a fixed, no-configuration build/test/release workflow.

## Namespace

- `Dist::Zilla::PluginBundle::DBIO` — the `[@DBIO]` plugin bundle
- `Dist::Zilla::Plugin::DBIO::HeritageLicense` — (removed, no longer needed)
- `Pod::Weaver::PluginBundle::DBIO` — the `@DBIO` PodWeaver config
- `Pod::Weaver::PluginBundle::DBIO::Heritage` — subclass that adds DBIx::Class copyright attribution

## Usage

```ini
# New DBIO distribution
name = DBIO-MyDriver

[@DBIO]
```

```ini
# Distribution derived from DBIx::Class code
name = DBIO-PostgreSQL

[@DBIO]
heritage = 1
```

```ini
# DBIO core
name           = DBIO
copyright_year = 2005

[@DBIO]
core     = 1
heritage = 1
```

## Key Behaviors

- **`author`**: set automatically — `heritage = 1` → `DBIO & DBIx::Class Authors`, otherwise → `DBIO Authors`. No `author =` needed in `dist.ini`.
- **`license`**: always `Perl_5` in META, set automatically. No `license =` needed in `dist.ini`. No `[License]` plugin — LICENSE file is committed in every repo and gathered from git.
- **`copyright_holder`**: set automatically — same logic as `author`. Override via `copyright_holder = ...` in the `[@DBIO]` section.
- **LICENSE file**: always committed in the repo. Heritage repos use the original DBIx::Class license with DBIO attribution header. Non-heritage repos use a standard Perl_5 license.
- **Version**: drivers use git tags (`first_version = 0.900000`); core uses `VersionFromMainModule`.
- **POD**: `@DBIO` for new distributions; `@DBIO::Heritage` for heritage (adds DBIx::Class copyright block).

## Build System

Uses itself via `[Bootstrap::lib]` for self-bootstrapping.

## Versioning — NEVER bump $VERSION manually

`$VERSION` in the module is managed by `RewriteVersion::Transitional` (part of
`@Git::VersionManager`). It is rewritten automatically during `dzil release`
based on the git tag. **Never edit `$VERSION` by hand.** The value in the source
between releases is the *previous* released version — that is correct and
intentional.

Similarly, never add a version line to `Changes` — `{{$NEXT}}` is filled in by
`NextRelease` during `dzil release`. Just add bullet points under `{{$NEXT}}`.

## Standard Commands

```bash
dzil build      # build and check
dzil test       # run tests
dzil release    # release to CPAN — must be run by the user, not by AI
```
