#!/usr/bin/env perl6

use Test;
use JSON::Fast;
use YAML::Parser::LibYAML;

plan 1;

my $yaml = yaml-parse("./t/01-quoted-issue1.yaml".IO.absolute);

is-deeply $yaml, {:a('001')}, 'quoted string';
