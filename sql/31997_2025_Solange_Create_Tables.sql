
-- CREATE ALL TABLES (7 Tables)

CREATE TABLE members (
    member_id        NUMBER PRIMARY KEY,
    national_id      VARCHAR2(16) UNIQUE NOT NULL,
    full_name        VARCHAR2(100) NOT NULL,
    phone_number     VARCHAR2(15) NOT NULL,
    village          VARCHAR2(50) NOT NULL,
    cell             VARCHAR2(50) NOT NULL,
    sector           VARCHAR2(50) NOT NULL,
    registration_date DATE DEFAULT SYSDATE,
    status           VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED'))
);

CREATE TABLE loan_types (
    loan_type_id     NUMBER PRIMARY KEY,
    type_name        VARCHAR2(50) UNIQUE NOT NULL,
    interest_rate    NUMBER(5,2) NOT NULL CHECK (interest_rate >= 0),
    max_amount       NUMBER(12,2) NOT NULL CHECK (max_amount > 0),
    min_duration_months NUMBER NOT NULL CHECK (min_duration_months > 0),
    max_duration_months NUMBER NOT NULL CHECK (max_duration_months > 0)
);

CREATE TABLE loans (
    loan_id          NUMBER PRIMARY KEY,
    member_id        NUMBER NOT NULL,
    loan_type_id     NUMBER NOT NULL,
    principal_amount NUMBER(12,2) NOT NULL CHECK (principal_amount > 0),
    interest_amount  NUMBER(12,2) DEFAULT 0,
    total_due        NUMBER(12,2) DEFAULT 0,
    duration_months  NUMBER NOT NULL,
    disbursement_date DATE DEFAULT SYSDATE,
    due_date         DATE NOT NULL,
    loan_status      VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (loan_status IN ('ACTIVE', 'PAID', 'DEFAULTED')),
    approved_by      VARCHAR2(50),
    approval_date    DATE DEFAULT SYSDATE,
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_loan_type FOREIGN KEY (loan_type_id) REFERENCES loan_types(loan_type_id)
);

CREATE TABLE savings_deposits (
    deposit_id       NUMBER PRIMARY KEY,
    member_id        NUMBER NOT NULL,
    deposit_date     DATE DEFAULT SYSDATE,
    amount           NUMBER(12,2) NOT NULL CHECK (amount > 0),
    deposit_method   VARCHAR2(20) CHECK (deposit_method IN ('CASH', 'MOMO', 'BANK_TRANSFER')),
    recorded_by      VARCHAR2(50),
    note             VARCHAR2(255),
    CONSTRAINT fk_saving_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE loan_repayments (
    repayment_id     NUMBER PRIMARY KEY,
    loan_id          NUMBER NOT NULL,
    repayment_date   DATE DEFAULT SYSDATE,
    amount_paid      NUMBER(12,2) NOT NULL CHECK (amount_paid > 0),
    payment_method   VARCHAR2(20) CHECK (payment_method IN ('CASH', 'MOMO', 'BANK_TRANSFER')),
    received_by      VARCHAR2(50),
    remaining_balance NUMBER(12,2) DEFAULT 0,
    CONSTRAINT fk_repayment_loan FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE audit_log (
    log_id           NUMBER PRIMARY KEY,
    table_name       VARCHAR2(50),
    action_type      VARCHAR2(20),
    record_id        NUMBER,
    old_value        VARCHAR2(4000),
    new_value        VARCHAR2(4000),
    performed_by     VARCHAR2(50),
    action_date      DATE DEFAULT SYSDATE
);

CREATE TABLE holidays (
    holiday_id   NUMBER PRIMARY KEY,
    holiday_date DATE NOT NULL UNIQUE,
    holiday_name VARCHAR2(100)
);