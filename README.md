# python-aosd

python-aosd is a Python binding for [libaosd]: an on screen display (OSD) library, which uses Cairo to create high quality rendered graphics to be overlaid on top of the screen.

[![build](https://github.com/arminha/python-aosd/workflows/build/badge.svg)](https://github.com/arminha/python-aosd/actions?query=workflow%3Abuild)

## Requirements

* Python >= 2.7
* [libaosd]
* [pycairo]
* [pangocairo]

## Build requirements

* [Pyrex] or [Cython]
* headers for [pycairo], [libaosd] and [pangocairo]

## Building

python-aosd uses [distutils]. Building it is as simple as running

```sh
python setup.py build
```

in the root directory.

Running

```sh
python setup.py install
```

will install python-aosd.

## Changelog

### Version 0.2.5

* Move to GitHub

### Version 0.2.4

* Replace command module in setup.py with subprocess

### Version 0.2.3

* Bug Fix: correct value of aosd.PANGO_ALIGN_CENTER

### Version 0.2.2

* move to git
* Bug Fix: fix indentation in aosd.pyx


[libaosd]: https://github.com/atheme-legacy/libaosd
[pyrex]: http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex
[cython]: http://cython.org
[pycairo]: http://cairographics.org/pycairo
[distutils]: http://docs.python.org/library/distutils.html
[pangocairo]: http://www.pango.org/
