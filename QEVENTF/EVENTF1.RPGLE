      *=====================================================================*
      *  EVENTF API - Public Interface                                      *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  19.05.2013                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Date        Name          Description                              *
      *  ----------  ------------  ---------------------------------------  *
      *  23.07.2015  Th.Raddatz    Fixed problem that an invalid error      *
      *                            was produced for blank messages IDs.     *
      *  17.01.2017  Th.Raddatz    Changed parameter o_rtnLib of procedure  *
      *                            Eventf_open() to *NOPASS/*OMIT.          *
      *                            Added procedure Eventf_openAppend().     *
      *  28.01.2017  Th.Raddatz    Added procedures: Eventf_copyFrom()      *
      *                                              Eventf_openAppend()    *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD   MODULE(&LI/&OB) +                       *
      *                             SRCFILE(&SL/&SF) +                      *
      *                             SRCMBR(&SM);                            *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< OPTION(*EVENTF);                                     *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN BNDDIR('QC2LE')
      /COPY QEVENTF,H_SPEC
      /COPY QEVENTF,COPYRIGHT
      *=====================================================================*
     FEVFEVENT  UF A F  300        DISK    usropn
     F                                     extfile(g_status.outFile)
     F                                     extmbr(g_status.outMbr)
     F                                     infds(g_fileInfo)
     F                                     block(*no)
      *
     FEVFEVENT2 IF   F  300        DISK    usropn
     F                                     extfile(g_inFile.name)
     F                                     extmbr(g_inFile.mbr)
     F                                     infds(g_fileInfo2)
     F                                     block(*no)
      *
     D g_fileInfo      ds                  likeds(infDS_DB_t)
     D g_fileInfo2     ds                  likeds(infDS_DB_t)
      * ------------------------------------
      *  Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  Exported prototypes
      * ------------------------------------
      /COPY QEVENTF,PEVENTF
      *
      * ------------------------------------
      *  Imported prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      /COPY QEVENTF,CEELIB                         CEE APIs
      /COPY QEVENTF,QP0LCVTPAT                     Qp0lCvtPathToQSYSObjName()--Resolve Path
      /COPY QEVENTF,QCMDEXC                        Execute Command (QCMDEXC) API
      *
      /define fileInfDS_DB
      /COPY QEVENTF,FDINFDS
      *
      * ------------------------------------
      *  Internal prototypes
      * ------------------------------------
      *
      *  Adds a value to the output buffer.
     D addValue...
     D                 pr            10u 0
     D                                     extproc('addValue')
     D  io_buffer                   300a
     D  io_pos                       10u 0
     D  i_value                     300a   const
      *
      *  Returns the timestamp, the file was last changed.
     D getLastChangedTime...
     D                 pr              z
     D                                     extproc('getLastChangedTime')
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
      *
      *  Returns the QSYS file name.
     D getQSYSFileName...
     D                 pr                  likeds(qFile_t)
     D                                     extproc('getQSYSFileName')
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
      *
      *  Creates an event file.
     D createEventFile...
     D                 pr
     D                                     extproc('createEventFile')
     D  i_file                             const like(evf_objName_t)
     D  i_lib                              const like(evf_objName_t)
      *
      *  Adds a member to the event file.
     D addEventFileMember...
     D                 pr
     D                                     extproc('addEventFileMember')
     D  i_file                             const like(evf_objName_t)
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
      *  Clears the member of the event file.
     D clearEventFileMember...
     D                 pr
     D                                     extproc('clearEventFileMember')
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
      *  Opens the event file.
     D openEventFile...
     D                 pr                  like(evf_objName_t)
     D                                     extproc('openEventFile')
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
      *  Closes the event file.
     D closeEventFile...
     D                 pr
     D                                     extproc('closeEventFile')
      *
      *  Appends a TIMESTAMP record to the event file.
     D writeTimestampRecord...
     D                 pr
     D                                     extproc('writeTimestampRecord')
      *
      *  Appends a PROCESSOR record to the event file.
     D writeProcessorRecord...
     D                 pr
     D                                     extproc('writeProcessorRecord')
     D  i_output_id                        const like(evf_output_id_t)
     D  i_line_class                       const like(evf_line_class_t)
      *
      *  Appends a FILEID record to the event file.
     D writeFileIDRecord...
     D                 pr
     D                                     extproc('writeFileIDRecord')
     D  i_source_id                        const like(evf_source_id_t)
     D  i_line                             const like(evf_line_t)
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
     D  i_temp_flag                        const like(evf_temp_flag_t)
      *
      *  Appends a FILEEND record to the event file.
     D writeFileEndRecord...
     D                 pr
     D                                     extproc('writeFileEndRecord')
     D  i_source_id                        const like(evf_source_id_t)
     D  i_expansions                       const like(evf_expansion_t)
      *
      *  Appends an ERROR record to the event file.
     D writeErrorRecord...
     D                 pr
     D                                     extproc('writeErrorRecord')
     D  i_source_id                        const like(evf_source_id_t)
     D  i_annot_class                      const like(evf_annot_class_t)
     D  i_stmt_line                        const like(evf_line_t)
     D  i_start_err_line...
     D                                     const like(evf_line_t)
     D  i_token_start                      const like(evf_token_t)
     D  i_end_err_line...
     D                                     const like(evf_line_t)
     D  i_token_end                        const like(evf_token_t)
     D  i_msg_id                           const like(evf_msg_id_t)
     D  i_sev_char                         const like(evf_sev_char_t)
     D  i_sev_num                          const like(evf_sev_num_t)
     D  i_length                           const like(evf_length_t)
     D  i_msg_text                         const like(evf_msg_text_t)
      *
      *  Converts a given message severity to the annotation class.
     D getAnnotationClass...
     D                 pr             1a
     D                                     extproc('getAnnotationClass')
     D  i_msgSeverity                10i 0 value
      *
      *  Converts a given message type to the severity character.
     D getSeverityChar...
     D                 pr             1a
     D                                     extproc('getSeverityChar')
     D  i_msgSeverity                10i 0 value
      *
      * ------------------------------------
      *  Global fields & constants
      * ------------------------------------
     D EVENT_FILE      c                   'EVFEVENT'
     D VERSION         c                   '0'
      *
     D g_status        ds                  qualified
     D  outFile                      21a   inz
     D  outMbr                             like(evf_objName_t) inz
      *
     D g_inFile        ds                  qualified
     D  name                         21a   inz
     D  mbr                                like(evf_objName_t) inz
      *
      *=========================================================================
      *  Opens an event file member. The event file is created, if
      *  it does not yet exist.
      *=========================================================================
      *  Parameters:
      *   i_lib         - Name of the library that contains the EVFEVENT file.
      *                   This parameter must be set to the name of the library
      *                   where the created object is to be stored.
      *   i_mbr         - Name of the member to use.
      *                   This parameter must be set to the name of the object
      *                   that is to be created.
      *   o_rtnLib      - Return the actual library that contains the event file.
      *
      *  Returns:
      *   done          - Returns cTrue on success, else cFalse.
      *=========================================================================
     P Eventf_open...
     P                 b                   export
     D                 pi
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
     D  o_rtnLib                                 like(evf_objName_t)
     D                                           options(*nopass: *omit)
      *
     D p_rtnLib        c                   3
      *
     D rtnLib          s                   like(o_rtnLib) inz
     D msg             ds                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

         if (%parms() >= p_rtnLib and %addr(o_rtnLib) <> *null);
            o_rtnLib = rtnLib;
         endif;

      /end-free
     P                 e
      *
      *=========================================================================
      *  Clears an existing event file member.
      *=========================================================================
      *  Parameters:
      *   i_lib         - Name of the library that contains the EVFEVENT file.
      *                   This parameter must be set to the name of the library
      *                   where the created object is to be stored.
      *   i_mbr         - Name of the member to use.
      *                   This parameter must be set to the name of the object
      *                   that is to be created.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_clear...
     P                 b                   export
     D                 pi
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
     D msg             ds                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  Opens an event file member for appending records. The event file
      *  is created, if it does not yet exist.
      *=========================================================================
      *  Parameters:
      *   i_lib         - Name of the library that contains the EVFEVENT file.
      *                   This parameter must be set to the name of the library
      *                   where the created object is to be stored.
      *   i_mbr         - Name of the member to use.
      *                   This parameter must be set to the name of the object
      *                   that is to be created.
      *   o_rtnLib      - Return the actual library that contains the event file.
      *
      *  Returns:
      *   done          - Returns cTrue on success, else cFalse.
      *=========================================================================
     P Eventf_openAppend...
     P                 b                   export
     D                 pi              n
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
     D  o_rtnLib                                 like(evf_objName_t)
     D                                           options(*nopass: *omit)
      *
     D p_rtnLib        c                   3
      *
     D rtnLib          s                   like(o_rtnLib) inz
     D msg             ds                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

         if (%parms() >= p_rtnLib and %addr(o_rtnLib) <> *null);
            o_rtnLib = rtnLib;
         endif;

         return cTrue;

      /end-free
     P                 e
      *
      *=========================================================================
      *  Appends a 'PROCESSOR' record to the event file.
      *=========================================================================
      *  Parameters:
      *   i_output_id   - The file ID of an output file produced by this
      *                   processor.
      *                   Default:        0
      *   i_line_class  - Method used to number lines.
      *                    EVF_LINE_CLASS_PHYSICAL_SOURCE -
      *                          physical line number
      *                    EVF_LINE_CLASS_EXPANDED_SOURCE -
      *                          line number in an expanded source
      *                   Default:        EVF_LINE_CLASS_PHYSICAL_SOURCE
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_writeProcessor...
     P                 b                   export
     D                 pi
     D  i_output_id                        const like(evf_output_id_t)
     D                                           options(*nopass: *omit)
     D  i_line_class                       const like(evf_line_class_t)
     D                                           options(*nopass: *omit)
      *
      *  Parameter positions
     D p_output_id     c                   1
     D p_line_class    c                   2
      *
      *  Optional parameters
     D output_id       s                   like(i_output_id)
     D line_class      s                   like(i_line_class)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (not %open(EVFEVENT));
            return;
         endif;

         if (%parms() >= p_output_id and %addr(i_output_id) <> *null);
            output_id = i_output_id;
         else;
            output_id = 0;
         endif;

         if (%parms() >= p_line_class and %addr(i_line_class) <> *null);
            line_class = i_line_class;
         else;
            line_class = EVF_LINE_CLASS_PHYSICAL_SOURCE;
         endif;

         writeTimestampRecord();
         writeProcessorRecord(output_id: line_class);

      /end-free
     P                 e
      *
      *=========================================================================
      *  Appends a 'FILEID' record to the event file.
      *=========================================================================
      *  Parameters:
      *   i_source_id   - A file identifier expressed as an integer.
      *   i_path        - Qualified member name, specified as:
      *                    a) a path name
      *                    b) a QSYS object name of type qFile_t
      *                    c) a QSYS object name of type qQSYSObj_t
      *   i_nameType    - Type of parameter 'i_path'.
      *                    EVF_NAME_TYPE_PATH - for a path name
      *                    EVF_NAME_TYPE_QSYS - for a QSYS object name
      *                   Default:        EVF_NAME_TYPE_QSYS
      *   i_temp_flag   - Indicates whether the source is a temporary file.
      *                   Default:        EVF_PERSISTENT_SOURCE
      *   i_line        - Source file line number where the new file
      *                   is referenced.
      *                   Default:        0
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_writeFileID...
     P                 b                   export
     D                 pi                  opdesc
     D  i_source_id                        const like(evf_source_id_t)
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
     D  i_nameType                    1a   const options(*nopass: *omit)
     D  i_temp_flag                        const like(evf_temp_flag_t)
     D                                           options(*nopass: *omit)
     D  i_line                             const like(evf_line_t)
     D                                           options(*nopass: *omit)
      *
      *  Parameter positions
     D p_path          c                   2
     D p_nameType      c                   3
     D p_temp_flag     c                   4
     D p_line          c                   5
      *
      *  Optional parameters
     D nameType        s                   like(i_nameType)
     D temp_flag       s                   like(i_temp_flag)
     D line            s                   like(i_line)
      *
     D qQSYSObj        ds                  likeds(qQSYSObj_t) inz
     D qFile           ds                  likeds(qFile_t) inz
     D nameInf         ds                  likeds(strInf_t) inz
     D path            s                   like(i_path) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (not %open(EVFEVENT));
            return;
         endif;

         if (%parms() >= p_nameType and %addr(i_nameType) <> *null);
            nameType = i_nameType;
         else;
            nameType = EVF_NAME_TYPE_QSYS;
         endif;

         if (%parms() >= p_temp_flag and %addr(i_temp_flag) <> *null);
            temp_flag = i_temp_flag;
         else;
            temp_flag = EVF_PERSISTENT_SOURCE;
         endif;

         if (%parms() >= p_line and %addr(i_line) <> *null);
            line = i_line;
         else;
            line = 0;
         endif;

         if (nameType = EVF_NAME_TYPE_QSYS);
            CEEGSI(p_path
                   : nameInf.dataType: nameInf.curlen: nameInf.maxlen: *omit);
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

      /end-free
     P                 e
      *
      *=========================================================================
      *  Appends a 'FILEEND' record to the event file.
      *=========================================================================
      *  Parameters:
      *   i_source_id   - A file identifier expressed as an integer.
      *   i_expansion   - Number of expanded source lines.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_writeFileEnd...
     P                 b                   export
     D                 pi
     D  i_source_id                        const like(evf_source_id_t)
     D  i_expansion                        const like(evf_expansion_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (not %open(EVFEVENT));
            return;
         endif;

         writeFileEndRecord(i_source_id: i_expansion);

      /end-free
     P                 e
      *
      *=========================================================================
      *  Appends an 'ERROR' record to the event file.
      *=========================================================================
      *  Parameters:
      *   i_source_id      - A file identifier expressed as an integer.
      *   i_stmt_line      - Line number containing the error.
      *   i_msg_id         - Message ID (for example, AMPX999).
      *   i_sev_num        - Severity level number.
      *   i_msg_text       - The message text of the error message.
      *   i_sev_char       - Severity code letter (I, W, E, S, or T).
      *   i_annot_class    - Indicates where in a listing of messages this
      *                      message should be placed.
      *   i_start_err_line - Line number containing the start of the error.
      *                      Default:        i_stmt_line
      *   i_end_err_line   - Line number containing the end of the error.
      *                      Default:        i_stmt_line
      *   i_token_start    - Column of the start of the token in error.
      *                      Default:        1
      *   i_token_end      - Column of the start of the token in error.
      *                      Default:        0
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_writeError...
     P                 b                   export
     D                 pi
     D  i_source_id                        const like(evf_source_id_t)
     D  i_stmt_line                        const like(evf_line_t)
     D  i_msg_id                           const like(evf_msg_id_t)
     D  i_sev_num                          const like(evf_sev_num_t)
     D  i_msg_text                         const like(evf_msg_text_t)
     D  i_sev_char                         const like(evf_sev_char_t)
     D                                           options(*nopass: *omit)
     D  i_annot_class                      const like(evf_annot_class_t)
     D                                           options(*nopass: *omit)
     D  i_start_err_line...
     D                                     const like(evf_line_t)
     D                                           options(*nopass: *omit)
     D  i_end_err_line...
     D                                     const like(evf_line_t)
     D                                           options(*nopass: *omit)
     D  i_token_start...
     D                                     const like(evf_token_t)
     D                                           options(*nopass: *omit)
     D  i_token_end...
     D                                     const like(evf_token_t)
     D                                           options(*nopass: *omit)
      *
      *  Parameter positions
     D p_sev_char      c                   6
     D p_annot_class...
     D                 c                   7
     D p_start_err_line...
     D                 c                   8
     D p_end_err_line  c                   9
     D p_token_start   c                   10
     D p_token_end     c                   11
      *
      *  Optional parameters
     D sev_char        s                   like(i_sev_char)
     D annot_class     s                   like(i_annot_class)
     D start_err_line  s                   like(i_start_err_line)
     D end_err_line    s                   like(i_end_err_line)
     D token_start     s                   like(i_token_start)
     D token_end       s                   like(i_token_end)
      *
     D msg_id          s                   like(i_msg_id)
     D msg_text        s                   like(i_token_end)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (%parms() >= p_sev_char and %addr(i_sev_char) <> *null);
            sev_char = i_sev_char;
         else;
            sev_char = getSeverityChar(i_sev_num);
         endif;

         if (%parms() >= p_annot_class and %addr(i_annot_class) <> *null);
            annot_class = i_annot_class;
         else;
            annot_class = getAnnotationClass(i_sev_num);
         endif;

         if (%parms() >= p_start_err_line and %addr(i_start_err_line) <> *null);
            start_err_line = i_start_err_line;
         else;
            start_err_line = i_stmt_line;
         endif;

         if (%parms() >= p_end_err_line and %addr(i_end_err_line) <> *null);
            end_err_line = i_end_err_line;
         else;
            end_err_line = start_err_line;
         endif;

         if (%parms() >= p_token_start and %addr(i_token_start) <> *null);
            token_start = i_token_start;
         else;
            token_start = 1;
         endif;

         if (%parms() >= p_token_end and %addr(i_token_end) <> *null);
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

      /end-free
     P                 e
      *
      *=========================================================================
      *  Copies the events of a given event file into this event file.
      *=========================================================================
      *  Parameters:
      *   i_fromLib     - Name of the library that contains the EVFEVENT file.
      *                   This parameter must be set to the name of the library
      *                   where the created object is to be stored.
      *   i_fromMbr     - Name of the member to use.
      *                   This parameter must be set to the name of the object
      *                   that is to be created.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_copyFrom...
     P                 b                   export
     D                 pi
     D  i_fromLib                          const like(evf_objName_t)
     D  i_fromMbr                          const like(evf_objName_t)
      *
     D buffer          ds           300
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  Closes an event file member.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Eventf_close...
     P                 b                   export
     D                 pi
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         closeEventFile();

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Appends a TIMESTAMP record to the event file.
      *
      *  This record indicates when the Events File was created, and allows an
      *  application to determine if the Events File is current (if the timestamp
      *  is older than a file indicated in a File ID record, the Events File may
      *  be incorrect for that file). This record is always the first record in
      *  the Events File.
      *
      *  Note: This record is not written by a processor; it is written by the
      *  caller of the first processor. This allows each processor to append to
      *  the Events File without having to determine if the file exists.
      *=========================================================================
     P writeTimestampRecord...
     P                 b
     D                 pi
      *
     D timestamp       ds           300    qualified inz
     D  format                 1     10a   inz('TIMESTAMP')
     D  version               12     12a   inz(VERSION)
     D  timestamp             14     27a
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         reset timestamp;
         timestamp.timestamp = %char(%date(): *ISO0) + %char(%time(): *HMS0);
         write EVFEVENT timestamp;

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Appends a PROCESSOR record to the event file.
      *
      *  This record indicates that a new processor has been invoked. One will
      *  always follow the timestamp record in the Events File (although there
      *  may be more than one).
      *
      *  version
      *  The revision of this record, used for upward compatibility. The current
      *  version is "1".
      *
      *  output-id
      *  The file ID of an output file produced by this processor. If the output
      *  of this processor is intended to be used as input to another processor,
      *  this file ID represents that file, and the file ID record of the file
      *  will follow this record. If this is the last processor that will be
      *  invoked for which the editor will be expected to display messages, the
      *  file ID is 0.
      *
      *  line-class
      *  Method used to number lines. Specify zero if a temporary file or
      *  internal file containing an expanded source representation is being
      *  used; the line number represents the line number in the expanded source.
      *  Specify one if the line number represents the physical line number in
      *  the source file indicated in source file ID field.
      *
      *  Note: If the output of one processor is intended as the input to another
      *  processor, the FILEID record for the output should contain a name, even
      *  if the output is not placed in a real file. This same name should be
      *  used in the input FILEID record of the processor using the output.
      *=========================================================================
     P writeProcessorRecord...
     P                 b
     D                 pi
     D  i_output_id                        const like(evf_output_id_t)
     D  i_line_class                       const like(evf_line_class_t)
      *
     D processor       ds           300    qualified inz
     D  format                 1     10a   inz('PROCESSOR')
     D  version               12     12a   inz(VERSION)
     D  output_id             14     16a
     D  line_class            18     18a
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         reset processor;
         processor.output_id = %editc(i_output_id: 'X');
         processor.line_class = i_line_class;
         write EVFEVENT processor;

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Appends a FILEID record to the event file.
      *
      *  This record contains the full name of the source file processed and
      *  associates an integer with the file name. There should be one record of
      *  this type for each source file processed (the main source file as well
      *  as any included source units (copylib members) and macros).
      *
      *  Note: If a file is included several times during processing, a file ID
      *  record should be written for each inclusion.
      *
      *  version
      *  The revision of this record, used for upward compatibility. The current
      *  version is "1".
      *
      *  source-id
      *  A file identifier expressed as an integer to be used in place of the
      *  file name to correlate an error record with the source file in which it
      *  occurred, without having to use the character based file name. Use zero
      *  if the input file is not known, such as input coming from a user exit.
      *
      *  line
      *  Source file line number where a new file is referenced, or zero if the
      *  file was not referenced from a file.
      *
      *  length
      *  Length of the file name; the maximum length is 255. In a FILEIDCONT
      *  record, the length is always zero since length is only determined by the
      *  file ID record.
      *
      *  filename
      *  The name should be the fully-qualified physical file name. If none
      *  exists (for example, getting text from the user) or the name can't be
      *  determined, place a null string here.
      *  The name can include servername.
      *
      *  sourcefile timestamp
      *  This is the timestamp on the Source file.
      *
      *  temp flag
      *  This field is set to 1 to indicate the source is a temporary file,
      *  otherwise it is set to 0. Temporary source file can only be opened in
      *  browse mode. Currently the temp flag is used to reference output
      *  generated by SQL preprocessor.
      *=========================================================================
     P writeFileIDRecord...
     P                 b
     D                 pi
     D  i_source_id                        const like(evf_source_id_t)
     D  i_line                             const like(evf_line_t)
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
     D  i_temp_flag                        const like(evf_temp_flag_t)
      *
     D fileID          ds           300    qualified inz
     D  format                 1     10a   inz('FILEID')
     D  version               12     12a   inz(VERSION)
     D  source_id             14     16a
     D  line                  18     23a
     D  length                25     27a
      *   char(*) - file name              FILE/LIBRARY(MEMBER), max. length = 255
      *   char(*) - source file timestamp  YYYYMMDDhhmmss
      *   char(*) - temp flag              0/1
      *
     D MAX_NAME_LENGTH...
     D                 c                   255
      *
     D pos             s             10u 0
     D offset          s             10u 0
     D len             s             10u 0
     D lastChanged     s             14a
     D path            s                   like(i_path) inz
     D qFile           ds                  likeds(qFile_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Appends a FILEEND record to the event file.
      *
      *  This record indicates that an included file is ending. It provides a
      *  method to determine the nesting of include files so a program can
      *  navigate back up the include chain. This is useful when the included
      *  file does not contain enough information to determine what caused the
      *  error.
      *
      *  version
      *  The revision of this record, used for upward compatibility. The current
      *  version is "1".
      *
      *  file-id
      *  file ID of this file. (source-id)
      *
      *  expansion
      *  Number of expanded source lines in this file, including any nested
      *  includes and macro expansions.
      *
      *  Note: Every file ID record must have a corresponding file end record,
      *  except for the file ID that follows the processor record to define the
      *  output file.
      *=========================================================================
     P writeFileEndRecord...
     P                 b
     D                 pi
     D  i_source_id                        const like(evf_source_id_t)
     D  i_expansion                        const like(evf_expansion_t)
      *
     D fileEnd         ds           300    qualified inz
     D  format                 1     10a   inz('FILEEND')
     D  version               12     12a   inz(VERSION)
     D  source_id             14     16a
     D  expansion             18     23a
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         reset fileEnd;
         fileEnd.source_id = %editc(i_source_id: 'X');
         fileEnd.expansion = %editc(i_expansion: 'X');
         write EVFEVENT fileEnd;

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Appends an ERROR record to the event file.
      *
      *  A record of this type contains information required to locate a token or
      *  line causing a message in the source file, as well as enough information
      *  to allow the message itself to be displayed. This information includes
      *  location information (such as what file and line the error occurred on)
      *  and information related to the error itself (such as the number, text,
      *  and severity of the message).
      *
      *  version
      *  The revision of this record, used for upward compatibility. The current
      *  version is "1".
      *
      *  file-id
      *  file ID of this file. (source-id)
      *
      *  annot-class
      *  Indicates where in a listing of messages this message should be placed
      *  when the Events File is loaded in the Error List window. The positions
      *  are defined as follows:
      *
      *   0 - top of list
      *   2 - middle of list
      *   3 - bottom of list
      *
      *  stmt-line
      *  Line number (in the source file associated with the above source file ID
      *  number) of the first line of the statement containing the error. This is
      *  required in case the error does not occur on the first line of the
      *  statement. This number is interpreted using the line class field.
      *
      *  start-err-line
      *  Line number (in the source file associated with the above source file ID
      *  number) containing the start of the error. This number is interpreted
      *  using the line class field.
      *
      *  token-start
      *  Column (or character in the line) of the start of the token in error. If
      *  this information is not available, a zero here will cause the entire
      *  line to be flagged as an error.
      *
      *  end-err-line
      *  Line number (in the source file associated with the above source file ID
      *  number) containing the end of the error. This number is interpreted
      *  using the line class field.
      *
      *  token-end
      *  Column (or character in the line) of the end of the token in error. If
      *  this information is not available, a zero here will cause the entire
      *  line to be flagged as an error.
      *
      *  msg-id
      *  Message ID (for example, AMPX999).
      *
      *  sev-char
      *  Severity code letter (I, W, E, S, or T).
      *
      *  sev-num
      *  Severity level number. For some systems, this is the return code
      *  associated with the severity code letter
      *  (for example, I=0, W=4, E=8, S=12, T=16).
      *
      *  length
      *  The actual length of the message text (the next field). The maximum
      *  length is 1024 bytes.
      *
      *  msg
      *  The message text of the error message. Any replacement of fields should
      *  have already been done.
      *=========================================================================
     P writeErrorRecord...
     P                 b
     D                 pi
     D  i_source_id                        const like(evf_source_id_t)
     D  i_annot_class                      const like(evf_annot_class_t)
     D  i_stmt_line                        const like(evf_line_t)
     D  i_start_err_line...
     D                                     const like(evf_line_t)
     D  i_token_start                      const like(evf_token_t)
     D  i_end_err_line...
     D                                     const like(evf_line_t)
     D  i_token_end                        const like(evf_token_t)
     D  i_msg_id                           const like(evf_msg_id_t)
     D  i_sev_char                         const like(evf_sev_char_t)
     D  i_sev_num                          const like(evf_sev_num_t)
     D  i_length                           const like(evf_length_t)
     D  i_msg_text                         const like(evf_msg_text_t)
      *
     D error           ds           300    qualified inz
     D  format                 1     10a   inz('ERROR')
     D  version               12     12a   inz(VERSION)
     D  source_id             14     16a
     D  annot_class           18     18a
     D  stmt_line             20     25a
     D  start_err_line...
     D                        27     32a
     D  token_start           34     36a
     D  end_err_line          38     43a
     D  token_end             45     47a
     D  msg_id                49     55a
     D  sev_char              57     57a
     D  sev_num               59     60a
     D  length                62     64a
     D  msg                   66    283a
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Adds a value to the output buffer.
      *=========================================================================
     P addValue...
     P                 b
     D                 pi            10u 0
     D  io_buffer                   300a
     D  io_pos                       10u 0
     D  i_value                     300a   const
      *
     D length          s             10u 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Returns the timestamp, the file was last changed.
      *=========================================================================
     P getLastChangedTime...
     P                 b
     D                 pi              z
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
      *
     D lastChanged     s               z   inz
      *
     D rc              s             10i 0
     D st_stat         ds                  likeds(st_stat_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         rc = stat(i_path: %addr(st_stat));
         if (rc <> 0);
            return lastChanged;
         endif;

         lastChanged = f_cvtEpochTS(st_stat.ctime);

         return lastChanged;

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Returns the QSYS file name.
      *=========================================================================
     P getQSYSFileName...
     P                 b
     D                 pi                  likeds(qFile_t)
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
      *
     D qFile           ds                  likeds(qFile_t) inz
      *
     D pathName        ds                  likeds(Qlg_Path_Name_t) inz
     D qsys_info       ds                  likeds(qsys0100_t) inz
     D errCode         ds                  likeds(errCode_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Creates an event file.
      *=========================================================================
     P createEventFile...
     P                 b
     D                 pi
     D  i_file                             const like(evf_objName_t)
     D  i_lib                              const like(evf_objName_t)
      *
     D command         s            128a   varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         command = 'CRTPF FILE(' + %trim(i_lib) + '/' + %trim(i_file) + ') +
                      RCDLEN(300) MAXMBRS(*NOMAX) SIZE(500000 1000 3) +
                      CCSID(*HEX) MBR(*NONE)';

         QCMDEXC(command: %len(command));

         p_rmvPgmMsg(cMsg_Rmv_All);

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Adds a member to a given event file.
      *=========================================================================
     P addEventFileMember...
     P                 b
     D                 pi
     D  i_file                             const like(evf_objName_t)
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
     D command         s            128a   varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         command = 'ADDPFM FILE(' + %trim(i_lib) + '/' + %trim(i_file) + ') +
                      MBR(' + %trim(i_mbr) + ')';

         QCMDEXC(command: %len(command));

         p_rmvPgmMsg(cMsg_Rmv_All);

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Clears the member of the event file.
      *=========================================================================
     P clearEventFileMember...
     P                 b
     D                 pi
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
     D command         s            128a   varying inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         command =
            'CLRPFM FILE(' + %trim(i_lib) + '/' + EVENT_FILE + ') +
                    MBR(' + %trim(i_mbr) + ')';

         QCMDEXC(command: %len(command));

         p_rmvPgmMsg(cMsg_Rmv_All);

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Opens the event file.
      *=========================================================================
     P openEventFile...
     P                 b
     D                 pi                  like(evf_objName_t)
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         g_status.outFile = %trim(i_lib) + '/' + EVENT_FILE;
         g_status.outMbr = %trim(i_mbr);
         open EVFEVENT;

         return g_fileInfo.openFB.lib;

      /end-free
     P                 e
      *
      *=========================================================================
      *  *** private ***
      *  Closes the event file.
      *=========================================================================
     P closeEventFile...
     P                 b
     D                 pi
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (not %open(EVFEVENT));
            return;
         endif;

         close EVFEVENT;
         clear g_status;

      /end-free
     P                 e
      *
      *=========================================================================
      *  Converts a given message severity to the annotation class.
      *=========================================================================
     P getAnnotationClass...
     P                 b
     D                 pi             1a
     D  i_msgSeverity                10i 0 value
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

        select;
        when (i_msgSeverity >= 50);
           return EVF_ANNOTATION_TOP;
        other;
           return EVF_ANNOTATION_MIDDLE;
        endsl;

      /end-free
     P                 e
      *
      *=========================================================================
      *  Converts a given message type to the severity character.
      *  Rules:
      *    n >= 40    -->   Terminating
      *    n >= 30    -->   Severe
      *    n >= 20    -->   Error
      *    n >= 10    -->   Warning
      *    other      -->   Info
      *=========================================================================
     P getSeverityChar...
     P                 b
     D                 pi             1a
     D  i_msgSeverity                10i 0 value
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

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

      /end-free
     P                 e
      *
