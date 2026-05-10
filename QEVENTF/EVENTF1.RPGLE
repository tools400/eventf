**free
//=====================================================================*
//  EVENTF API - Public Interface                                      *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  19.05.2013                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Date        Name          Description                              *
//  ----------  ------------  ---------------------------------------  *
//  23.07.2015  Th.Raddatz    Fixed problem that an invalid error      *
//                            was produced for blank messages IDs.     *
//  17.01.2017  Th.Raddatz    Changed parameter o_rtnLib of procedure  *
//                            Eventf_open() to *NOPASS/*OMIT.          *
//                            Added procedure Eventf_openAppend().     *
//  28.01.2017  Th.Raddatz    Added procedures: Eventf_copyFrom()      *
//                                              Eventf_openAppend()    *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD   MODULE(&LI/&OB) +                       *
//                             SRCFILE(&SL/&SF) +                      *
//                             SRCMBR(&SM);                            *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain bnddir('QC2LE');
/copy QEVENTF,H_SPEC
/copy QEVENTF,COPYRIGHT
//=====================================================================*
dcl-f EVFEVENT disk(300) usage(*update: *delete: *output) usropn extfile(g_status.outFile)
  extmbr(g_status.outMbr) infds(g_fileInfo) block(*no);

dcl-f EVFEVENT2 disk(300) usropn extfile(g_inFile.name) extmbr(g_inFile.mbr) infds(g_fileInfo2)
  block(*no);

dcl-ds g_fileInfo likeds(fileInfDS_t);
dcl-ds g_fileInfo2 likeds(fileInfDS_t);
// ------------------------------------
//  Constants
// ------------------------------------

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  Exported prototypes
// ------------------------------------
/include QEVENTF,PEVENTF

// ------------------------------------
//  Imported prototypes
// ------------------------------------
/include QBASICS1,PBASICS1                      Service program BASICS1
/include QEVENTF,CEELIB                         CEE APIs
/include QEVENTF,QP0LCVTPAT                     Qp0lCvtPathToQSYSObjName()--Resolve Path
/include QEVENTF,QCMDEXC                        Execute Command (QCMDEXC) API

/include QEVENTF,FDINFDS

// ------------------------------------
//  Global fields & constants
// ------------------------------------
dcl-c EVENT_FILE 'EVFEVENT';
dcl-c VERSION '0';

dcl-ds g_status qualified;
  outFile char(21) inz;
  outMbr  like(evf_objName_t) inz;
end-ds;

dcl-ds g_inFile qualified;
  name char(21) inz;
  mbr  like(evf_objName_t) inz;
end-ds;

//=========================================================================
//  Opens an event file member. The event file is created, if
//  it does not yet exist.
//=========================================================================
//  Parameters:
//   i_lib         - Name of the library that contains the EVFEVENT file.
//                   This parameter must be set to the name of the library
//                   where the created object is to be stored.
//   i_mbr         - Name of the member to use.
//                   This parameter must be set to the name of the object
//                   that is to be created.
//   o_rtnLib      - Return the actual library that contains the event file.
//
//  Returns:
//   done          - Returns cTrue on success, else cFalse.
//=========================================================================
dcl-proc Eventf_open export;
  dcl-pi *n;
    i_lib    like(evf_objName_t) const;
    i_mbr    like(evf_objName_t) const;
    o_rtnLib like(evf_objName_t) options(*nopass: *omit);
  end-pi;

  dcl-s rtnLib like(o_rtnLib) inz;
  dcl-ds msg likeds(msg_t) inz;

  monitor;

    rtnLib = '';

    if (not f_exist(EVENT_FILE: i_lib: '*FILE'));
      createEventFile(EVENT_FILE: i_lib);
    endif;

    if (not f_exist(EVENT_FILE: i_lib: '*FILE': i_mbr));
      addEventFileMember(EVENT_FILE: i_lib: i_mbr);
    endif;

    clearEventFileMember(i_lib: i_mbr);

    rtnLib = openEventFile(i_lib: i_mbr);

  on-error;
    msg = f_rcvPgmMsgObj(cMsg_Escape);
    f_sndPgmMsg(msg: cMsg_Prv);
  endmon;

  if (%parms() >= %parmnum(o_rtnLib) and %addr(o_rtnLib) <> *null);
    o_rtnLib = rtnLib;
  endif;

end-proc;

