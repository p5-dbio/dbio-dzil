package Pod::Weaver::PluginBundle::DBIO::Heritage;
# ABSTRACT: Pod::Weaver configuration for DBIO heritage distributions
our $VERSION = '0.900001';
use strict;
use warnings;

=head1 SYNOPSIS

  [PodWeaver]
  config_plugin = @DBIO::Heritage

=head1 DESCRIPTION

Variant of L<Pod::Weaver::PluginBundle::DBIO> for distributions derived
from DBIx::Class code. Identical in structure but adds the DBIx::Class
copyright attribution to the generated B<COPYRIGHT AND LICENSE> section.

Used automatically by L<Dist::Zilla::PluginBundle::DBIO> when C<heritage = 1>.

=cut

use parent 'Pod::Weaver::PluginBundle::DBIO';

sub mvp_bundle_config {
  my ($class, $args) = @_;
  $args->{payload}{heritage} = 1;
  return Pod::Weaver::PluginBundle::DBIO::mvp_bundle_config($class, $args);
}

1;
