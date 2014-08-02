perl5-app-module-template
=========================

Yet Another Perl Module Starter

App::Module::Template

Do we need another Perl module create? Probably not. But, this is my take on it.

I wanted a tool that would do exactly what I wanted with minimal fuss. The idea is to layout a directory as a template with all of the files just as you like. The files are Template Toolkit templates that get their values populated from a config file.

When you run 'module-template', it looks for your template directory and config file in $HOME/.module-template. Any values set in your config file will appear in your templates. Every template will get processed into a new directory matching your module name in the exact location as your template. Easy.

CONFIGURATION
-------------

Edit $HOME/.module-template/config.

This configuration file is read with Config::General. It is basically key/value pairs. There is a template_toolkit block used to configure Template Toolkit.

A Sample Config

```
author = Default Author
email = author@example.com
support_email = support@example.com
license_type = Artistic_2_0
```


INSTALL
-------

To install this module, run the following commands:

  perl Makefile.PL
  make
  make test
  make install

DEPENDENCIES
------------

This application requires Perl 5.16 or greater.

this application depends on Template Toolkit.

COPYRIGHT AND LICENSE

Copyright (C) 2014, Trevor S. Cornpropst
