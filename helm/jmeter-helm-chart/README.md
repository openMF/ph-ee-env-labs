Here are the steps to deploy this jmeter helm chart.

1. Update the dependencies using:<br>
   ```helm dep up helm/jmeter-helm-chart```
2. Run helm upgrade command:<br>
    ```helm upgrade -f helm/jmeter-helm-chart/values.yaml jmeter helm/jmeter-helm-chart --install --create-namespace -n jmeter```

After successful helm upgrade. You get following services up and running:
1. 