use NativeCall;

unit module YAML::Parser;

sub parse_file(Str $file, &sub (Str, Str)) 
  is native('../clib/libyaml_wrap.so.1.0.0')
  { * };

sub parse(Str $yaml) is export {
  my ($kvp, @doc);
  my $x = sub (Str $x, Str $y){
    say "$x";
    say "  $y" if $y ne '';
    given $x {
      when * eq 'YAML_SEQUENCE_START_EVENT' {
        @doc.push( [] );
      };
      when * eq 'YAML_MAPPING_START_EVENT' {
        @doc.push( { } ); 
      };
      when * eq 'YAML_SCALAR_EVENT' {
        if @doc[*-1] ~~ Hash { 
          if !$kvp.defined {
            $kvp = $y;
          }else{
            @doc[*-1].append( $kvp => $y );
            $kvp = Any;
          }
        } else {
          @doc[*-1].push($y);
        }
      };
      when * eq 'YAML_MAPPING_END_EVENT' {
        if @doc[*-2] ~~ Hash {
          @doc[*-2].append( $kvp => @doc.pop );
        } else { 
          @doc[*-2].push(@doc.pop);
        }
      };
      when * eq 'YAML_SEQUENCE_END_EVENT' {
        if @doc[*-2] ~~ Hash {
          @doc[*-2].append( $kvp => @doc.pop );
        } else { 
          @doc[*-2].push(@doc.pop)
            if @doc.elems > 1;
        }
      };
    }
    CATCH { default { .say; } }
  };
  parse_file("test2.yaml", $x);
  my $yam = @doc[0];
  use Data::Dump;
  say Dump $yam;
}
