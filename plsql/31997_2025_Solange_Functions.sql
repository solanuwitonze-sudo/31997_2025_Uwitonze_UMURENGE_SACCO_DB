
-- CREATE FUNCTIONS
CREATE OR REPLACE FUNCTION fn_get_savings_balance(p_member_id NUMBER)
RETURN NUMBER
IS
    v_total NUMBER := 0;
BEGIN
    SELECT NVL(SUM(amount), 0)
    INTO v_total
    FROM savings_deposits
    WHERE member_id = p_member_id;
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN 0;
END;
/