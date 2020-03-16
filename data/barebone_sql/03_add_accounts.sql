USE `tn03`;

-- loan product
SET @last_product_id = 1;
SET @last_ext_id = -1;
SELECT COALESCE(max(external_id), 1) INTO @last_ext_id FROM m_product_loan;


INSERT INTO `m_product_loan` VALUES
(@last_product_id, 'TZS', 2, 1, 1,
 NULL, NULL, NULL, NULL, concat('Interoperation Customer Product', @last_product_id),'Demo Interoperation Product', -- 6
 NULL, b'0', b'0', 1.000000, 1.000000,
 1.000000, 3, 1.000000, 0,
 1, 1, 1, 2, 1200,
 NULL,NULL, NULL, NULL, NULL,
 1, 1, 3, @last_ext_id + 1, 0,
 0,0,ADDDATE(curdate(),-100),ADDDATE(curdate(),100), 0, 0,
 NULL, NULL,NULL, 1, 30,
 0, 0, 0.00, 0, 1,
 0, 0, 0, null, b'0');

SET @product_id = -1;
SELECT id INTO @product_id FROM m_product_loan WHERE name = concat('Interoperation Customer Product', @last_product_id);

-- charge, mapping
INSERT INTO `m_charge` VALUES (
  NULL, concat('Loan Withdraw Fee_', @product_id), 'TZS', 1, 2,
        1, 0, 1.000000, NULL, NULL,
        NULL, 0, 1, 0, NULL,
  NULL, NULL, NULL, NULL);

INSERT INTO `m_product_loan_charge` VALUES
  (@product_id, (SELECT id
                 FROM m_charge
                 WHERE name = concat('Loan Withdraw Fee_', @product_id)));

-- gl_account, mappings
-- ASSET-1, LIABILITY-2, EQUITY-3, INCOME-4, EXPENSE-5
SET @liab_acc_name = concat('Loan Payable Liability_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @liab_acc_name, NULL, NULL, concat('0360009420', @product_id),
        0, 1, 1, 1, NULL, 'Loan Payable Liability');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @liab_acc_name),
  @product_id,
  NULL, NULL, NULL, 2);

SET @nostro_acc_name = concat('Loan NOSTRO_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @nostro_acc_name, NULL, NULL, concat('0360009421', @product_id),
        0, 1, 1, 1, NULL, 'Loan NOSTRO');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @nostro_acc_name),
  @product_id,
  NULL, NULL, NULL, 1);

SET @cash_acc_name = concat('Loan Product Cash_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @cash_acc_name, NULL, NULL, concat('0360009422', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Cash');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @cash_acc_name),
  @product_id,
  NULL, NULL, NULL, 1);

SET @expen_acc_name = concat('Loan Product Expenses_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @expen_acc_name, NULL, NULL, concat('0360009423', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Expenses');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @expen_acc_name),
  @product_id,
  NULL, NULL, NULL, 5);

SET @accrue_acc_name = concat('Loan Product Accrue Liability_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @accrue_acc_name, NULL, NULL, concat('0360009424', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Accrue Liability');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @accrue_acc_name),
  @product_id,
  NULL, NULL, NULL, 2);

SET @equ_acc_name = concat('Loan Product Equity_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @equ_acc_name, NULL, NULL, concat('0360009425', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Equity');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @equ_acc_name),
  @product_id,
  NULL, NULL, NULL, 3);

SET @feer_acc_name = concat('Loan Product Fees Revenue_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @feer_acc_name, NULL, NULL, concat('0360009426', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Fees Revenue');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @feer_acc_name),
  @product_id,
  NULL, NULL, NULL, 4);
  
SET @overd_acc_name = concat('Overdraft_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  11, @overd_acc_name, NULL, NULL, concat('0360009427', @product_id),
        0, 1, 1, 1, NULL, 'Overdraft');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @overd_acc_name),
  @product_id,
  NULL, 1, NULL, 11);
  
-- TENANT 4 ######################

USE `tn04`;

-- loan product
SET @last_product_id = 1;
SET @last_ext_id = -1;
SELECT COALESCE(max(external_id), 1) INTO @last_ext_id FROM m_product_loan;


