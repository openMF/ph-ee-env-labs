-- create basic schemas
CREATE SCHEMA IF NOT EXISTS `fineract_tenants`;
CREATE SCHEMA IF NOT EXISTS `fineract_default`;

-- add tenant schemas
CREATE SCHEMA IF NOT EXISTS `tn03`;
CREATE SCHEMA IF NOT EXISTS `tn04`;

-- add tenant server connections
USE `fineract_tenants`;
SET @last_connection_id = -1;

SELECT COALESCE(max(id), 1)+1 INTO @last_connection_id FROM tenant_server_connections;
INSERT INTO `tenant_server_connections` (`id`, `schema_name`, `schema_server`, `schema_server_port`, `schema_username`, `schema_password`, `auto_update`) VALUES 
(@last_connection_id, 'tn03', 'fineractmysql-dev', '3306', 'root', 'skdcnwauicn2ucnaecasdsajdnizucawencascdca', 1);

SELECT COALESCE(max(id), 1)+1 INTO @last_connection_id FROM tenant_server_connections;
INSERT INTO `tenant_server_connections` (`id`, `schema_name`, `schema_server`, `schema_server_port`, `schema_username`, `schema_password`, `auto_update`) VALUES 
(@last_connection_id, 'tn04', 'fineractmysql-dev', '3306', 'root', 'skdcnwauicn2ucnaecasdsajdnizucawencascdca', 1);

-- add tenants
USE `fineract_tenants`;
SET @last_tenant_id = -1;
SET @last_connection_id = -1;
SELECT COALESCE(max(id), 1)+1 INTO @last_tenant_id FROM tenants;
SELECT id INTO @last_connection_id FROM tenant_server_connections where schema_name = 'tn03';
INSERT INTO `tenants` VALUES (@last_tenant_id,'tn03','Rhino','Africa/Bujumbura',NULL,NULL,NULL,NULL, @last_connection_id, @last_connection_id);

SELECT COALESCE(max(id), 1)+1 INTO @last_tenant_id FROM tenants;
SELECT id INTO @last_connection_id FROM tenant_server_connections where schema_name = 'tn04';
INSERT INTO `tenants` VALUES (@last_tenant_id,'tn04','Elephant','Africa/Bujumbura',NULL,NULL,NULL,NULL, @last_connection_id, @last_connection_id);