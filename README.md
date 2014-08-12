# App::Module::Template

Yet Another Perl Module Starter...

[![Build Status](https://travis-ci.org/tscornpropst/App-Module-Template.svg?branch=master)](https://travis-ci.org/tscornpropst/App-Module-Template)
[![Coverage Status](https://coveralls.io/repos/tscornpropst/App-Module-Template/badge.png)](https://coveralls.io/r/tscornpropst/App-Module-Template)

Do we need another Perl module create? Probably not. But, here you go.

__App::Module::Template__ is the guts to **_module-template_**, a command line utility to create a Perl project directory based off a template directory you define. **module-template** will initialize the directory for you the first time you run the program. The rest is up to you.

When you run **module-template**, it looks for your template directory and config file in $HOME/.module-template. You can override these locations with command line options. Any values set in your config file will appear in your templates. Every template will get processed into a new directory matching your module name in the exact location as your template. Files with no template markup are copied over to their relevant location in your project directory.

## USAGE

Normal usage

```
module-template My::Module
```

Prompts you for a module name if you don't provide one

```
module-template
module-template - Enter module name>
module-template - Enter module name> My::Module
```

Doesn't work because my::module is not a valid perl module name

```
module-template my::module
```


## CONFIGURATION

Edit $HOME/.module-template/config.

This configuration file is read with Config::General. It is basically key/value pairs. There is a template_toolkit block used to configure Template Toolkit.

A Sample Config

```
author = Default Author
email = author@example.com
support_email = support@example.com
min_perl_version = 5.016
eumm_version = 6.63
license_type = Artistic_2_0

<template_toolkit>
  PRE_CHOMP = 0
  POST_CHOMP = 0
  ENCODING = utf8
  ABSOLUTE = 1
  RELATIVE = 1
</template_toolkit>
```


## INSTALL

To install this module, run the following commands:

  perl Makefile.PL
  make
  make test
  make install

## DEPENDENCIES

Perl 5.16 or greater.

Template Toolkit

Copyright (C) 2014, Trevor S. Cornpropst