//=========================================================================
//  Clears an existing event file member.
//=========================================================================
//  Parameters:
//   i_lib         - Name of the library that contains the EVFEVENT file.
//                   This parameter must be set to the name of the library
//                   where the created object is to be stored.
//   i_mbr         - Name of the member to use.
//                   This parameter must be set to the name of the object
//                   that is to be created.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_clear export;
  dcl-pi *n;
    i_lib like(evf_objName_t) const;
    i_mbr like(evf_objName_t) const;
  end-pi;

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  monitor;

    if (not f_exist(EVENT_FILE: i_lib: '*FILE'));
      return;
    endif;

    if (not f_exist(EVENT_FILE: i_lib: '*FILE': i_mbr));
      return;
    endif;

    clearEventFileMember(i_lib: i_mbr);

  on-error;
    msg = f_rcvPgmMsgObj(cMsg_Escape);
    f_sndPgmMsg(msg: cMsg_Prv);
  endmon;

end-proc;

//=========================================================================
//  Opens an event file member for appending records. The event file
//  is created, if it does not yet exist.
//=========================================================================
//  Parameters:
//   i_lib         - Name of the library that contains the EVFEVENT file.
//                   This parameter must be set to the name of the library
//                   where the created object is to be stored.
//   i_mbr         - Name of the member to use.
//                   This parameter must be set to the name of the object
//                   that is to be created.
//   o_rtnLib      - Return the actual library that contains the event file.
//
//  Returns:
//   done          - Returns cTrue on success, else cFalse.
//=========================================================================
dcl-proc Eventf_openAppend export;
  dcl-pi *n ind;
    i_lib    like(evf_objName_t) const;
    i_mbr    like(evf_objName_t) const;
    o_rtnLib like(evf_objName_t) options(*nopass: *omit);
  end-pi;

  dcl-s rtnLib like(o_rtnLib) inz;
  dcl-ds msg likeds(msg_t) inz;

  monitor;

    rtnLib = '';

    if (not f_exist(EVENT_FILE: i_lib: '*FILE'));
      return cFalse;
    endif;

    if (not f_exist(EVENT_FILE: i_lib: '*FILE': i_mbr));
      return cFalse;
    endif;

    rtnLib = openEventFile(i_lib: i_mbr);

  on-error;
    msg = f_rcvPgmMsgObj(cMsg_Escape);
    f_sndPgmMsg(msg: cMsg_Prv);
  endmon;

  if (%parms() >= %parmnum(o_rtnLib) and %addr(o_rtnLib) <> *null);
    o_rtnLib = rtnLib;
  endif;

  return cTrue;

end-proc;

//=========================================================================
//  Appends a 'PROCESSOR' record to the event file.
//=========================================================================
//  Parameters:
//   i_output_id   - The file ID of an output file produced by this
//                   processor.
//                   Default:        0
//   i_line_class  - Method used to number lines.
//                    EVF_LINE_CLASS_PHYSICAL_SOURCE -
//                          physical line number
//                    EVF_LINE_CLASS_EXPANDED_SOURCE -
//                          line number in an expanded source
//                   Default:        EVF_LINE_CLASS_PHYSICAL_SOURCE
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_writeProcessor export;
  dcl-pi *n;
    i_output_id  like(evf_output_id_t) options(*nopass: *omit) const;
    i_line_class like(evf_line_class_t) options(*nopass: *omit) const;
  end-pi;

  //  Optional parameters
  dcl-s output_id like(i_output_id);
  dcl-s line_class like(i_line_class);

  if (not %open(EVFEVENT));
    return;
  endif;

  if (%parms() >= %parmnum(i_output_id) and %addr(i_output_id) <> *null);
    output_id = i_output_id;
  else;
    output_id = 0;
  endif;

  if (%parms() >= %parmnum(i_line_class) and %addr(i_line_class) <> *null);
    line_class = i_line_class;
  else;
    line_class = EVF_LINE_CLASS_PHYSICAL_SOURCE;
  endif;

  writeTimestampRecord();
  writeProcessorRecord(output_id: line_class);

end-proc;

