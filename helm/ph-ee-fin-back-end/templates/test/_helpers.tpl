{{/*
This template defines a reusable environment section.
It directly provides values.
*/}}

{{- define "inttest.env" -}}
  env:
    - name: SAVINGS_BASE-URL
      value: "https://fineract-server:8443"
    - name: AMS_BASE-URL
      value: "http://ph-ee-connector-ams-mifos:80"
    - name: LOAN_BASE-URL
      value: "https://fineract-server:8443"
    - name: "OPERATIONS-APP_CONTACTPOINT"
      value: "http://ph-ee-operations-app:80"
    - name: "BULK-PROCESSOR_CONTACTPOINT"
      value: "https://ph-ee-connector-bulk:8443"
    - name: "CHANNEL-CONNECTOR_CONTACTPOINT"
      value: "https://ph-ee-connector-channel:8443"
    - name:  "LOGGING_LEVEL_ROOT"
      value: "INFO"
    - name: "MAX_RETRY_COUNT"
      value: "5"
    - name: "RETRY_INTERVAL"
      value: "15000"
    - name: "DEFAULTS_TENANT"
      value: "gorilla"
    - name: "DEFAULTS_AUTHORIZATION"
      value: "Basic bWlmb3M6cGFzc3dvcmQ="
    - name: "CHANNEL_BASE-URL"
      value: "https://ph-ee-connector-channel:8443"
    - name: "CHANNEL_CONTACTPOINT"
      value: "https://ph-ee-connector-channel:8443"
    - name: "SAVINGS_CONTACTPOINT"
      value: "https://fineract-server:8443"
    - name: "LOAN_CONTACTPOINT"
      value: "https://fineract-server:8443"
    - name: "MOCK_SERVER_PORT"
      value: "53013"
    - name: "IDENTITY_ACCOUNT_MAPPER_CONTACTPOINT"
      value: "http://ph-ee-identity-account-mapper:80"
    - name: "MIFOS_CONNECTOR_CONTACTPOINT"
      value: "http://ph-ee-connector-ams-mifos:80"
    - name: "AMSMIFOS_MOCK_BASE_URL"
      value: "http://ph-ee-connector-ams-mifos:70"
    - name: "MOCK_PAYMENT_SCHEMA_CONTACTPOINT"
      value: "http://ph-ee-connector-mock-payment-schema:8080"
    - name: "MY_POD_IP"
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: "CALLBACK_URL"
      value: "http://$(MY_POD_IP):53013"
    - name: "PAYBILL_MPESA_CONNECTOR_CONTACTPOINT"
      value: ""
    - name: "VOUCHER_MANAGEMENT_CONTACTPOINT"
      value: "http://ph-ee-vouchers:80"
    - name: "BILLPAY_CONTACTPOINT"
      value: "http://ph-ee-connector-bill-pay:8080"
    - name: "awaitly_maxWaitTime"
      value: "30"
    - name: "GLOBAL_WAIT_TIME_MS"
      value: "5000"
{{- end }}
