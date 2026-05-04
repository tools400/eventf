**free
//===============================================================*
//  erstellt : 19.05.2013                                        *
//===============================================================*
//                                                               *
//  Kurzdokumentation :                                          *
//                                                               *
//  Rahmentestprogramm mit Protokollausgabe                      *
//  Thema:                                                       *
//     Event File API - Example 4 (long path names)              *
//                                                               *
//===============================================================*
// >>PRE-COMPILER<<                                              *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                   *
//                           SRCFILE(&SL/&SF) +                  *
//                           SRCMBR(&SM);                        *
//   >>COMPILE<<                                                 *
//     >>PARM<< TRUNCNBR(*NO);                                   *
//     >>PARM<< DBGVIEW(*LIST);                                  *
//     >>PARM<< OPTION(*EVENTF);                                 *
//   >>END-COMPILE<<                                             *
//   >>EXECUTE<<                                                 *
//   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                      *
//                           MODULE(&LI/&OB          +           *
//                                          ) +                  *
//                           BNDSRVPGM(*LIBL/BASICS1      +      *
//                                     *LIBL/EVENTF       +      *
//                                          ) +                  *
//                           BNDDIR(*N         ) +               *
//                           DETAIL(*BASIC) +                    *
//                           ACTGRP(*NEW);                       *
// >>END-PRE-COMPILER<<                                          *
//===============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
ctl-opt main(pgm_entry_point);

// ------------------------------------
//  External Prototypes
// ------------------------------------

/copy QEVENTF,PEVENTF                        Event File API

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('EVENTFT4');
end-pr;

dcl-pr main extproc('main');
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-proc PGM_ENTRY_POINT;
  dcl-pi *n;
  end-pi;

  main();

end-proc;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s source_id like(evf_source_id_t);
  dcl-s object like(evf_objName_t);
  dcl-s library like(evf_objName_t);
  dcl-s fileName like(evf_path_t);

  object = 'EVENTF';
  library = 'RADDATZ';

  Eventf_open(library: object);
  Eventf_writeProcessor();

  // Add module source
  source_id = 1;
  fileName =
     '/home/raddatz/directory1/directory2/directory3/directory4/di+
      rectory5/directory6/directory7/directory8/directory9/directo+
      ry10/directory11/directory12/directory13/directory14/directo+
      ry15/directory16/directory17/directory18/directory19/directo+
      ry20/EVENTF1.RPGLE';
  Eventf_writeFileID(source_id: fileName
                     : EVF_NAME_TYPE_PATH
                     : EVF_PERSISTENT_SOURCE);

  // Add first /copy book
  fileName =
     '/home/raddatz/directory1/directory2/directory3/directory4/di+
      rectory5/directory6/directory7/directory8/directory9/directo+
      ry10/directory11/directory12/directory13/directory14/directo+
      ry15/directory16/directory17/directory18/directory19/directo+
      ry20/H_SPEC.RPGLE';

  Eventf_writeFileID(source_id + 1: fileName
                     : EVF_NAME_TYPE_PATH
                     : EVF_PERSISTENT_SOURCE
                     : 43);

  Eventf_writeFileEnd(source_id + 1: 10);
  Eventf_writeFileEnd(source_id: 842);

  Eventf_close();


end-proc main;
