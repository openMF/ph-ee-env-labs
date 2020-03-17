-- STEP 1 add interop data
USE `tn05`;

SET @last_saving_prod_id = -1;
SELECT COALESCE(max(id), 1) into @last_saving_prod_id from m_savings_product;

SET @saving_prod_name = concat('Saving Product', @last_saving_prod_id);

INSERT INTO `m_savings_product`
(`name`, `short_name`, `description`, `deposit_type_enum`, `currency_code`, `currency_digits`,
 `currency_multiplesof`, `nominal_annual_interest_rate`, `interest_compounding_period_enum`,
 `interest_posting_period_enum`, `interest_calculation_type_enum`, `interest_calculation_days_in_year_type_enum`,
 `min_required_opening_balance`, `accounting_type`, `withdrawal_fee_amount`, `withdrawal_fee_type_enum`,
 `withdrawal_fee_for_transfer`, `allow_overdraft`, `min_required_balance`, `enforce_min_required_balance`,
 `min_balance_for_interest_calculation`, `withhold_tax`, `tax_group_id`, `is_dormancy_tracking_active`)
VALUES (@saving_prod_name, concat('SP', @last_saving_prod_id), 'Saving Product', 100, 'TZS', 2, NULL, 0.000000, 1,
                           4, 1, 360, NULL, 2, NULL, NULL, 0, 0, 0.000000, 1, NULL, 0, NULL, 0);

SET @saving_prod_id = -1;
SELECT id INTO @saving_prod_id FROM m_savings_product WHERE name = @saving_prod_name;

SET @payment_type_id = -1;
SELECT id INTO @payment_type_id FROM m_payment_type WHERE value = 'Money Transfer';

SET @saving_gl_name = 'Interoperation Saving';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@saving_gl_name, NULL, NULL, 'Interop_Saving', 0, 1, 1, 1, 'Interoperation Saving Asset'); -- account_usage: DETAIL, classification_enum: ASSET

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES ((SELECT id FROM acc_gl_account WHERE name = @saving_gl_name), @saving_prod_id, 2, @payment_type_id, NULL, 1); -- product_type: SAVING, financial_account_type: ASSET

SET @nostro_gl_name = 'Interoperation NOSTRO';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@nostro_gl_name, NULL, NULL, 'Interop_Nostro', 0, 0, 1, 2, 'Interoperation NOSTRO Liability'); -- account_usage: DETAIL, classification_enum: LIABILITY

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES ((SELECT id FROM acc_gl_account WHERE name = @nostro_gl_name), @saving_prod_id, 2, NULL, NULL, 2); -- product_type: SAVING, financial_account_type: LIABILITY

SET @fee_gl_name = 'Interoperation Fee';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@fee_gl_name, NULL, NULL, 'Interop_Fee', 0, 0, 1, 4, 'Interoperation Fee Income'); -- account_usage: DETAIL, classification_enum: INCOME

SET @fee_gl_id = -1;
SELECT id INTO @fee_gl_id FROM acc_gl_account WHERE name = @fee_gl_name;

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES (@fee_gl_id, @saving_prod_id, 2, NULL, NULL, 4); -- product_type: SAVING, financial_account_type: INCOME

SET @charge_name = 'Interoperation Withdraw Fee';
INSERT INTO `m_charge`
(`name`,`currency_code`,`charge_applies_to_enum`,`charge_time_enum`,`charge_calculation_enum`,`charge_payment_mode_enum`,
 `amount`,`fee_on_day`,`fee_interval`,`fee_on_month`,`is_penalty`,`is_active`,`is_deleted`,`min_cap`,`max_cap`,`fee_frequency`,
 `income_or_liability_account_id`,`tax_group_id`)
VALUES (@charge_name, 'TZS', 2, 5, 1, NULL, 1.000000, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, @fee_gl_id, NULL);

-- STEP 2 add tn05

SET @client_name = 'InteropCustomer';
SET @saving_account_no = '9062b90de19b43989005';
SET @saving_account_ext_id = '9062b90de19b43989005d9';
SET @IBAN = 'IC11in03tn05' + @saving_account_ext_id;
SET @MSISDN = '27710305999';

