Helm Upgrade command ---->
helm upgrade -f helm/g2p-sandbox/values.yaml g2pconnect helm/g2p-sandbox --install --create-namespace --namespace paymenthub

Known Issue 
Migration script race condition Operation app startup issue work around
1. Port forward operationsmysqlpodname -3307 (kubectl get operationsmysql pod name)
2. Connect to mysql with root passwrod (kubectl get secret operationsmysql, take root password and base64 decode it, mysql -uroot -P3307 -p)
3. Delete tenants (drop database tenants;)
4. Run the SQL scripts which didn’t run successfully

4a. CREATE DATABASE `tenants`;

4b. GRANT ALL PRIVILEGES ON `tenants`.* TO 'mifos';

4c. GRANT ALL PRIVILEGES ON `rhino`.* TO 'mifos';

4d. GRANT ALL PRIVILEGES ON `gorilla`.* TO 'mifos';

4e. GRANT ALL ON *.* TO 'root'@'%';

5. Restart ops-app pod
