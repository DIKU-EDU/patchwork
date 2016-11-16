# Patchwork — Patching Meta-Structure on top of Git

Patchwork allows to maintain features as patches. This is useful for code
handouts that build on each other, but cannot otherwise be maintained as
branches. _This is not recommended for projects where branches will do._

![Some Patchwork](logo.png
  "Image license: CC0; Source: https://pixabay.com/en/colorful-colourful-art-modern-1788518/")

## History

Early versions of patchwork appeared in [OSM
2015/2016](http://web.archive.org/web/20161116162814/http://kurser.ku.dk/course/ndaa04029u/2015-2016)
at [DIKU](http://diku.dk/).

The purpose there was to manage the various versions of
[KUDOS](https://github.com/DIKU-EDU/kudos), handed out throughout the course.
Each handout contained additions/variations on the [public code
base](https://github.com/DIKU-EDU/kudos), which were relevant to some given
assignment. These changes could not be maintained as branches on
[KUDOS](https://github.com/DIKU-EDU/kudos), as they revealed solutions to
assignments which might have been reused in the following years.

They could've been maintained in a private GitHub fork, but GitHub has poor
support for this. So "patchwork" would be needed elsewhere.
