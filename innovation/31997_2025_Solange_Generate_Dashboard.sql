SET SERVEROUTPUT ON
SET PAGESIZE 50000
SET LINESIZE 200
SET FEEDBACK OFF
SET TRIMSPOOL ON

SPOOL dashboard.html

DECLARE
    v_total_savings NUMBER;
    v_total_loans NUMBER;
    v_active_loans NUMBER;
    v_overdue_loans NUMBER;
    v_member_savings NUMBER;
    v_overdue_count NUMBER;
    
    CURSOR c_members IS
        SELECT full_name, member_id FROM members WHERE status = 'ACTIVE';
        
    CURSOR c_loans IS
        SELECT l.loan_id, m.full_name, l.principal_amount, l.interest_amount, 
               l.total_due, l.due_date, l.loan_status
        FROM loans l
        JOIN members m ON l.member_id = m.member_id
        WHERE l.loan_status = 'ACTIVE'
        ORDER BY l.due_date;
        
    CURSOR c_overdue IS
        SELECT l.loan_id, m.full_name, l.total_due, l.due_date
        FROM loans l
        JOIN members m ON l.member_id = m.member_id
        WHERE l.loan_status = 'ACTIVE' AND l.due_date < SYSDATE;
        
BEGIN
    SELECT NVL(SUM(amount), 0) INTO v_total_savings FROM savings_deposits;
    SELECT NVL(SUM(principal_amount), 0) INTO v_total_loans FROM loans;
    SELECT NVL(SUM(principal_amount), 0) INTO v_active_loans FROM loans WHERE loan_status = 'ACTIVE';
    SELECT COUNT(*) INTO v_overdue_loans FROM loans WHERE loan_status = 'ACTIVE' AND due_date < SYSDATE;

    DBMS_OUTPUT.PUT_LINE('<!DOCTYPE html>');
    DBMS_OUTPUT.PUT_LINE('<html>');
    DBMS_OUTPUT.PUT_LINE('<head>');
    DBMS_OUTPUT.PUT_LINE('<title>Umurenge SACCO Dashboard</title>');
    DBMS_OUTPUT.PUT_LINE('<style>');
    DBMS_OUTPUT.PUT_LINE('body { font-family: Arial, sans-serif; background: #f0f2f5; padding: 20px; }');
    DBMS_OUTPUT.PUT_LINE('.container { max-width: 1100px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }');
    DBMS_OUTPUT.PUT_LINE('h1 { color: #1a3c5e; border-bottom: 3px solid #1a3c5e; padding-bottom: 10px; }');
    DBMS_OUTPUT.PUT_LINE('h2 { color: #1a3c5e; margin-top: 30px; }');
    DBMS_OUTPUT.PUT_LINE('.row { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 20px; }');
    DBMS_OUTPUT.PUT_LINE('.card { background: #f8f9fa; padding: 20px; border-radius: 8px; flex: 1; min-width: 150px; text-align: center; }');
    DBMS_OUTPUT.PUT_LINE('.card .value { font-size: 32px; font-weight: bold; color: #1a3c5e; }');
    DBMS_OUTPUT.PUT_LINE('.card .label { font-size: 14px; color: #6c757d; margin-top: 5px; }');
    DBMS_OUTPUT.PUT_LINE('.card.overdue { background: #fff3f3; border-left: 5px solid #dc3545; }');
    DBMS_OUTPUT.PUT_LINE('.card.overdue .value { color: #dc3545; }');
    DBMS_OUTPUT.PUT_LINE('table { width: 100%; border-collapse: collapse; margin-top: 15px; }');
    DBMS_OUTPUT.PUT_LINE('th { background: #1a3c5e; color: white; padding: 12px; text-align: left; }');
    DBMS_OUTPUT.PUT_LINE('td { padding: 12px; border-bottom: 1px solid #dee2e6; }');
    DBMS_OUTPUT.PUT_LINE('.overdue-row { background: #fff3f3; color: #dc3545; font-weight: bold; }');
    DBMS_OUTPUT.PUT_LINE('.alert { background: #dc3545; color: white; padding: 15px; border-radius: 8px; margin-top: 20px; text-align: center; font-weight: bold; font-size: 18px; }');
    DBMS_OUTPUT.PUT_LINE('.alert.green { background: #28a745; }');
    DBMS_OUTPUT.PUT_LINE('.footer { margin-top: 30px; color: #6c757d; font-size: 12px; text-align: center; border-top: 1px solid #dee2e6; padding-top: 15px; }');
    DBMS_OUTPUT.PUT_LINE('</style>');
    DBMS_OUTPUT.PUT_LINE('</head>');
    DBMS_OUTPUT.PUT_LINE('<body>');
    DBMS_OUTPUT.PUT_LINE('<div class="container">');
    DBMS_OUTPUT.PUT_LINE('<h1>Umurenge SACCO Dashboard</h1>');
    DBMS_OUTPUT.PUT_LINE('<p><strong>Generated on:</strong> ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI') || '</p>');
    DBMS_OUTPUT.PUT_LINE('<p><strong>Data Source:</strong> Live Oracle Database</p>');
    
    IF v_overdue_loans > 0 THEN
        DBMS_OUTPUT.PUT_LINE('<div class="alert">ALERT: ' || v_overdue_loans || ' loan(s) are OVERDUE</div>');
    ELSE
        DBMS_OUTPUT.PUT_LINE('<div class="alert green">No Overdue Loans - All loans are in good standing</div>');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('<div class="row">');
    DBMS_OUTPUT.PUT_LINE('<div class="card"><div class="value">RWF ' || TO_CHAR(v_total_savings, '999,999,999') || '</div><div class="label">Total Savings</div></div>');
    DBMS_OUTPUT.PUT_LINE('<div class="card"><div class="value">RWF ' || TO_CHAR(v_total_loans, '999,999,999') || '</div><div class="label">Total Loans</div></div>');
    DBMS_OUTPUT.PUT_LINE('<div class="card"><div class="value">RWF ' || TO_CHAR(v_active_loans, '999,999,999') || '</div><div class="label">Active Loans</div></div>');
    
    IF v_overdue_loans > 0 THEN
        DBMS_OUTPUT.PUT_LINE('<div class="card overdue"><div class="value">' || v_overdue_loans || '</div><div class="label">Overdue Loans</div></div>');
    ELSE
        DBMS_OUTPUT.PUT_LINE('<div class="card"><div class="value">0</div><div class="label">Overdue Loans</div></div>');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('</div>');
    
    DBMS_OUTPUT.PUT_LINE('<h2>Loan Portfolio</h2>');
    DBMS_OUTPUT.PUT_LINE('<table><tr><th>Loan ID</th><th>Member</th><th>Principal</th><th>Interest</th><th>Total Due</th><th>Due Date</th><th>Status</th></tr>');
    
    FOR rec IN c_loans LOOP
        IF rec.due_date < SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('<tr class="overdue-row">');
        ELSE
            DBMS_OUTPUT.PUT_LINE('<tr>');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('<td>' || rec.loan_id || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td>' || rec.full_name || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td>' || TO_CHAR(rec.principal_amount, '999,999,999') || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td>' || TO_CHAR(rec.interest_amount, '999,999,999') || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td>' || TO_CHAR(rec.total_due, '999,999,999') || '</td>');
        DBMS_OUTPUT.PUT_LINE('<td>' || TO_CHAR(rec.due_date, 'DD-MON-YYYY') || '</td>');
        
        IF rec.due_date < SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('<td>OVERDUE</td>');
        ELSE
            DBMS_OUTPUT.PUT_LINE('<td>ACTIVE</td>');
        END IF;
        DBMS_OUTPUT.PUT_LINE('</tr>');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('</table>');
    
    DBMS_OUTPUT.PUT_LINE('<h2>Member Savings Summary</h2>');
    DBMS_OUTPUT.PUT_LINE('<table><tr><th>Member Name</th><th>Total Savings (RWF)</th><th>Status</th></tr>');
    
    FOR rec IN c_members LOOP
        SELECT NVL(SUM(amount), 0) INTO v_member_savings FROM savings_deposits WHERE member_id = rec.member_id;
        DBMS_OUTPUT.PUT_LINE('<tr><td>' || rec.full_name || '</td><td>' || TO_CHAR(v_member_savings, '999,999,999') || '</td><td>Active</td></tr>');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('</table>');
    
    DBMS_OUTPUT.PUT_LINE('<div class="footer">');
    DBMS_OUTPUT.PUT_LINE('Innovation Component - Dynamic HTML Report generated by Oracle PL/SQL<br>');
    DBMS_OUTPUT.PUT_LINE('Script: Innovation/31997_2025_Solange_Generate_Dashboard.sql');
    DBMS_OUTPUT.PUT_LINE('</div>');
    DBMS_OUTPUT.PUT_LINE('</div>');
    DBMS_OUTPUT.PUT_LINE('</body>');
    DBMS_OUTPUT.PUT_LINE('</html>');
END;
/

SPOOL OFF
EXIT