//=========================================================================
//  Appends a 'FILEID' record to the event file.
//=========================================================================
//  Parameters:
//   i_source_id   - A file identifier expressed as an integer.
//   i_path        - Qualified member name, specified as:
//                    a) a path name
//                    b) a QSYS object name of type qFile_t
//                    c) a QSYS object name of type qQSYSObj_t
//   i_nameType    - Type of parameter 'i_path'.
//                    EVF_NAME_TYPE_PATH - for a path name
//                    EVF_NAME_TYPE_QSYS - for a QSYS object name
//                   Default:        EVF_NAME_TYPE_QSYS
//   i_temp_flag   - Indicates whether the source is a temporary file.
//                   Default:        EVF_PERSISTENT_SOURCE
//   i_line        - Source file line number where the new file
//                   is referenced.
//                   Default:        0
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_writeFileID export;
  dcl-pi *n opdesc;
    i_source_id like(evf_source_id_t) const;
    i_path      like(evf_path_t) options(*varsize) const;
    i_nameType  char(1) options(*nopass: *omit) const;
    i_temp_flag like(evf_temp_flag_t) options(*nopass: *omit) const;
    i_line      like(evf_line_t) options(*nopass: *omit) const;
  end-pi;

  //  Optional parameters
  dcl-s nameType like(i_nameType);
  dcl-s temp_flag like(i_temp_flag);
  dcl-s line like(i_line);

  dcl-ds qQSYSObj likeds(qQSYSObj_t) inz;
  dcl-ds qFile likeds(qFile_t) inz;
  dcl-ds nameInf likeds(strInf_t) inz;
  dcl-s path like(i_path) inz;

  if (not %open(EVFEVENT));
    return;
  endif;

  if (%parms() >= %parmnum(i_nameType) and %addr(i_nameType) <> *null);
    nameType = i_nameType;
  else;
    nameType = EVF_NAME_TYPE_QSYS;
  endif;

  if (%parms() >= %parmnum(i_temp_flag) and %addr(i_temp_flag) <> *null);
    temp_flag = i_temp_flag;
  else;
    temp_flag = EVF_PERSISTENT_SOURCE;
  endif;

  if (%parms() >= %parmnum(i_line) and %addr(i_line) <> *null);
    line = i_line;
  else;
    line = 0;
  endif;

  if (nameType = EVF_NAME_TYPE_QSYS);
    CEEGSI(%parmnum(i_path): nameInf.dataType: nameInf.curlen: nameInf.maxlen: *omit);
    if (nameInf.curlen = 30);
      qFile = i_path;
    else;
      qQSYSObj = i_path;
      qFile.name = qQSYSObj.name;
      qFile.lib = qQSYSObj.lib;
      qFile.mbr = qQSYSObj.mbr;
    endif;
    path = f_cvtQSYSObjNameToPath(qFile);
  else;
    path = i_path;
  endif;

  writeFileIDRecord(i_source_id: line: path: temp_flag);

end-proc;

//=========================================================================
//  Appends a 'FILEEND' record to the event file.
//=========================================================================
//  Parameters:
//   i_source_id   - A file identifier expressed as an integer.
//   i_expansion   - Number of expanded source lines.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_writeFileEnd export;
  dcl-pi *n;
    i_source_id like(evf_source_id_t) const;
    i_expansion like(evf_expansion_t) const;
  end-pi;

  if (not %open(EVFEVENT));
    return;
  endif;

  writeFileEndRecord(i_source_id: i_expansion);

end-proc;

