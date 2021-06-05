FROM python:3.9
ENV FLASK_APP=app
RUN mkdir app
COPY ./app /app
COPY ./requirements.txt .
RUN pip install -r requirements.txt
CMD [ "python", "app/__init__.py" ]