INSERT INTO `m_client` (`account_no`, `external_id`, `status_enum`, `sub_status`, `activation_date`, `office_joining_date`,
                        `office_id`, `transfer_to_office_id`, `staff_id`, `firstname`, `middlename`, `lastname`, `fullname`,
                        `display_name`, `mobile_no`, `gender_cv_id`, `date_of_birth`, `image_id`, `closure_reason_cv_id`,
                        `closedon_date`, `updated_by`, `updated_on`, `submittedon_date`, `submittedon_userid`, `activatedon_userid`,
                        `closedon_userid`, `default_savings_product`, `default_savings_account`, `client_type_cv_id`, `client_classification_cv_id`,
                        `reject_reason_cv_id`, `rejectedon_date`, `rejectedon_userid`, `withdraw_reason_cv_id`, `withdrawn_on_date`,
                        `withdraw_on_userid`, `reactivated_on_date`, `reactivated_on_userid`, `legal_form_enum`, `reopened_on_date`,
                        `reopened_by_userid`)
VALUES (@saving_account_no, NULL, 300, NULL, ADDDATE(curdate(), -100), NULL, 1, NULL, NULL, NULL, NULL, NULL,
 @client_name, @client_name, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ADDDATE(curdate(), -100),
  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL);

SET @last_saving_prod_id = -1;
SELECT COALESCE(max(id), 1) into @last_saving_prod_id from m_savings_product;

SET @saving_prod_name = concat('Saving Product', @last_saving_prod_id);
SET @saving_prod_id = -1;
SELECT id INTO @saving_prod_id FROM m_savings_product WHERE name = @saving_prod_name;

SET @client_id = -1;
SELECT id INTO @client_id FROM m_client WHERE fullname = @client_name;

INSERT INTO `m_savings_account`
(`account_no`, `external_id`, `client_id`, `group_id`, `product_id`, `field_officer_id`, `status_enum`,
 `sub_status_enum`, `account_type_enum`, `deposit_type_enum`, `submittedon_date`, `submittedon_userid`,
 `approvedon_date`, `approvedon_userid`, `activatedon_date`, `activatedon_userid`,
 `currency_code`, `currency_digits`, `currency_multiplesof`, `nominal_annual_interest_rate`,
 `interest_compounding_period_enum`, `interest_posting_period_enum`, `interest_calculation_type_enum`,
 `interest_calculation_days_in_year_type_enum`, `min_required_opening_balance`, `withdrawal_fee_for_transfer`,
 `allow_overdraft`, `account_balance_derived`, `min_required_balance`, `enforce_min_required_balance`,
 `version`, `withhold_tax`)
VALUES (@saving_account_no, @saving_account_ext_id, @client_id, NULL, @saving_prod_id, NULL, 300, 0, 1, 100, ADDDATE(curdate(), -100),
  NULL, ADDDATE(curdate(), -100), NULL, ADDDATE(curdate(), -100), NULL, 'TZS', 2, NULL, 1.000000, 1, 4, 1, -- 29. - 4
  360, NULL, 1, 1, 100000000.000000, 0.000000, 1, 1, 0);

SET @saving_acc_id = -1;
SELECT id INTO @saving_acc_id FROM m_savings_account WHERE account_no = @saving_account_no;

INSERT INTO interop_identifier (id, account_id, type, a_value, sub_value_or_type, created_by, created_on, modified_by, modified_on)
VALUES (NULL, @saving_acc_id, 'IBAN', @IBAN, NULL, 'operator', CURDATE(), 'operator',
        CURDATE());
INSERT INTO interop_identifier (id, account_id, type, a_value, sub_value_or_type, created_by, created_on, modified_by, modified_on)
VALUES (NULL, @saving_acc_id, 'MSISDN', @MSISDN, NULL, 'operator', CURDATE(), 'operator', CURDATE());

SET @charge_name = 'Interoperation Withdraw Fee';

INSERT INTO `m_savings_account_charge` (`savings_account_id`, `charge_id`, `is_penalty`, `charge_time_enum`, `charge_calculation_enum`,
                                        `amount`, `amount_outstanding_derived`,`is_paid_derived`, `waived`, `is_active`)
VALUES (@saving_acc_id, (SELECT id FROM m_charge WHERE name = @charge_name), 0, 5, 1, 1.000000, 0.000000, 0, 0, 1);

-- STEP 3 add interop data
USE `tn06`;

SET @last_saving_prod_id = -1;
SELECT COALESCE(max(id), 1) into @last_saving_prod_id from m_savings_product;

