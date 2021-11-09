#!/bin/sh

fullfilename() {

    # check to see if $1 exists
    if [ -e $1 ]; then
        B=`basename $1`
        P=`dirname $1`
         # echo BASE:$B  PATH:$P
        pushd $P > /dev/null 2> /dev/null

        if [ `pwd` != "/" ]
        then
            FULLNAME=`pwd`/$B
        else
            FULLNAME=/$B
        fi
        popd > /dev/null 2> /dev/null

    else
        echo "Input file not found $1";
        exit -1
    fi

}

getbasename() {
    bname=`basename $FULLNAME .asm`;
}

which java > /dev/null; retval=$?;

if [ $retval -eq 1 ]; then
    echo "ERROR: Cannot find java, email TA or instructor";
    exit -1;
fi

if [ $# -lt 1 ]; then
    echo "Incorrect usage: need to specify the assemble source filename as first argument";
    exit -1;
fi

# fullfilename $1;
FULLNAME=$1;
getbasename;

tempdir=`mktemp -d`;


outfile_prefix=$tempdir/"loadfile";
outfile=$outfile_prefix"_all.img";
# echo $FULLNAME
java -classpath ~karu/courses/cs552/spring2008/handouts/assembler Assemble $FULLNAME $outfile_prefix > $outfile;

echo "Created the following files";
ls $tempdir;
cp $tempdir/* .

rm -rf $tempdir

exit;

