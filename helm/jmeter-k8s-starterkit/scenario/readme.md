### Steps to run load test.

1. Run a Jmeter GUI. Here are the steps to Start Jmeter GUI: https://github.com/apache/jmeter.git
2. Open the scenario file you want to run in JMeter GUI. Here is the folder structure.
   ``` 
   jmeter-k8s-starterkit
   --- scenario
        --- batchTransaction
            --- batchTransaction.jmx
   ```
3. Set configuration for your load test:
![Voucher_load_test_setup.png](voucherRedeemAndPay%2FVoucher_load_test_setup.png)
4. Set Headers of an API.
![Voucher_header_setup.png](voucherRedeemAndPay%2FVoucher_header_setup.png)
5. Set API endpoints and Method.
![voucher_API_spec_setup.png](voucherRedeemAndPay%2Fvoucher_API_spec_setup.png)
6. Start Load Test.
![start_load_test.png](voucherRedeemAndPay%2Fstart_load_test.png)
7. See Results.
![load_test_result.png](voucherRedeemAndPay%2Fload_test_result.png)

> NOTE: To Create New load test just reuse the existing .jmx file and save it in different folder.

### Steps to run voucher Redeem and Pay API load test.

To run load test on voucher redeem and pay API we need to create and activate voucher. To serve this purpose we have created an integration test that can create and activate vouchers in bulk.

Here is the configuration:
https://github.com/openMF/ph-ee-integration-test/blob/master/src/main/resources/application.yaml#L269

Here is the integration test:
https://github.com/openMF/ph-ee-integration-test/blob/master/src/test/java/resources/voucherManagementTest.feature#L81

> NOTE: ```totalvouchers``` is the configuration for the vouchers you want to create. By default it will create and activate 30 vouchers.

Once you run the integration test it will create a file in ph-ee-connector-integration-test/vouchertest folder. The generated file contains all the ```voucherNumbers``` and ```serialNumbers``` that is created while running the integration test.

The file you got from integration test just use it in jmeter for load test like below.

![use_CSV_file.png](voucherRedeemAndPay%2Fuse_CSV_file.png)
