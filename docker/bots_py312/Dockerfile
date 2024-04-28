FROM python:3.12

ENV PYTHONUNBUFFERED 1

COPY ./docker/bots_py312/requirements.txt /requirements/

RUN pip install --upgrade pip
RUN pip install -r /requirements/requirements.txt

COPY . /bots
WORKDIR /bots

RUN pip install /bots
RUN mkdir /usr/local/lib/python3.12/site-packages/bots/botssys
RUN mkdir /usr/local/lib/python3.12/site-packages/bots/botssys/sqlitedb
COPY ./src/bots/config/bots.ini /usr/local/lib/python3.12/site-packages/bots/config/
# COPY ./src/bots/config/settings.py /usr/local/lib/python3.12/site-packages/bots/config/
COPY ./src/bots/config/botsdb /usr/local/lib/python3.12/site-packages/bots/botssys/sqlitedb/

COPY ./docker/bots_py312/supervisord.conf /etc/supervisor/supervisord.conf

COPY ./docker/bots_py312/crontab /requirements/

CMD [ "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
EXPOSE 8080
