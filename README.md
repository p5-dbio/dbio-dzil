# Dist-Zilla-PluginBundle-DBIO

The standard Dist::Zilla plugin bundle for all DBIO distributions.

## Scope

- `Dist::Zilla::PluginBundle::DBIO` -- the `[@DBIO]` plugin bundle
- `Pod::Weaver::PluginBundle::DBIO` -- the `@DBIO` PodWeaver config

## Usage

```ini
# dist.ini for a DBIO driver
name = DBIO-DriverName
author = DBIO & DBIx::Class Authors
license = Perl_5

[@DBIO]
```

For DBIO core:

```ini
[@DBIO]
core = 1
```

## Features

- Version from git tags (first release: 0.900000)
- PodWeaver with `=attr` and `=method` collectors
- Custom copyright: DBIO Authors + DBIx::Class Authors
- GitHub metadata and issue tracking
- Self-bootstrapping via `[Bootstrap::lib]`
