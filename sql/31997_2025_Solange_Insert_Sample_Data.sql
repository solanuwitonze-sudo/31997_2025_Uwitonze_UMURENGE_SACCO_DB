
-- INSERT SAMPLE DATA (Members, Savings, Loans, Repayments)
-- Insert Members
INSERT INTO members (member_id, national_id, full_name, phone_number, village, cell, sector, status)
VALUES (seq_member_id.NEXTVAL, '1234567890123456', 'Mukamana Grace', '0788123456', 'Nyamirambo', 'Muhima', 'Nyarugenge', 'ACTIVE');

INSERT INTO members (member_id, national_id, full_name, phone_number, village, cell, sector, status)
VALUES (seq_member_id.NEXTVAL, '2345678901234567', 'Habimana Jean', '0788234567', 'Kimironko', 'Kibagabaga', 'Gasabo', 'ACTIVE');

INSERT INTO members (member_id, national_id, full_name, phone_number, village, cell, sector, status)
VALUES (seq_member_id.NEXTVAL, '3456789012345678', 'Uwimana Diane', '0788345678', 'Gisozi', 'Kinyinya', 'Gasabo', 'ACTIVE');

-- Insert Savings Deposits
INSERT INTO savings_deposits (deposit_id, member_id, deposit_date, amount, deposit_method, recorded_by)
VALUES (seq_deposit_id.NEXTVAL, 1000, SYSDATE, 50000, 'CASH', 'Officer Jean');

INSERT INTO savings_deposits (deposit_id, member_id, deposit_date, amount, deposit_method, recorded_by)
VALUES (seq_deposit_id.NEXTVAL, 1001, SYSDATE, 75000, 'MOMO', 'Officer Jean');

INSERT INTO savings_deposits (deposit_id, member_id, deposit_date, amount, deposit_method, recorded_by)
VALUES (seq_deposit_id.NEXTVAL, 1002, SYSDATE, 25000, 'CASH', 'Officer Marie');

-- Insert Loans (with DUE_DATE)
INSERT INTO loans (loan_id, member_id, loan_type_id, principal_amount, duration_months, approved_by, due_date)
VALUES (seq_loan_id.NEXTVAL, 1000, 1, 300000, 12, 'Officer Jean', ADD_MONTHS(SYSDATE, 12));

INSERT INTO loans (loan_id, member_id, loan_type_id, principal_amount, duration_months, approved_by, due_date)
VALUES (seq_loan_id.NEXTVAL, 1001, 2, 1500000, 18, 'Officer Jean', ADD_MONTHS(SYSDATE, 18));

INSERT INTO loans (loan_id, member_id, loan_type_id, principal_amount, duration_months, approved_by, due_date)
VALUES (seq_loan_id.NEXTVAL, 1002, 3, 100000, 4, 'Officer Marie', ADD_MONTHS(SYSDATE, 4));

INSERT INTO loans (loan_id, member_id, loan_type_id, principal_amount, duration_months, approved_by, due_date)
VALUES (seq_loan_id.NEXTVAL, 1000, 1, 200000, 6, 'Officer Jean', ADD_MONTHS(SYSDATE, 6));

-- Insert Loan Repayments
INSERT INTO loan_repayments (repayment_id, loan_id, repayment_date, amount_paid, payment_method, received_by)
VALUES (seq_repayment_id.NEXTVAL, 5000, SYSDATE, 50000, 'MOMO', 'Officer Jean');

INSERT INTO loan_repayments (repayment_id, loan_id, repayment_date, amount_paid, payment_method, received_by)
VALUES (seq_repayment_id.NEXTVAL, 5001, SYSDATE, 100000, 'CASH', 'Officer Jean');

INSERT INTO loan_repayments (repayment_id, loan_id, repayment_date, amount_paid, payment_method, received_by)
VALUES (seq_repayment_id.NEXTVAL, 5002, SYSDATE, 20000, 'MOMO', 'Officer Marie');

COMMIT;