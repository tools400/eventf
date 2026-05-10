**free
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
dcl-ds evf_timestamp qualified template;
  type        char(10) inz('TIMESTAMP');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  value       char(14) inz; // yyyymmddhhmmss
end-ds;

// Processor Record
// This record indicates that a new processor has been invoked.
// One will always follow the timestamp record in the Events File.
dcl-ds evf_processor qualified template;
  type        char(10) inz('PROCESSOR');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  output_id   char(3) inz('000');
  separator_3 char(1) inz;
  line_class  char(1) inz('1');
end-ds;

// File ID Record
// This record contains the full name of the source file processed
// and associates an integer with the file name.
// Usage:  result = %trimR(evf_file_id_1) + evf_file_id_2
dcl-ds evf_file_id_1 qualified template;
  type        char(10) inz('FILEID');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  source_id   char(3) inz('001');
  separator_3 char(1) inz;
  line        char(6) inz('000000');
  separator_4 char(1) inz;
  length      char(3) inz('000');
  separator_5 char(1) inz;
  filename    char(200) inz('Library___/File______(Member____)');
end-ds;

dcl-ds evf_file_id_2 qualified template;
  separator_6          char(1) inz;
  sourcefile_timestamp char(14) inz('YYYYMMDDHHMMSS');
  separator_7          char(1) inz;
  temp_flag            char(1) inz('0');
end-ds;

// File End Record
// This record indicates that an included file is ending.
dcl-ds evf_file_end qualified template;
  type        char(10) inz('FILEEND');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  file_id     char(3) inz('001');
  separator_3 char(1) inz;
  expansion   char(6) inz('000000');
end-ds;

// Error Information Record
// A record of this type contains information required to locate
// a token or line causing a message in the source file, as well
// as enough information to allow the message itself to be displayed.
dcl-ds evf_error qualified template;
  type           char(10) inz('ERROR');
  separator_1    char(1) inz;
  version        char(1) inz('0');
  separator_2    char(1) inz;
  file_id        char(3) inz('001');
  separator_3    char(1) inz;
  annot_class    char(1) inz('1');
  separator_4    char(1) inz;
  stmt_line      char(6) inz('000000');
  separator_5    char(1) inz;
  start_err_line char(6) inz('000000');
  separator_6    char(1) inz;
  token_start    char(3) inz('000');
  separator_7    char(1) inz;
  end_err_line   char(6) inz('000000');
  separator_8    char(1) inz;
  token_end      char(3) inz('000');
  separator_9    char(1) inz;
  msg_id         char(7) inz;
  separator_10   char(1) inz;
  msg_id         char(7) inz;
  separator_11   char(1) inz;
  sev_char       char(1) inz('E'); // I, W, E, S, or
  separator_12   char(1) inz;
  sev_num        char(2) inz('30');
  separator_13   char(1) inz;
  length         char(3) inz('000');
  separator_14   char(1) inz;
  msg            char(200) inz;
end-ds;

// Expansion Record
// This record contains information about expanded source lines
// due to a pre-processor.
dcl-ds evf_expansion qualified template;
  type              char(10) inz('EXPANSION');
  separator_1       char(1) inz;
  version           char(1) inz('0');
  separator_2       char(1) inz;
  input_file_id     char(3) inz('000');
  separator_3       char(1) inz;
  input_line_start  char(6) inz('000000');
  separator_4       char(1) inz;
  input_line_end    char(6) inz('000000');
  separator_5       char(1) inz;
  output_file_id    char(3) inz('000');
  separator_6       char(1) inz;
  output_line_start char(6) inz('000000');
  separator_7       char(1) inz;
  output_line_end   char(6) inz('000000');
  separator_8       char(1) inz;
end-ds;

// Program Record
// This record indicates a new program in the same source file
// is being compiled.
// Note: All ERROR records for a program must come after the
//       PROGRAM record for that program and before any PROGRAM
//       records for other programs.
dcl-ds evf_program qualified template;
  type        char(10) inz('PROGRAM');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  line        char(6) inz('000000');
end-ds;

// Map Define Record
// This record indicates that a macro is being defined.
dcl-ds evf_map_define qualified template;
  type        char(10) inz('MAPDEFINE');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  macro_id    char(3) inz('000');
  separator_3 char(1) inz;
  line        char(6) inz('000000');
  separator_4 char(1) inz;
  length      char(3) inz('000');
  separator_5 char(1) inz;
  macro_name  char(200) inz;
end-ds;

// Map Start Record
// This record indicates that source expansion is starting.
dcl-ds evf_map_start qualified template;
  type        char(10) inz('MAPSTART');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  macro_id    char(3) inz('000');
  separator_3 char(1) inz;
  line        char(6) inz('000000');
end-ds;

// Map End Record
// This record indicates that source expansion is complete.
dcl-ds evf_map_end qualified template;
  type        char(10) inz('MAPEND');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  macro_id    char(3) inz('000');
  separator_3 char(1) inz;
  line        char(6) inz('000000');
  separator_4 char(1) inz;
  expansion   char(6) inz('000000');
end-ds;

// Feedback Code Record
// This record indicates that source expansion is complete.
dcl-ds evf_feedback qualified template;
  type        char(10) inz('FEEDBACK');
  separator_1 char(1) inz;
  version     char(1) inz('0');
  separator_2 char(1) inz;
  return_code char(3) inz('0');
  separator_3 char(1) inz;
  reason_code char(3) inz('0');
end-ds;
