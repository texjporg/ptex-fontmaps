#!/usr/bin/env perl
# kanji-config-updmap: setup Japanese font embedding
# Version $VER$
#
# formerly known as updmap-setup-kanji
#
# Copyright 2004-2006 by KOBAYASHI R. Taizo for the shell version (updmap-otf)
# Copyright 2011-2019 by PREINING Norbert
# Copyright 2016-2019 by Japanese TeX Development Community
#
# This file is licensed under GPL version 3 or any later version.
# For copyright statements see end of file.
#
# For development see
#  https://github.com/texjporg/jfontmaps
#
# For a changelog see the git log
#

$^W = 1;
use Getopt::Long qw(:config no_autoabbrev ignore_case_always);
use strict;

my $prg = "kanji-config-updmap";
my $version = '$VER$';

my $updmap_real = "updmap";
my $updmap = $updmap_real;

# copied from updmap.pl
# which programs are available for various writing styles
# this gives
#  jaEmbed.ptex, jaEmbed.otf, jaEmbed.uptex, jaEmbed.otf-up
#  koEmbed.otf, koEmbed.otf-up
# etc
my @supported_writing_styles = qw/ja ko tc sc/;
my %kanji_map_progs = (
  ja => [ qw/ptex otf uptex otf-up/ ],
  ko => [ qw/otf uptex/ ],
  sc => [ qw/otf uptex/ ],
  tc => [ qw/otf uptex/ ]
);

my $dry_run = 0;
my $opt_help = 0;
my $opt_jis = 0;
my $opt_sys = 0;
my $opt_user = 0;
my $opt_old = 0;
my $opt_mode_one;
my $opt_mode_ja;
my $opt_mode_sc;
my $opt_mode_tc;
my $opt_mode_ko;

if (! GetOptions(
        "n|dry-run" => \$dry_run,
        "h|help" => \$opt_help,
        "jis2004" => \$opt_jis,
        "mode=s"   => \$opt_mode_one,
        "ja=s"     => \$opt_mode_ja,
        "sc=s"     => \$opt_mode_sc,
        "tc=s"     => \$opt_mode_tc,
        "ko=s"     => \$opt_mode_ko,
        "sys"      => \$opt_sys,
        "user"     => \$opt_user,
        "old"      => \$opt_old,
        "version"  => sub { print &version(); exit(0); }, ) ) {
  die "Try \"$0 --help\" for more information.\n";
}

#
# BACKWARD COMPATIBILITY MODE
#
if (defined($opt_mode_one) || defined($opt_mode_ja) || defined($opt_mode_sc) ||
    defined($opt_mode_tc) || defined($opt_mode_ko)) {
  my $backMode;
  if (scalar grep(/=/, @ARGV)) {
    die "Mixing of compatibility mode with arguments of the form NN[.PP]=<fam> is not supported!";
  }
  if ($opt_mode_one) {
    if (defined($opt_mode_ja) || defined($opt_mode_sc) ||
        defined($opt_mode_tc) || defined($opt_mode_ko)) {
      die "Options --ja/--sc/--tc/--ko are invalid with --mode=NN!\n";
    }
    # define a corresponding option by empty string
    if (member($opt_mode_one, @supported_writing_styles)) {
      $backMode = $opt_mode_one;
    } else {
      die "Unknown mode $opt_mode_one!";
    }
    # we don't have the --ja=familiy stuff!
    @ARGV = map { "$backMode=$_" } @ARGV;
  } else {
    # case --ja=<fam>
    # in this case we are not allowed to have any further ARGV
    if ($#ARGV >= 0) {
      die "Unexpected argument(s) @ARGV";
    }
    if (defined($opt_mode_ja)) {
      push @ARGV, "ja=$opt_mode_ja";
    } 
    if (defined($opt_mode_ko)) {
      push @ARGV, "ko=$opt_mode_ko";
    }
    if (defined($opt_mode_tc)) {
      push @ARGV, "tc=$opt_mode_tc";
    }
    if (defined($opt_mode_sc)) {
      push @ARGV, "sc=$opt_mode_sc";
    }
  }
  # print "DEBUG CONVERTED ARGUMENTS: @ARGV\n";
}
#
# BACKWARD COMPATIBILITY MODE II
#
if ($#ARGV < 0) {
  die "Missing argument, try \"$0 --help\" for more information.\n";
}
if ($ARGV[0] !~ m/=/) {
  $ARGV[0] = "ja=" . $ARGV[0];
}

