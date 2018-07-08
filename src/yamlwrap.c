#include <yaml.h>
#include <stdio.h>

int read_handler(void *ext, unsigned char *buffer, unsigned long size, unsigned long *length) {
  /* ... */
  //*buffer;
  //*length;
  /* ... */
  printf("buffer: '%s'\n", buffer);
  return 1;
}

int parse_file(char* file, 
               void (*no_event)(),
               void (*stream_start_event)(),
               void (*stream_end_event)(),
               void (*document_start_event)(),
               void (*document_end_event)(),
               void (*sequence_start_event)(),
               void (*sequence_end_event)(),
               void (*mapping_start_event)(),
               void (*mapping_end_event)(),
               void (*alias_event)(unsigned char*),
               void (*scalar_event)(unsigned char*, char*),
               void (*nil_scalar_event)()
) {
  yaml_parser_t parser;
  yaml_event_t event;
  int status = 1;
  FILE* input;
  void* ext;

  yaml_parser_initialize(&parser);
  input = fopen(file, "rb");

  ext = "hello";
  yaml_parser_set_input_file(&parser, input);

  //yaml_parser_set_input(&parser, read_handler, ext);
  do {
    if (!yaml_parser_parse(&parser, &event)) {
      goto error;
    }
    switch(event.type){
      case YAML_NO_EVENT:
        no_event();
        break;
      case YAML_STREAM_START_EVENT:
        stream_start_event();
        break;
      case YAML_STREAM_END_EVENT:
        stream_end_event();
        break;
      case YAML_DOCUMENT_START_EVENT:
        document_start_event();
        break;
      case YAML_DOCUMENT_END_EVENT:
        document_end_event();
        break;
      case YAML_SEQUENCE_START_EVENT:
        sequence_start_event();
        break;
      case YAML_SEQUENCE_END_EVENT:
        sequence_end_event();
        break;
      case YAML_MAPPING_START_EVENT:
        mapping_start_event();
        break;
      case YAML_MAPPING_END_EVENT:
        mapping_end_event();
        break;
      case YAML_ALIAS_EVENT:
        alias_event(event.data.alias.anchor);
        break;
      case YAML_SCALAR_EVENT:
        if(event.data.scalar.length == 0 && event.data.scalar.plain_implicit){
          nil_scalar_event();
        }else{
          scalar_event(event.data.scalar.value, event.data.scalar.style == YAML_DOUBLE_QUOTED_SCALAR_STYLE || event.data.scalar.style == YAML_SINGLE_QUOTED_SCALAR_STYLE ? "string" : "auto");
        }
        break;
    };
  } while(event.type != YAML_STREAM_END_EVENT);
  goto noerror;
  error:
  status = 0;
  noerror:
  yaml_event_delete(&event);
  yaml_parser_delete(&parser);
  fclose(input);
  return status;
}
