package Dist::Zilla::PluginBundle::DBIO;
# ABSTRACT: Dist::Zilla plugin bundle for DBIO distributions
our $VERSION = '0.001';
use Moose;
use Dist::Zilla;
with 'Dist::Zilla::Role::PluginBundle::Easy';

=head1 SYNOPSIS

  # Driver dist.ini — that's all you need
  name = DBIO-MyDriver
  author = DBIO & DBIx::Class Authors
  license = Perl_5

  [@DBIO]

  # DBIO core dist.ini
  name = DBIO
  author = DBIx::Class & DBIO Contributors (see AUTHORS file)
  license = Perl_5
  copyright_holder = DBIO Contributors
  copyright_year = 2005

  [@DBIO]
  core = 1

  [MetaNoIndex]
  directory = lib/DBIO/Admin
  ; ...

  [MetaResources]
  repository.type = git
  ; ...

=head1 DESCRIPTION

Standard L<Dist::Zilla> plugin bundle for all DBIO distributions.

For drivers: no configuration needed. Version comes from git tags,
copyright is a custom dual notice in POD.

For DBIO core: set C<core = 1> to use L<Dist::Zilla::Plugin::VersionFromMainModule>
and L<Dist::Zilla::Plugin::MakeMaker::Awesome> instead. Add extra plugins
(MetaNoIndex, MetaResources) after the bundle in dist.ini.

=attr core

Set to 1 for DBIO core. Changes version handling and MakeMaker.

=cut

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;
use Dist::Zilla::PluginBundle::Git::VersionManager;

has core => (
  is      => 'ro',
  isa     => 'Bool',
  lazy    => 1,
  default => sub { $_[0]->payload->{core} },
);

sub configure {
  my ($self) = @_;

  # File gathering — core has extra excludes
  my @exclude_filenames = qw(
    META.yml META.json MANIFEST README LICENSE CLAUDE.md
  );
  my @exclude_match;

  if ($self->core) {
    push @exclude_filenames, qw(
      README.md Dockerfile .mailmap .dir-locals.el .gitattributes
      Features_09 TODO
    );
    push @exclude_match, qw(
      ^maint/ ^inc/ ^cover_db/ ^\.claude/ ^t/var/ docker-compose
    );
  }

  $self->add_plugins([ 'Git::GatherDir' => {
    exclude_filename => \@exclude_filenames,
    @exclude_match ? ( exclude_match => \@exclude_match ) : (),
  }]);

  $self->add_plugins('PruneCruft');

  # Metadata
  $self->add_plugins(qw(
    MetaJSON
    MetaYAML
    MetaConfig
    MetaProvides::Package
    Prereqs::FromCPANfile
  ));

  # Version — core uses VersionFromMainModule, drivers use git tags
  if ($self->core) {
    $self->add_plugins('VersionFromMainModule');
  }

  # POD
  $self->add_plugins([
    PodWeaver => { config_plugin => '@DBIO' }
  ]);

  # Tests
  $self->add_plugins('ExtraTests');

  # Build — core uses MakeMaker::Awesome
  if ($self->core) {
    $self->add_plugins([ 'MakeMaker::Awesome' => { eumm_version => '6.78' } ]);
    $self->add_plugins([ 'ExecDir' => { dir => 'script' } ]);
  } else {
    $self->add_plugins('MakeMaker');
  }

  # Distribution files
  $self->add_plugins(qw(
    License
    Readme
    ManifestSkip
    Manifest
  ));

  # GitHub — drivers get auto-detected GithubMeta, core adds MetaResources manually
  unless ($self->core) {
    $self->add_plugins([ 'GithubMeta' => { issues => 1 } ]);
  }

  # Git checks
  $self->add_plugins([ 'Git::Check' => {
    allow_dirty => [qw( dist.ini Changes cpanfile )],
  }]);

  $self->add_plugins([
    'Git::CheckFor::CorrectBranch' => { release_branch => 'main' },
  ]);

  # Release workflow
  if ($self->core) {
    # Core: simple git workflow, version from module
    $self->add_plugins(
      'Git::Commit',
      [ 'Git::Tag' => { tag_format => 'v%V' } ],
      'Git::Push',
    );
  } else {
    # Drivers: version from git tags
    $self->add_bundle('@Git::VersionManager' => {
      'RewriteVersion::Transitional.fallback_version_provider' => 'Git::NextVersion',
      'RewriteVersion::Transitional.global' => 1,
      'Git::NextVersion.first_version' => '0.900000',
      'Git::Tag.tag_format' => 'v%V',
    });

    $self->add_plugins([
      'Git::Push' => { push_to => 'origin' },
    ]);
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;
