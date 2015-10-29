===========
python-aosd
===========

python-aosd is a Python binding for libaosd_: an on screen display (OSD) library, which uses Cairo to create high quality rendered graphics to be overlaid on top of the screen.

.. image:: https://travis-ci.org/arminha/python-aosd.svg?branch=master
    :target: https://travis-ci.org/arminha/python-aosd

Requirements
------------

* Python > 2.6
* libaosd_
* pycairo_
* pangocairo_

Build requirements
------------------

* Pyrex_ or Cython_
* headers for pycairo_, libaosd_ and pangocairo_

Building
--------

python-aosd uses distutils_. Building it is as simple as running

::

  python setup.py build

in the root directory.

Running

::

  python setup.py install

will install python-aosd.

Changelog
---------

Version 0.2.5
=============
* Move to GitHub

Version 0.2.4
=============
* Replace command module in setup.py with subprocess

Version 0.2.3
=============
* Bug Fix: correct value of aosd.PANGO_ALIGN_CENTER

Version 0.2.2
=============
* move to git
* Bug Fix: fix indentation in aosd.pyx


.. _libaosd: http://atheme.org/project/libaosd
.. _Pyrex: http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex
.. _Cython: http://cython.org
.. _pycairo: http://cairographics.org/pycairo
.. _distutils: http://docs.python.org/library/distutils.html
.. _pangocairo: http://www.pango.org/
