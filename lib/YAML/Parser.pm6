use NativeCall;

unit module YAML::Loader;

sub parse_file(Str $file, 
               &no_event (), 
               &stream_start_event (), 
               &stream_end_event (), 
               &document_start_event (),
               &document_end_event (), 
               &sequence_start_event (), 
               &sequence_end_event (), 
               &mapping_start_event (),
               &mapping_end_event (), 
               &alias_event (Str), 
               &scalar_event (Str), 
) 
  is native('../clib/libyaml_wrap.so.1.0.0')
  { * };


sub log() {
  "log(): status({$*STATUS.elems}), keys({@*KEYS.elems}), stack({@*STACK.elems})".say if $*DEBUG;
}

sub no-event() {
  'no-event'.say if $*DEBUG;
  '/no-event'.say if $*DEBUG;
}

sub stream-start-event() {
  'stream-start-event'.say if $*DEBUG;
  '/stream-start-event'.say if $*DEBUG;
}

sub stream-end-event() {
  'stream-end-event'.say if $*DEBUG;
  '/stream-end-event'.say if $*DEBUG;
}

sub document-start-event() {
  'document-start-event'.say if $*DEBUG;
  '/document-start-event'.say if $*DEBUG;
}

sub document-end-event() {
  'document-end-event'.say if $*DEBUG;
  '/document-end-event'.say if $*DEBUG;
}

sub sequence-start-event() {
  'sequence-start-event'.say if $*DEBUG;
  @*STACK.push([]);
  $*STATUS++;
  log();
  '/sequence-start-event'.say if $*DEBUG;
}

sub sequence-end-event() {
  'sequence-end-event'.say if $*DEBUG;
  push-pop;
  '/sequence-end-event'.say if $*DEBUG;
}

sub mapping-start-event() {
  'mapping-start-event'.say if $*DEBUG;
  @*STACK.push({});
  $*STATUS++;
  log();
  '/mapping-start-event'.say if $*DEBUG;
}

sub push-pop() {
  if $*STATUS > 0 { 
    my $x = @*STACK.pop;
    if @*STACK.elems > 1 && @*STACK[*-1] ~~ Hash {
      @*STACK[*-2].append(@*KEYS.pop<value> => $x);
    } elsif @*STACK.elems > 1 {
      @*STACK[*-1].push($x);
    } elsif $*STATUS == 1 && @*STACK.elems {
      @*STACK[*-1].push($x);
    } else {
      @*STACK.push($x);
    }
  }
  $*STATUS--;

};

use Data::Dump;
sub mapping-end-event() {
  'mapping-end-event'.say if $*DEBUG;
  push-pop;
  '/mapping-end-event'.say if $*DEBUG;
}

sub alias-event(Str $alias) {
  'alias-event'.say if $*DEBUG;
  log();
  '/alias-event'.say if $*DEBUG;
}

sub scalar-event(Str $scalar) {
  'scalar-event'.say if $*DEBUG;
  @*KEYS.push({ depth => $*STATUS, value => $scalar });
  if $*STATUS > 0 && @*KEYS.elems > 1 && @*KEYS[*-2]<depth> == $*STATUS {
    my ($k, $v) = (@*KEYS.pop<value>, @*KEYS.pop<value>);
    @*STACK[*-1].append($v, $k);
  }
  log();
  '/scalar-event'.say if $*DEBUG;
}


sub yaml-parse(Str $yaml, Bool $DEBUG = False) is export {
  my $*STATUS = 0;
  my @*STACK = [];
  my @*KEYS;
  my $*DEBUG = $DEBUG;
  parse_file("test2.yaml", 
             &no-event, 
             &stream-start-event, 
             &stream-end-event,
             &document-start-event,
             &document-end-event,
             &sequence-start-event,
             &sequence-end-event,
             &mapping-start-event,
             &mapping-end-event,
             &alias-event,
             &scalar-event, 
            );
  @*STACK[0];
}
