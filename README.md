# Patchwork — Patching Meta-Structure on top of Git

Patchwork allows to maintain features as separate patches. This is useful for
code handouts that build on each other, but cannot otherwise be maintained in
branches. This is not recommended for projects where branches will do.

![Some Patchwork](logo.png
  "Image license: CC0; Source: https://pixabay.com/en/colorful-colourful-art-modern-1788518/")

## History

Early versions of patchwork appeared in [OSM
2015/2016](http://web.archive.org/web/20161116162814/http://kurser.ku.dk/course/ndaa04029u/2015-2016)
at [DIKU](http://diku.dk/). The purpose there was to manage various versions of
[KUDOS](https://github.com/DIKU-EDU/kudos) handed out throughout the course.
Each handout contained additions/variations on the public code base which were
relevant to a given assignment. These changes could not be maintained in
branches on [KUDOS](https://github.com/DIKU-EDU/kudos), as they offered
solutions to some of the earlier exercises which might have been reused in the
following years.

They could've been maintained in a private GitHub fork, but GitHub has poor
support for this.
