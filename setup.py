#!/usr/bin/env python
# coding=utf8

from distutils.core import setup
from distutils.extension import Extension
try:
    from Cython.Distutils import build_ext
except ImportError:
    from Pyrex.Distutils import build_ext

import commands

def pkgconfig_include_dirs(*packages):
    flag_map = {'-I': 'include_dirs'}
    kw = {}
    for token in commands.getoutput("pkg-config --cflags %s" % ' '.join(packages)).split():
        kw.setdefault(flag_map.get(token[:2]), []).append(token[2:])
    return kw['include_dirs']


setup (
    cmdclass = {'build_ext' : build_ext},

    name = 'python-aosd',
    version = '0.1.0',
    ext_modules = [
        Extension(
            'aosd',
            ['src/aosd.pyx'],
            include_dirs= pkgconfig_include_dirs('pangocairo') + ['/usr/include/libaosd'],
            libraries = ['aosd', 'aosd-text']
        )
    ],

    author = 'Armin Häberling',
    author_email = 'armin.aha@gmail.com',
    url = 'http://code.google.com/p/python-aosd/',
    description = 'Python bindings for libaosd',
    long_description= 'This library provides python bindings for libaosd, an advanced on screen display library.',
    classifiers = [
        'Development Status :: 3 - Alpha',
        'Environment :: X11 Applications',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX',
        'Programming Language :: Python',
    ],
)
