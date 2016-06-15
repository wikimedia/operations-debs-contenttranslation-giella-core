# gt.m4 - Macros to locate and utilise giellatekno scripts -*- Autoconf -*-
# serial 1 (gtsvn-1)
# 
# Copyright © 2011 Divvun/Samediggi/UiT <bugs@divvun.no>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# the prefixes gt_*, _gt_* are reserved here for giellatekno variables and
# macros. It is the same as gettext and probably others, but I expect no
# collisions really.


AC_DEFUN([gt_PROG_SCRIPTS_PATHS],
         [
# GTCORE and GTFREE env. variables are required by the testbench
AC_ARG_VAR([GTCORE], [directory for giellatekno core data and scripts])
AC_ARG_VAR([GTFREE], [gtfree path must be defined for the test bench to work])

# Check if any of the corpus data repositories are available:
AC_MSG_CHECKING([whether GTBOUND STABLE exists for __UND__])
AS_IF([test -d ${GTBOUND}/stable/goldstandard/converted/__UND__/],
      [gtboundstable=yes],
      [gtboundstable=no])
AC_MSG_RESULT([$gtboundstable])
AM_CONDITIONAL([BOUNDSTABLE], [test "x$gtboundstable" != "xno"])

AC_MSG_CHECKING([whether GTBOUND PRESTABLE exists for __UND__])
AS_IF([test -d ${GTBOUND}/prestable/goldstandard/converted/__UND__/],
      [gtboundprestable=yes],
      [gtboundprestable=no])
AC_MSG_RESULT([$gtboundprestable])
AM_CONDITIONAL([BOUNDPRESTABLE], [test "x$gtboundprestable" != "xno"])

AC_MSG_CHECKING([whether GTFREE STABLE exists for __UND__])
AS_IF([test -d ${GTFREE}/stable/goldstandard/converted/__UND__/],
      [gtfreestable=yes],
      [gtfreestable=no])
AC_MSG_RESULT([$gtfreestable])
AM_CONDITIONAL([FREESTABLE], [test "x$gtfreestable" != "xno"])

AC_MSG_CHECKING([whether GTFREE PRESTABLE exists for __UND__])
AS_IF([test -d ${GTFREE}/prestable/goldstandard/converted/__UND__/],
      [gtfreeprestable=yes],
      [gtfreeprestable=no])
AC_MSG_RESULT([$gtfreeprestable])
AM_CONDITIONAL([FREEPRESTABLE], [test "x$gtfreeprestable" != "xno"])

# Define whether you want to be a maintainer:
AC_ARG_VAR([GTMAINTAINER], [define if you are maintaining the infra to get additional complaining about infra integrity])
AM_CONDITIONAL([WANT_MAINTAIN], [test x"$GTMAINTAINER" != x])
AC_PATH_PROG([GTVERSION], [gt-version.sh], [false],
             [$GTCORE/scripts/$PATH_SEPARATOR$GTHOME/gtcore/scripts/])
AS_IF([test "x$GTSCRIPT" = xfalse], 
      [cat<<<EOT
Could not find giellatekno core scripts in:
       $GTCORE/scripts 
       $GTHOME/gtcore/scripts 
       $PATH 
Please do one of the following: 
       a. svn co https://victorio.uit.no/langtech/trunk/gtcore
       b. cd gtcore/scripts && ./autogen.sh && ./configure && make install
       c. $GTHOME/gt/script/gtsetup.sh
       d. add "export GTCORE=path/to/gtcore" to your ~/.profile or similar
EOT
       AC_MSG_ERROR([gtversion.sh could not be executed])])

# Check for forrest, whether we should install xml files in the forrest dir.
# Requires forrest and that $GTBIG is defined (= available).
AC_PATH_PROG([FORREST], [forrest], [], [$PATH$PATH_SEPARATOR$with_forrest])
AC_MSG_CHECKING([whether we can enable html report generation])
AS_IF([test "x$GTBIG" != x], [
    AS_IF([test "x$FORREST" != x], [html_report=yes], [html_report=no])
],[html_report=no])
AC_MSG_RESULT([$html_report])
AM_CONDITIONAL([CAN_FORREST], [test "x$html_report" != xno])

# Check for Hunspell
AC_PATH_PROG([HUNSPELL], [hunspell], [], [$PATH$PATH_SEPARATOR$with_hunspell])
AC_MSG_CHECKING([whether we can enable hunspell testing])
AS_IF([test "x$HUNSPELL" != "x" -a -d hunspell/$GTLANG2-latest/ ],
      [hunspell_test=yes],
      [hunspell_test=no])
AC_MSG_RESULT([$hunspell_test])
AM_CONDITIONAL([CAN_HUNSPELL], [test "x$hunspell_test" != "xno"])

# Check for Foma, and the trie-spell-foma tool
AC_PATH_PROG([TRIE_SPELL_FOMA], [trie-spell-foma], [],
             [$PATH$PATH_SEPARATOR$with_trie_spell_foma])
AC_PATH_PROG([FLOOKUP], [flookup], [],
             [$PATH$PATH_SEPARATOR$with_flookup])
AC_MSG_CHECKING([whether we can enable foma testing])
AS_IF([test "x$TRIE_SPELL_FOMA" != "x" \
		 -a "x$FLOOKUP" != "x" \
		 -a -d foma-trie/$GTLANG2-latest/ ],
      [trie_spell_foma_test=yes],
      [trie_spell_foma_test=no])
AC_MSG_RESULT([$trie_spell_foma_test])
AM_CONDITIONAL([CAN_FOMASPELL], [test "x$trie_spell_foma_test" != "xno"])

# Define GTPRIV - needed for plx and Púki speller tools:
AC_ARG_VAR([GTPRIV], [gtpriv path must be defined for the plx tests to work])

# Check for and configure PLX-spell-smX - only available for SME, SMJ and SMA
AC_PATH_PROG([PLXSPELLSME], [spellSamiNort], [],
   [$GTPRIV/polderland/bin$PATH_SEPARATOR$PATH$PATH_SEPARATOR$with_plxspellsme])
AC_PATH_PROG([PLXSPELLSMJ], [spellSamiLule], [],
   [$GTPRIV/polderland/bin$PATH_SEPARATOR$PATH$PATH_SEPARATOR$with_plxspellsmj])
AC_PATH_PROG([PLXSPELLSMA], [spellSamiSout], [],
   [$GTPRIV/polderland/bin$PATH_SEPARATOR$PATH$PATH_SEPARATOR$with_plxspellsma])
AC_MSG_CHECKING([whether we can enable PLX speller testing])
AS_IF([test "x$PLXSPELLSME" != "x" -a \
            "x$PLXSPELLSMJ" != "x" -a \
            "x$PLXSPELLSMA" != "x" -a \
            -d plx/$GTLANG2-latest/ ],
      [plxspell_test=yes],
      [plxspell_test=no])
AC_MSG_RESULT([$plxspell_test])
AM_CONDITIONAL([CAN_PLXSPELL], [test "x$plxspell_test" != "xno"])
AM_CONDITIONAL([CAN_PLXSPELLSME],
               [test "x$plxspell_test" != "xno" -a "x$GTLANG" = "xsme"])
AM_CONDITIONAL([CAN_PLXSPELLSMJ],
               [test "x$plxspell_test" != "xno" -a "x$GTLANG" = "xsmj"])
AM_CONDITIONAL([CAN_PLXSPELLSMA],
               [test "x$plxspell_test" != "xno" -a "x$GTLANG" = "xsma"])

# Check for and configure Púki - only for Icelandic, only in $GTPRIV, and only
# for Linux.
AC_PATH_PROG([PUKI], [puki], [],
   [$GTPRIV/puki/bin$PATH_SEPARATOR$PATH$PATH_SEPARATOR$with_puki])
AC_MSG_CHECKING([whether we can enable Púki speller testing - Linux only])
AS_IF([test "x$PUKI" != "x" -a \
			-d puki/$GTLANG2-latest/ -a \
			"$(expr substr $(uname -s) 1 5)" == "Linux"],
      [pukispell_test=yes],
      [pukispell_test=no])
AC_MSG_RESULT([$pukispell_test])
AM_CONDITIONAL([CAN_PUKISPELL], [test "x$pukispell_test" != "xno"])

# Check for Voikkospell
AC_PATH_PROG([VOIKKOSPELL], [voikkospell], [],
             [$PATH$PATH_SEPARATOR$with_voikkospell])
AC_MSG_CHECKING([whether we can enable voikkospell testing])
AS_IF([test "x$VOIKKOSPELL" != "x" -a -d voikko/$GTLANG2-latest/ ],
      [voikkospell_test=yes],
      [voikkospell_test=no])
AC_MSG_RESULT([$voikkospell_test])
AM_CONDITIONAL([CAN_VOIKKOSPELL], [test "x$voikkospell_test" != "xno"])

]) # gt_PROG_SCRIPTS_PATHS

AC_DEFUN([gt_PRINT_FOOTER],
[
cat<<EOF
-- Building $PACKAGE_STRING:
    * test Hunspell: $hunspell_test
    * test Foma+trie: $trie_spell_foma_test
    * test PLX: $plxspell_test
    * test Púki: $pukispell_test
    * test Voikko: $voikkospell_test
    * Html reports using forrest: $html_report

 -- Available test corpora:
    * Stable bound: $gtboundstable
    * Prestable bound: $gtboundprestable
    * Stable free: $gtfreestable
    * Prestable free: $gtfreeprestable

For more ./configure options, run ./configure --help

To run the speller test bench do:
    make
EOF
]) # gt_PRINT_FOOTER
# vim: set ft=config: 
