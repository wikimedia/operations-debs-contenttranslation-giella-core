## Process this file with automake to produce Makefile.in
## Copyright: Sámediggi/Divvun/UiT
## Licence: GPL v3+

# The target(s) to build:
noinst_DATA=
if CAN_VOIKKOSPELL
noinst_DATA+=$(SPELLERVERSION) $(SPELLERTESTRESULT)

# if Forrest, then
if CAN_FORREST
FORRESTTESTRESULT=$(SPLTESTREPDIR)/$(GTLANG)/$(TESTTOOL)/goldstandard/$(DATE)-$(TESTTIME)-$(SPELLERTESTRESULT)

noinst_DATA+=$(FORRESTTESTRESULT)
endif # CAN_FORREST

endif # CAN_VOIKKOSPELL

include $(top_srcdir)/am-shared/voikko-include.am
