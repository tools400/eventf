**free
/if not defined(CEELIB)
/define CEELIB

// ---------------------------------------------------------------
//   Program or Procedure Call APIs
// ---------------------------------------------------------------

//  Condition token, used as feedback code
dcl-ds cee_fc_t qualified template;
  Condition_ID char(4) pos(1);
  MsgSev       int(5) pos(1);
  Msg_No       uns(5) pos(3);
  Flags        char(1) pos(5);
  Facility_ID  char(3) pos(6);
  I_S_Info     char(4) pos(9);
end-ds;

//  Retrieve Operational Descriptor Information (CEEDOD)
dcl-pr CEEDOD extproc('CEEDOD');
  i_posn     int(10) const;
  o_desctype int(10);
  o_datatype int(10);
  o_descinf1 int(10);
  o_descinf2 int(10);
  o_datalen  int(10);
  o_fc       char(12) options(*omit);
end-pr;

//  Reference fields for CEEDOD API
dcl-ds descInf_t qualified template;
  desctype int(10);
  datatype int(10);
  descinf1 int(10);
  descinf2 int(10);
  datalen  int(10);
end-ds;

//  Test for Omitted Argument (CEETSTA) API
dcl-pr CEETSTA extproc('CEETSTA');
  io_isPresent int(10);
  i_argNum     int(10) const;
  o_fc         char(12) options(*omit);
end-pr;

//  Get String Information (CEEGSI) API
dcl-pr CEEGSI extproc('CEEGSI');
  i_posn     int(10) const;
  o_datatype int(10);
  o_curlen   int(10);
  o_maxlen   int(10);
  o_fb       char(12) options(*omit);
end-pr;

//  Reference fields for CEEGSI API
dcl-ds strInf_t qualified template;
  datatype int(10);
  curlen   int(10);
  maxlen   int(10);
end-ds;

// ---------------------------------------------------------------
//   Math APIs
// ---------------------------------------------------------------

//  Logarithm base 10 (double float)
dcl-pr CEESDLG1 extproc('CEESDLG1');
  i_value  float(8) const;
  o_result float(8);
end-pr;

// ---------------------------------------------------------------
//   ILE CEE Date and Time APIs
// ---------------------------------------------------------------

//  Calculate Day of Week from Lilian Date (CEEDYWK) API
dcl-pr CEEDYWK opdesc extproc('CEEDYWK');
  i_lilian_date int(10) const;
  o_day_no      int(10);
  o_feedback    char(12) options(*omit);
end-pr;

//  Convert Lilian Date to Character Format (CEEDATE) API
dcl-pr CEEDATE opdesc extproc('CEEDATE');
  i_lilian_date int(10) const;
  i_date_format char(80) options(*varsize) const;
  o_char_date   char(80) options(*varsize);
  o_feedback    char(12) options(*omit);
end-pr;

//  Convert Date to Lilian Format (CEEDAYS) API
dcl-pr CEEDAYS opdesc extproc('CEEDAYS');
  i_char_date   char(80) options(*varsize) const;
  i_date_format char(80) options(*varsize) const;
  o_lilian_date int(10);
  o_feedback    char(12) options(*omit);
end-pr;

//  Convert Seconds to Character Timestamp (CEEDATM) API
dcl-pr CEEDATM opdesc extproc('CEEDATM');
  i_input_seconds    float(8) const;
  i_picture_string   char(80) options(*varsize) const;
  o_output_timestamp char(80) options(*varsize);
  o_feedback         char(12) options(*omit);
end-pr;

//  Get Offset from Universal Time Coordinated to Local Time (CEEUTCO) API
dcl-pr CEEUTCO extproc('CEEUTCO');
  o_offsethours   int(10);
  o_offsetminutes int(10);
  o_offsetseconds float(8);
  o_feedback      char(12) options(*nopass);
end-pr;

dcl-ds cee_utco_t qualified template;
  offhours int(10);
  offmins  int(10);
  offsecs  float(8);
end-ds;

//  Convert Timestamp to Number of Seconds (CEESECS) API
dcl-pr CEESECS extproc('CEESECS') opdesc;
  i_inTimestamp char(255) options(*varsize) const;
  i_inPicture   char(255) options(*varsize) const;
  o_outSeconds  float(8);
  o_outFC       char(12) options(*omit);
end-pr;

// ---------------------------------------------------------------
//   Activation Group and Control Flow APIs
// ---------------------------------------------------------------

//  Register Activation Group Exit Procedure (CEE4RAGE) API
dcl-pr CEE4RAGE extproc('CEE4RAGE');
  i_pProc pointer(*proc) const;
  o_fc    char(12) options(*omit);
end-pr;

dcl-c END_ACTGRP_CODE_EXCEPTION_MESSAGE x'40000000';
dcl-c END_ACTGRP_CODE_ABNORMAL_END x'00008000';
dcl-c END_ACTGRP_CODE_ACTGRP_IS_ENDING x'00004000';
dcl-c END_ACTGRP_CODE_INIT_BY_RCLACTGRP x'00002000';
dcl-c END_ACTGRP_CODE_INIT_BY_JOB_END x'00001000';
dcl-c END_ACTGRP_CODE_INIT_BY_EXIT_VERB x'00000800';
dcl-c END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK x'00000400';
dcl-c END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP x'00000200';

dcl-pr CEE4RAGE_user_exit extproc('CEE4RAGE_user_exit');
  i_ag_mark      uns(10) const;
  i_reason       uns(10) const;
  io_result_code uns(10);
  io_user_rc     int(10);
end-pr;

//  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
dcl-pr CEERTX extproc('CEERTX');
  i_procPtr  pointer(*proc) const;
  i_rtxToken pointer options(*omit) const;
  o_fc       char(12) options(*omit);
end-pr;

dcl-pr CEERTX_user_exit extproc('CEERTX_user_exit');
  i_rtxToken pointer const;
end-pr;

//  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
dcl-pr CEEUTX extproc('CEEUTX');
  i_procPtr pointer(*proc) const;
  o_fc      char(12) options(*omit);
end-pr;

/endif
