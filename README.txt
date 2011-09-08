
python-aosd
***********

python-aosd is a Python binding for libaosd. An on screen display (OSD)
library, which uses Cairo to create high quality rendered graphics to be
overlaid on top of the screen.

Requirements
============

  • Python > 2.6
  • libaosd (of course)
  • pycairo
  • pangocairo

Build requirements
==================

  • Pyrex or Cython
  • headers for pycairo, libaosd and pangocairo

Building
========

python-aosd uses distutils, so building it is as simple as running

    python setup.py build

in the root directory.

Running

    python setup.py install

will install python-aosd.

Changelog
=========

Version 0.2.2
-------------

  • move to git
  • Bug Fix: fix indentation in aosd.pyx

