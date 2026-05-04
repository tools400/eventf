**free
/if not defined(PEVENTF)
/define PEVENTF

//  Type templates
dcl-s evf_path_t varchar(5000) template;
dcl-s evf_objName_t char(10) template;
dcl-s evf_output_id_t zoned(3) template;
dcl-s evf_line_class_t char(1) template;
dcl-s evf_source_id_t zoned(3) template;
dcl-s evf_line_t uns(10) template;
dcl-s evf_temp_flag_t char(1) template;
dcl-s evf_expansion_t zoned(6) template;
dcl-s evf_annot_class_t char(1) template;
dcl-s evf_token_t uns(5) template;
dcl-s evf_msg_id_t char(7) template;
dcl-s evf_sev_char_t char(1) template;
dcl-s evf_sev_num_t uns(5) template;
dcl-s evf_msg_text_t varchar(210) template;
dcl-s evf_length_t uns(5) template;

//  Processor Record
dcl-c EVF_LINE_CLASS_EXPANDED_SOURCE '0';
dcl-c EVF_LINE_CLASS_PHYSICAL_SOURCE '1';

//  File ID Record
dcl-c EVF_TEMPORARY_SOURCE '1';
dcl-c EVF_PERSISTENT_SOURCE '0';
dcl-c EVF_NAME_TYPE_QSYS '0';
dcl-c EVF_NAME_TYPE_PATH '1';

//  Annotation Classes
dcl-c EVF_ANNOTATION_TOP '0';
dcl-c EVF_ANNOTATION_MIDDLE '1';
dcl-c EVF_ANNOTATION_BOTTOM '2';

//  Severity Character
dcl-c EVF_SEVERITY_INFO 'I';
dcl-c EVF_SEVERITY_WARNING 'W';
dcl-c EVF_SEVERITY_ERROR 'E';
dcl-c EVF_SEVERITY_SEVERE 'S';
dcl-c EVF_SEVERITY_TERMINATING 'T';

//  Message Severity
dcl-c EVF_MSG_SEVERITY_INFO 0;
dcl-c EVF_MSG_SEVERITY_WARNING 10;
dcl-c EVF_MSG_SEVERITY_ERROR 20;
dcl-c EVF_MSG_SEVERITY_SEVERE 30;
dcl-c EVF_MSG_SEVERITY_TERMINATING 40;

//  Opens an event file member. The event file is created, if
//  it does not yet exist.
dcl-pr Eventf_open extproc('EVENTF1_Eventf_open');
  i_lib    like(evf_objName_t) const;
  i_mbr    like(evf_objName_t) const;
  o_rtnLib like(evf_objName_t) options(*nopass: *omit);
end-pr;

//  Opens an event file member for appending records. The event file
//  is created, if it does not yet exist.
dcl-pr Eventf_openAppend ind extproc('EVENTF1_Eventf_openAppend');
  i_lib    like(evf_objName_t) const;
  i_mbr    like(evf_objName_t) const;
  o_rtnLib like(evf_objName_t) options(*nopass: *omit);
end-pr;

//  Appends a 'PROCESSOR' record to the event file.
dcl-pr Eventf_writeProcessor extproc('EVENTF1_Eventf_writeProcessor');
  i_output_id  like(evf_output_id_t) options(*nopass: *omit) const;
  i_line_class like(evf_line_class_t) options(*nopass: *omit) const;
end-pr;

//  Appends a 'FILEID' record to the event file.
dcl-pr Eventf_writeFileID opdesc extproc('EVENTF1_Eventf_writeFileID');
  i_source_id like(evf_source_id_t) const;
  i_path      like(evf_path_t) options(*varsize) const;
  i_nameType  char(1) options(*nopass: *omit) const;
  i_temp_flag like(evf_temp_flag_t) options(*nopass: *omit) const;
  i_line      like(evf_line_t) options(*nopass: *omit) const;
end-pr;

//  Appends a 'FILEEND' record to the event file.
dcl-pr Eventf_writeFileEnd extproc('EVENTF1_Eventf_writeFileEnd');
  i_source_id like(evf_source_id_t) const;
  i_expansion like(evf_expansion_t) const;
end-pr;

//  Appends a 'ERROR' record to the event file.
dcl-pr Eventf_writeError extproc('EVENTF1_Eventf_writeError');
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
end-pr;

//  Clears an existing event file member.
dcl-pr Eventf_clear extproc('EVENTF1_Eventf_clear');
  i_lib like(evf_objName_t) const;
  i_mbr like(evf_objName_t) const;
end-pr;

//  Copies the events of a given event file into this event file.
dcl-pr Eventf_copyFrom extproc('EVENTF1_Eventf_copyFrom');
  i_fromLib like(evf_objName_t) const;
  i_fromMbr like(evf_objName_t) const;
end-pr;

//  Closes an event file member.
dcl-pr Eventf_close extproc('EVENTF1_Eventf_close');
end-pr;

/endif