INSERT INTO `m_product_loan` VALUES
(@last_product_id, 'TZS', 2, 1, 1, -- 5
 NULL, NULL, NULL, NULL, concat('Interoperation Customer Product', @last_product_id),'Demo Interoperation Product', -- 6
 NULL, b'0', b'0', 1.000000, 1.000000, -- 5
 1.000000, 3, 1.000000, 0, -- 4
 1, 1, 1, 2, 1200, -- number_of_repayments 5
 NULL,NULL, NULL, NULL, NULL, -- 5
 1, 1, 3, @last_ext_id + 1, 0, -- 5
 0,0,ADDDATE(curdate(),-100),ADDDATE(curdate(),100), 0, 0, -- dates 6
 NULL, NULL,NULL, 1, 30, -- 5
 0, 0, 0.00, 0, 1, -- 5
 0, 0, 0, null, b'0'); -- 5

SET @product_id = -1;
SELECT id INTO @product_id FROM m_product_loan WHERE name = concat('Interoperation Customer Product', @last_product_id);

-- charge, mapping
INSERT INTO `m_charge` VALUES (
  NULL, concat('Loan Withdraw Fee_', @product_id), 'TZS', 1, 2,
        1, 0, 1.000000, NULL, NULL,
        NULL, 0, 1, 0, NULL,
  NULL, NULL, NULL, NULL);

INSERT INTO `m_product_loan_charge` VALUES
  (@product_id, (SELECT id
                 FROM m_charge
                 WHERE name = concat('Loan Withdraw Fee_', @product_id)));

-- gl_account, mappings
-- ASSET-1, LIABILITY-2, EQUITY-3, INCOME-4, EXPENSE-5
SET @liab_acc_name = concat('Loan Payable Liability_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @liab_acc_name, NULL, NULL, concat('0360009420', @product_id),
        0, 1, 1, 1, NULL, 'Loan Payable Liability');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @liab_acc_name),
  @product_id,
  NULL, NULL, NULL, 2);

SET @nostro_acc_name = concat('Loan NOSTRO_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @nostro_acc_name, NULL, NULL, concat('0360009421', @product_id),
        0, 1, 1, 1, NULL, 'Loan NOSTRO');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @nostro_acc_name),
  @product_id,
  NULL, NULL, NULL, 1);

SET @cash_acc_name = concat('Loan Product Cash_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @cash_acc_name, NULL, NULL, concat('0360009422', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Cash');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @cash_acc_name),
  @product_id,
  NULL, NULL, NULL, 1);

SET @expen_acc_name = concat('Loan Product Expenses_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @expen_acc_name, NULL, NULL, concat('0360009423', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Expenses');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @expen_acc_name),
  @product_id,
  NULL, NULL, NULL, 5);

SET @accrue_acc_name = concat('Loan Product Accrue Liability_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @accrue_acc_name, NULL, NULL, concat('0360009424', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Accrue Liability');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @accrue_acc_name),
  @product_id,
  NULL, NULL, NULL, 2);

SET @equ_acc_name = concat('Loan Product Equity_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @equ_acc_name, NULL, NULL, concat('0360009425', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Equity');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @equ_acc_name),
  @product_id,
  NULL, NULL, NULL, 3);

SET @feer_acc_name = concat('Loan Product Fees Revenue_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  NULL, @feer_acc_name, NULL, NULL, concat('0360009426', @product_id),
        0, 1, 1, 1, NULL, 'Loan Product Fees Revenue');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @feer_acc_name),
  @product_id,
  NULL, NULL, NULL, 4);
  
SET @overd_acc_name = concat('Overdraft_', @product_id);
INSERT INTO `acc_gl_account` VALUES (
  11, @overd_acc_name, NULL, NULL, concat('0360009427', @product_id),
        0, 1, 1, 1, NULL, 'Overdraft');

INSERT INTO `acc_product_mapping` VALUES (
  NULL,
  (SELECT id
   FROM acc_gl_account
   WHERE name = @overd_acc_name),
  @product_id,
  NULL, 1, NULL, 11);