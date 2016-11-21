# Patchwork — Patching Meta-Structure on top of Git

Patchwork allows to maintain features as patches. This is useful for code
handouts that build on each other, but cannot otherwise be maintained as
branches. _This is not recommended for projects where branches will do._

![Some Patchwork](logo.png
  "Image license: CC0; Source: https://pixabay.com/en/colorful-colourful-art-modern-1788518/")

[![License](https://img.shields.io/badge/license-EUPL%20v1.1-blue.svg)](https://github.com/DIKU-EDU/patchwork/blob/master/LICENSE.md)

## History

Early versions of patchwork appeared in [OSM
2015/2016](http://web.archive.org/web/20161116162814/http://kurser.ku.dk/course/ndaa04029u/2015-2016)
at [DIKU](http://diku.dk/).

The purpose there was to manage the various versions of
[KUDOS](https://github.com/DIKU-EDU/kudos), handed out throughout the course.
Each handout contained additions/variations on the [public code
base](https://github.com/DIKU-EDU/kudos), which were relevant to some given
assignment. These changes could not be maintained as branches on
[KUDOS](https://github.com/DIKU-EDU/kudos), as they might have revealed partial
solutions to other and future assignments.

They could've been maintained in a private GitHub fork, but GitHub has poor
support for this — "patchwork" would be needed elsewhere.

## Guide

To make patchwork, you will need a patchfile. A patchfile is a shell script
which will be
[sourced](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#dot)
by [`gen-patchwork.sh`](src/gen-patchwork.sh) and
[`gen-patch.sh`](src/gen-patch.sh), but is primarily intended for the
definition of 4 variables: `HTTPS_REMOTE`, `BASETAG`, `BASEPATCHES`, and
`PATCHNAME`.

A "patchwork" is a clone of the `HTTPS_REMOTE` at tag `BASETAG`, with the
patches listed in `BASEPATCHES` applied on top, in addition to the working
patch `PATCHNAME` (if any). That is, for each patch, there is a directory
containing a patchfile. These directories can be composed in other patches via
the `BASEPATCHES` array variable.

To get patchwork to work, you will also need to add the path to
[`tmpdir`](https://github.com/oleks/tmpdir) to your PATH environment variable.
(Specifically [`gen-patch.sh`](src/gen-patch.sh) will need it.)

### Editor Command Lines

For readability, we recommend starting the file with editor control lines
indicating that the patchfile is a conf-style file:

````
# -*- mode: conf-mode
# vim: set ft=config
````
