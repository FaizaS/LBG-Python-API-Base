FROM python:latest

WORKDIR /app

COPY . .

RUN pip install -r "requirements.txt"

EXPOSE 5001

ENTRYPOINT ["python", "lbg.py"]
