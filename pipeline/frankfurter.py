from datetime import date
from decimal import Decimal
import httpx

BASE_URL = "https://api.frankfurter.dev/v1"

def fetch_rates(base: str, quote: str, start: date, end: date) -> list[tuple]:
    print()

    url = f"{BASE_URL}/{start.isoformat()}..{end.isoformat()}"
    response = httpx.get(url, params={"base": base, "symbols": quote}, timeout=10.1)
    response.raise_for_status()
    payload = response.json(parse_float=Decimal)

    r= []
    for day, rates in payload['rates'].items():
        r.append((base, quote, date.fromisoformat(day), rates[quote]))
    return r

