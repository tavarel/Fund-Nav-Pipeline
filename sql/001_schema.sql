-- Creating SQL tables to be inserted on the POSTGRES db.
BEGIN;

DROP TABLE IF EXISTS prices CASCADE;
DROP TABLE IF EXISTS positions CASCADE;
DROP TABLE IF EXISTS portfolios CASCADE;
DROP TABLE IF EXISTS securities CASCADE;


CREATE TABLE securities (
    security_id     INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticker      TEXT    NOT NULL UNIQUE,
    name       TEXT     NOT NULL,   
    asset_class     TEXT       NOT NULL CHECK(asset_class IN ('equity', 'fixed_income')),
    currency    CHAR(3)        NOT NULL CHECK(currency ~ '^[A-Z]{3}$'),
    expense_ratio   NUMERIC(7,6) CHECK(expense_ratio >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT now()
);


CREATE TABLE portfolios (
    portfolio_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name    TEXT    NOT NULL UNIQUE,
    base_currency   CHAR(3)     NOT NULL CHECK(base_currency ~ '^[A-Z]{3}$'),
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now()
);


CREATE TABLE positions (

    portfolio_id INTEGER NOT NULL REFERENCES portfolios(portfolio_id),
    security_id INTEGER NOT NULL REFERENCES securities(security_id),
    position_date DATE NOT NULL,
    quantity NUMERIC(18,6) NOT NULL CHECK(quantity >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (portfolio_id, security_id, position_date)

);


CREATE TABLE prices (
    security_id INTEGER NOT NULL REFERENCES securities(security_id),
    close_price NUMERIC(18, 6) NOT NULL CHECK(close_price > 0),
    price_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (security_id, price_date)
    
);


COMMIT;
