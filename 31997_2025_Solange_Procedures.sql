
-- CREATE PROCEDURES (With Cursor)
CREATE OR REPLACE PROCEDURE sp_weekly_financial_report
IS
    CURSOR c_members IS
        SELECT member_id, full_name FROM members WHERE status = 'ACTIVE';
    v_savings  NUMBER;
    v_loans    NUMBER;
    v_overdue  NUMBER;
    v_balance  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('WEEKLY SACCO FINANCIAL STATEMENT');
    DBMS_OUTPUT.PUT_LINE('Report Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
    SELECT NVL(SUM(amount), 0) INTO v_savings FROM savings_deposits;
    DBMS_OUTPUT.PUT_LINE('Total Savings Deposits: ' || v_savings);
    SELECT NVL(SUM(principal_amount), 0) INTO v_loans
    FROM loans WHERE loan_status = 'ACTIVE';
    DBMS_OUTPUT.PUT_LINE('Total Active Loans: ' || v_loans);
    SELECT COUNT(*) INTO v_overdue
    FROM loans
    WHERE loan_status = 'ACTIVE' AND due_date < SYSDATE;
    DBMS_OUTPUT.PUT_LINE('Overdue Loans: ' || v_overdue);
    DBMS_OUTPUT.PUT_LINE('Member Summary:');
    FOR rec IN c_members LOOP
        v_balance := fn_get_savings_balance(rec.member_id);
        DBMS_OUTPUT.PUT_LINE('   - ' || rec.full_name || ': Savings = ' || v_balance);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error generating report: ' || SQLERRM);
END;
/