SET @saving_prod_name = concat('Saving Product', @last_saving_prod_id);

INSERT INTO `m_savings_product`
(`name`, `short_name`, `description`, `deposit_type_enum`, `currency_code`, `currency_digits`,
 `currency_multiplesof`, `nominal_annual_interest_rate`, `interest_compounding_period_enum`,
 `interest_posting_period_enum`, `interest_calculation_type_enum`, `interest_calculation_days_in_year_type_enum`,
 `min_required_opening_balance`, `accounting_type`, `withdrawal_fee_amount`, `withdrawal_fee_type_enum`,
 `withdrawal_fee_for_transfer`, `allow_overdraft`, `min_required_balance`, `enforce_min_required_balance`,
 `min_balance_for_interest_calculation`, `withhold_tax`, `tax_group_id`, `is_dormancy_tracking_active`)
VALUES (@saving_prod_name, concat('SP', @last_saving_prod_id), 'Saving Product', 100, 'TZS', 2, NULL, 0.000000, 1,
                           4, 1, 360, NULL, 2, NULL, NULL, 0, 0, 0.000000, 1, NULL, 0, NULL, 0);

SET @saving_prod_id = -1;
SELECT id INTO @saving_prod_id FROM m_savings_product WHERE name = @saving_prod_name;

SET @payment_type_id = -1;
SELECT id INTO @payment_type_id FROM m_payment_type WHERE value = 'Money Transfer';

SET @saving_gl_name = 'Interoperation Saving';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@saving_gl_name, NULL, NULL, 'Interop_Saving', 0, 1, 1, 1, 'Interoperation Saving Asset'); -- account_usage: DETAIL, classification_enum: ASSET

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES ((SELECT id FROM acc_gl_account WHERE name = @saving_gl_name), @saving_prod_id, 2, @payment_type_id, NULL, 1); -- product_type: SAVING, financial_account_type: ASSET

SET @nostro_gl_name = 'Interoperation NOSTRO';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@nostro_gl_name, NULL, NULL, 'Interop_Nostro', 0, 0, 1, 2, 'Interoperation NOSTRO Liability'); -- account_usage: DETAIL, classification_enum: LIABILITY

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES ((SELECT id FROM acc_gl_account WHERE name = @nostro_gl_name), @saving_prod_id, 2, NULL, NULL, 2); -- product_type: SAVING, financial_account_type: LIABILITY

SET @fee_gl_name = 'Interoperation Fee';
INSERT INTO `acc_gl_account` (`name`, `parent_id`, `hierarchy`, `gl_code`, `disabled`, `manual_journal_entries_allowed`, `account_usage`, `classification_enum`, `description`)
VALUES (@fee_gl_name, NULL, NULL, 'Interop_Fee', 0, 0, 1, 4, 'Interoperation Fee Income'); -- account_usage: DETAIL, classification_enum: INCOME

SET @fee_gl_id = -1;
SELECT id INTO @fee_gl_id FROM acc_gl_account WHERE name = @fee_gl_name;

INSERT INTO `acc_product_mapping` (`gl_account_id`, `product_id`, `product_type`, `payment_type`, `charge_id`, `financial_account_type`)
VALUES (@fee_gl_id, @saving_prod_id, 2, NULL, NULL, 4); -- product_type: SAVING, financial_account_type: INCOME

SET @charge_name = 'Interoperation Withdraw Fee';
INSERT INTO `m_charge`
(`name`,`currency_code`,`charge_applies_to_enum`,`charge_time_enum`,`charge_calculation_enum`,`charge_payment_mode_enum`,
 `amount`,`fee_on_day`,`fee_interval`,`fee_on_month`,`is_penalty`,`is_active`,`is_deleted`,`min_cap`,`max_cap`,`fee_frequency`,
 `income_or_liability_account_id`,`tax_group_id`)
VALUES (@charge_name, 'TZS', 2, 5, 1, NULL, 1.000000, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, @fee_gl_id, NULL);

-- STEP 3 add tn06

SET @client_name = 'InteropMerchant';
SET @saving_account_no = 'a6b6c10b2aaa4778ac2f';
SET @saving_account_ext_id = 'a6b6c10b2aaa4778ac2fc9';
SET @IBAN = 'IC11in03tn06' + @saving_account_ext_id;
SET @MSISDN = '27710306999';

