#!/usr/bin/env perl6

use Test;
use JSON::Fast;
use YAML::Parser;

my @dirs = './t/data'.IO.dir.grep({
  [$_.dir.grep({
    $_.basename eq 'json.json' ||
    $_.basename eq 'yaml.yaml'
  })].elems == 2
});

plan @dirs.elems;

for @dirs -> $dir {
  my $json = from-json "{$dir.absolute}/json.json".IO.slurp;
  my $yaml = yaml-parse("{$dir.absolute}/yaml.yaml");

  is-deeply $yaml, $json, "{$dir.basename}"; 
}

#vi:syntax=perl6
