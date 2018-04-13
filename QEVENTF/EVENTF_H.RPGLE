      /if defined(EVENTF_H)
      /eof
      /endif
      /define EVENTF_H

      // The Events File contains information that allows the editor to locate, in the
      // source member, any tokens or lines that caused a message to be issued, and to
      // relate messages that refer to expanded source to the corresponding position in
      // a given source file. The Events File is meant to provide machine-readable
      // information useful to certain classes of tools. The processor's listing file,
      // by contrast, is meant to be read by humans. Since the Events File has a common
      // format across all processors, tools will not have to write processor-specific
      // code to obtain the information they need.

      // Source: http://pic.dhe.ibm.com/infocenter/iadthelp/v8r5/index.jsp?
      //         topic=%2Fcom.ibm.etools.iseries.rse.doc%2Ftopics%2Frevformat.html

      // Timestamp Record
      // This record indicates when the Events File was created, and allows an application
      // to determine if the Events File is current. This record is always the first record
      // in the Events File.
     D evf_timestamp...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('TIMESTAMP')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  value                        14a   inz                                  yyyymmddhhmmss

      // Processor Record
      // This record indicates that a new processor has been invoked.
      // One will always follow the timestamp record in the Events File.
     D evf_processor...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('PROCESSOR')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  output_id                     3a   inz('000')
     D  separator_3                   1    inz
     D  line_class                    1a   inz('1')

      // File ID Record
      // This record contains the full name of the source file processed
      // and associates an integer with the file name.
      // Usage:  result = %trimR(evf_file_id_1) + evf_file_id_2
     D evf_file_id_1...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('FILEID')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  source_id                     3a   inz('001')
     D  separator_3                   1    inz
     D  line                          6a   inz('000000')
     D  separator_4                   1    inz
     D  length                        3a   inz('000')
     D  separator_5                   1    inz
     D  filename                    200a   inz(
     D                                     'Library___/File______(Member____)')

     D evf_file_id_2...
     D                 ds                  qualified based(pDummy)
     D  separator_6                   1    inz
     D  sourcefile_timestamp...
     D                               14a   inz('YYYYMMDDHHMMSS')
     D  separator_7                   1    inz
     D  temp_flag                     1a   inz('0')

      // File End Record
      // This record indicates that an included file is ending.
     D evf_file_end...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('FILEEND')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  file_id                       3a   inz('001')
     D  separator_3                   1    inz
     D  expansion                     6a   inz('000000')

      // Error Information Record
      // A record of this type contains information required to locate
      // a token or line causing a message in the source file, as well
      // as enough information to allow the message itself to be displayed.
     D evf_error...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('ERROR')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  file_id                       3a   inz('001')
     D  separator_3                   1    inz
     D  annot_class                   1a   inz('1')
     D  separator_4                   1    inz
     D  stmt_line                     6a   inz('000000')
     D  separator_5                   1    inz
     D  start_err_line...
     D                                6a   inz('000000')
     D  separator_6                   1    inz
     D  token_start                   3a   inz('000')
     D  separator_7                   1    inz
     D  end_err_line                  6a   inz('000000')
     D  separator_8                   1    inz
     D  token_end                     3a   inz('000')
     D  separator_9                   1    inz
     D  msg_id                        7a   inz
     D  separator_10                  1    inz
     D  msg_id                        7a   inz
     D  separator_11                  1    inz
     D  sev_char                      1a   inz('E')                             I, W, E, S, or
     D  separator_12                  1    inz
     D  sev_num                       2a   inz('30')
     D  separator_13                  1    inz
     D  length                        3a   inz('000')
     D  separator_14                  1    inz
     D  msg                         200a   inz

      // Expansion Record
      // This record contains information about expanded source lines
      // due to a pre-processor.
     D evf_expansion...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('EXPANSION')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  input_file_id                 3a   inz('000')
     D  separator_3                   1    inz
     D  input_line_start...
     D                                6a   inz('000000')
     D  separator_4                   1    inz
     D  input_line_end...
     D                                6a   inz('000000')
     D  separator_5                   1    inz
     D  output_file_id...
     D                                3a   inz('000')
     D  separator_6                   1    inz
     D  output_line_start...
     D                                6a   inz('000000')
     D  separator_7                   1    inz
     D  output_line_end...
     D                                6a   inz('000000')
     D  separator_8                   1    inz

      // Program Record
      // This record indicates a new program in the same source file
      // is being compiled.
      // Note: All ERROR records for a program must come after the
      //       PROGRAM record for that program and before any PROGRAM
      //       records for other programs.
     D evf_program...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('PROGRAM')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  line                          6a   inz('000000')

      // Map Define Record
      // This record indicates that a macro is being defined.
     D evf_map_define...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('MAPDEFINE')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  macro_id                      3a   inz('000')
     D  separator_3                   1    inz
     D  line                          6a   inz('000000')
     D  separator_4                   1    inz
     D  length                        3a   inz('000')
     D  separator_5                   1    inz
     D  macro_name                  200a   inz

      // Map Start Record
      // This record indicates that source expansion is starting.
     D evf_map_start...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('MAPSTART')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  macro_id                      3a   inz('000')
     D  separator_3                   1    inz
     D  line                          6a   inz('000000')

      // Map End Record
      // This record indicates that source expansion is complete.
     D evf_map_end...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('MAPEND')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  macro_id                      3a   inz('000')
     D  separator_3                   1    inz
     D  line                          6a   inz('000000')
     D  separator_4                   1    inz
     D  expansion                     6a   inz('000000')

      // Feedback Code Record
      // This record indicates that source expansion is complete.
     D evf_feedback...
     D                 ds                  qualified based(pDummy)
     D  type                         10a   inz('FEEDBACK')
     D  separator_1                   1    inz
     D  version                       1a   inz('0')
     D  separator_2                   1    inz
     D  return_code                   3a   inz('0')
     D  separator_3                   1    inz
     D  reason_code                   3a   inz('0')

