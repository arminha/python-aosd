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

    name = 'aosd',
    version = '0.2.4',
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

    description = 'Python bindings for libaosd',
    long_description= 'This library provides a pure python wrapper for libaosd, an advanced on screen display library.',
)