//=========================================================================
//  Appends an 'ERROR' record to the event file.
//=========================================================================
//  Parameters:
//   i_source_id      - A file identifier expressed as an integer.
//   i_stmt_line      - Line number containing the error.
//   i_msg_id         - Message ID (for example, AMPX999).
//   i_sev_num        - Severity level number.
//   i_msg_text       - The message text of the error message.
//   i_sev_char       - Severity code letter (I, W, E, S, or T).
//   i_annot_class    - Indicates where in a listing of messages this
//                      message should be placed.
//   i_start_err_line - Line number containing the start of the error.
//                      Default:        i_stmt_line
//   i_end_err_line   - Line number containing the end of the error.
//                      Default:        i_stmt_line
//   i_token_start    - Column of the start of the token in error.
//                      Default:        1
//   i_token_end      - Column of the start of the token in error.
//                      Default:        0
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_writeError export;
  dcl-pi *n;
    i_source_id      like(evf_source_id_t) const;
    i_stmt_line      like(evf_line_t) const;
    i_msg_id         like(evf_msg_id_t) const;
    i_sev_num        like(evf_sev_num_t) const;
    i_msg_text       like(evf_msg_text_t) const;
    i_sev_char       like(evf_sev_char_t) options(*nopass: *omit) const;
    i_annot_class    like(evf_annot_class_t) options(*nopass: *omit) const;
    i_start_err_line like(evf_line_t) options(*nopass: *omit) const;
    i_end_err_line   like(evf_line_t) options(*nopass: *omit) const;
    i_token_start    like(evf_token_t) options(*nopass: *omit) const;
    i_token_end      like(evf_token_t) options(*nopass: *omit) const;
  end-pi;

  //  Optional parameters
  dcl-s sev_char like(i_sev_char);
  dcl-s annot_class like(i_annot_class);
  dcl-s start_err_line like(i_start_err_line);
  dcl-s end_err_line like(i_end_err_line);
  dcl-s token_start like(i_token_start);
  dcl-s token_end like(i_token_end);

  dcl-s msg_id like(i_msg_id);

  if (%parms() >= %parmnum(i_sev_char) and %addr(i_sev_char) <> *null);
    sev_char = i_sev_char;
  else;
    sev_char = getSeverityChar(i_sev_num);
  endif;

  if (%parms() >= %parmnum(i_annot_class) and %addr(i_annot_class) <> *null);
    annot_class = i_annot_class;
  else;
    annot_class = getAnnotationClass(i_sev_num);
  endif;

  if (%parms() >= %parmnum(i_start_err_line) and %addr(i_start_err_line) <> *null);
    start_err_line = i_start_err_line;
  else;
    start_err_line = i_stmt_line;
  endif;

  if (%parms() >= %parmnum(i_end_err_line) and %addr(i_end_err_line) <> *null);
    end_err_line = i_end_err_line;
  else;
    end_err_line = start_err_line;
  endif;

  if (%parms() >= %parmnum(i_token_start) and %addr(i_token_start) <> *null);
    token_start = i_token_start;
  else;
    token_start = 1;
  endif;

  if (%parms() >= %parmnum(i_token_end) and %addr(i_token_end) <> *null);
    token_end = i_token_end;
  else;
    token_end = 0;
  endif;

  if (i_msg_id <> '');
    msg_id = i_msg_id;
  else;
    msg_id = '[none]';
  endif;

  writeErrorRecord(i_source_id: annot_class: i_stmt_line
                   : start_err_line: token_start
                   : end_err_line: token_end
                   : msg_id: sev_char: i_sev_num
                   : %len(i_msg_text): i_msg_text);

end-proc;

//=========================================================================
//  Copies the events of a given event file into this event file.
//=========================================================================
//  Parameters:
//   i_fromLib     - Name of the library that contains the EVFEVENT file.
//                   This parameter must be set to the name of the library
//                   where the created object is to be stored.
//   i_fromMbr     - Name of the member to use.
//                   This parameter must be set to the name of the object
//                   that is to be created.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_copyFrom export;
  dcl-pi *n;
    i_fromLib like(evf_objName_t) const;
    i_fromMbr like(evf_objName_t) const;
  end-pi;

  dcl-ds buffer len(300);
  end-ds;

  g_inFile.name = %trim(i_fromLib) + '/' + EVENT_FILE;
  g_inFile.mbr = %trim(i_fromMbr);
  open EVFEVENT2;

  dou (%eof(EVFEVENT2));
    read EVFEVENT2 buffer;
    if (not %eof);
      write EVFEVENT buffer;
    endif;
  enddo;

  close EVFEVENT2;

end-proc;

//=========================================================================
//  Closes an event file member.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Eventf_close export;
  dcl-pi *n;
  end-pi;

  closeEventFile();

end-proc;

//=========================================================================
//  *** private ***
//  Appends a TIMESTAMP record to the event file.
//
//  This record indicates when the Events File was created, and allows an
//  application to determine if the Events File is current (if the timestamp
//  is older than a file indicated in a File ID record, the Events File may
//  be incorrect for that file). This record is always the first record in
//  the Events File.
//
//  Note: This record is not written by a processor; it is written by the
//  caller of the first processor. This allows each processor to append to
//  the Events File without having to determine if the file exists.
//=========================================================================
dcl-proc writeTimestampRecord;
  dcl-pi *n extproc(*dclcase);
  end-pi;

  dcl-ds timestamp len(300) qualified inz;
    format    char(10) inz('TIMESTAMP');
    version   char(1) inz(VERSION) pos(12);
    timestamp char(14) pos(14);
  end-ds;

  reset timestamp;
  timestamp.timestamp = %char(%date(): *ISO0) + %char(%time(): *HMS0);
  write EVFEVENT timestamp;

end-proc;

