**free
/if not defined(fileInfDS_t)
/define fileInfDS_t
//===============================================================*
//  File information data structure                              *
//===============================================================*
dcl-ds fileInfDS_t qualified template;
  // Reserved 01
  reserved_01      char(8) pos(1);
  // Open indication 1=open
  isOpen           char(1) pos(9);
  // End of file 1=EOF
  isEOF            char(1) pos(10);
  // Status
  status           zoned(5) pos(11);
  // Operation code, first 5 pos.
  opCode           char(5) pos(16);
  // IO-Type:
  //   F=The last operation was specified for a file name
  //   R=The last operation was specified for a record
  //   I=The last operation was an implicit file operation.
  IO_type          char(1) pos(21);
  // Routine of operation code
  routine          char(8) pos(22);
  // RPG source listing line nbr
  srcSeq           char(8) pos(30);
  // Record format
  rcdFormat        char(8) pos(38);
  // System message number
  sysMsgNbr        char(7) pos(46);
  // Reserved 02
  reserved_02      char(14) pos(53);
  // Valid after post:
  //    Screen size (product of the number of rows
  //    and the number of columns on the device screen).
  screenSize       zoned(4) pos(67);
  //    The display's keyboard type.
  //       00 = alphanumeric or katakana
  //       10 = ideographic
  kbdType          zoned(2) pos(71);
  //    The display type.
  //       00 = alphanumeric or katakana
  //       10 = ideographic
  //       20 = DBCS
  displayType      zoned(2) pos(73);
  //    Always set to 00.
  mode             zoned(2) pos(75);
  // Reserved_03
  reserved_03      char(4) pos(77);

  //  -------------------------------
  //    Open Feedback
  //  -------------------------------
  openFeedback     likeds(openFeedback_t);

  //  -------------------------------
  //    Input/Output Feedback
  //  -------------------------------
  IO_feedback      likeds(IO_feedback_t);

  //  -------------------------------
  //    I/O Feedback, File specific
  //  -------------------------------
  IO_feedback_file char(256);
  //    I/O Feedback Database File
  IO_feedback_DB   likeds(IO_feedback_DB_t) overlay(IO_feedback_file);
end-ds;

//  -------------------------------
//    Open Feedback
//  -------------------------------
dcl-ds openFeedback_t len(160) qualified;
  // DS=Display DB=File SP=Spooled File
  ODP_type      char(2) pos(1);
  // File name
  file          char(10) pos(3);
  // Library
  lib           char(10) pos(13);
  // Spool file name
  spoolFile     char(10) pos(23);
  // Spool file library
  spoolLib      char(10) pos(33);
  // Spool file number
  spoolNbr      int(5) pos(43);
  // Record length
  maxRcdLength  int(5) pos(45);
  // Key length
  maxKeyLength  int(5) pos(47);
  // Member
  mbr           char(10) pos(49);
  // Reserved
  reserved_01   int(10) pos(59);
  // Reserved
  reserved_02   int(10) pos(63);
  // File type
  //     1  =  Display
  //     2  =  Printer
  //     4  =  Diskette
  //     5  =  Tape
  //     9  =  Save
  //    10  =  DDM
  //    11  =  ICF
  //    20  =  Inline data
  //    21  =  Database
  fileType      int(5) pos(67);
  // Reserved
  reserved_03   char(3) pos(69);
  // Number of lines on a display screen or       (Display, printer)
  // number of lines on a printed page.
  rows          int(5) pos(72);
  // Length of the null field byte map.           (Database)
  lenNullFldMap int(5) pos(72);
  // Number of positions on a display screen or   (Display, printer)
  // number of characters on a printed line.
  columns       int(5) pos(74);
  // Length of the null key field byte map.       (Database)
  lenKeyFldMap  int(5) pos(74);
  // Number of records in the member at open
  // at open time.
  numRcdsAtOpen int(10) pos(76);
  // Access type
  accessType    char(2) pos(80);
  // Duplicate key?
  isDupKey      char(1) pos(82);
  // Source file?
  isSrcFile     char(1) pos(83);
  // Reserved
  reserved_04   char(10) pos(84);
  // Reserved
  reserved_05   char(10) pos(94);
  // Offset to volume label fields of open
  // feedback area.
  ofsVolLblFld  int(5) pos(104);
  // Max rcds in blk
  maxBlkRcds    int(5) pos(106);
  // Overflow line
  overflow      int(5) pos(108);
  // Blk increment
  blkInc        int(5) pos(110);
  // Reserved
  reserved_06   char(4) pos(112);
  // Miscellaneous flags
  flags1        char(1) pos(116);
  // Requester name
  requester     char(10) pos(117);
  // Open count
  openCount     int(5) pos(127);
  // Reserved
  reserved_07   char(1) pos(129);
  // Num based mbrs
  numBasedMbrs  int(5) pos(131);
  // Miscellaneous flags
  flags2        char(1) pos(133);
  // Open identifier
  openID        char(2) pos(134);
  // Max rcd fmt length
  maxRcdFmtLen  int(5) pos(136);
  // Database CCSID
  CCSID         int(5) pos(138);
  // Miscellaneous flags
  flags3        char(1) pos(140);
  // Reserved
  reserved_08   char(6) pos(141);
  // Num devs defined
  numDevices    int(5) pos(147);
end-ds;

//  -------------------------------
//    Input/Output Feedback
//  -------------------------------
dcl-ds IO_feedback_t len(126) qualified;
  // Offset to file dependant feedback
  ofsFileDepFB   int(5);
  // Write count
  writeCount     int(10);
  // Read count
  readCount      int(10);
  // Write/read count
  writeReadCount int(10);
  // Other I/O count
  otherCount     int(10);
  // Reserved
  reserved_01    char(1);
  // Current operation
  //   hex 01 =  Read or read block or read from invited devices
  //   hex 02 =  Read direct
  //   hex 03 =  Read by key
  //   hex 05 =  Write or write block
  //   hex 06 =  Write-read
  //   hex 07 =  Update
  //   hex 08 =  Delete
  //   hex 09 =  Force-end-of-data
  //   hex 0A =  Force-end-of-volume
  //   hex 0D =  Release record lock
  //   hex 0E =  Change end-of-data
  //   hex 0F =  Put deleted record
  //   hex 11 =  Release device
  //   hex 12 =  Acquire device
  operation      char(1);
  // Rcd format name
  IO_rcdFmt      char(10);
  // Device class
  deviceClass    char(2);
  // Pgm device name
  IO_pgmDevice   char(10);
  // Rcd len of I/O
  IO_rcdLength   int(10);
  // Reserved
  reserved_02    char(80);
end-ds;

//  -------------------------------
//    I/O Feedback Database File
//  -------------------------------
dcl-ds IO_feedback_DB_t qualified;
  // Number of locked records
  numLckRcds   int(5) pos(11);
  // Maximum number of fields
  maxNumFlds   int(5);
  // Nbr of key fields
  nbrOfKeyFlds int(5) pos(21);
  // Key length
  keyLength    int(5) pos(27);
  // Data member number.
  dtaMbrNum    int(5);
  // Relative record number in data member.
  rcdNbr       uns(10);
end-ds;

/endif