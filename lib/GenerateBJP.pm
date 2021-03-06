#!/usr/bin/perl

package GenerateBJP;

use strict;
use warnings;


# Modules import
################################################################################

use YAML::Syck;
$YAML::Syck::ImplicitTyping = 1;
$YAML::Syck::Headless = 1;
use File::Slurp qw(read_file write_file);


# Configuration section
################################################################################

my $command = "python3";
my $latexScript = "latex/bjp.py";



# Functions
################################################################################



sub generate_conf {
  my $doc = shift;
  my $file = shift;
  
  # Create a new object with a single hashref document
  #my $yaml = YAML::Tiny->new( $doc );
  
  # Save both documents to a file
  #$yaml->write( $file );
  open(my $fh, ">:encoding(UTF-8)", $file);
  DumpFile($fh, $doc);


}


# Entry point
################################################################################


sub displayBJP {
  my $params = shift @_;
  my $script_path = shift @_;

  # All parameters are facultative except uid
  die "uid parameter not present" unless $params->{uuid};

  my $cal = $params->{"output-half"};

  $cal =~ s/\],/|/g;      # replacing dates separators (,) by |
  $cal =~ s/[\[\]]//g;    # deleting [ and ]

  $cal =~ s/"*0\.1"*/am/g; # replace half-day notation by OK, ma, am
  $cal =~ s/"*1\.0"*/ma/g;
  $cal =~ s/"*1\.1"*/OK/g;

  # create the hash
  my %cal = map { split /,/ } split /\|/, $cal;

  # truncate the timestamp to 10 characters
  %cal = map { substr($_, 0, 10) => $cal{$_} } keys %cal; 

  # get month and year
  my $month = (localtime((keys %cal)[0]))[4] + 1;
  my $year = (localtime((keys %cal)[0]))[5] + 1900;

  # recreate the hash with the number of the day as key
  %cal = map { (localtime($_))[3] => $cal{$_} } keys %cal;

  # Count days number
  my $full_days = 0;
  my $half_days = 0;
  foreach my $key ( keys %cal ) {
    $full_days++ if $cal{$key} =~ /OK/;
    $half_days++ if $cal{$key} =~ /ma/ or $cal{$key} =~ /am/;
  }
  my $total_days = $full_days + $half_days / 2;

  my $calendar = \%cal;

  my $conf = {
    client => {
      nom => $params->{cname},
      contact => "$params->{ccontactname} / $params->{ccontacttel}",
      adresse => $params->{ccontactaddress}."\n",
    },
    linagora => {
      responsable => $params->{umanager},
      intervenant => $params->{uname},
    },
    mission => {
      prestation => $params->{missionname},
      projet => $params->{missioncode},
      nature => $params->{missionnature},
    },
    annee => $year,
    mois => $month,
    calendrier => $calendar,
  };

  my $yaml_file = "latex/var/bjp-".time().".yml";

  # Generate yaml file from received form information
  &generate_conf($conf, $yaml_file);

  # Script getting yaml file and generating cartouche.tex and calendrier.tikz
  system($command, $latexScript, $yaml_file);
  if ( $? == -1 )
  {
    print STDERR "command failed: $!\n";
  }

  # susbstitute days number
  my $file_data = read_file 'latex/bjp.tex', {binmode => ':utf8'};
  $file_data =~ s/Nombre de jours : [0-9.,]+/Nombre de jours : $total_days/g;
  write_file 'latex/bjp.tex', {binmode => ':utf8'}, $file_data;

  # Generating pdf from all latex files bjp.tex includes cartouche and calendrier
  system("latexmk", "-gg", "-pdf", "-outdir=$script_path/latex", "latex/bjp.tex");
  if ( $? == -1 )
  {
    print STDERR "command failed: $!\n";
  }

  return "bjp-".$params->{uuid}."-".time().".pdf";
}



1;