//=========================================================================
//  *** private ***
//  Appends a PROCESSOR record to the event file.
//
//  This record indicates that a new processor has been invoked. One will
//  always follow the timestamp record in the Events File (although there
//  may be more than one).
//
//  version
//  The revision of this record, used for upward compatibility. The current
//  version is "1".
//
//  output-id
//  The file ID of an output file produced by this processor. If the output
//  of this processor is intended to be used as input to another processor,
//  this file ID represents that file, and the file ID record of the file
//  will follow this record. If this is the last processor that will be
//  invoked for which the editor will be expected to display messages, the
//  file ID is 0.
//
//  line-class
//  Method used to number lines. Specify zero if a temporary file or
//  internal file containing an expanded source representation is being
//  used; the line number represents the line number in the expanded source.
//  Specify one if the line number represents the physical line number in
//  the source file indicated in source file ID field.
//
//  Note: If the output of one processor is intended as the input to another
//  processor, the FILEID record for the output should contain a name, even
//  if the output is not placed in a real file. This same name should be
//  used in the input FILEID record of the processor using the output.
//=========================================================================
dcl-proc writeProcessorRecord;
  dcl-pi *n extproc(*dclcase);
    i_output_id  like(evf_output_id_t) const;
    i_line_class like(evf_line_class_t) const;
  end-pi;

  dcl-ds processor len(300) qualified inz;
    format     char(10) inz('PROCESSOR');
    version    char(1) inz(VERSION) pos(12);
    output_id  char(3) pos(14);
    line_class char(1) pos(18);
  end-ds;

  reset processor;
  processor.output_id = %editc(i_output_id: 'X');
  processor.line_class = i_line_class;
  write EVFEVENT processor;

end-proc;

//=========================================================================
//  *** private ***
//  Appends a FILEID record to the event file.
//
//  This record contains the full name of the source file processed and
//  associates an integer with the file name. There should be one record of
//  this type for each source file processed (the main source file as well
//  as any included source units (copylib members) and macros).
//
//  Note: If a file is included several times during processing, a file ID
//  record should be written for each inclusion.
//
//  version
//  The revision of this record, used for upward compatibility. The current
//  version is "1".
//
//  source-id
//  A file identifier expressed as an integer to be used in place of the
//  file name to correlate an error record with the source file in which it
//  occurred, without having to use the character based file name. Use zero
//  if the input file is not known, such as input coming from a user exit.
//
//  line
//  Source file line number where a new file is referenced, or zero if the
//  file was not referenced from a file.
//
//  length
//  Length of the file name; the maximum length is 255. In a FILEIDCONT
//  record, the length is always zero since length is only determined by the
//  file ID record.
//
//  filename
//  The name should be the fully-qualified physical file name. If none
//  exists (for example, getting text from the user) or the name can't be
//  determined, place a null string here.
//  The name can include servername.
//
//  sourcefile timestamp
//  This is the timestamp on the Source file.
//
//  temp flag
//  This field is set to 1 to indicate the source is a temporary file,
//  otherwise it is set to 0. Temporary source file can only be opened in
//  browse mode. Currently the temp flag is used to reference output
//  generated by SQL preprocessor.
//=========================================================================
dcl-proc writeFileIDRecord;
  dcl-pi *n extproc(*dclcase);
    i_source_id like(evf_source_id_t) const;
    i_line      like(evf_line_t) const;
    i_path      like(evf_path_t) options(*varsize) const;
    i_temp_flag like(evf_temp_flag_t) const;
  end-pi;

  dcl-ds fileID len(300) qualified inz;
    format    char(10) inz('FILEID');
    version   char(1) inz(VERSION) pos(12);
    source_id char(3) pos(14);
    line      char(6) pos(18);
    length    char(3) pos(25);
  end-ds;
  //   char(*) - file name              FILE/LIBRARY(MEMBER), max. length = 255
  //   char(*) - source file timestamp  YYYYMMDDhhmmss
  //   char(*) - temp flag              0/1

  dcl-c MAX_NAME_LENGTH 255;

  dcl-s pos uns(10);
  dcl-s offset uns(10);
  dcl-s len uns(10);
  dcl-s lastChanged char(14);
  dcl-s path like(i_path) inz;
  dcl-ds qFile likeds(qFile_t) inz;

  lastChanged =
     %subst(%char(getLastChangedTime(i_path): *ISO0): 1: 14);

  if (f_startsWith('/QSYS.LIB': i_path));
    qFile = getQSYSFileName(i_path);
    path = %trimR(qFile.lib) + '/' +
           %trimR(qFile.name) + '(' +
           %trimR(qFile.mbr) + ')';
  else;
    path = i_path;
  endif;

  reset fileID;
  fileID.source_id = %editc(i_source_id: 'X');
  fileID.line = %editc(%dec(i_line: 6: 0): 'X');
  fileID.length = %editc(%dec(%len(path): 3: 0): 'X');

  offset = 0;
  dow (offset < %len(path));
    pos = 29;
    %subst(fileID: 29) = '';

    if (%len(path) - offset > MAX_NAME_LENGTH);
      len = MAX_NAME_LENGTH;
    else;
      len = %len(path) - offset;
    endif;

    addValue(fileID: pos: %subst(path: 1 + offset: len));
    if (offset + len >= %len(path));
      addValue(fileID: pos: lastChanged);
      addValue(fileID: pos: i_temp_flag);
    endif;

    write EVFEVENT fileID;

    offset += len;
    fileID.format = 'FILEIDCONT';
    fileID.line = %editc(%dec(0: 6: 0): 'X');
    fileID.length = %editc(%dec(0: 3: 0): 'X');
  enddo;

