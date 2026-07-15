
-- INSERT REFERENCE DATA (Loan Types & Holidays)

INSERT INTO loan_types VALUES (1, 'Inkunga (Social)', 18.5, 500000, 6, 12);
INSERT INTO loan_types VALUES (2, 'Ubucuruzi (Business)', 22.0, 2000000, 12, 24);
INSERT INTO loan_types VALUES (3, 'Amakuru (Emergency)', 15.0, 300000, 3, 6);

INSERT INTO holidays VALUES (1, '01-JAN-2026', 'New Year');
INSERT INTO holidays VALUES (2, '01-FEB-2026', 'Heroes Day');
INSERT INTO holidays VALUES (3, '07-APR-2026', 'Genocide Memorial');
INSERT INTO holidays VALUES (4, '01-JUL-2026', 'Independence Day');
INSERT INTO holidays VALUES (5, '04-JUL-2026', 'Liberation Day');
INSERT INTO holidays VALUES (6, '15-AUG-2026', 'Assumption');
INSERT INTO holidays VALUES (7, '25-DEC-2026', 'Christmas');
INSERT INTO holidays VALUES (8, '26-DEC-2026', 'Boxing Day');
INSERT INTO holidays VALUES (9, '01-MAY-2026', 'Labour Day');
INSERT INTO holidays VALUES (10, '15-OCT-2026', 'Umuganura');

COMMIT;