sub win32 { return ($^O=~/^MSWin(32|64)$/i); }
my $nul = (win32() ? 'nul' : '/dev/null') ;

if (defined($ARGV[0]) && $ARGV[0] ne "status") {
  if (!($opt_user || $opt_sys)) {
    die "Either -user or -sys mode is required.";
  }
}

if ($opt_user && $opt_sys) {
  die "Only one of -user and -sys can be used!";
}

if ($opt_sys) {
  $updmap = "$updmap --sys" ;
  $updmap_real = "$updmap_real --sys" ;
} else {
  # TeX Live 2017 requires --user option
  # try to determine the version of updmap installed
  my $updver = `updmap --version 2>&1`;
  if ($updver =~ m/^updmap version r([0-9]*) /) {
    if ($1 >= 44080) {
      $updmap = "$updmap --user" ;
      $updmap_real = "$updmap_real --user" ;
    } # else nothing to do, already set up for old updmap
  } else {
    # not recognized updmap -> assume new updmap unless --old
    if (!$opt_old) {
      $updmap = "$updmap --user" ;
      $updmap_real = "$updmap_real --user" ;
    }
  }
}
if ($dry_run) {
  $updmap = "echo updmap";
}

if ($opt_help) {
  Usage();
  exit(0);
}

#
# representatives of support font families
#
my %representatives;
my @databaselist = "ptex-fontmaps-data.dat";
push @databaselist, "ptex-fontmaps-macos-data.dat" if (macosx_new());


main(@ARGV);

sub macosx { return ($^O=~/^darwin$/i); }

sub macosx_new {
  if (macosx()) {
    my $macos_ver = `sw_vers -productVersion`;
    my $macos_ver_major = $macos_ver;
    $macos_ver_major =~ s/^(\d+)\.(\d+).*/$1/;
    my $macos_ver_minor = $macos_ver;
    $macos_ver_minor =~ s/^(\d+)\.(\d+).*/$2/;
    if ($macos_ver_major==10) {
      if ($macos_ver_minor>=11) {
        return 1;
      }
    }
  }
  return 0;
}

sub version {
  my $ret = sprintf "%s version %s\n", $prg, $version;
  return $ret;
}

sub Usage {
  my $usage = <<"EOF";
  $prg $version
  Set up embedding of Japanese/Chinese/Korean fonts via updmap.cfg.

    This script searches for some of the most common fonts
    for embedding into pdfs by dvipdfmx.

    In addition it allows to set up arbitrary font families
    to be embedded into the generated pdf files, as long
    as at least the representative map file is present.
    Other map files will be used if available:

      For Japanese:
        ptex-<family>.map (representative map file)
        uptex-<family>.map
        otf-<family>.map
        otf-up-<family>.map

      For Simplified Chinese, Traditional Chinese and Korean:
        uptex-<NN>-<family>.map (representative map file)
        otf-<NN>-<family>.map
       (NN being: sc, tc, ko)

  Please see the documentation of updmap for details (updmap --help).

  Usage:  $prg [OPTION] NN[.PROG]={<fontname>|auto|nofont|status} ...

     NN:         One of ja, ko, sc, tc
     PROG:       One of ptex, otf, uptex, otf-up
     <family>    Embed an arbitrary font family <family>, at least
                 the representative map file has to be available.
     auto:       Automatically select the best font available.
     nofont:     Embed no fonts (and rely on system fonts when displaying pdfs).
                 If your system does not have any of the supported font
                 families, this target is selected automatically.
     status:     Get information about current environment and usable font maps.

  Options:
    -n, --dry-run  Do not actually run updmap
    -h, --help     Show this message and exit
    --jis2004      Use JIS2004 variants for default fonts of (u)pTeX
    --sys          Run in sys mode, i.e., call updmap -sys
    --user         Run in user mode, i.e., call updmap -user or updmap,
                   by checking the version of the updmap script.
                   If a non-parsable output of `updmap --version' is found,
                   a new updmap with --user option is assumed.
                   If this is not the case, explicitly use --old.
    --old          Makes $prg call `updmap' without --user argument in user mode.
    --version      Show version information and exit

  Backward compatibility with previous versions of $prg:

       $prg [OPTION] {<fontname>|auto|nofont|status}

  Additional options:
    --mode=NN      Setup for Japanese (NN=ja), Korean (NN=ko),
                   Simplified Chinese (NN=sc), Traditional Chinese (NN=tc)
    --NN=<family>  Shorthand for --mode=NN <family>

EOF
;
  print $usage;
  exit(0);
}

