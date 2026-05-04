**free
//===============================================================*
//  erstellt : 19.05.2013                                        *
//===============================================================*
//                                                               *
//  Kurzdokumentation :                                          *
//                                                               *
//  Rahmentestprogramm mit Protokollausgabe                      *
//  Thema:                                                       *
//     Event File API - Example 3 (QSYS object names)            *
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
//  Type Definitions
// ------------------------------------

dcl-ds qQSYSObj_t qualified template;
  name char(10);
  lib  char(10);
  mbr  char(10);
  type char(10);
end-ds;

// ------------------------------------
//  External Prototypes
// ------------------------------------

/copy QEVENTF,PEVENTF                        Event File API

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('EVENTFT3');
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
  dcl-ds qQSYSObj likeds(qQSYSObj_t);

  object = 'EVENTF';
  library = 'RADDATZ';

  Eventf_open(library: object);
  Eventf_writeProcessor();

  // Add module source
  source_id = 1;
  qQSYSObj.name = 'QEVENTF';
  qQSYSObj.lib = 'RADDATZ';
  qQSYSObj.mbr = 'EVENTF1';
  Eventf_writeFileID(source_id: qQSYSObj
                     : EVF_NAME_TYPE_QSYS
                     : EVF_PERSISTENT_SOURCE);

  // Add first /copy book
  qQSYSObj.name = 'QEVENTF';
  qQSYSObj.lib = 'RADDATZ';
  qQSYSObj.mbr = 'H_SPEC';
  Eventf_writeFileID(source_id + 1: qQSYSObj
                     : EVF_NAME_TYPE_QSYS
                     : EVF_PERSISTENT_SOURCE
                     : 43);

  Eventf_writeFileEnd(source_id + 1: 10);
  Eventf_writeFileEnd(source_id: 842);

  Eventf_close();


end-proc main;
