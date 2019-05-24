# YAML::Parser::LibYAML

Uses a wrapper and constructs a perl6 array/hash/whatever to represent the YAML.  Use it for good (or bad, I don't care).

```perl6

use YAML::Parser::LibYAML;

my $yaml = yaml-parse('path/to/yaml.yaml');

$yaml.perl.say;
```

Profit.

tony-o | thanks to ingy and tina for fuelling this creation with scotch and vegan pizza

If you must build this yourself, you can do

> zef build .

or

> src/build.sh
