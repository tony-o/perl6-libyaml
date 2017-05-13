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

int parse_file(char* file, void (*m)(char*, unsigned char*)) {
  yaml_parser_t parser;
  yaml_event_t event;
  int status = 1;

  yaml_parser_initialize(&parser);
  FILE* input = fopen(file, "rb");

  void* ext = "hello";
  yaml_parser_set_input_file(&parser, input);

  //yaml_parser_set_input(&parser, read_handler, ext);
  do {
    if (!yaml_parser_parse(&parser, &event)) {
      goto error;
    }
    switch(event.type){
      case YAML_NO_EVENT:
        m("YAML_NO_EVENT", "");
        break;
      case YAML_STREAM_START_EVENT:
        m("YAML_STREAM_START_EVENT", "");
        break;
      case YAML_STREAM_END_EVENT:
        m("YAML_STREAM_END_EVENT", "");
        break;
      case YAML_DOCUMENT_START_EVENT:
        m("YAML_DOCUMENT_START_EVENT", "");
        break;
      case YAML_DOCUMENT_END_EVENT:
        m("YAML_DOCUMENT_END_EVENT", "");
        break;
      case YAML_SEQUENCE_START_EVENT:
        m("YAML_SEQUENCE_START_EVENT", "");
        break;
      case YAML_SEQUENCE_END_EVENT:
        m("YAML_SEQUENCE_END_EVENT", "");
        break;
      case YAML_MAPPING_START_EVENT:
        m("YAML_MAPPING_START_EVENT", "");
        break;
      case YAML_MAPPING_END_EVENT:
        m("YAML_MAPPING_END_EVENT", "");
        break;
      case YAML_ALIAS_EVENT:
        m("YAML_ALIAS_EVENT", event.data.alias.anchor);
        break;
      case YAML_SCALAR_EVENT:
        m("YAML_SCALAR_EVENT", event.data.scalar.value);
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
