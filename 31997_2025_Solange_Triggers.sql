-- CREATE SIMPLE TRIGGERS
-- Trigger 1: Auto-Calculate Interest
CREATE OR REPLACE TRIGGER trg_calc_loan_interest
BEFORE INSERT ON loans
FOR EACH ROW
DECLARE
    v_rate NUMBER;
BEGIN
    SELECT interest_rate INTO v_rate
    FROM loan_types
    WHERE loan_type_id = :NEW.loan_type_id;
    :NEW.interest_amount := (:NEW.principal_amount * v_rate * :NEW.duration_months) / 1200;
    :NEW.total_due := :NEW.principal_amount + :NEW.interest_amount;
    :NEW.due_date := ADD_MONTHS(SYSDATE, :NEW.duration_months);
END;
/

-- Trigger 2: Block Overdue Loan Applications
CREATE OR REPLACE TRIGGER trg_block_overdue_loan
BEFORE INSERT ON loans
FOR EACH ROW
DECLARE
    v_overdue_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_overdue_count
    FROM loans l
    LEFT JOIN loan_repayments r ON l.loan_id = r.loan_id
    WHERE l.member_id = :NEW.member_id
      AND l.loan_status = 'ACTIVE'
      AND (r.repayment_date IS NULL OR r.remaining_balance > 0)
      AND l.due_date < SYSDATE - 30;
    IF v_overdue_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Member has overdue loans. Cannot approve new loan.');
    END IF;
END;
/

-- Trigger 3: Update Remaining Balance After Repayment
CREATE OR REPLACE TRIGGER trg_update_loan_balance
AFTER INSERT ON loan_repayments
FOR EACH ROW
DECLARE
    v_total_paid NUMBER := 0;
    v_total_due  NUMBER := 0;
    v_balance    NUMBER := 0;
BEGIN
    SELECT NVL(SUM(amount_paid), 0) INTO v_total_paid
    FROM loan_repayments
    WHERE loan_id = :NEW.loan_id;
    SELECT total_due INTO v_total_due
    FROM loans
    WHERE loan_id = :NEW.loan_id;
    v_balance := v_total_due - v_total_paid;
    UPDATE loan_repayments
    SET remaining_balance = v_balance
    WHERE repayment_id = :NEW.repayment_id;
    IF v_balance <= 0 THEN
        UPDATE loans
        SET loan_status = 'PAID'
        WHERE loan_id = :NEW.loan_id;
    END IF;
END;
/

-- Trigger 4: Block Weekend and Holiday Transactions
CREATE OR REPLACE TRIGGER trg_block_weekend_holiday
BEFORE INSERT OR UPDATE OR DELETE ON loans
DECLARE
    v_today DATE := SYSDATE;
    v_is_holiday NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_is_holiday
    FROM holidays
    WHERE TRUNC(holiday_date) = TRUNC(v_today);
    IF TO_CHAR(v_today, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN') OR v_is_holiday > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transactions blocked on weekends and public holidays.');
    END IF;
END;
/