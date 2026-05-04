**free
ctl-opt debug option(*srcstmt: *nodebugio);
/if not defined(NO_DECEDIT)
ctl-opt decedit('0,');
/endif
ctl-opt datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
ctl-opt ccsid(*CHAR: *jobrun);