end-proc;

//=========================================================================
//  *** private ***
//  Appends a FILEEND record to the event file.
//
//  This record indicates that an included file is ending. It provides a
//  method to determine the nesting of include files so a program can
//  navigate back up the include chain. This is useful when the included
//  file does not contain enough information to determine what caused the
//  error.
//
//  version
//  The revision of this record, used for upward compatibility. The current
//  version is "1".
//
//  file-id
//  file ID of this file. (source-id)
//
//  expansion
//  Number of expanded source lines in this file, including any nested
//  includes and macro expansions.
//
//  Note: Every file ID record must have a corresponding file end record,
//  except for the file ID that follows the processor record to define the
//  output file.
//=========================================================================
dcl-proc writeFileEndRecord;
  dcl-pi *n extproc(*dclcase);
    i_source_id like(evf_source_id_t) const;
    i_expansion like(evf_expansion_t) const;
  end-pi;

  dcl-ds fileEnd len(300) qualified inz;
    format    char(10) inz('FILEEND');
    version   char(1) inz(VERSION) pos(12);
    source_id char(3) pos(14);
    expansion char(6) pos(18);
  end-ds;

  reset fileEnd;
  fileEnd.source_id = %editc(i_source_id: 'X');
  fileEnd.expansion = %editc(i_expansion: 'X');
  write EVFEVENT fileEnd;

end-proc;

//=========================================================================
//  *** private ***
//  Appends an ERROR record to the event file.
//
//  A record of this type contains information required to locate a token or
//  line causing a message in the source file, as well as enough information
//  to allow the message itself to be displayed. This information includes
//  location information (such as what file and line the error occurred on)
//  and information related to the error itself (such as the number, text,
//  and severity of the message).
//
//  version
//  The revision of this record, used for upward compatibility. The current
//  version is "1".
//
//  file-id
//  file ID of this file. (source-id)
//
//  annot-class
//  Indicates where in a listing of messages this message should be placed
//  when the Events File is loaded in the Error List window. The positions
//  are defined as follows:
//
//   0 - top of list
//   2 - middle of list
//   3 - bottom of list
//
//  stmt-line
//  Line number (in the source file associated with the above source file ID
//  number) of the first line of the statement containing the error. This is
//  required in case the error does not occur on the first line of the
//  statement. This number is interpreted using the line class field.
//
//  start-err-line
//  Line number (in the source file associated with the above source file ID
//  number) containing the start of the error. This number is interpreted
//  using the line class field.
//
//  token-start
//  Column (or character in the line) of the start of the token in error. If
//  this information is not available, a zero here will cause the entire
//  line to be flagged as an error.
//
//  end-err-line
//  Line number (in the source file associated with the above source file ID
//  number) containing the end of the error. This number is interpreted
//  using the line class field.
//
//  token-end
//  Column (or character in the line) of the end of the token in error. If
//  this information is not available, a zero here will cause the entire
//  line to be flagged as an error.
//
//  msg-id
//  Message ID (for example, AMPX999).
//
//  sev-char
//  Severity code letter (I, W, E, S, or T).
//
//  sev-num
//  Severity level number. For some systems, this is the return code
//  associated with the severity code letter
//  (for example, I=0, W=4, E=8, S=12, T=16).
//
//  length
//  The actual length of the message text (the next field). The maximum
//  length is 1024 bytes.
//
//  msg
//  The message text of the error message. Any replacement of fields should
//  have already been done.
//=========================================================================
dcl-proc writeErrorRecord;
  dcl-pi *n extproc(*dclcase);
    i_source_id      like(evf_source_id_t) const;
    i_annot_class    like(evf_annot_class_t) const;
    i_stmt_line      like(evf_line_t) const;
    i_start_err_line like(evf_line_t) const;
    i_token_start    like(evf_token_t) const;
    i_end_err_line   like(evf_line_t) const;
    i_token_end      like(evf_token_t) const;
    i_msg_id         like(evf_msg_id_t) const;
    i_sev_char       like(evf_sev_char_t) const;
    i_sev_num        like(evf_sev_num_t) const;
    i_length         like(evf_length_t) const;
    i_msg_text       like(evf_msg_text_t) const;
  end-pi;

  dcl-ds error len(300) qualified inz;
    format         char(10) inz('ERROR');
    version        char(1) inz(VERSION) pos(12);
    source_id      char(3) pos(14);
    annot_class    char(1) pos(18);
    stmt_line      char(6) pos(20);
    start_err_line char(6) pos(27);
    token_start    char(3) pos(34);
    end_err_line   char(6) pos(38);
    token_end      char(3) pos(45);
    msg_id         char(7) pos(49);
    sev_char       char(1) pos(57);
    sev_num        char(2) pos(59);
    length         char(3) pos(62);
    msg            char(218) pos(66);
  end-ds;

  reset error;
  error.source_id = %editc(i_source_id: 'X');
  error.annot_class = i_annot_class;
  error.stmt_line = %editc(%dec(i_stmt_line: 6: 0): 'X');
  error.start_err_line = %editc(%dec(i_start_err_line: 6: 0): 'X');
  error.token_start = %editc(%dec(i_token_start: 3: 0): 'X');
  error.end_err_line = %editc(%dec(i_end_err_line: 6: 0): 'X');
  error.token_end = %editc(%dec(i_token_end: 3: 0): 'X');
  error.msg_id = i_msg_id;
  error.sev_char = i_sev_char;
  error.sev_num = %editc(%dec(i_sev_num: 2: 0): 'X');
  error.length = %editc(%dec(i_length: 3: 0): 'X');
  error.msg = i_msg_text;
  write EVFEVENT error;

