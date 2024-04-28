# -*- coding: utf-8 -*-

"""A setuptools based setup module.

For more information, please see
- https://pypi.python.org/pypi/setuptools
- https://pythonhosted.org/setuptools
- https://python-packaging-user-guide.readthedocs.io/en/latest/distributing/
- https://packaging.python.org/en/latest/distributing.html
- https://github.com/pypa/sampleproject

"""
from __future__ import absolute_import, division, print_function

import io
import os
import platform
import setuptools


def read(*names, **kwargs):
    r"""Return the contents of a file.

    Default encoding is UTF-8, unless specified otherwise.

    Args:
        - names (list, required): list of strings, parts of the path.
          the path might be relative to the current file.

    Keyword Args:
        **kwargs: Arbitrary keyword arguments.

    Returns:
      String containing the content of the file.

    Examples:
        >>> read('docs/readme.rst')
            u'Overview\n--------\n...'

        >>> read('docs', 'readme.rst')
            u'Overview\n--------\n...'

    """
    fn = os.path.join(os.path.dirname(__file__), *names)
    with io.open(fn, encoding=kwargs.get('encoding', 'utf8')) as fd:
        return fd.read()


version = '2024.04.27.1'


long_description = (
    read('docs', 'readme.rst') +
    '\n\n' +
    read('docs', 'changes.rst')
    #'\n\n' +
    #read('docs', 'contributors.rst')
    )

install_requires = [
    'click==8.1.7',
    'future==1.0.0',
    'setuptools==69.5.1',
    'six==1.16.0'
]

extras_require = {
    'docs': [
        'sphinx==7.3.7',
        'sphinx_rtd_theme==2.0.0'
    ],
    'tools': [
        'ecdsa==0.19.0',       # dep of paramiko
        'Genshi==0.7.7',       # for using templates/mapping to HTML)
        'paramiko==3.4.0',     # SFTP
        'pdfminer==20191125',  # parse pdf-files
        'pycryptodome==3.20.0',     # SFTP
        'xlrd==2.0.1'          # parse excel-files
    ]
}

# Add OS-specific dependencies
operating_system = platform.system()
if operating_system == 'Linux':
    install_requires.append('pyinotify')
elif operating_system == 'Windows':
    install_requires.append('pywin32')

classifiers = [
    'Development Status :: 5 - Production/Stable',
    'Operating System :: OS Independent',
    'Programming Language :: Python :: 3.12',
    'License :: OSI Approved :: GNU General Public License (GPL)',
    'Topic :: Office/Business',
    'Topic :: Office/Business :: Financial',
    'Topic :: Other/Nonlisted Topic',
    'Topic :: Communications',
    'Environment :: Console',
    'Environment :: Web Environment',
    ]

setuptools.setup(
    name='bots',
    version=version,
    author='hjebbers',
    author_email='hjebbers@gmail.com',
    url='https://github.com/bots-edi/bots',
    description='Bots open source edi translator',
    long_description=long_description,
    platforms='OS Independent (Written in an interpreted language)',
    license='GNU General Public License (GPL)',
    keywords='edi edifact x12 tradacoms xml fixedfile csv',
    packages=setuptools.find_packages('src'),
    package_dir={'': 'src'},
    include_package_data=True,
    zip_safe=False,
    classifiers=classifiers,
    install_requires=install_requires,
    extras_require=extras_require,

    scripts=[
        'scripts/bots-webserver.py',
        'scripts/bots-engine.py',
        'scripts/bots-grammarcheck.py',
        'scripts/bots-xml2botsgrammar.py',
        'scripts/bots-updatedb.py',
        'scripts/bots-dirmonitor.py',
        'scripts/bots-jobqueueserver.py',
        'scripts/bots-plugoutindex.py',
        'scripts/bots-job2queue.py',
        ],

    entry_points={
        'console_scripts': [
            'bots-dirmonitor = bots.dirmonitor:start',
            'bots-engine = bots.engine:start',
            'bots-engine2 = bots.engine:start',
            'bots-grammarcheck = bots.grammarcheck:start',
            'bots-job2queue = bots.job2queue:start',
            'bots-jobqueueserver = bots.jobqueueserver:start',
            'bots-plugoutindex = bots.plugoutindex:start',
            'bots-updatedb = bots.updatedb:start',
            'bots-webserver = bots.webserver:start',
            'bots-xml2botsgrammar = bots.xml2botsgrammar:start',
            ]
        },
    )
