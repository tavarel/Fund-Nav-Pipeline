from datetime import date

from pipeline.db import get_connection
from pipeline.frankfurter import fetch_rates
from pipeline.fx_rates import upsert_fx_rates


rows = fetch_rates("USD", "JPY", date(2026, 8, 17), date(2026, 9, 25)) # testing purposes
print(f"Fetched {len(rows)} rates. First: {rows[0]}")

with get_connection() as conn:    
    count = upsert_fx_rates(conn, rows)
    print(f"Upserted {count} rows into fx_rates.")