#!/bin/bash

function print_usage() {
    echo "Usage: $0 [OPTIONS...]"
    echo "Prepare Autotools build infrastructure"
    echo
    echo "  -h, --help          print this usage info"
    echo "  -l, --add-langvar   Add env. variable \$GTLANG___UND__ to login script."
    echo "                      This makes it possible to use the built fst's"
    echo "                      with the analyser and generator scripts."
    echo
}

# option variables
langvar=""

# manual getopt loop... Mac OS X does not have good getopt
while test $# -ge 1 ; do
    if test x$1 = x--add-langvar -o x$1 = x-l ; then
        langvar=langvar
    elif test x$1 = x--help -o x$1 = x-h ; then
        print_usage
        exit 0
    else
        echo
        echo "ERROR: $0: unknown option $1"
        print_usage
        exit 1
    fi
    shift
done

# Variable setup for adding env. variable:
GTLANG=__UND__
LANGDIR=$(pwd)
TIME=$(date +%H%M)
DATE=$(date +%Y%m%d)
LOGINFILE=

# Find the login file:
if [[ -r ~/.bash_profile ]]; then
	LOGINFILE=~/.bash_profile
elif [[ -r ~/.profile ]]; then
	LOGINFILE=~/.profile
elif [[ -r ~/.bashrc ]]; then
	LOGINFILE=~/.bashrc
fi

echo
echo "Initial automake setup of $(basename $(pwd))"

# autoreconf should work for most platforms
autoreconf -i

# If option -l / --add-langvar was used:
if test x$langvar = xlangvar ; then
	if test x$LOGINFILE = x ; then
		echo
		echo "ERROR: could not find a login script to add the variable to!"
		echo
		exit 1
	else
		if test x$GTLANG___UND__ = x$LANGDIR ; then
			echo "\$GTLANG___UND__ already defined."
		else
			# Already defined with a different value:
			if test x$GTLANG___UND__ != x ; then
				renew=renew
				OLDLANGDIR=$GTLANG___UND__
			fi

			# Add the variable to the login script:
			cp $LOGINFILE $LOGINFILE.gtbackup.${DATE}-${TIME}
			echo "export GTLANG___UND__=$LANGDIR" >> $LOGINFILE
			source $LOGINFILE

			# Feedback depending on whether it was added or redefined:
			if test x$renew = xrenew ; then
			 echo "The env. variable \$GTLANG___UND__ has been redefined in"
			 echo "$LOGINFILE. The old value $OLDLANGDIR is no longer in use."
			else
			 echo "The env. variable \$GTLANG___UND__ has been added to $LOGINFILE."
    		 echo "Your built fst's (those you get after 'make') will be used"
    		 echo "with the analyser and generator scripts. There's a backup of"
    		 echo "your old $LOGINFILE in $LOGINFILE.gtbackup.${DATE}-${TIME}."
    		 echo "Please log out and log in again for the variable to be used."
			fi
		fi
	fi
fi

# Check whether the variable is defined, warn the user if not or different from
# the current dir:
if   test x$GTLANG___UND__ = x ; then
	echo "WARNING: The variable \$GTLANG___UND__ has not been defined. You will not"
	echo "be able to use your own fst's with the analyser and generator scripts"
	echo "if not defined. Please consider rerunning this script with option -l:"
	echo
	echo "$0 -l"
	echo
elif test x$GTLANG___UND__ != x$LANGDIR ; then
	echo "WARNING: The variable \$GTLANG___UND__ has the value:"
	echo "  $GTLANG___UND__"
	echo "instead of the expected:"
	echo "  $LANGDIR"
	echo "Please consider rerunning this script with option -l to update the"
	echo "variable:"
	echo
	echo "$0 -l"
	echo
fi
