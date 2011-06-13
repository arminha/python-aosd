===========
python-aosd
===========

python-aosd is a Python binding for libaosd_. An on screen display (OSD) library, which uses Cairo to create high quality rendered graphics to be overlaid on top of the screen.

Requirements
------------

* Python > 2.6
* libaosd_ (of course)
* pycairo_
* pangocairo

Build requirements
------------------

* Pyrex_ or Cython_
* headers for pycairo_, libaosd_ and pangocairo

Building
--------

python-aosd uses distutils_, so building it is as simple as running

::

  python setup.py build

in the root directory.

Running

::

  python setup.py install

will install python-aosd.


.. _libaosd: http://atheme.org/project/libaosd
.. _Pyrex: http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex
.. _Cython: http://cython.org
.. _pycairo: http://cairographics.org/pycairo
.. _distutils: http://docs.python.org/library/distutils.html

