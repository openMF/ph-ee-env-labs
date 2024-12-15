Helm Upgrade command ---->
helm upgrade -f helm/govstack-chart/values.yaml g2p-sandbox helm/govstack-chart --install --create-namespace --namespace paymenthub

Known Issue 
Migration script race condition Operation app startup issue work around
1. port forward ops-mysql -3307
2. connect the mysql with root passwrod 
3. delete tenants 
4. Run the SQL scripts which didn’t run successfully

CREATE DATABASE `tenants`;
GRANT ALL PRIVILEGES ON `tenants`.* TO 'mifos';
CREATE DATABASE `rhino`;
CREATE DATABASE `gorilla`;
GRANT ALL PRIVILEGES ON `rhino`.* TO 'mifos';
GRANT ALL PRIVILEGES ON `gorilla`.* TO 'mifos';
GRANT ALL ON *.* TO 'root'@'%';

5. restart ops-app pod