sub member {
  my $what = shift;
  return scalar grep($_ eq $what, @_);
}


###
### Collect Database Lines
###

sub InitDatabase {
  %representatives = ();
}

sub ReadDatabase {
  my @curdbl;
  # open database
  for my $f (@databaselist) {
    my $foo = kpse_miscfont($f);
    if (!open(FDB, "<$foo")) {
      printf STDERR "Cannot find $f, skipping!\n";
      next;
    }
    @curdbl = <FDB>;
    close(FDB);
    # parse lines
    my $lineno = 0;
    chomp(@curdbl);
    push @curdbl, ""; # add a "final empty line" to easy parsing
    for my $l (@curdbl) {
      $lineno++;
      next if ($l =~ m/^\s*$/); # skip empty line
      next if ($l =~ m/^\s*#/); # skip comment line
      $l =~ s/\s*#.*$//; # skip comment after '#'
      if ($l =~ m/^JA\((\d+)\):\s*(.*):\s*(.*)$/) {
        $representatives{'ja'}{$2}{'priority'} = $1;
        $representatives{'ja'}{$2}{'file'} = $3;
        next;
      }
      if ($l =~ m/^SC\((\d+)\):\s*(.*):\s*(.*)$/) {
        $representatives{'sc'}{$2}{'priority'} = $1;
        $representatives{'sc'}{$2}{'file'} = $3;
        next;
      }
      if ($l =~ m/^TC\((\d+)\):\s*(.*):\s*(.*)$/) {
        $representatives{'tc'}{$2}{'priority'} = $1;
        $representatives{'tc'}{$2}{'file'} = $3;
        next;
      }
      if ($l =~ m/^KO\((\d+)\):\s*(.*):\s*(.*)$/) {
        $representatives{'ko'}{$2}{'priority'} = $1;
        $representatives{'ko'}{$2}{'file'} = $3;
        next;
      }
      # we are still here??
      die "Cannot parse \"$foo\" at line $lineno,
           exiting. Strange line: >>>$l<<<\n";
    }
  }
  if (!%representatives) {
    die "Candidate list is empty, cannot proceed!\n";
  }
}

sub kpse_miscfont {
  my ($file) = @_;
  # print STDERR "DEBUG calling kpsewhich $file\n";
  chomp(my $foo = `kpsewhich -format=miscfont $file`);
  # for GitHub repository diretory structure
  if ($foo eq "") {
    $foo = "database/$file" if (-f "database/$file");
  }
  return $foo;
}

###
### GetStatus
###

sub check_mapfile {
  my $mapf = shift;
  # print STDERR "DEBUG calling kpsewhich $mapf\n";
  my $f = `kpsewhich $mapf 2> $nul`;
  my $ret = $?;
  if (wantarray) {
    return (!$ret, $f);
  } else {
    return (!$ret);
  }
}

sub get_repr_map_file {
  my ($mode, $prog, $status) = @_;
  my $testmap;
  if (defined($prog)) {
    if ($mode eq "ja") {
      $testmap = "$prog-$status.map";
    } else {
      $testmap = "$prog-$mode-$status.map";
    }
  } else {
    $testmap = ($mode eq "ja" ? "ptex-$status.map" : "uptex-${mode}-$status.map");
  }
  return($testmap);
}

sub get_cfg {
  my $arg = shift;
  my $updSet = $arg;
  my $mode;
  my $prog;
  # add the Embed string
  if ($updSet !~ m/\./) {
    $mode = $updSet;
    $updSet .= "Embed";
  } else {
    ($mode, $prog) = split(/\./, $updSet);
    $updSet = "${mode}Embed.$prog";
  }
  # print "DEBUG CALLING $updmap_real --quiet --showoption $updSet\n";
  my $val = `$updmap_real --quiet --showoption $updSet`;
  chomp($val);
  if ($val eq "$updSet=(undefined)") {
    return undef;
  }
  my $STATUS;
  if ($val =~ m/^\Q$updSet\E=([^()\s]*)(\s+\()?/) {
    $STATUS = $1;
  } else {
    return undef;
  }
}

sub GetStatus {
  my $arg = shift;
  my $mode;
  my $prog;
  # add the Embed string
  if ($arg !~ m/\./) {
    $mode = $arg;
  } else {
    ($mode, $prog) = split(/\./, $arg);
  }

  my $status = get_cfg($arg);
  my $parentstatus;
  if (!$status) {
    if (!defined($prog)) {
      # die if we cannot find the main setting (without sub-setting for programs)
      die "Cannot find status of current $arg setting via updmap --showoption!\n"
        if (!defined($prog));
    } else {
      # we tried to get ja.ptex and this is not defined by now, get the 
      # superseeding ja
      $parentstatus = get_cfg($mode);
      die "Cannot find status of current $parentstatus setting via updmap --showoption!\n"
        if (!$parentstatus);
    }
  }

  my $testmap;
  if (defined($status)) {
    $testmap = get_repr_map_file($mode, $prog, $status);
  } else {
    print "CURRENT family for $arg: (unset)\n";
    $testmap = get_repr_map_file($mode, $prog, $parentstatus);
  }
  if (check_mapfile($testmap)) {
    if (defined($status)) {
      print "CURRENT family for $arg: $status\n";
    } else {
      print "CURRENT family for $mode: $parentstatus\n";
    }
  } else {
    print STDERR "WARNING: Currently selected map file for $arg cannot be found: $testmap\n";
  }

  for my $k (sort { $representatives{$mode}{$a}{'priority'}
                    <=>
                    $representatives{$mode}{$b}{'priority'} }
                  keys %{$representatives{$mode}}) {
    my $MAPFILE = get_repr_map_file($mode, $prog, $k);
    next if ($MAPFILE eq $testmap);
    if (check_mapfile($MAPFILE)) {
      if (is_repr_available($mode, $k)) {
        print "Standby family : $k\n";
      }
    }
  }
  return $status;
}

sub is_repr_available {
  my ($mode, $fam) = @_;
  # print "DEBUG etnering is_available $mode $fam\n";
  if (defined($representatives{$mode}{$fam})) {
    if (!defined($representatives{$mode}{$fam}{'available'})) {
      # check availability
      $representatives{$mode}{$fam}{'available'} = check_availability($mode, $fam);
    }
    return $representatives{$mode}{$fam}{'available'};
  } else {
    return "";
  }
}

sub check_availability {
  my ($mode, $fam) = @_;
  # print STDERR "DEBUG calling kpsewhich $representatives{$mode}{$fam}{'file'}\n";
  my $f = `kpsewhich $representatives{$mode}{$fam}{'file'}`;
  if ($?) {
    return "";
  } else {
    return chomp($f);
  }
}

###
### Setup Map files
###

sub SetupMapFile {
  my $arg = shift;
  my $rep = shift;
  # print "DEBUG entering SetupMapFile $arg $rep\n";
  my $updSet = $arg;
  my $mode;
  my $prog;
  # add the Embed string
  if ($updSet !~ m/\./) {
    $mode = $updSet;
    $updSet .= "Embed";
  } else {
    ($mode, $prog) = split(/\./, $updSet);
    $updSet = "${mode}Embed.$prog";
  }

  my $MAPFILE = get_repr_map_file($mode, $prog, $rep);
  if (check_mapfile($MAPFILE)) {
    print "Setting up ... $MAPFILE\n";
    system("$updmap --quiet --nomkmap --nohash --setoption $updSet $rep");
    if ($opt_jis) {
      system("$updmap --quiet --nomkmap --nohash --setoption jaVariant -04");
    } else {
      system("$updmap --quiet --nomkmap --nohash --setoption jaVariant \"\"");
    }
  } else {
    die "NOT EXIST $MAPFILE\n";
  }
}

sub SetupReplacement {
  my $arg = shift;
  my $fam = shift;
  my $mode;
  my $prog;
  if ($arg !~ m/\./) {
    $mode = $arg;
  } else {
    ($mode, $prog) = split(/\./, $arg);
  }

  if (defined($representatives{$mode}{$fam})) {
    if (is_repr_available($mode, $fam)) {
      SetupMapFile($arg, $fam);
    } else {
      printf STDERR "$fam not available, falling back to auto!\n";
      SetupReplacement($arg, "auto");
    }
  } else {
    if ($fam eq "nofont") {
      SetupMapFile($arg, "noEmbed");
    } elsif ($fam eq "auto") {
      for my $i (sort { $representatives{$mode}{$a}{'priority'}
                        <=>
                        $representatives{$mode}{$b}{'priority'} }
                      keys %{$representatives{$mode}}) {
                      # print "DEBUG checking for $mode / $i\n";
        if (is_repr_available($mode, $i)) {
          SetupMapFile($arg, $i);
          return;
        }
      }
      # still here, no map file found!
      SetupMapFile($arg, "noEmbed");
    } else {
      # anything else is treated as a map file name
      SetupMapFile($arg, $fam);
    }
  }
}

###
### MAIN
###

sub main {
  InitDatabase();
  ReadDatabase();

  # require Data::Dumper;
  # # two times to silence perl warnings!
  # $Data::Dumper::Indent = 1;
  # $Data::Dumper::Indent = 1;
  # print "READING DONE ============================\n";
  # print Data::Dumper::Dumper(\%representatives);

  my $runUpdmap = 0;

  # first run over arguments to check for correctness
  my $error = 0;
  for my $arg (@_) {
    my ($a, $b) = split(/=/, $arg, 2);
    my ($mode, $prog) = split(/\./, $a, 2);
    if (defined($prog)) {
      if (!member($prog, @{$kanji_map_progs{$mode}})) {
        print "Program $prog cannot be used in $mode mode!\n";
        $error = 1;
      }
    }
  }
  if ($error) {
    die "Incorrect arguments found, terminating!";
  }

  for my $arg (@_) {
    my ($a, $b) = split(/=/, $arg, 2);
    my ($mode, $prog) = split(/\./, $a, 2);
    if ($b eq "status") {
      GetStatus($a);
    } elsif ($b eq "auto") {
      SetupReplacement($a, $b);
      $runUpdmap = 1;
    } elsif ($b eq "nofont") {
      SetupReplacement($a, $b);
      $runUpdmap = 1;
    } else {
      SetupReplacement($a, $b);
      $runUpdmap = 1;
    }
  }

  system("$updmap") if ($runUpdmap);
}

#
#
# Copyright statements:
#
# KOBAYASHI Taizo
# email to preining@logic.at
# Message-Id: <20120130.162953.59640143170594580.tkoba@cc.kyushu-u.ac.jp>
# Message-Id: <20120201.105639.625859878546968959.tkoba@cc.kyushu-u.ac.jp>
# --------------------------------------------------------
# copyright statement は簡単に以下で結構です。
#
#        Copyright 2004-2006 by KOBAYASHI Taizo
#
# では
#        GPL version 3 or any later version
#
# --------------------------------------------------------
#
# PREINING Norbert
# as author and maintainer of the current file
# Licensed under GPL version 3 or any later version
#
### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim: set tabstop=2 expandtab autoindent:
