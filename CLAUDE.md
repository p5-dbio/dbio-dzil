# CLAUDE.md -- Dist::Zilla::PluginBundle::DBIO

## Project Vision

The standard Dist::Zilla plugin bundle for all DBIO distributions. Provides a fixed, no-configuration build/test/release workflow.

**Status**: Initial development.

## Namespace

- `Dist::Zilla::PluginBundle::DBIO` -- the `[@DBIO]` plugin bundle
- `Pod::Weaver::PluginBundle::DBIO` -- the `@DBIO` PodWeaver config

## Usage

```ini
# dist.ini
name = DBIO-MyDriver
author = DBIO Authors
license = Perl_5

[@DBIO]
```

## Build System

Uses itself via `[Bootstrap::lib]` for self-bootstrapping.
