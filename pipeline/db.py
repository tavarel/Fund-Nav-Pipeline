import os

import psycopg
from dotenv import load_dotenv

def get_connection() -> psycopg.Connection:
    return psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ['DB_PORT'],
        dbname=os.environ["POSTGRES_DB"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"]
    );

