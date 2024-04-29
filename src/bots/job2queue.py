#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function, unicode_literals
import sys
import click
import psycopg2
import psycopg2.extras
from psycopg2.extensions import UNICODE, register_type

# Bots-modules
from . import botsinit
from . import botsglobal

if sys.version_info[0] > 2:
    basestring = unicode = str

JOBQUEUEMESSAGE2TXT = {
    0: 'OK, job is added to queue',
    1: 'Error, job not added to jobqueue. Cannot contact database',
    4: 'Duplicate job, not added.',
}

def send_job_to_jobqueue(task_args, priority=5):
    """Adds a new job to the bots-jobqueue using direct database access."""
    try:
        botsinit.connect()

        task_description = ' '.join(task_args) if isinstance(task_args, (list, tuple)) else task_args
        with botsglobal.db.cursor() as cur:
            # Check if the same pending job already exists
            cur.execute("SELECT job_id FROM job_queue WHERE task_details = %s AND status = 'pending'", (task_description,))
            existing_job = cur.fetchone()

            if existing_job:
                if existing_job[0] != priority:
                    # Update priority if different
                    cur.execute("UPDATE job_queue SET priority = %s WHERE job_id = %s", (priority, existing_job[0]))
                    botsglobal.db.commit()
                    return 0
                else:
                    # Do not add a duplicate job
                    return 4
            else:
                # Insert new job without specifying job_id
                cur.execute("INSERT INTO job_queue (priority, task_details, status) VALUES (%s, %s, 'pending')", (priority, task_description))
                botsglobal.db.commit()
                return 0
    except Exception as e:
        botsglobal.logger.error('Database error: {}'.format(e))
        return 1

@click.command()
@click.option('--configdir', '-c', default='config', help='Path to config-directory.')
@click.option('--priority', '-p', default=5, type=click.IntRange(1, 9), help='Priority of job. Highest priority is 1')
@click.argument('task_args', nargs=-1)
def start(configdir, priority, task_args):
    botsinit.generalinit(configdir)
    if not botsglobal.ini.getboolean('jobqueue', 'enabled', False):
        print('Error: bots jobqueue cannot start; not enabled in {}/bots.ini'.format(configdir))
        sys.exit(1)

    # Convert tuple of task arguments into a single string
    task_args = ' '.join(task_args)
    return_code = send_job_to_jobqueue(task_args, priority)
    print(JOBQUEUEMESSAGE2TXT[return_code])
    sys.exit(return_code)

if __name__ == '__main__':
    start()

