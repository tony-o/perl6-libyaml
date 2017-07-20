# YAML::Parser::LibYAML

Uses a wrapper and constructs a perl6 array/hash/whatever to represent the YAML.  Use it for good (or bad, I don't care).

```perl6

use YAML::Parser::LibYAML;

my $yaml = yaml-parser('path/to/yaml.yaml');

$yaml.perl.say;
```

Profit.

tony-o
