-- Creating SQL tables to be inserted on the POSTGRES db.

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

