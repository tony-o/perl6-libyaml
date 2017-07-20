#!/usr/bin/env perl6

use lib 'lib';
use YAML::Parser;
use Data::Dump;


warn 'start of test.yaml=========================';
say Dump yaml-parse('t/data/YD5X/yaml.yaml', True);
warn 'end of test.yaml===========================';
