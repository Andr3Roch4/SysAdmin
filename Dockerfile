FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3

COPY env.py .

ENV PYTHON="Isto é uma env variable."

ENTRYPOINT [ "python3" , "env.py" ]
