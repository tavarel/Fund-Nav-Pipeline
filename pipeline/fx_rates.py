import psycopg

# %s usualy prevents SQL injections 
UPSERT_SQL = """
    INSERT INTO fx_rates (base_currency, quote_currency, rate_date, rate)
    VALUES (%s, %s, %s, %s)
    ON CONFLICT (base_currency, quote_currency, rate_date)
    DO UPDATE SET rate = EXCLUDED.rate 
"""

def upsert_fx_rates(conn: psycopg.Connection, r: list[tuple]) -> int:
    with conn.cursor() as cur:
        cur.executemany(UPSERT_SQL, r)
    return len(r)