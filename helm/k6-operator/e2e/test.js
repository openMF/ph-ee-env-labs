import http from 'k6/http';
import { sleep } from 'k6';
import {group ,check } from 'k6';
const processInstanceKeys = []
var messageSuccess = 0;
var messageFailure = 0;
var messagePending = 0;
export const options = {
  insecureSkipTLSVerify: true,
  vus: 1,
  duration: '30m',
  iterations: 5,
};
export default function () {
  if(processInstanceKeys.length < `${options.iterations}`){
    sendMessage();
  }
  if(processInstanceKeys.length >= `${options.iterations}`){
    group('second API request', function() {
      // make the second API request
      sleep(30)
      getStatus();
      console.log("messagePending = ",messagePending);
      console.log("messageSuccess = ",messageSuccess);
      console.log("messageFailure = ",messageFailure);
      check(`${options.iterations}`, {
        'Check for success rate of messages': (r) => r == messageSuccess
      });
    });
  }
}
export function sendMessage(){
  const url = 'https://channel.sandbox.fynarfin.io/channel/sendNotifications';
  const payload = JSON.stringify({
    "transactionId":"123455",
    "account":"1234",
    "originDate":1675404746398,
    "amount":"100",
    "phoneNumber":"+15005550012",
    "messageType":"Success",
    "parentWorkflowId":"12345667",
    "deliveryMessage":"HELLO WORLD",
});

  const params = {
    headers: {
      "Platform-TenantId": "default",
      "Fineract-Tenant-App-Key": "123456543234abdkdkdkd",
      "X-CorrelationID": "1234567868976798",
      "Content-Type": "application/json",
    },
  };
  var res = http.post(url, payload, params);
  processInstanceKeys.push(res.json().transactionId)
};


export function getStatus(){
  const params = {
    headers: {
      "Fineract-Platform-TenantId": "default",
      "Fineract-Tenant-App-Key": "123456543234abdkdkdkd",
      "X-CorrelationID": "1234567868976798",
      "Content-Type": "application/json",
    },
  };
  for(var index = 0; index < processInstanceKeys.length; index++){
    var url = 'https://messagegateway.sandbox.fynarfin.io/sms/details/'+processInstanceKeys[index];
    var res = http.get(url, params);
    if(res.json().deliveryStatus == 300){
      messageSuccess++;
    }
    if(res.json().deliveryStatus == 400){
      messageFailure++;
    }
    if(res.json().deliveryStatus == 200){
      messagePending++;
    }
  }
}