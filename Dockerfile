FROM python:3

ENV DB_PASSWORD ChangeMe

WORKDIR /usr/FeuerwehrAlarmdepesche

COPY ./dockerInternalStart.sh start.sh
COPY Alarmdepesche /
COPY vorlagen/Steinbachhallenberg.html /
RUN apt-get update -y && \
    apt-get install -y python-pip python-dev libmysqlclient-dev screen && \
    pip install --no-cache-dir -U -r python/requirements.txt

RUN export DEBIAN_FRONTEND=noninteractive ; \
    apt-get install -y mysql-server apache2

# Dev
RUN apt-get install -y vim

COPY ./dockerInternalStart.sh start.sh
COPY Alarmdepesche/ Alarmdepesche/
COPY Alarmdepesche/alarmdepescheconfig.py Alarmdepesche/
COPY vorlagen vorlagen

COPY dbinit.sql .

RUN chmod +x /usr/FeuerwehrAlarmdepesche/start.sh
ENTRYPOINT [ "/usr/FeuerwehrAlarmdepesche/start.sh" ]
