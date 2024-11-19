-- Friendly reminder to replace the placeholder with a real password before using this.
CREATE USER 'guacamole'@'guacamole.mariadb_default' IDENTIFIED BY 'GUACAMOLE_DB_PASSWORD';
GRANT ALL PRIVILEGES ON guacamole.* TO 'guacamole'@'guacamole.mariadb_default';
