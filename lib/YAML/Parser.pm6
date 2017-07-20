unit module YAML::Loader;

use NativeCall;
use LibraryMake;

sub libyaml_wrap is export(:libyaml_wrap) {
  state $ = do {
		my $so = get-vars('')<SO>;
		~(%?RESOURCES{"lib/libyaml_wrap$so"});
	}
}

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
               &nil_scalar_event (),
) 
  is native(&libyaml_wrap)
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
    log();
    my $x = @*STACK.pop;
    if @*STACK.elems >= 1 {
      if @*STACK[*-1] ~~ Hash {
        @*STACK[*-1].append(
          @*KEYS.pop<value> => $x,
        );
      } elsif @*STACK[*-1] ~~ Array {
        @*STACK[*-1].push($x);
      } else {
        die 'Now we here';
      }
    } else {
      @*STACK.push($x);
    }
  }
  log();
  $*STATUS--;

};

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

sub nil-scalar-event {
  scalar-event(Any);
}

sub scalar-event($scalar) {
  'scalar-event'.say if $*DEBUG;
  my $value = 
    Any ~~ $scalar 
      ?? Any 
      !! $scalar ~~ m{^\d+\.?\d*$} 
         ?? $scalar.Numeric 
         !! $scalar eq 'false' 
            ?? False 
            !! $scalar eq 'true' 
               ?? True 
               !! $scalar;

  @*KEYS.push({ depth => $*STATUS, value => $value });
  if @*STACK.elems && @*STACK[*-1] ~~ Hash && $*STATUS > 0 && @*KEYS.elems > 1 && @*KEYS[*-2]<depth> == $*STATUS {
    my ($k, $v) = (@*KEYS.pop<value>, @*KEYS.pop<value>);
    @*STACK[*-1].append($v, $k);
  } elsif @*STACK.elems && @*STACK[*-1] ~~ Array && $*STATUS > 0 && @*KEYS.elems > 0 && @*KEYS[*-1]<depth> == $*STATUS {
    @*STACK[*-1].push(@*KEYS.pop<value>);
  }
  log();
  '/scalar-event'.say if $*DEBUG;
}


sub yaml-parse(Str $yaml, Bool $DEBUG = False) is export {
  my $*STATUS = 0;
  my @*STACK = [];
  my @*KEYS;
  my $*DEBUG = $DEBUG;
  parse_file("{$yaml.IO.absolute}", 
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
             &nil-scalar-event,
            );
  return @*KEYS[0]<value> if @*STACK.elems == 0;
  @*STACK[0];
}