end-proc;

//=========================================================================
//  *** private ***
//  Adds a value to the output buffer.
//=========================================================================
dcl-proc addValue;
  dcl-pi *n uns(10) extproc(*dclcase);
    io_buffer char(300);
    io_pos    uns(10);
    i_value   char(300) const;
  end-pi;

  dcl-s length uns(10);

  length = %len(%trimR(i_value));
  if (io_pos + length - 1 > %len(io_buffer));
    length = %len(io_buffer) - io_pos + 1;
  endif;

  if (length <= 0);
    return 0;
  endif;

  %subst(io_buffer: io_pos: length) = %subst(i_value: 1: length);
  io_pos += length + 1;

  return length;

end-proc;

//=========================================================================
//  *** private ***
//  Returns the timestamp, the file was last changed.
//=========================================================================
dcl-proc getLastChangedTime;
  dcl-pi *n timestamp extproc(*dclcase);
    i_path like(evf_path_t) options(*varsize) const;
  end-pi;

  dcl-s lastChanged timestamp inz;

  dcl-s rc int(10);
  dcl-ds st_stat likeds(st_stat_t) inz;

  rc = stat(i_path: %addr(st_stat));
  if (rc <> 0);
    return lastChanged;
  endif;

  lastChanged = f_cvtEpochTS(st_stat.ctime);

  return lastChanged;

end-proc;

