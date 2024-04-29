#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import threading
import time
import queue
from queue import Empty
import signal
import subprocess

import click
import psycopg2
from psycopg2.extensions import register_type, UNICODE

from . import botsinit
from . import botslib
from . import botsglobal

def handle_sigterm(*args):
    """Handle graceful shutdown on receiving SIGTERM."""
    print("Shutdown signal received. Exiting gracefully.")
    sys.exit(0)

def initialize_db_connection():
    """Initialize the database connection using direct access to psycopg2 with error handling."""
    try:
        botsinit.connect()  # Ensure that this connects and sets up botsglobal.db properly
        return botsglobal.db
    except Exception as e:
        print(f"Failed to connect to the database: {e}")
        botsglobal.logger.error('Severe error in bots system:\n%(msg)s', {'msg': e})
        sys.exit(1)

class Jobqueue:
    """Class to handle job queue operations."""
    def __init__(self, logger, db):
        self.logger = logger
        self.db = db
        self.jobcounter = self._get_max_jobnumber()

    def updatejobstatus(self, jobnumber, status):
        """Update the status of a job in the queue."""
        try:
            with self.db.cursor() as cur:
                cur.execute("UPDATE job_queue SET status = %s WHERE job_id = %s", (status, jobnumber))
                self.db.commit()
                self.logger.info(f'Job {jobnumber} status updated to {status}')
        except Exception as e:
            self.logger.error(f'Failed to update job status for {jobnumber}: {e}')

    def _get_max_jobnumber(self):
        """Retrieve the maximum job number from the job queue."""
        with self.db.cursor() as cur:
            cur.execute("SELECT MAX(job_id) FROM job_queue")
            max_number = cur.fetchone()[0]
            return max_number if max_number is not None else 0

    def getjob(self):
        """Retrieve the highest priority job from the queue."""
        with self.db.cursor() as cur:
            cur.execute("SELECT job_id, task_details FROM job_queue WHERE status = 'pending' ORDER BY priority DESC LIMIT 1")
            job = cur.fetchone()
            if job:
                self.updatejobstatus(job[0], 'in progress')
                return job
            return None

def poll_database_for_jobs(logger, job_queue, q):
    """Polls the database for new jobs and pushes them into the queue."""
    while True:
        job = job_queue.getjob()  # This method should check for new jobs
        if job:
            logger.info(f"New job fetched from database: {job}")
            q.put((job[0], job[1]))  # Ensure job is properly formatted as (job_id, task_details)
        else:
            logger.info("No new jobs found in the database.")
        time.sleep(10)  # Wait for 10 seconds before polling again

def launcher(logger, q, launch_frequency, max_runtime, db, job_queue):
    """Launch jobs from the queue at specified intervals with retry logic."""
    while True:
        try:
            jobnumber, task_to_run = q.get(timeout=launch_frequency)
            logger.info(f'Starting job {jobnumber}')
            result = subprocess.run(task_to_run, shell=True, text=True, capture_output=True)
            if result.returncode == 0:
                logger.info(f'Job {jobnumber} completed successfully.')
                job_queue.updatejobstatus(jobnumber, 'completed')
            else:
                logger.error(f'Job {jobnumber} failed with error: {result.stderr}')
                job_queue.updatejobstatus(jobnumber, 'failed')
            q.task_done()
        except Empty:
            continue
        except Exception as msg:
            logger.error('Error starting job %(job)s: %(msg)s', {'job': jobnumber, 'msg': str(msg)})
            q.task_done()

@click.command()
@click.option('--configdir', '-c', default='config', help='Path to config-directory.')
def start(configdir):
    """Start the job queue server."""
    botsinit.generalinit(configdir)
    if not botsglobal.ini.getboolean('jobqueue', 'enabled', False):
        logger.error(f'Error: bots jobqueue cannot start; not enabled in {configdir}/bots.ini')
        sys.exit(1)

    logger = botsinit.initserverlogging('jobqueue')
    db = initialize_db_connection()
    job_queue = Jobqueue(logger, db)
    q = queue.Queue()

    launch_frequency = botsglobal.ini.getint('jobqueue', 'launch_frequency', 5)
    max_runtime = botsglobal.ini.getint('settings', 'maxruntime', 300)

    signal.signal(signal.SIGTERM, handle_sigterm)

    # Start the database polling thread
    polling_thread = threading.Thread(target=poll_database_for_jobs, args=(logger, job_queue, q))
    polling_thread.start()
    logger.info("Database polling thread started successfully.")

    # Setup launcher threads
    threads = []
    for i in range(2):
        t = threading.Thread(target=launcher, args=(logger, q, launch_frequency, max_runtime, db, job_queue))
        t.start()
        threads.append(t)
        logger.info(f"Launcher thread {i} started successfully.")

    logger.info('Jobqueue server started.')
    try:
        for t in threads:
            t.join()
    except KeyboardInterrupt:
        logger.info('Shutting down due to keyboard interrupt.')
        sys.exit(0)

if __name__ == '__main__':
    start()
