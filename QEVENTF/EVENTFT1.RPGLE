**free
//===============================================================*
//  erstellt : 19.05.2013                                        *
//===============================================================*
//                                                               *
//  Kurzdokumentation :                                          *
//                                                               *
//  Rahmentestprogramm mit Protokollausgabe                      *
//  Thema:                                                       *
//     Event File API - Example 1 (short path names)             *
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
//  Imports
// ------------------------------------

/include QBASICS1,PBASICS1                      Service program BASICS1

// ------------------------------------
//  Type Definitions
// ------------------------------------

/include qeventf,CEELIB
/include qeventf,QP0LCVTPAT

// ------------------------------------
//  Prototypes
// ------------------------------------

/copy QEVENTF,PEVENTF                        Event File API

dcl-pr PGM_ENTRY_POINT extpgm('EVENTFT1');
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

//=========================================================================
//  Converts a QSYS object name to a path.
//=========================================================================
//  Parameters:
//   i_obj         - The name of the object.
//   i_lib         - The name of the object library.
//                   Default:        *LIBL
//   i_mbr         - The name of the member, when the object is a file.
//
//  Returns:
//   path          - IFS path name.
//=========================================================================
//  Examples:
//   cvtQSYSObjNameToPath(qFile)
//   cvtQSYSObjNameToPath(qObj: '*DTAARA');
//   cvtQSYSObjNameToPath(library: '*LIB');
//   cvtQSYSObjNameToPath(object: '*OUTQ');
//   cvtQSYSObjNameToPath(object: library: '*MSGQ');
//   cvtQSYSObjNameToPath(object: library: member: '*FILE');
//=========================================================================
dcl-proc cvtQSYSObjNameToPath export;
  dcl-pi *n varchar(5000) opdesc extproc(*dclcase);
    i_obj       char(40) options(*varsize) const;
    i_libOrType char(10) options(*nopass: *omit) const;
    i_mbrOrType char(10) options(*nopass: *omit) const;
    i_objType   char(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s path varchar(5000) inz;

  //  Optional parameter fields
  dcl-s libOrType like(i_libOrType) inz;
  dcl-s mbrOrType like(i_mbrOrType) inz;
  dcl-s objType like(i_objType) inz;

  //  Local fields
  dcl-ds objInf likeds(strInf_t) inz;
  dcl-ds qQSYSObj likeds(qQSYSObj_t) inz;
  dcl-ds qFile likeds(qFile_t) inz;
  dcl-ds qObj likeds(qFile_t) inz;

  dcl-s object char(10) inz;
  dcl-s library char(10) inz;
  dcl-s member char(10) inz;
  dcl-s type char(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Process optional parameter values ...
  if (%parms() >= %parmnum(i_libOrType) and %addr(i_libOrType) <> *null);
    libOrType = i_libOrType;
  else;
    libOrType = '';
  endif;

  if (%parms() >= %parmnum(i_mbrOrType) and %addr(i_mbrOrType) <> *null);
    mbrOrType = i_mbrOrType;
  else;
    mbrOrType = '';
  endif;

  if (%parms() >= %parmnum(i_objType) and %addr(i_objType) <> *null);
    objType = i_objType;
  else;
    objType = '';
  endif;

  CEEGSI(%parmnum(i_obj): objInf.dataType: objInf.curlen: objInf.maxlen: *omit);

  select;
  when (objInf.curlen = 40);   // 1 parameter
    if (%parms() <> 1);
      snd-msg *escape 'Incorrect number of parameters for ''qQSYSObj_t'' object.' %target(*caller);
    endif;

    qQSYSObj = i_obj;
    object = qQSYSObj.name;
    library = qQSYSObj.lib;
    member = qQSYSObj.mbr;
    type = qQSYSObj.type;

  when (objInf.curlen = 30);   // 2 parameters
    if (%parms() <> 1 and not (%parms() = 2 and libOrType = '*FILE'));
      snd-msg *escape 'Incorrect number of parameters for ''qFile_t'' object.' %target(*caller);
    endif;

    qFile = i_obj;
    object = qFile.name;
    library = qFile.lib;
    member = qFile.mbr;
    if (%parms() = 1);
      type = '*FILE';
    else;
      type = libOrType;
    endif;

  when (objInf.curlen = 20);   // 2 parameters
    if (%parms() <> 2);
      snd-msg *escape 'Incorrect number of parameters for ''qObj_t'' object.' %target(*caller);
    endif;

    qObj = i_obj;
    object = qObj.name;
    library = qObj.lib;
    member = '';
    type = libOrType;

  other;                       // 3 or 4 parameters, eg:
    if (%parms() <> 2 and %parms() <> 3 and not (%parms() = 4 and objType = '*FILE'));
      snd-msg *escape 'Incorrect number of parameters.' %target(*caller);
    endif;

    object = i_obj;
    select;
    when (%parms() = 2);
      library = '';
      member = '';
      type = libOrType;
    when (%parms() = 3);
      library = libOrType;
      member = '';
      type = mbrOrType;
    other;
      library = libOrType;
      member = mbrOrType;
      type = objType;
    endsl;
  endsl;

  if (type = '*LIB');
    library = object;
    object = '';
  else;
    if (library = '');
      library = '*LIBL';
    endif;
  endif;

  path = '/QSYS.LIB';

  if (library <> '' and library <> 'QSYS');
    path += '/';

    select;
    when (library = '*ALL');
      path += '%ALL%';
    when (library = '*ALLUSR');
      path += '%ALLUSR%';
    when (library = '*CURLIB');
      path += '%CURLIB%';
    when (library = '*LIBL');
      path += '%LIBL%';
    when (library = '*USRLIBL');
      path += '%USRLIBL%';
    other;
      path += %trim(library);
    endsl;

    path += '.LIB';
  endif;

  if (object <> '');
    path += '/';

    select;
    when (object = '*ALL');
      path += '%ALL%';
    other;
      path += %trim(object);
    endsl;

    path += '.' + %trimR(%subst(type: 2));
  endif;

  if (member <> '');
    path += '/';

    path += %trim(member);

    path += '.MBR';
  endif;

  return path;

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
  fileName = cvtQSYSObjNameToPath('QEVENTF': 'RADDATZ': 'EVENTF1': '*FILE');
  Eventf_writeFileID(source_id: fileName: EVF_NAME_TYPE_PATH: EVF_PERSISTENT_SOURCE);

  // Add first /copy book
  fileName = cvtQSYSObjNameToPath('QEVENTF': 'RADDATZ': 'H_SPEC': '*FILE');
  Eventf_writeFileID(source_id + 1: fileName: EVF_NAME_TYPE_PATH: EVF_PERSISTENT_SOURCE: 43);

  // Close the first /copy book
  Eventf_writeFileEnd(source_id + 1: 10); // close first /copy book

  // Add errors of module source
  Eventf_writeError(source_id
                    : 1077                   // stmt-line
                    : 'RNF5409'              // msg-id
                    : 30                     // sev-num
                    : 'The prototyped call returns a value which is lost when CALLP is used.'
                    : EVF_SEVERITY_ERROR     // sev-char
                    : EVF_ANNOTATION_TOP     // annotation class
                    : 1076                   // start-err-line
                    : 1078                   // end-err-line
                    : 13                     // token-start
                    : 18);                   // token-end

  Eventf_writeError(source_id
                    : 1077                   // stmt-line
                    : 'RNF5409'              // msg-id
                    : 30                     // sev-num
                    : 'The prototyped call returns a value which is lost when CALLP is used.'
                    : EVF_SEVERITY_ERROR     // sev-char
                    : EVF_ANNOTATION_TOP);   // annotation class

  // Close the module source
  Eventf_writeFileEnd(source_id: 842);

  Eventf_close();


end-proc main;