//=========================================================================
//  *** private ***
//  Returns the QSYS file name.
//=========================================================================
dcl-proc getQSYSFileName;
  dcl-pi *n likeds(qFile_t) extproc(*dclcase);
    i_path like(evf_path_t) options(*varsize) const;
  end-pi;

  dcl-ds qFile likeds(qFile_t) inz;

  dcl-ds pathName likeds(Qlg_Path_Name_t) inz;
  dcl-ds qsys_info likeds(qsys0100_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;

  pathName = *ALLx'00';
  pathName.CCSID = QLG_PATH_JOB_CCSID;
  pathName.Country_ID = QLG_PATH_JOB_COUNTRYID;
  pathName.Language_ID = QLG_PATH_JOB_LANGUAGEID;
  pathName.Reserved = *ALLx'00';
  pathName.Path_Type = QLG_CHAR_SINGLE;
  pathName.Path_Length = %len(%trimR(i_path));
  pathName.Path_Name_Delimiter = '/';
  pathName.Reserved2 = *ALLx'00';
  pathName.Path_Name = i_path;
  errCode = f_newApiErrCode(cFalse);

  Qp0lCvtPathToQSYSObjName(
     pathName: qsys_info: 'QSYS0100': %size(qsys_info): 0: errCode);

  qFile.name = %trimR(qsys_info.obj_name: x'00');
  qFile.lib = %trimR(qsys_info.lib_name: x'00');
  qFile.mbr = %trimR(qsys_info.mbr_name: x'00');

  return qFile;

end-proc;

//=========================================================================
//  *** private ***
//  Creates an event file.
//=========================================================================
dcl-proc createEventFile;
  dcl-pi *n extproc(*dclcase);
    i_file like(evf_objName_t) const;
    i_lib  like(evf_objName_t) const;
  end-pi;

  dcl-s command varchar(128);

  command = 'CRTPF FILE(' + %trim(i_lib) + '/' + %trim(i_file) + ') +
               RCDLEN(300) MAXMBRS(*NOMAX) SIZE(500000 1000 3) +
               CCSID(*HEX) MBR(*NONE)';

  QCMDEXC(command: %len(command));

  p_rmvPgmMsg(cMsg_Rmv_All);

end-proc;

//=========================================================================
//  *** private ***
//  Adds a member to a given event file.
//=========================================================================
dcl-proc addEventFileMember;
  dcl-pi *n extproc(*dclcase);
    i_file like(evf_objName_t) const;
    i_lib  like(evf_objName_t) const;
    i_mbr  like(evf_objName_t) const;
  end-pi;

  dcl-s command varchar(128);

  command = 'ADDPFM FILE(' + %trim(i_lib) + '/' + %trim(i_file) + ') +
               MBR(' + %trim(i_mbr) + ')';

  QCMDEXC(command: %len(command));

  p_rmvPgmMsg(cMsg_Rmv_All);

end-proc;

//=========================================================================
//  *** private ***
//  Clears the member of the event file.
//=========================================================================
dcl-proc clearEventFileMember;
  dcl-pi *n extproc(*dclcase);
    i_lib like(evf_objName_t) const;
    i_mbr like(evf_objName_t) const;
  end-pi;

  dcl-s command varchar(128) inz;

  command =
     'CLRPFM FILE(' + %trim(i_lib) + '/' + EVENT_FILE + ') +
             MBR(' + %trim(i_mbr) + ')';

  QCMDEXC(command: %len(command));

  p_rmvPgmMsg(cMsg_Rmv_All);

end-proc;

//=========================================================================
//  *** private ***
//  Opens the event file.
//=========================================================================
dcl-proc openEventFile;
  dcl-pi *n like(evf_objName_t) extproc(*dclcase);
    i_lib like(evf_objName_t) const;
    i_mbr like(evf_objName_t) const;
  end-pi;

  g_status.outFile = %trim(i_lib) + '/' + EVENT_FILE;
  g_status.outMbr = %trim(i_mbr);
  open EVFEVENT;

  return g_fileInfo.openFeedback.lib;

end-proc;

//=========================================================================
//  *** private ***
//  Closes the event file.
//=========================================================================
dcl-proc closeEventFile;
  dcl-pi *n extproc(*dclcase);
  end-pi;

  if (not %open(EVFEVENT));
    return;
  endif;

  close EVFEVENT;
  clear g_status;

end-proc;

//=========================================================================
//  Converts a given message severity to the annotation class.
//=========================================================================
dcl-proc getAnnotationClass;
  dcl-pi *n char(1) extproc(*dclcase);
    i_msgSeverity int(10) value;
  end-pi;

  select;
  when (i_msgSeverity >= 50);
    return EVF_ANNOTATION_TOP;
  other;
    return EVF_ANNOTATION_MIDDLE;
  endsl;

end-proc;

//=========================================================================
//  Converts a given message type to the severity character.
//  Rules:
//    n >= 40    -->   Terminating
//    n >= 30    -->   Severe
//    n >= 20    -->   Error
//    n >= 10    -->   Warning
//    other      -->   Info
//=========================================================================
dcl-proc getSeverityChar;
  dcl-pi *n char(1) extproc(*dclcase);
    i_msgSeverity int(10) value;
  end-pi;

  select;
  when (i_msgSeverity >= EVF_MSG_SEVERITY_TERMINATING);
    return EVF_SEVERITY_TERMINATING;
  when (i_msgSeverity >= EVF_MSG_SEVERITY_SEVERE);
    return EVF_SEVERITY_SEVERE;
  when (i_msgSeverity >= EVF_MSG_SEVERITY_ERROR);
    return EVF_SEVERITY_ERROR;
  when (i_msgSeverity >= EVF_MSG_SEVERITY_WARNING);
    return EVF_SEVERITY_WARNING;
  other;
    return EVF_SEVERITY_INFO;
  endsl;

end-proc;
