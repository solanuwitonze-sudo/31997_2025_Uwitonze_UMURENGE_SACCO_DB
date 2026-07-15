-- CREATE COMPOUND TRIGGER (Audit Logging)

CREATE OR REPLACE TRIGGER trg_audit_loan_changes
FOR UPDATE OR DELETE ON loans
COMPOUND TRIGGER
    TYPE t_audit_rec IS RECORD (
        table_name  VARCHAR2(50),
        action_type VARCHAR2(20),
        record_id   NUMBER,
        old_value   VARCHAR2(4000),
        new_value   VARCHAR2(4000),
        performed_by VARCHAR2(50)
    );
    TYPE t_audit_tab IS TABLE OF t_audit_rec INDEX BY PLS_INTEGER;
    g_audit_data t_audit_tab;
    g_idx PLS_INTEGER := 0;

    BEFORE EACH ROW IS
    BEGIN
        g_idx := g_idx + 1;
        g_audit_data(g_idx).table_name := 'LOANS';
        g_audit_data(g_idx).record_id := :OLD.loan_id;
        g_audit_data(g_idx).performed_by := USER;

        IF UPDATING THEN
            g_audit_data(g_idx).action_type := 'UPDATE';
            g_audit_data(g_idx).old_value := 'Status:' || :OLD.loan_status || '|Amount:' || :OLD.total_due;
            g_audit_data(g_idx).new_value := 'Status:' || :NEW.loan_status || '|Amount:' || :NEW.total_due;
        ELSIF DELETING THEN
            g_audit_data(g_idx).action_type := 'DELETE';
            g_audit_data(g_idx).old_value := 'Status:' || :OLD.loan_status || '|Amount:' || :OLD.total_due;
            g_audit_data(g_idx).new_value := 'DELETED';
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..g_idx LOOP
            INSERT INTO audit_log (log_id, table_name, action_type, record_id, old_value, new_value, performed_by)
            VALUES (seq_audit_id.NEXTVAL, 
                    g_audit_data(i).table_name,
                    g_audit_data(i).action_type,
                    g_audit_data(i).record_id,
                    g_audit_data(i).old_value,
                    g_audit_data(i).new_value,
                    g_audit_data(i).performed_by);
        END LOOP;
        g_idx := 0;
    END AFTER STATEMENT;
END;
/