**free
/if not defined(Qp0lCvtPathToQSYSObjName)
/define Qp0lCvtPathToQSYSObjName

//  Qp0lCvtPathToQSYSObjName()--Resolve Integrated File System Path Name
//                              into QSYS Object Name
dcl-pr Qp0lCvtPathToQSYSObjName int(10) extproc('Qp0lCvtPathToQSYSObjName');
  i_path      likeds(Qlg_Path_Name_t) const;
  o_qsys_info char(65535) options(*varsize);
  i_format    char(8) const;
  i_bytPrv    int(10) value;
  i_ccsid     int(10) value;
  io_errCode  char(65535) options(*varsize);
end-pr;

dcl-ds qsys0100_t qualified template;
  bytRet   int(10);
  bytAvl   int(10);
  ccsid    int(10);
  lib_name char(28);
  lib_type char(20);
  obj_name char(28);
  obj_type char(20);
  mbr_name char(28);
  mbr_type char(20);
  asp_name char(28);
end-ds;

/if not defined(Qlg_Path_Name)
/define Qlg_Path_Name
dcl-ds Qlg_Path_Name_t qualified align template;
  ccsid               int(10);
  country_ID          char(2);
  language_ID         char(3);
  reserved            char(3);
  path_Type           uns(10);
  path_Length         int(10);
  path_Name_Delimiter char(2);
  reserved2           char(10);
  path_Name           char(256);
end-ds;

dcl-c QLG_PATH_JOB_CCSID 0;
dcl-c QLG_PATH_JOB_COUNTRYID x'0000';
dcl-c QLG_PATH_JOB_LANGUAGEID x'000000';

//  The Path_Name is a character string and the delimiter is one byte long.
dcl-c QLG_CHAR_SINGLE 0;

//  The Path_Name is a pointer and the delimiter is one byte long.
dcl-c QLG_PTR_SINGLE 1;

//  The Path_Name is a character string and the delimiter is two bytes long.
dcl-c QLG_CHAR_DOUBLE 2;

//  The Path_Name is a pointer and the delimiter is two bytes long.
dcl-c QLG_PTR_DOUBLE 3;

/endif
/endif