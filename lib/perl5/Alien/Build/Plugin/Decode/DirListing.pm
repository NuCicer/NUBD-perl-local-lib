package Alien::Build::Plugin::Decode::DirListing;

use strict;
use warnings;
use Alien::Build::Plugin;
use File::Basename ();

# ABSTRACT: Plugin to extract links from a directory listing
our $VERSION = '1.69'; # VERSION


sub init
{
  my($self, $meta) = @_;

  $meta->add_requires('share' => 'File::Listing' => 0);
  $meta->add_requires('share' => 'URI' => 0);
  
  $meta->register_hook( decode => sub {
    my(undef, $res) = @_;
    
    die "do not know how to decode @{[ $res->{type} ]}"
      unless $res->{type} eq 'dir_listing';
    
    my $base = URI->new($res->{base});
    
    return {
      type => 'list',
      list => [
        map {
          my($name) = @$_;
          my $basename = $name;
          $basename =~ s{/$}{};
          my %h = (
            filename => File::Basename::basename($basename),
            url      => URI->new_abs($name, $base)->as_string,
          );
          \%h;
        } File::Listing::parse_dir($res->{content})
      ],
    };
  });

  $self;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Build::Plugin::Decode::DirListing - Plugin to extract links from a directory listing

=head1 VERSION

version 1.69

=head1 SYNOPSIS

 use alienfile;
 plugin 'Decode::DirListing';

=head1 DESCRIPTION

Note: in most case you will want to use L<Alien::Build::Plugin::Download::Negotiate>
instead.  It picks the appropriate decode plugin based on your platform and environment.
In some cases you may need to use this plugin directly instead.

This plugin decodes a ftp file listing into a list of candidates for your Prefer plugin.
It is useful when fetching from an FTP server via L<Alien::Build::Plugin::Fetch::LWP>.

=head1 SEE ALSO

L<Alien::Build::Plugin::Download::Negotiate>, L<Alien::Build::Plugin::Decode::DirListingFtpcopy>, L<Alien::Build>, L<alienfile>, L<Alien::Build::MM>, L<Alien>

=head1 AUTHOR

Author: Graham Ollis E<lt>plicease@cpan.orgE<gt>

Contributors:

Diab Jerius (DJERIUS)

Roy Storey

Ilya Pavlov

David Mertens (run4flat)

Mark Nunberg (mordy, mnunberg)

Christian Walde (Mithaldu)

Brian Wightman (MidLifeXis)

Zaki Mughal (zmughal)

mohawk (mohawk2, ETJ)

Vikas N Kumar (vikasnkumar)

Flavio Poletti (polettix)

Salvador Fandiño (salva)

Gianni Ceccarelli (dakkar)

Pavel Shaydo (zwon, trinitum)

Kang-min Liu (劉康民, gugod)

Nicholas Shipp (nshp)

Juan Julián Merelo Guervós (JJ)

Joel Berger (JBERGER)

Petr Pisar (ppisar)

Lance Wicks (LANCEW)

Ahmad Fatoum (a3f, ATHREEF)

José Joaquín Atria (JJATRIA)

Duke Leto (LETO)

Shoichi Kaji (SKAJI)

Shawn Laffan (SLAFFAN)

Paul Evans (leonerd, PEVANS)

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011-2019 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
