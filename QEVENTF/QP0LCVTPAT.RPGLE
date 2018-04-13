 DEF  /IF NOT DEFINED(Qp0lCvtPathToQSYSObjName)
 DEF  /DEFINE Qp0lCvtPathToQSYSObjName
      *
      *  Qp0lCvtPathToQSYSObjName()--Resolve Integrated File System Path Name
      *                              into QSYS Object Name
     D Qp0lCvtPathToQSYSObjName...
     D                 PR            10I 0 extproc('Qp0lCvtPathToQSYSObjName')
     D  i_path                             const  likeds(Qlg_Path_Name_t)
     D  o_qsys_info               65535A          options(*varsize)
     D  i_format                      8A   const
     D  i_bytPrv                     10I 0 value
     D  i_ccsid                      10I 0 value
     D  io_errCode                65535A          options(*varsize)
      *
     D qsys0100_t      DS                  qualified based(pDummy)
     D  bytRet                 1      4i 0
     D  bytAvl                 5      8i 0
     D  ccsid                  9     12i 0
     D  lib_name              13     40a
     D  lib_type              41     60a
     D  obj_name              61     88a
     D  obj_type              89    108a
     D  mbr_name             109    136a
     D  mbr_type             137    156a
     D  asp_name             157    184a
      *
      /if not defined(Qlg_Path_Name)
      /define Qlg_Path_Name
     D Qlg_Path_Name_t...
     D                 DS                  qualified align         based(pDummy)
     D   CCSID                       10I 0
     D   Country_ID                   2A
     D   Language_ID                  3A
     D   Reserved                     3A
     D   Path_Type                   10U 0
     D   Path_Length                 10I 0
     D   Path_Name_Delimiter...
     D                                2A
     D   Reserved2                   10A
     D   Path_Name                  256A
      *
     D QLG_PATH_JOB_CCSID...
     D                 C                   0
     D QLG_PATH_JOB_COUNTRYID...
     D                 C                   x'0000'
     D QLG_PATH_JOB_LANGUAGEID...
     D                 C                   x'000000'
      *
      *  The Path_Name is a character string and the delimiter is one byte long.
     D QLG_CHAR_SINGLE...
     D                 C                   0
      *
      *  The Path_Name is a pointer and the delimiter is one byte long.
     D QLG_PTR_SINGLE...
     D                 C                   1
      *
      *  The Path_Name is a character string and the delimiter is two bytes long.
     D QLG_CHAR_DOUBLE...
     D                 C                   2
      *
      *  The Path_Name is a pointer and the delimiter is two bytes long.
     D QLG_PTR_DOUBLE...
     D                 C                   3
      *
      /endif
      *
 DEF  /ENDIF
