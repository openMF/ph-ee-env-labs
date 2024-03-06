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
