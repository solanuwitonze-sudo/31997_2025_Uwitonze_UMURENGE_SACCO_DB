
-- CREATE PACKAGE SPECIFICATION & BODY

CREATE OR REPLACE PACKAGE pkg_loan_mgmt AS
    PROCEDURE approve_loan(p_loan_id NUMBER, p_approver VARCHAR2);
    PROCEDURE record_repayment(p_loan_id NUMBER, p_amount NUMBER, p_method VARCHAR2, p_receiver VARCHAR2);
    FUNCTION get_loan_status(p_loan_id NUMBER) RETURN VARCHAR2;
    PROCEDURE generate_overdue_alert;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_loan_mgmt AS

    PROCEDURE approve_loan(p_loan_id NUMBER, p_approver VARCHAR2) IS
    BEGIN
        UPDATE loans
        SET approved_by = p_approver,
            approval_date = SYSDATE,
            loan_status = 'ACTIVE'
        WHERE loan_id = p_loan_id;
        DBMS_OUTPUT.PUT_LINE('Loan ' || p_loan_id || ' approved by ' || p_approver);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END;

    PROCEDURE record_repayment(p_loan_id NUMBER, p_amount NUMBER, p_method VARCHAR2, p_receiver VARCHAR2) IS
    BEGIN
        INSERT INTO loan_repayments (repayment_id, loan_id, repayment_date, amount_paid, payment_method, received_by)
        VALUES (seq_repayment_id.NEXTVAL, p_loan_id, SYSDATE, p_amount, p_method, p_receiver);
        DBMS_OUTPUT.PUT_LINE('Repayment recorded for loan ' || p_loan_id);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END;

    FUNCTION get_loan_status(p_loan_id NUMBER) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT loan_status INTO v_status
        FROM loans
        WHERE loan_id = p_loan_id;
        RETURN v_status;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'LOAN NOT FOUND';
        WHEN OTHERS THEN
            RETURN 'ERROR: ' || SQLERRM;
    END;

    PROCEDURE generate_overdue_alert IS
        CURSOR c_overdue IS
            SELECT m.full_name, l.loan_id, l.total_due, l.due_date
            FROM loans l
            JOIN members m ON l.member_id = m.member_id
            WHERE l.loan_status = 'ACTIVE' AND l.due_date < SYSDATE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('OVERDUE LOAN ALERT');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        FOR rec IN c_overdue LOOP
            DBMS_OUTPUT.PUT_LINE('Member: ' || rec.full_name || ' | Loan: ' || rec.loan_id || ' | Due: ' || TO_CHAR(rec.due_date, 'DD-MON-YYYY') || ' | Amount: ' || rec.total_due);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error generating alert: ' || SQLERRM);
    END;

END;
/