INSERT INTO `m_client` (`account_no`, `external_id`, `status_enum`, `sub_status`, `activation_date`, `office_joining_date`,
                        `office_id`, `transfer_to_office_id`, `staff_id`, `firstname`, `middlename`, `lastname`, `fullname`,
                        `display_name`, `mobile_no`, `gender_cv_id`, `date_of_birth`, `image_id`, `closure_reason_cv_id`,
                        `closedon_date`, `updated_by`, `updated_on`, `submittedon_date`, `submittedon_userid`, `activatedon_userid`,
                        `closedon_userid`, `default_savings_product`, `default_savings_account`, `client_type_cv_id`, `client_classification_cv_id`,
                        `reject_reason_cv_id`, `rejectedon_date`, `rejectedon_userid`, `withdraw_reason_cv_id`, `withdrawn_on_date`,
                        `withdraw_on_userid`, `reactivated_on_date`, `reactivated_on_userid`, `legal_form_enum`, `reopened_on_date`,
                        `reopened_by_userid`)
VALUES (@saving_account_no, NULL, 300, NULL, ADDDATE(curdate(), -100), NULL, 1, NULL, NULL, NULL, NULL, NULL,
 @client_name, @client_name, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ADDDATE(curdate(), -100),
  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL);

-- saving product, account
SET @last_saving_prod_id = -1;
SELECT COALESCE(max(id), 1) into @last_saving_prod_id from m_savings_product;

SET @saving_prod_name = concat('Saving Product', @last_saving_prod_id);
SET @saving_prod_id = -1;
SELECT id INTO @saving_prod_id FROM m_savings_product WHERE name = @saving_prod_name;

SET @client_id = -1;
SELECT id INTO @client_id FROM m_client WHERE fullname = @client_name;

INSERT INTO `m_savings_account`
(`account_no`, `external_id`, `client_id`, `group_id`, `product_id`, `field_officer_id`, `status_enum`,
 `sub_status_enum`, `account_type_enum`, `deposit_type_enum`, `submittedon_date`, `submittedon_userid`,
 `approvedon_date`, `approvedon_userid`, `activatedon_date`, `activatedon_userid`,
 `currency_code`, `currency_digits`, `currency_multiplesof`, `nominal_annual_interest_rate`,
 `interest_compounding_period_enum`, `interest_posting_period_enum`, `interest_calculation_type_enum`,
 `interest_calculation_days_in_year_type_enum`, `min_required_opening_balance`, `withdrawal_fee_for_transfer`,
 `allow_overdraft`, `account_balance_derived`, `min_required_balance`, `enforce_min_required_balance`,
 `version`, `withhold_tax`)
VALUES (@saving_account_no, @saving_account_ext_id, @client_id, NULL, @saving_prod_id, NULL, 300, 0, 1, 100, ADDDATE(curdate(), -100),
  NULL, ADDDATE(curdate(), -100), NULL, ADDDATE(curdate(), -100), NULL, 'TZS', 2, NULL, 1.000000, 1, 4, 1, -- 29. - 4
  360, NULL, 1, 1, 100000000.000000, 0.000000, 1, 1, 0);

-- interop_identifier
SET @saving_acc_id = -1;
SELECT id INTO @saving_acc_id FROM m_savings_account WHERE account_no = @saving_account_no;

INSERT INTO interop_identifier (id, account_id, type, a_value, sub_value_or_type, created_by, created_on, modified_by, modified_on)
VALUES (NULL, @saving_acc_id, 'IBAN', @IBAN, NULL, 'operator', CURDATE(), 'operator',
        CURDATE());
INSERT INTO interop_identifier (id, account_id, type, a_value, sub_value_or_type, created_by, created_on, modified_by, modified_on)
VALUES (NULL, @saving_acc_id, 'MSISDN', @MSISDN, NULL, 'operator', CURDATE(), 'operator', CURDATE());

SET @charge_name = 'Interoperation Withdraw Fee';

INSERT INTO `m_savings_account_charge` (`savings_account_id`, `charge_id`, `is_penalty`, `charge_time_enum`, `charge_calculation_enum`,
                                        `amount`, `amount_outstanding_derived`,`is_paid_derived`, `waived`, `is_active`)
VALUES (@saving_acc_id, (SELECT id FROM m_charge WHERE name = @charge_name), 0, 5, 1, 1.000000, 0.000000, 0, 0, 1);