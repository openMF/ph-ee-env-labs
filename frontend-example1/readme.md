## Here are the Step to install paymenthub and fineract:

### Installation steps for frontend chart:

1. Create helm chart using command:

    ``` helm create frontend-example1 ```

2. Add frontend-2.0.0 as a dependency in chart.yaml
    ```
    apiVersion: v2
    name: frontend-example1
    description: A Helm chart for Kubernetes
    
    type: application
    version: 0.1.0
    appVersion: "1.16.0"
    
    dependencies:
    - name: front-end
      repository: "https://fynarfin.io/images/front-end-2.0.0/"
      version: 2.0.0

   ```
3. Steps to add custom configuration (optional):
   You can apply your own configuration using values.yaml. Here is the example of that.
    ```
   front-end:
     ph-ee-engine:
       connector_bulk:
         enabled: false
   ```
   > NOTE: This configuration will disable connector_bulk service.
   
4. Helm dependency upgrade:
    ```
   helm dep up frontend-example1
   ```
5. Helm upgrade for deployment:
    ```
   helm upgrade -f frontend-example1/values.yaml frontend frontend-example1 --install --create-namespace -n frontend
   ```


