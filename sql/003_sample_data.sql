-- Generates provisional sample market data (prices, FX rates, positions).

BEGIN;

SELECT setseed(0.42);

-- Business days in the sample period, shared by the three inserts below.
-- The temporary table disappears automatically at COMMIT.

CREATE TEMP TABLE sample_dates ON COMMIT DROP AS
SELECT d::date AS business_date

FROM generate_series('2026-08-17'::date, '2026-09-25'::date, interval '1 day') AS d
WHERE EXTRACT(ISODOW FROM d) < 6          -- Monday (1) to Friday (5)
  AND d::date <> '2026-09-07';            -- US market holiday (Labor Day)


INSERT INTO prices (security_id, price_date, close_price)

SELECT
    s.security_id,
    d.business_date,
    ROUND((b.base_price * (1 + (random() - 0.5) * 0.04))::numeric, 2)
FROM securities AS s
JOIN (VALUES
    ('IVV', 650), ('IJH', 65),  ('IJR', 120), ('EFA', 100), ('IEMG', 65),
    ('EWJ', 85),  ('AGG', 100), ('TLT', 90),  ('IEF', 96),  ('LQD', 110)
) AS b (ticker, base_price) ON b.ticker = s.ticker
CROSS JOIN sample_dates AS d;

-- Daily USD/JPY rate: moves up to 1% around 148.
INSERT INTO fx_rates (base_currency, quote_currency, rate_date, rate)
SELECT
    'USD',
    'JPY',
    business_date,
    ROUND((148 * (1 + (random() - 0.5) * 0.02))::numeric, 4)
FROM sample_dates;

-- Daily positions of the fund. The fund buys 500 more IVV on 2026-09-08.
INSERT INTO positions (portfolio_id, security_id, position_date, quantity)
SELECT
    p.portfolio_id,
    s.security_id,
    d.business_date,
    CASE
        WHEN s.ticker = 'IVV' AND d.business_date >= '2026-09-08' THEN q.quantity + 500
        ELSE q.quantity
    END

FROM portfolios AS p
CROSS JOIN securities AS s
JOIN (VALUES
    ('IVV', 2000), ('IJH', 3000), ('IJR', 1500), ('EFA', 4000), ('IEMG', 3000),
    ('EWJ', 2500), ('AGG', 5000), ('TLT', 2000), ('IEF', 2000), ('LQD', 2500)
) AS q (ticker, quantity) ON q.ticker = s.ticker
CROSS JOIN sample_dates AS d
WHERE p.name = 'Tokyo Global Fund';

COMMIT;