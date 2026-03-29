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
author = DBIO Authors
license = Perl_5

[@DBIO]
```

```ini
# Distribution derived from DBIx::Class code
name = DBIO-PostgreSQL
author = DBIO & DBIx::Class Authors
license = Perl_5

[@DBIO]
heritage = 1
```

```ini
# DBIO core
name = DBIO
author = DBIx::Class & DBIO Contributors (see AUTHORS file)
license = Perl_5
copyright_year = 2005

[@DBIO]
core = 1
heritage = 1
copyright_holder = DBIO Contributors
```

## Key Behaviors

- **`copyright_holder`**: set automatically — `heritage = 1` → `DBIO & DBIx::Class Authors`, otherwise → `DBIO Authors`. Override via `copyright_holder = ...` in the `[@DBIO]` section.
- **LICENSE**: always committed in the repo and gathered from git. Heritage repos use the original DBIx::Class license with DBIO attribution header. Non-heritage repos use a standard Perl_5 license. No `[License]` plugin used.
- **Version**: drivers use git tags (`first_version = 0.900000`); core uses `VersionFromMainModule`.
- **POD**: `@DBIO` for new distributions; `@DBIO::Heritage` for heritage (adds DBIx::Class copyright block).

## Build System

Uses itself via `[Bootstrap::lib]` for self-bootstrapping.

## Standard Commands

```bash
dzil build      # build and check
dzil test       # run tests
dzil release    # release to CPAN
```
