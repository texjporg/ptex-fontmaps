#
# release.sh
# copied from luatexja project and adapted

PROJECT=ptex-fontmaps
DIR=`pwd`/..
VER=${VER:-`date +%Y%m%d.0`}

TEMP=/tmp

echo "Making Release $VER. Ctrl-C to cancel."
read REPLY
if test -d "$TEMP/$PROJECT-$VER"; then
  echo "Warning: the directory '$TEMP/$PROJECT-$VER' is found:"
  echo
  ls $TEMP/$PROJECT-$VER
  echo
  echo -n "I'm going to remove this directory. Continue? yes/No"
  echo
  read REPLY <&2
  case $REPLY in
    y*|Y*) rm -rf $TEMP/$PROJECT-$VER;;
    *) echo "Aborted."; exit 1;;
  esac
fi
echo
git commit -m "Release $VER" --allow-empty
git archive --format=tar --prefix=$PROJECT-$VER/ HEAD | (cd $TEMP && tar xf -)
git --no-pager log --date=short --format='%ad  %aN  <%ae>%n%n%x09* %s%d [%h]%n' > $TEMP/$PROJECT-$VER/ChangeLog
cat ChangeLog.pre-git >> $TEMP/$PROJECT-$VER/ChangeLog
cd $TEMP
# exclude unnecessary files for CTAN
rm -f $PROJECT-$VER/.gitignore $PROJECT-$VER/ChangeLog.pre-git
rm -rf $PROJECT-$VER/tools $PROJECT-$VER/tests
# remove tl-update stuff that is only here temporarily
rm -rf $PROJECT-$VER/tl-updates
# version number
rm -rf $PROJECT-$VER-orig
cp -r $PROJECT-$VER $PROJECT-$VER-orig
cd $PROJECT-$VER
for i in README script/kanji-fontmap-creator.pl script/kanji-config-updmap.pl ; do
  perl -pi.bak -e "s/\\\$VER\\\$/$VER/g" $i
  rm -f ${i}.bak
done
cd ..
diff -urN $PROJECT-$VER-orig $PROJECT-$VER

#
# separate macOS-specific packages
mkdir $PROJECT-macos-$VER
# remove the non-free part in the main project
mkdir -p $PROJECT-macos-$VER/maps
for i in $PROJECT-$VER/maps/* ; do
  bn=`basename $i`
  case $bn in
    hiragino-elcapitan|hiragino-elcapitan-pron)
       mv $PROJECT-$VER/maps/$bn $PROJECT-macos-$VER/maps/ ;;
    hiragino-highsierra|hiragino-highsierra-pron)
       mv $PROJECT-$VER/maps/$bn $PROJECT-macos-$VER/maps/ ;;
    toppanbunkyu-sierra|toppanbunkyu-highsierra)
       mv $PROJECT-$VER/maps/$bn $PROJECT-macos-$VER/maps/ ;;
  esac
done
mkdir -p $PROJECT-macos-$VER/database
mv $PROJECT-$VER/database/*-macos-*.dat $PROJECT-macos-$VER/database/
# remove the rest of the stuff
mv $PROJECT-$VER/README.macos $PROJECT-macos-$VER/README

tar zcf $DIR/$PROJECT-$VER.tar.gz $PROJECT-$VER
tar zcf $DIR/$PROJECT-macos-$VER.tar.gz $PROJECT-macos-$VER
echo
echo You should execute
echo
echo "  git push && git tag $VER && git push origin $VER"
echo
echo Informations for submitting CTAN: 
echo "  CONTRIBUTION: ptex-fontmaps"
echo "  SUMMARY:      Font maps and configuration tools for Japanese/Chinese/Korean fonts with (u)ptex"
echo "  DIRECTORY:    language/japanese/ptex-fontmaps"
echo "  LICENSE:      free/other-free"
echo "  FILE:         $DIR/$PROJECT-$VER.tar.gz"

