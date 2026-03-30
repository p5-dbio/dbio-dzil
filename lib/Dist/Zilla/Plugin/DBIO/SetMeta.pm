package Dist::Zilla::Plugin::DBIO::SetMeta;
# ABSTRACT: Set author, copyright_holder, and license on the Dist::Zilla object
our $VERSION = '0.900002';
use Moose;
with 'Dist::Zilla::Role::Plugin', 'Dist::Zilla::Role::BeforeBuild';

has author => (is => 'ro', isa => 'Str', required => 1);
has holder => (is => 'ro', isa => 'Str', required => 1);

sub before_build {
  my ($self) = @_;
  my $zilla = $self->zilla;

  my %attr = map { $_->name => $_ } $zilla->meta->get_all_attributes;

  $attr{authors}->set_value($zilla, [$self->author]);
  $attr{_copyright_holder}->set_value($zilla, $self->holder);
  $attr{_license_class}->set_value($zilla, 'Perl_5');
}

__PACKAGE__->meta->make_immutable;
no Moose;
