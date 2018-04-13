      /IF NOT DEFINED(PEVENTF)
      /DEFINE PEVENTF
      *
      *  Type templates
     D evf_path_t...
     D                 s           5000a   varying     based(pDummy)
     D evf_objName_t...
     D                 s             10a               based(pDummy)
     D evf_output_id_t...
     D                 s              3s 0             based(pDummy)
     D evf_line_class_t...
     D                 s              1a               based(pDummy)
     D evf_source_id_t...
     D                 s              3s 0             based(pDummy)
     D evf_line_t...
     D                 s             10u 0             based(pDummy)
     D evf_temp_flag_t...
     D                 s              1a               based(pDummy)
     D evf_expansion_t...
     D                 s              6s 0             based(pDummy)
     D evf_annot_class_t...
     D                 s              1a               based(pDummy)
     D evf_token_t...
     D                 s              5u 0             based(pDummy)
     D evf_msg_id_t...
     D                 s              7a               based(pDummy)
     D evf_sev_char_t...
     D                 s              1a               based(pDummy)
     D evf_sev_num_t...
     D                 s              5u 0             based(pDummy)
     D evf_msg_text_t...
     D                 s            210a   varying     based(pDummy)
     D evf_length_t...
     D                 s              5u 0             based(pDummy)
      *
      *  Processor Record
     D EVF_LINE_CLASS_EXPANDED_SOURCE...
     D                 c                   '0'
     D EVF_LINE_CLASS_PHYSICAL_SOURCE...
     D                 c                   '1'
      *
      *  File ID Record
     D EVF_TEMPORARY_SOURCE...
     D                 c                   '1'
     D EVF_PERSISTENT_SOURCE...
     D                 c                   '0'
     D EVF_NAME_TYPE_QSYS...
     D                 c                   '0'
     D EVF_NAME_TYPE_PATH...
     D                 c                   '1'
      *
      *  Annotation Classes
     D EVF_ANNOTATION_TOP...
     D                 c                   '0'
     D EVF_ANNOTATION_MIDDLE...
     D                 c                   '1'
     D EVF_ANNOTATION_BOTTOM...
     D                 c                   '2'
      *
      *  Severity Character
     D EVF_SEVERITY_INFO...
     D                 c                   'I'
     D EVF_SEVERITY_WARNING...
     D                 c                   'W'
     D EVF_SEVERITY_ERROR...
     D                 c                   'E'
     D EVF_SEVERITY_SEVERE...
     D                 c                   'S'
     D EVF_SEVERITY_TERMINATING...
     D                 c                   'T'
      *
      *  Message Severity
     D EVF_MSG_SEVERITY_INFO...
     D                 c                   0
     D EVF_MSG_SEVERITY_WARNING...
     D                 c                   10
     D EVF_MSG_SEVERITY_ERROR...
     D                 c                   20
     D EVF_MSG_SEVERITY_SEVERE...
     D                 c                   30
     D EVF_MSG_SEVERITY_TERMINATING...
     D                 c                   40
      *
      *  Opens an event file member. The event file is created, if
      *  it does not yet exist.
     D Eventf_open...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_open+
     D                                     ')
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
     D  o_rtnLib                                 like(evf_objName_t)
     D                                           options(*nopass: *omit)
      *
      *  Opens an event file member for appending records. The event file
      *  is created, if it does not yet exist.
     D Eventf_openAppend...
     D                 pr              n
     D                                     extproc('EVENTF1_+
     D                                     Eventf_openAppend+
     D                                     ')
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
     D  o_rtnLib                                 like(evf_objName_t)
     D                                           options(*nopass: *omit)
      *
      *  Appends a 'PROCESSOR' record to the event file.
     D Eventf_writeProcessor...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_writeProcessor+
     D                                     ')
     D  i_output_id                        const like(evf_output_id_t)
     D                                           options(*nopass: *omit)
     D  i_line_class                       const like(evf_line_class_t)
     D                                           options(*nopass: *omit)
      *
      *  Appends a 'FILEID' record to the event file.
     D Eventf_writeFileID...
     D                 pr                  opdesc
     D                                     extproc('EVENTF1_+
     D                                     Eventf_writeFileID+
     D                                     ')
     D  i_source_id                        const like(evf_source_id_t)
     D  i_path                             const like(evf_path_t)
     D                                           options(*varsize)
     D  i_nameType                    1a   const options(*nopass: *omit)
     D  i_temp_flag                        const like(evf_temp_flag_t)
     D                                           options(*nopass: *omit)
     D  i_line                             const like(evf_line_t)
     D                                           options(*nopass: *omit)
      *
      *  Appends a 'FILEEND' record to the event file.
     D Eventf_writeFileEnd...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_writeFileEnd+
     D                                     ')
     D  i_source_id                        const like(evf_source_id_t)
     D  i_expansion                        const like(evf_expansion_t)
      *
      *  Appends a 'ERROR' record to the event file.
     D Eventf_writeError...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_writeError+
     D                                     ')
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
      *  Clears an existing event file member.
     D Eventf_clear...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_clear+
     D                                     ')
     D  i_lib                              const like(evf_objName_t)
     D  i_mbr                              const like(evf_objName_t)
      *
      *  Copies the events of a given event file into this event file.
     D Eventf_copyFrom...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_copyFrom+
     D                                     ')
     D  i_fromLib                          const like(evf_objName_t)
     D  i_fromMbr                          const like(evf_objName_t)
      *
      *  Closes an event file member.
     D Eventf_close...
     D                 pr
     D                                     extproc('EVENTF1_+
     D                                     Eventf_close+
     D                                     ')
      *
      /ENDIF
