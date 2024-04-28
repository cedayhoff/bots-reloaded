# -*- coding: utf-8 -*-

import os
import bots
# Django settings for bots project.
PROJECT_PATH = os.path.abspath(os.path.dirname(bots.__file__))

#*******settings for sending bots error reports via email**********************************
MANAGERS = (    #bots will send error reports to the MANAGERS
    ('name_manager', 'adress@test.com'),
    )
EMAIL_HOST = 'localhost'             #Default: 'localhost'
EMAIL_USE_TLS = True
EMAIL_PORT = 587  # Typically 587 when using TLS
EMAIL_HOST_USER = ''        #Default: ''. Username to use for the SMTP server defined in EMAIL_HOST. If empty, Django won't attempt authentication.
EMAIL_HOST_PASSWORD = ''    #Default: ''. PASSWORD to use for the SMTP server defined in EMAIL_HOST. If empty, Django won't attempt authentication.
#~ SERVER_EMAIL = 'user@gmail.com'           #Sender of bots error reports. Default: 'root@localhost'
#~ EMAIL_SUBJECT_PREFIX = ''   #This is prepended on email subject.

#*********database settings*************************
# Set default database to SQLite
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(PROJECT_PATH, 'config/botsdb'),
        # The rest of the settings are not necessary for SQLite
    }
}

# Get the database engine from an environment variable
database_engine = os.getenv('DB_ENGINE', 'sqlite').lower()
#SQLite database (default bots database)
if database_engine == 'mysql':
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'botsdb',
        'USER': 'sa',
        'PASSWORD': 'botsbots123#',
        'HOST': 'db', 
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES', NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
            'charset': 'utf8mb4',
            'use_unicode': True,
        }
    }

# Configure for MariaDB
if database_engine == 'mariadb':
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'botsdb',
        'USER': 'sa',
        'PASSWORD': 'botsbots123#',
        'HOST': 'db', 
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES', NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
            'charset': 'utf8mb4',
            'use_unicode': True,
        }
    }


# Configure for PostgreSQL
elif database_engine == 'postgresql':
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'botsdb',
        'USER': 'bots',
        'PASSWORD': 'botsbots',
        'HOST': 'db',
        'PORT': '5432',
        'OPTIONS': {},
    }

# Configure for Oracle
if database_engine == 'oracle':
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.oracle',
            'NAME': 'FREE',  # Use SID here
            'USER': 'sa',
            'PASSWORD': 'botsbots123#',
            'PORT': '1521',
        }
    }

# Configure for SQL Server
elif database_engine == 'sqlserver':
    DATABASES['default'] = {
        'ENGINE': 'mssql', 
        'NAME': 'botsdb',
        'USER': 'sa',
        'PASSWORD': 'botsbots123#',
        'HOST': 'db',
        'PORT': '1433',
        'OPTIONS': {
            'driver': 'ODBC Driver 17 for SQL Server',
        },
    }

#*********setting date/time zone and formats *************************
# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# If running in a Windows environment this must be set to the same as your
# system time zone.
TIME_ZONE = 'Europe/Amsterdam'

#~ *********language code/internationalization*************************
# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'
#~ LANGUAGE_CODE = 'nl'
USE_I18N = True
USE_L10N = True

#*************************************************************************
#*********other django setting. please consult django docs.***************
#*************************************************************************
#*************************************************************************

#*********path settings*************************
# Static and media files configuration
STATIC_URL = '/media/'
STATIC_ROOT = PROJECT_PATH + '/'
ROOT_URLCONF = 'bots.urls'
LOGIN_URL = '/login/'
LOGIN_REDIRECT_URL = '/home'
LOGOUT_URL = '/logout/'
#~ LOGOUT_REDIRECT_URL = #not such parameter; is set in urls.py
ALLOWED_HOSTS = ['*']

#*********sessions, cookies, log out time*************************
SESSION_EXPIRE_AT_BROWSER_CLOSE = True      #True: always log in when browser is closed
SESSION_COOKIE_AGE = 3600                   #seconds a user needs to login when no activity
SESSION_SAVE_EVERY_REQUEST = True           #if True: SESSION_COOKIE_AGE is interpreted as: since last activity

#set in bots.ini
#~ DEBUG = True
#~ TEMPLATE_DEBUG = DEBUG
SITE_ID = 1
# Make this unique, and don't share it with anybody.
SECRET_KEY = 'm@-u37qiujmeqfbu$daaaaz)sp^7an4u@h=wfx9dd$$$zl2i*x9#awojdc'

#*******template handling and finding*************************************************************************
# List of callables that know how to import templates from various sources.
#disable because these used values are the default values
#~ TEMPLATE_LOADERS = (
    #~ 'django.template.loaders.filesystem.Loader',
    #~ 'django.template.loaders.app_directories.Loader',
    #~ )

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(PROJECT_PATH, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.media', 
                'django.template.context_processors.static',
                'django.template.context_processors.i18n',  
                'bots.bots_context.set_context',
            ],
        },
    },
]
#*******includes for django*************************************************************************
LOCALE_PATHS = (
    os.path.join(PROJECT_PATH, 'locale'),
    )
#save uploaded file (=plugin) always to file. no path for temp storage is used, so system default is used.
FILE_UPLOAD_HANDLERS = (
    'django.core.files.uploadhandler.TemporaryFileUploadHandler',
    )
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


INSTALLED_APPS = [
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'bots',
    'django.contrib.admin',
    'django.contrib.messages',
    'crispy_forms',
    'crispy_bootstrap4',
]


CRISPY_TEMPLATE_PACK = 'bootstrap4'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': '/var/log/django.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}