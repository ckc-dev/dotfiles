-- Friendly reminder to replace the placeholder with a real password before using this.
CREATE USER 'nextcloud'@'nextcloud.mariadb_default' IDENTIFIED BY 'NEXTCLOUD_DB_PASSWORD';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'nextcloud.mariadb_default';
