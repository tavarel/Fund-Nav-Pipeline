BEGIN;




INSERT INTO portfolios (name, base_currency)
VALUES ('Tokyo Global Fund', 'JPY');

\copy securities (ticker, name, asset_class, currency, expense_ratio) FROM '/data/securities.csv' WITH (FORMAT csv, HEADER true)

COMMIT;