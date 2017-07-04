#!/usr/bin/env perl

use strict;
use Getopt::Long qw(:config no_autoabbrev ignore_case_always);

my $option = 0;
my @opt_mode;
if (! GetOptions(
        "ja"       => sub { $option = 1; push @opt_mode, "ja"; },
        "ko"       => sub { $option = 1; push @opt_mode, "ko"; },
        "sc"       => sub { $option = 1; push @opt_mode, "sc"; },
        "tc"       => sub { $option = 1; push @opt_mode, "tc"; },
) ) {
  print_error("Only --ja, --ko, --sc and --tc are available!\n");
  exit(1);
}

# without any option, all classes are tested
@opt_mode = ("ja", "ko", "sc", "tc") if (!$option);

for my $class (@opt_mode) {
  do_class($class);
}

exit(0);

sub do_class {
  my ($cl) = @_;
  my @embedlist = '';
  # parse the output of kanji-config-updmap status
  print_info("Running \"kanji-config-updmap-sys -$cl status\" ...\n");
  my @foo = `perl ../script/kanji-config-updmap.pl -sys -$cl status`;
  my $lineno = 0;
  for my $l (@foo) {
    $lineno++;
    next if ($l =~ m/^\s*$/);
    if ($l =~ m/^.*:\s*(.*)$/) { push @embedlist, $1; next; }
    # we are still here??
    print_error("Cannot parse line $lineno, exiting.\n");
    print_error("Strange line: >>>$l<<<\n");
    exit (1);
  }
  for my $k (@embedlist) {
    next if (!$k);
    print_info("Running test for $cl-$k ...\n");
    for my $dir (qw/yoko tate/) {
      # first round
      my $curr = "test-$cl-$k-$dir.tex";
      open(FOO, ">", $curr) ||
        die ("Cannot open $curr: $!");
      print FOO "\\let\\DIR\\", "$dir\n";
      print FOO "\\def\\MAPSET", "$cl", "{$k}\n";
      print FOO "\\def\\MAPSET", "$cl", "VAR{}\n";
      print FOO "\\def\\USEOTF{y}\n";
      print FOO "\\def\\CFGLOADED{}\n";
      print FOO "\\input maptest-plain.tex\n";
      close FOO;
      chomp (@foo = `euptex -kanji=utf8 -interaction=nonstopmode $curr`);
      $curr =~ s/.tex$//;
      check_outfile("$curr.dvi");
      chomp (@foo = `dvipdfmx -o $curr-up.pdf $curr.dvi`);
      check_outfile("$curr-up.pdf");
      if ($cl eq 'ja') {
        chomp (@foo = `eptex -kanji=utf8 -interaction=nonstopmode $curr`);
        $curr =~ s/.tex$//;
        check_outfile("$curr.dvi");
        chomp (@foo = `dvipdfmx -o $curr-p.pdf $curr.dvi`);
        check_outfile("$curr-p.pdf");
        chomp (@foo = `kpsewhich ptex-$k-04.map`);
        if (@foo) {
          # second round for JIS04
          $curr = "test-$cl-$k-$dir.tex";
          open(FOO, ">", $curr) ||
            die ("Cannot open $curr: $!");
          print FOO "\\let\\DIR\\", "$dir\n";
          print FOO "\\def\\MAPSET", "$cl", "{$k}\n";
          print FOO "\\def\\MAPSET", "$cl", "VAR{-04}\n";
          print FOO "\\def\\USEOTF{y}\n";
          print FOO "\\def\\CFGLOADED{}\n";
          print FOO "\\input maptest-plain.tex\n";
          close FOO;
          chomp (@foo = `euptex -kanji=utf8 -interaction=nonstopmode $curr`);
          $curr =~ s/.tex$//;
          check_outfile("$curr.dvi");
          chomp (@foo = `dvipdfmx -o $curr-up-04.pdf $curr.dvi`);
          check_outfile("$curr-up-04.pdf");
          chomp (@foo = `eptex -kanji=utf8 -interaction=nonstopmode $curr`);
          $curr =~ s/.tex$//;
          check_outfile("$curr.dvi");
          chomp (@foo = `dvipdfmx -o $curr-p-04.pdf $curr.dvi`);
          check_outfile("$curr-p-04.pdf");
        }
      }
      for my $ext (qw/tex log dvi/) { unlink "$curr.$ext" };
    }
  }
}

sub check_outfile {
  my ($file) = @_;
  if ( ! -f "$file" ) {
    print_error("No output $file!\n");
    exit(1);
  }
}

sub print_info {
  print STDOUT @_;
}
sub print_warning {
  print STDERR "[WARNING]: ", @_;
}
sub print_error {
  print STDERR "[ERROR]: ", @_;
}
