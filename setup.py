#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
try:
    from Cython.Distutils import build_ext
except ImportError:
    from Pyrex.Distutils import build_ext

import subprocess

def pkgconfig_include_dirs(*packages):
    flag_map = {'-I': 'include_dirs'}
    kw = {}
    for token in subprocess.check_output(['pkg-config', '--cflags'] + list(packages)).split():
        kw.setdefault(flag_map.get(token[:2]), []).append(token[2:])
    return kw['include_dirs']

package_version = '0.2.5'

setup (
    cmdclass = {'build_ext' : build_ext},

    name = 'python-aosd',
    version = package_version,
    ext_modules = [
        Extension(
            'aosd',
            ['src/aosd.pyx'],
            include_dirs= pkgconfig_include_dirs('pangocairo') + ['/usr/include/libaosd', '/usr/include/pycairo'],
            libraries = ['aosd', 'aosd-text']
        )
    ],
    requires = ['cairo'],

    author = u'Armin H\u00e4berling',
    author_email = 'armin.aha@gmail.com',
    url = 'https://github.com/arminha/python-aosd',
    download_url = 'https://github.com/arminha/python-aosd/archive/' + package_version + '.tar.gz',
    description = 'Python bindings for libaosd',
    long_description =
    '''
    python-aosd is a Python binding for libaosd: an on screen display (OSD) library, which uses Cairo to create high quality rendered graphics to be overlaid on top of the screen.
    ''',
    classifiers = [
        'Development Status :: 4 - Beta',
        'Environment :: X11 Applications',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX',
        'Programming Language :: Cython',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Intended Audience :: Developers',
        'Topic :: Desktop Environment',
        'Topic :: Software Development :: Libraries',
    ],
)
