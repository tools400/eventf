      *===============================================================*
      *                                                               *
      *  erstellt : 19.05.2013                                        *
      *                                                               *
      *===============================================================*
      *                                                               *
      *  Kurzdokumentation :                                          *
      *                                                               *
      *  Rahmentestprogramm mit Protokollausgabe                      *
      *  Thema:                                                       *
      *     Event File API - Example 2 (QSYS object names)            *
      *                                                               *
      *===============================================================*
      * >>PRE-COMPILER<<                                              *
      *                                                               *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                   *
      *                           SRCFILE(&SL/&SF) +                  *
      *                           SRCMBR(&SM);                        *
      *                                                               *
      *   >>COMPILE<<                                                 *
      *     >>PARM<< TRUNCNBR(*NO);                                   *
      *     >>PARM<< DBGVIEW(*LIST);                                  *
      *     >>PARM<< OPTION(*EVENTF);                                 *
      *   >>END-COMPILE<<                                             *
      *                                                               *
      *   >>EXECUTE<<                                                 *
      *                                                               *
      *   >>CMD<<    CRTPGM       PGM(&LI/&OB) +                      *
      *                           MODULE(&LI/&OB          +           *
      *                                          ) +                  *
      *                           BNDSRVPGM(*LIBL/BASICS1      +      *
      *                                     *LIBL/EVENTF       +      *
      *                                          ) +                  *
      *                           BNDDIR(*N         ) +               *
      *                           DETAIL(*BASIC) +                    *
      *                           ACTGRP(*NEW);                       *
      *                                                               *
      * >>END-PRE-COMPILER<<                                          *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
     FQSYSPRT   O    F   80        PRINTER OFLIND(*in70)
      *
      * ------------------------------------
      *  Type definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1                      SrvPgm: Basics 1
      *
      *  Examinee
      /COPY QEVENTF,PEVENTF                        Event File API
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Globale Konstanten
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                  extpgm('EVENTFT2')
      *
     D main...
     D                 PR                         extproc('main')
      *
      *  Logs a message to the job log or appends it to a spooled file
     D logMsg...
     D                 PR                         extproc('logMsg')
     D  i_text                      128A   value  varying options(*nopass)
      *
      *  Sends a message to QCMD
     D sndMsg...
     D                 PR                         extproc('sndMsg')
     D  i_text                      128A   value  varying
      *
      *  Prints a given message to QSYSPRT.
     D printMsg...
     D                 PR                  extproc('printMsg')
     D  i_text                      128A   value  varying options(*nopass)
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
     D PGM_ENTRY_POINT...
     D                 PI
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         if (%open(QSYSPRT));
            close QSYSPRT;
         endif;

         *inlr = *on;

      /END-FREE
      *
      *===============================================================*
      *  *** private ***
      *  Logs a message to the job log or appends it to a spooled file
      *===============================================================*
     P logMsg...
     P                 B
     D                 PI
     D  i_text                      128A   value  varying options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE


         if (%parms() >= 1);
            printMsg(i_text);
            // sndMsg(i_text);
         else;
            printMsg('');
            // no output to the job log
         endif;

      /END-FREE
      *
     P                 E
      *
      *===============================================================*
      *  *** private ***
      *  Sends a message to the caller.
      *===============================================================*
     P sndMsg...
     P                 B
     D                 PI
     D  i_text                      128A   value  varying
      *
      *  Return value
     D pBuffer         S               *   inz
      *
      *  Local fields
     D msgKey          S              4A                        inz
      *
     D qMsgF           DS                  qualified            inz
     D  name                         10A
     D  lib                          10A
      *
     D errCode         DS                  qualified            inz
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved                      1A
     D  excDta                      256A
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D   i_msgID                      7A   const
     D   i_qMsgF                     20A   const
     D   i_msgData                32767A   const  options(*varsize )
     D   i_length                    10I 0 const
     D   i_msgType                   10A   const
     D   i_callStkE               32767A   const  options(*varsize )
     D   i_callStkC                  10I 0 const
     D   o_msgKey                     4A
     D   io_ErrCode               32767A          options(*varsize )
     D   i_lenStkE                   10I 0 const  options(*nopass  )
     D   i_callStkEQ                 20A   const  options(*nopass  )
     D   i_wait                      10I 0 const  options(*nopass  )
     D   i_callStkEDT                10A   const  options(*nopass  )
     D   i_ccsid                     10I 0 const  options(*nopass  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
         clear qMsgF;
         qMsgF.name = 'QCPFMSG';
         qMsgF.lib  = '*LIBL';
         clear errCode;
         errCode.bytPrv = %size(errCode);
         QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                  : '*CTLBDY': 1
                  : msgKey: errCode);
         return;

      /END-FREE
      *
     P                 E
      *
      * =====================================================================
      *  *** private ***
      *  Prints a given message to QSYSPRT.
      * =====================================================================
     P printMsg...
     P                 B
     D                 PI
     D  i_text                      128A   value  varying options(*nopass)
      *
      *  Local fields
     D lineOutput      DS            80    inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free
         if (not %open(QSYSPRT));
            open QSYSPRT;
         endif;
         if (%parms() >= 1);
            lineOutput = i_text;
         endif;
         write QSYSPRT lineOutput;
      /end-free
     P                 E
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D source_id       s                   like(evf_source_id_t)
     D object          s                   like(evf_objName_t)
     D library         s                   like(evf_objName_t)
     D qFile           ds                  likeds(qFile_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         object = 'EVENTF';
         library = 'RADDATZ';

         Eventf_open(library: object);
         Eventf_writeProcessor();

         // Add module source
         source_id = 1;
         qFile.name = 'QEVENTF';
         qFile.lib = 'RADDATZ';
         qFile.mbr = 'EVENTF1';
         Eventf_writeFileID(source_id: qFile
                            : EVF_NAME_TYPE_QSYS
                            : EVF_PERSISTENT_SOURCE);

         // Add first /copy book
         qFile.name = 'QEVENTF';
         qFile.lib = 'RADDATZ';
         qFile.mbr = 'H_SPEC';
         Eventf_writeFileID(source_id + 1: qFile
                            : EVF_NAME_TYPE_QSYS
                            : EVF_PERSISTENT_SOURCE
                            : 43);

         Eventf_writeFileEnd(source_id + 1: 10);
         Eventf_writeFileEnd(source_id: 842);

         Eventf_close();

      /END-FREE
      *
     P main...
     P                 E
      *
