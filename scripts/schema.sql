CREATE DATABASE  IF NOT EXISTS `stormdb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `stormdb`;

CREATE TABLE `directus_folders` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_folders_parent_foreign` (`parent`),
  CONSTRAINT `directus_folders_parent_foreign` FOREIGN KEY (`parent`) REFERENCES `directus_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_roles` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `icon` varchar(30) NOT NULL DEFAULT 'supervised_user_circle',
  `description` text,
  `ip_access` text,
  `enforce_tfa` tinyint(1) NOT NULL DEFAULT '0',
  `collection_list` json DEFAULT NULL,
  `admin_access` tinyint(1) NOT NULL DEFAULT '0',
  `app_access` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_users` (
  `id` char(36) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` text,
  `tags` json DEFAULT NULL,
  `avatar` char(36) DEFAULT NULL,
  `language` varchar(8) DEFAULT 'en-US',
  `theme` varchar(20) DEFAULT 'auto',
  `tfa_secret` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'active',
  `role` char(36) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `last_access` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_page` varchar(255) DEFAULT NULL,
  `provider` varchar(128) NOT NULL DEFAULT 'default',
  `external_identifier` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `directus_users_external_identifier_unique` (`external_identifier`),
  UNIQUE KEY `directus_users_email_unique` (`email`),
  KEY `directus_users_role_foreign` (`role`),
  CONSTRAINT `directus_users_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(45) NOT NULL,
  `user` char(36) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(50) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `collection` varchar(64) NOT NULL,
  `item` varchar(255) NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `directus_activity_collection_foreign` (`collection`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `directus_collections` (
  `collection` varchar(64) NOT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `note` text,
  `display_template` varchar(255) DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `singleton` tinyint(1) NOT NULL DEFAULT '0',
  `translations` json DEFAULT NULL,
  `archive_field` varchar(64) DEFAULT NULL,
  `archive_app_filter` tinyint(1) NOT NULL DEFAULT '1',
  `archive_value` varchar(255) DEFAULT NULL,
  `unarchive_value` varchar(255) DEFAULT NULL,
  `sort_field` varchar(64) DEFAULT NULL,
  `accountability` varchar(255) DEFAULT 'all',
  `color` varchar(255) DEFAULT NULL,
  `item_duplication_fields` json DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `group` varchar(64) DEFAULT NULL,
  `collapse` varchar(255) NOT NULL DEFAULT 'open',
  PRIMARY KEY (`collection`),
  KEY `directus_collections_group_foreign` (`group`),
  CONSTRAINT `directus_collections_group_foreign` FOREIGN KEY (`group`) REFERENCES `directus_collections` (`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `directus_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection` varchar(64) NOT NULL,
  `field` varchar(64) NOT NULL,
  `special` varchar(64) DEFAULT NULL,
  `interface` varchar(64) DEFAULT NULL,
  `options` json DEFAULT NULL,
  `display` varchar(64) DEFAULT NULL,
  `display_options` json DEFAULT NULL,
  `readonly` tinyint(1) NOT NULL DEFAULT '0',
  `hidden` tinyint(1) NOT NULL DEFAULT '0',
  `sort` int(10) unsigned DEFAULT NULL,
  `width` varchar(30) DEFAULT 'full',
  `translations` json DEFAULT NULL,
  `note` text,
  `conditions` json DEFAULT NULL,
  `required` tinyint(1) DEFAULT '0',
  `group` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_fields_collection_foreign` (`collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_files` (
  `id` char(36) NOT NULL,
  `storage` varchar(255) NOT NULL,
  `filename_disk` varchar(255) DEFAULT NULL,
  `filename_download` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `folder` char(36) DEFAULT NULL,
  `uploaded_by` char(36) DEFAULT NULL,
  `uploaded_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `charset` varchar(50) DEFAULT NULL,
  `filesize` bigint(20) DEFAULT NULL,
  `width` int(10) unsigned DEFAULT NULL,
  `height` int(10) unsigned DEFAULT NULL,
  `duration` int(10) unsigned DEFAULT NULL,
  `embed` varchar(200) DEFAULT NULL,
  `description` text,
  `location` text,
  `tags` text,
  `metadata` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_files_uploaded_by_foreign` (`uploaded_by`),
  KEY `directus_files_modified_by_foreign` (`modified_by`),
  KEY `directus_files_folder_foreign` (`folder`),
  CONSTRAINT `directus_files_folder_foreign` FOREIGN KEY (`folder`) REFERENCES `directus_folders` (`id`) ON DELETE SET NULL,
  CONSTRAINT `directus_files_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`),
  CONSTRAINT `directus_files_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `directus_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_migrations` (
  `version` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `directus_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role` char(36) DEFAULT NULL,
  `collection` varchar(64) NOT NULL,
  `action` varchar(10) NOT NULL,
  `permissions` json DEFAULT NULL,
  `validation` json DEFAULT NULL,
  `presets` json DEFAULT NULL,
  `fields` text,
  PRIMARY KEY (`id`),
  KEY `directus_permissions_collection_foreign` (`collection`),
  KEY `directus_permissions_role_foreign` (`role`),
  CONSTRAINT `directus_permissions_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_presets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bookmark` varchar(255) DEFAULT NULL,
  `user` char(36) DEFAULT NULL,
  `role` char(36) DEFAULT NULL,
  `collection` varchar(64) DEFAULT NULL,
  `search` varchar(100) DEFAULT NULL,
  `layout` varchar(100) DEFAULT 'tabular',
  `layout_query` json DEFAULT NULL,
  `layout_options` json DEFAULT NULL,
  `refresh_interval` int(11) DEFAULT NULL,
  `filter` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_presets_collection_foreign` (`collection`),
  KEY `directus_presets_user_foreign` (`user`),
  KEY `directus_presets_role_foreign` (`role`),
  CONSTRAINT `directus_presets_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `directus_presets_user_foreign` FOREIGN KEY (`user`) REFERENCES `directus_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `directus_relations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `many_collection` varchar(64) NOT NULL,
  `many_field` varchar(64) NOT NULL,
  `one_collection` varchar(64) DEFAULT NULL,
  `one_field` varchar(64) DEFAULT NULL,
  `one_collection_field` varchar(64) DEFAULT NULL,
  `one_allowed_collections` text,
  `junction_field` varchar(64) DEFAULT NULL,
  `sort_field` varchar(64) DEFAULT NULL,
  `one_deselect_action` varchar(255) NOT NULL DEFAULT 'nullify',
  PRIMARY KEY (`id`),
  KEY `directus_relations_many_collection_foreign` (`many_collection`),
  KEY `directus_relations_one_collection_foreign` (`one_collection`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_revisions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `activity` int(10) unsigned NOT NULL,
  `collection` varchar(64) NOT NULL,
  `item` varchar(255) NOT NULL,
  `data` json DEFAULT NULL,
  `delta` json DEFAULT NULL,
  `parent` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_revisions_collection_foreign` (`collection`),
  KEY `directus_revisions_parent_foreign` (`parent`),
  KEY `directus_revisions_activity_foreign` (`activity`),
  CONSTRAINT `directus_revisions_activity_foreign` FOREIGN KEY (`activity`) REFERENCES `directus_activity` (`id`) ON DELETE CASCADE,
  CONSTRAINT `directus_revisions_parent_foreign` FOREIGN KEY (`parent`) REFERENCES `directus_revisions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `directus_sessions` (
  `token` varchar(64) NOT NULL,
  `user` char(36) NOT NULL,
  `expires` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ip` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`token`),
  KEY `directus_sessions_user_foreign` (`user`),
  CONSTRAINT `directus_sessions_user_foreign` FOREIGN KEY (`user`) REFERENCES `directus_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_name` varchar(100) NOT NULL DEFAULT 'Directus',
  `project_url` varchar(255) DEFAULT NULL,
  `project_color` varchar(10) DEFAULT '#00C897',
  `project_logo` char(36) DEFAULT NULL,
  `public_foreground` char(36) DEFAULT NULL,
  `public_background` char(36) DEFAULT NULL,
  `public_note` text,
  `auth_login_attempts` int(10) unsigned DEFAULT '25',
  `auth_password_policy` varchar(100) DEFAULT NULL,
  `storage_asset_transform` varchar(7) DEFAULT 'all',
  `storage_asset_presets` json DEFAULT NULL,
  `custom_css` text,
  `storage_default_folder` char(36) DEFAULT NULL,
  `basemaps` json DEFAULT NULL,
  `mapbox_key` varchar(255) DEFAULT NULL,
  `module_bar` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_settings_project_logo_foreign` (`project_logo`),
  KEY `directus_settings_public_foreground_foreign` (`public_foreground`),
  KEY `directus_settings_public_background_foreign` (`public_background`),
  KEY `directus_settings_storage_default_folder_foreign` (`storage_default_folder`),
  CONSTRAINT `directus_settings_project_logo_foreign` FOREIGN KEY (`project_logo`) REFERENCES `directus_files` (`id`),
  CONSTRAINT `directus_settings_public_background_foreign` FOREIGN KEY (`public_background`) REFERENCES `directus_files` (`id`),
  CONSTRAINT `directus_settings_public_foreground_foreign` FOREIGN KEY (`public_foreground`) REFERENCES `directus_files` (`id`),
  CONSTRAINT `directus_settings_storage_default_folder_foreign` FOREIGN KEY (`storage_default_folder`) REFERENCES `directus_folders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `directus_webhooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `method` varchar(10) NOT NULL DEFAULT 'POST',
  `url` text NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'active',
  `data` tinyint(1) NOT NULL DEFAULT '1',
  `actions` varchar(100) NOT NULL,
  `collections` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_dashboards` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `icon` varchar(30) NOT NULL DEFAULT 'dashboard',
  `note` text,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_created` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_dashboards_user_created_foreign` (`user_created`),
  CONSTRAINT `directus_dashboards_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `directus_panels` (
  `id` char(36) NOT NULL,
  `dashboard` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `icon` varchar(30) DEFAULT 'insert_chart',
  `color` varchar(10) DEFAULT NULL,
  `show_header` tinyint(1) NOT NULL DEFAULT '0',
  `note` text,
  `type` varchar(255) NOT NULL,
  `position_x` int(11) NOT NULL,
  `position_y` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `options` json DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_created` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `directus_panels_dashboard_foreign` (`dashboard`),
  KEY `directus_panels_user_created_foreign` (`user_created`),
  CONSTRAINT `directus_panels_dashboard_foreign` FOREIGN KEY (`dashboard`) REFERENCES `directus_dashboards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `directus_panels_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `goal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_UNIQUE` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `purchase` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_UNIQUE` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `within` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_UNIQUE` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


CREATE TABLE `customer_source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_UNIQUE` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_UNIQUE` (`value`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `projects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_created` char(36) DEFAULT NULL,
  `user_updated` char(36) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `min_area` int(11) DEFAULT NULL,
  `min_budget` int(11) DEFAULT NULL,
  `within` int(11) DEFAULT NULL,
  `goal` int(11) DEFAULT NULL,
  `max_budget` bigint(20) DEFAULT NULL,
  `address_1` varchar(2048) DEFAULT NULL,
  `address_2` varchar(2048) DEFAULT NULL,
  `address_3` varchar(2048) DEFAULT NULL,
  `tax_income` int(11) DEFAULT NULL,
  `bank_seen` tinyint(4) DEFAULT NULL,
  `accession` tinyint(4) DEFAULT NULL,
  `comments` text,
  `status` int(11) NOT NULL DEFAULT '0',
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `projects_user_created_foreign` (`user_created`),
  KEY `projects_user_updated_foreign` (`user_updated`),
  CONSTRAINT `projects_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`),
  CONSTRAINT `projects_user_updated_foreign` FOREIGN KEY (`user_updated`) REFERENCES `directus_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(4) unsigned DEFAULT '0',
  `user_created` char(36) DEFAULT NULL,
  `user_updated` char(36) DEFAULT NULL,
  `user_incharge` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `customer_situation` int(11) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `place_of_birth` varchar(1024) DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `name_additional` varchar(255) DEFAULT NULL,
  `phone_additional` varchar(255) DEFAULT NULL,
  `email_additional` varchar(255) DEFAULT NULL,
  `customer_situation_additional` int(11) DEFAULT NULL,
  `date_of_birth_additional` date DEFAULT NULL,
  `place_of_birth_additional` varchar(1024) DEFAULT NULL,
  `nationality_additional` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `address_of_buyers` varchar(2048) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `last_updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_source` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customers_user_created_foreign` (`user_created`),
  KEY `customers_user_updated_foreign` (`user_updated`),
  KEY `customers_customers_source_foreign_idx` (`customer_source`),
  CONSTRAINT `customers_customers_source_foreign` FOREIGN KEY (`customer_source`) REFERENCES `customer_source` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `customers_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`),
  CONSTRAINT `customers_user_updated_foreign` FOREIGN KEY (`user_updated`) REFERENCES `directus_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE `customer_projects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_customer_id_idx` (`customer_id`),
  KEY `project_project_id_idx` (`project_id`),
  CONSTRAINT `customer_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `project_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;


CREATE TABLE `customer_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_created` char(36) NOT NULL,
  `action_type` int(11) NOT NULL,
  `comment` text,
  `customer_id` int(10) unsigned NOT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `actions_user_created_foreign` (`user_created`),
  KEY `actions_customer_id_foreign` (`customer_id`),
  KEY `actions_action_type_foreign` (`action_type`),
  CONSTRAINT `actions_action_type_foreign` FOREIGN KEY (`action_type`) REFERENCES `actions` (`value`),
  CONSTRAINT `actions_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `actions_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;


