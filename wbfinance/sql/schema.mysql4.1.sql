--
-- Webfinance schema
-- 
-- Requires InnoDB.
-- Apply with mysql -u root --password=topsecret < schema.sql
-- 
-- Nicolas Bouthors <nbouthors@nbi.fr>
--
-- $Id$

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `webfinance_accounts`;
CREATE TABLE `webfinance_accounts` (
  `id` int(11) NOT NULL auto_increment,
  `account_name` varchar(128) NOT NULL,
  `id_bank` int(11) NOT NULL default '0',
  `id_user` int(11) default '0',
  `account` varchar(255) NOT NULL,
  `comment` text NOT NULL,
  `currency` varchar(64) NOT NULL default 'EUR',
  `country` varchar(128) NOT NULL,
  `type` varchar(64) default 'compte commercial',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `account_name` (`account_name`),
  KEY `id_bank` (`id_bank`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

DROP TABLE IF EXISTS `webfinance_banks`;
CREATE TABLE `webfinance_banks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `short_name` varchar(64) default NULL,
  `phone` varchar(64) default '00.00.00.00',
  `mail` varchar(64) default 'example@example.com',
  `comment` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `short_name` (`short_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;


DROP TABLE IF EXISTS `webfinance_categories`;
CREATE TABLE `webfinance_categories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `comment` text,
  `class` varchar(32) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

DROP TABLE IF EXISTS `webfinance_clients`;
CREATE TABLE `webfinance_clients` (
  `id_client` int(11) NOT NULL auto_increment,
  `nom` varchar(200) default NULL,
  `date_created` datetime default NULL,
  `tel` varchar(15) default NULL,
  `fax` varchar(200) default NULL,
  `addr1` varchar(255) default NULL,
  `cp` varchar(10) default NULL,
  `ville` varchar(100) default NULL,
  `addr2` varchar(255) default NULL,
  `addr3` varchar(255) default NULL,
  `pays` varchar(50) default 'France',
  `vat_number` varchar(40) default NULL,
  `has_unpaid` tinyint(1) default NULL,
  `state` enum('client','prospect','archive','fournisseur') default NULL,
  `ca_total_ht` decimal(20,4) default NULL,
  `ca_total_ht_year` decimal(20,4) default NULL,
  `has_devis` tinyint(4) NOT NULL default '0',
  `email` varchar(255) default NULL,
  `siren` varchar(50) default NULL,
  `total_du_ht` decimal(20,4) default NULL,
  `id_company_type` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id_client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

DROP TABLE IF EXISTS `webfinance_company_types`;
CREATE TABLE `webfinance_company_types` (
  `id_company_type` int(11) NOT NULL auto_increment,
  `nom` varchar(255) default NULL,
  PRIMARY KEY  (`id_company_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

DROP TABLE IF EXISTS `webfinance_dns`;
CREATE TABLE `webfinance_dns` (
  `id_dns` int(11) NOT NULL auto_increment,
  `id_domain` int(11) NOT NULL default '0',
  `name` varchar(50) default NULL,
  `record_type` enum('A','CNAME','MX','NS','AAAA','TXT') default 'CNAME',
  `value` varchar(50) default 'nbi.fr',
  `date_modified` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id_dns`),
  KEY `id_domain` (`id_domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_domain`;
CREATE TABLE `webfinance_domain` (
  `id_domain` int(11) NOT NULL auto_increment,
  `nom` varchar(255) default NULL,
  `date_modified` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `id_client` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id_domain`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_expense_details`;
CREATE TABLE `webfinance_expense_details` (
  `id` int(11) NOT NULL auto_increment,
  `id_expense` int(11) NOT NULL,
  `comment` text,
  `amount` decimal(14,2) NOT NULL default '0.00',
  `file` blob,
  `file_type` varchar(25) default NULL,
  `file_name` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `id_expense` (`id_expense`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_expenses`;
CREATE TABLE `webfinance_expenses` (
  `id` int(11) NOT NULL auto_increment,
  `date` date default NULL,
  `id_user` int(11) NOT NULL,
  `id_transaction` int(11) NOT NULL,
  `comment` text,
  `date_update` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `id_user` (`id_user`),
  KEY `id_transaction` (`id_transaction`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

DROP TABLE IF EXISTS `webfinance_invoice_rows`;
CREATE TABLE `webfinance_invoice_rows` (
  `id_facture_ligne` int(11) NOT NULL auto_increment,
  `id_facture` int(11) NOT NULL default '0',
  `description` blob,
  `qtt` decimal(5,2) default NULL,
  `ordre` int(10) unsigned default NULL,
  `prix_ht` decimal(20,5) default NULL,
  PRIMARY KEY  (`id_facture_ligne`),
  KEY `pfk_facture` (`id_facture`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

DROP TABLE IF EXISTS `webfinance_invoices`;
CREATE TABLE `webfinance_invoices` (
  `id_facture` int(11) NOT NULL auto_increment,
  `id_client` int(11) NOT NULL default '0',
  `date_created` datetime default NULL,
  `date_generated` datetime default NULL,
  `date_sent` datetime default NULL,
  `date_paiement` datetime default NULL,
  `is_paye` tinyint(4) default '0',
  `num_facture` varchar(10) default NULL,
  `type_paiement` varchar(255) default 'Ã€ rÃ©ception de cette facture',
  `ref_contrat` varchar(255) default NULL,
  `extra_top` blob,
  `facture_file` varchar(255) default NULL,
  `accompte` decimal(10,4) default '0.0000',
  `extra_bottom` blob,
  `date_facture` datetime default NULL,
  `type_doc` enum('facture','devis') default 'facture',
  `commentaire` blob,
  `id_type_presta` int(11) default '1',
  `id_compte` int(11) NOT NULL default '34',
  `is_envoye` tinyint(4) default '0',
  PRIMARY KEY  (`id_facture`),
  UNIQUE KEY `num_facture` (`num_facture`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

DROP TABLE IF EXISTS `webfinance_naf`;
CREATE TABLE `webfinance_naf` (
  `id_naf` int(11) NOT NULL auto_increment,
  `code` varchar(4) NOT NULL default '',
  `nom` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id_naf`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_personne`;
CREATE TABLE `webfinance_personne` (
  `id_personne` int(11) NOT NULL auto_increment,
  `nom` varchar(100) default NULL,
  `prenom` varchar(100) default NULL,
  `date_created` datetime default NULL,
  `entreprise` varchar(30) default NULL,
  `fonction` varchar(30) default NULL,
  `tel` varchar(15) default NULL,
  `tel_perso` varchar(15) default NULL,
  `mobile` varchar(15) default NULL,
  `fax` varchar(15) default NULL,
  `email` varchar(255) default NULL,
  `adresse1` varchar(255) default NULL,
  `ville` varchar(255) default NULL,
  `cp` varchar(10) default NULL,
  `digicode` varchar(10) default NULL,
  `station_metro` varchar(10) default NULL,
  `date_anniversaire` varchar(10) default NULL,
  `note` blob,
  `client` int(11) NOT NULL default '-1',
  PRIMARY KEY  (`id_personne`),
  KEY `pfk_client` (`client`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

DROP TABLE IF EXISTS `webfinance_pref`;
CREATE TABLE `webfinance_pref` (
  `id_pref` int(11) NOT NULL auto_increment,
  `owner` int(11) NOT NULL default '-1',
  `type_pref` varchar(100) default NULL,
  `value` blob,
  PRIMARY KEY  (`id_pref`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

DROP TABLE IF EXISTS `webfinance_publication_method`;
CREATE TABLE `webfinance_publication_method` (
  `id_publication_method` int(11) NOT NULL auto_increment,
  `nom` varchar(50) default NULL,
  `code` varchar(20) default NULL,
  `description` blob,
  PRIMARY KEY  (`id_publication_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


DROP TABLE IF EXISTS `webfinance_suivi`;
CREATE TABLE `webfinance_suivi` (
  `id_suivi` int(11) NOT NULL auto_increment,
  `type_suivi` tinyint(3) unsigned default NULL,
  `id_objet` int(11) NOT NULL default '0',
  `message` blob,
  `date_added` datetime default NULL,
  `date_modified` datetime default NULL,
  `added_by` int(11) default NULL,
  `rappel` datetime default NULL,
  `done` tinyint(3) unsigned default '0',
  `done_date` datetime default NULL,
  PRIMARY KEY  (`id_suivi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_transactions`;
CREATE TABLE `webfinance_transactions` (
  `id` int(11) NOT NULL auto_increment,
  `id_account` int(11) NOT NULL,
  `id_category` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `amount` decimal(14,2) NOT NULL default '0.00',
  `type` enum('real','prevision','asap') default NULL,
  `document` varchar(128) default '',
  `date` date NOT NULL,
  `date_update` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `comment` text,
  `file` mediumblob,
  `file_type` varchar(25) default NULL,
  `file_name` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  KEY `id_account` (`id_account`,`id_category`),
  KEY `id_category` (`id_category`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=52 ;

--
-- Dumping data for table `webfinance_transactions`
--

INSERT INTO `webfinance_transactions` (`id`, `id_account`, `id_category`, `text`, `amount`, `type`, `document`, `date`, `date_update`, `comment`, `file`, `file_type`, `file_name`) VALUES (2, 14, 4, 'REALISATION', 5000.00, 'real', '', '2005-01-16', '2006-04-03 14:35:22', '', '', '', ''),
(3, 14, 8, 'FRAIS DOSSIER DONT T', -125.64, 'real', '', '2005-03-16', '2006-04-03 14:24:02', '', NULL, NULL, NULL),
(4, 14, 5, 'RECUP. TIMBRES ACTE ', -6.00, 'real', '', '2005-03-16', '2006-04-03 14:24:02', '', NULL, NULL, NULL),
(6, 14, 0, 'VIRMENT', -221.26, 'real', '', '2005-03-17', '2006-04-03 14:28:41', '', '', '', ''),
(8, 14, 0, 'Achat', -1661.24, 'real', '', '2005-03-17', '2006-04-03 14:29:04', '', '', '', ''),
(10, 14, 5, 'VIR ASINFO F0189926 ', -2018.85, 'real', '', '2005-02-17', '2006-04-03 14:34:49', '', '', '', ''),
(12, 14, 0, 'VIR XXXXXXXXXX', 1000.00, 'real', '', '2005-03-18', '2006-04-03 14:21:20', 'Virement recu ', '', '', ''),
(13, 14, 9, 'VIR MR. AZERT', 10.00, 'real', '', '2005-03-29', '2006-04-03 14:32:13', '', '', '', ''),
(14, 14, 3, 'CHEQUE 0504041917806', -22.00, 'real', '', '2005-04-04', '2006-04-03 14:32:13', 'ras', NULL, NULL, NULL),
(15, 14, 8, 'VIR M OU MME OLIVIER', 10.00, 'real', '', '2005-04-04', '2006-04-03 14:32:13', '', NULL, NULL, NULL),
(16, 14, 8, 'CHEQUE 0038509500034', -64.80, 'real', '', '2005-04-05', '2006-04-03 14:32:13', '', NULL, NULL, NULL),
(20, 14, 0, 'CHEQUE 000', -449.50, 'prevision', '', '2006-04-07', '2006-04-03 14:29:59', 'Paiement &frac12;', '', '', ''),
(25, 14, 0, 'FAC 080405 CB:830290', -35.80, 'real', '', '2005-06-12', '2006-04-03 14:32:25', '?', '', '', ''),
(27, 14, 0, 'REM REMISE CB 539561', 69.07, 'real', '', '2005-04-16', '2006-03-28 15:14:13', '', NULL, NULL, NULL),
(28, 14, 5, 'REM REMISE CB 539561', 108.45, 'real', '', '2005-04-17', '2006-04-03 14:32:13', '', NULL, NULL, NULL),
(30, 14, 0, 'REM REMISE CB 539561', 138.37, 'real', '', '2005-04-18', '2006-03-28 15:14:13', '', NULL, NULL, NULL),
(32, 14, 0, 'VIR MR. AZERTY', 30.00, 'real', '', '2005-04-19', '2006-04-03 14:21:33', '', '', '', ''),
(33, 14, 8, 'REM REMISE CB 539561', 217.65, 'real', '', '2005-04-19', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(36, 14, 3, 'REM REMISE CB 539561', 157.46, 'real', '', '2005-04-20', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(37, 14, 7, 'REM REMISE CB 539561', 147.23, 'real', '', '2006-01-21', '2006-04-03 14:36:02', '', '', '', ''),
(38, 14, 5, 'REM REMISE CB 539561', 78.39, 'real', '', '2005-04-22', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(39, 14, 3, 'REM REMISE CB 539561', 336.55, 'real', '', '2005-08-23', '2006-04-03 14:26:11', '', '', '', ''),
(40, 14, 8, 'REM REMISE CB 539561', 49.08, 'real', '', '2005-04-24', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(41, 14, 5, 'REM REMISE CB 539561', 78.61, 'real', '', '2005-04-25', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(42, 14, 5, 'REM REMISE CB 539561', 138.21, 'real', '', '2005-04-26', '2006-04-03 14:23:28', '', NULL, NULL, NULL),
(44, 14, 9, 'REM REMISE CB 539', 88.39, 'real', '', '2005-12-27', '2006-04-03 14:31:35', '', '', '', ''),
(45, 14, 3, 'REM REMISE CB 53', 118.14, 'real', '', '2005-07-28', '2006-04-03 14:25:57', '', '', '', ''),
(46, 14, 7, 'CHEQUE 29', -159.00, 'real', '', '2005-04-29', '2006-04-03 14:23:28', '', '', '', ''),
(47, 14, 5, 'REM REMISE CB 5', 69.07, 'real', '', '2005-04-29', '2006-04-03 14:23:28', '', '', '', ''),
(48, 14, 5, 'REM REMISE CB EEEEE', 236.83, 'real', '', '2005-04-30', '2006-04-03 14:23:28', '', '', '', ''),
(49, 14, 3, 'REM REMISE CB ZZZZZZ', 29.31, 'real', '', '2005-05-01', '2006-04-03 14:23:28', '', '', '', ''),
(50, 14, 9, 'CHEQUE XXX', -19.00, 'real', '', '2005-05-02', '2006-04-03 14:23:28', '', '', '', ''),
(51, 14, 2, 'Test asap', 1000.00, 'asap', '', '2006-04-04', '2006-04-03 14:30:43', 'test asap', '', '', '');


DROP TABLE IF EXISTS `webfinance_type_presta`;
CREATE TABLE `webfinance_type_presta` (
  `id_type_presta` int(11) NOT NULL auto_increment,
  `nom` varchar(255) default NULL,
  PRIMARY KEY  (`id_type_presta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

INSERT INTO `webfinance_type_presta` (`id_type_presta`, `nom`) VALUES (1, 'Formation'),
(2, 'Web'),
(3, 'Dev'),
(4, 'Support');

DROP TABLE IF EXISTS `webfinance_type_suivi`;
CREATE TABLE `webfinance_type_suivi` (
  `id_type_suivi` int(11) NOT NULL auto_increment,
  `name` varchar(200) default NULL,
  `selectable` tinyint(4) default '1',
  PRIMARY KEY  (`id_type_suivi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

INSERT INTO `webfinance_type_suivi` (`id_type_suivi`, `name`, `selectable`) VALUES (1, 'CrÃ©ation entreprise', 0),
(2, 'Contact Téléphonique', 1),
(3, 'Courier envoyé', 1),
(4, 'Courier reçu', 1),
(5, 'Rendez-vous', 1),
(6, 'Presta', 1);

DROP TABLE IF EXISTS `webfinance_type_tva`;
CREATE TABLE `webfinance_type_tva` (
  `id_type_tva` int(11) NOT NULL auto_increment,
  `nom` varchar(255) default NULL,
  `taux` decimal(5,3) default NULL,
  PRIMARY KEY  (`id_type_tva`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

INSERT INTO `webfinance_type_tva` (`id_type_tva`, `nom`, `taux`) VALUES (1, 'Taux normal 19,6%', 19.600),
(2, 'Pas de tva facturée (export...)', 0.000);

DROP TABLE IF EXISTS `webfinance_userlog`;
CREATE TABLE `webfinance_userlog` (
  `id_userlog` int(11) NOT NULL auto_increment,
  `log` blob,
  `date` datetime default NULL,
  `id_user` int(11) default NULL,
  PRIMARY KEY  (`id_userlog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `webfinance_users`;
CREATE TABLE `webfinance_users` (
  `id_user` int(11) NOT NULL auto_increment,
  `last_name` varchar(100) default NULL,
  `first_name` varchar(100) default NULL,
  `login` varchar(10) default NULL,
  `password` varchar(100) default NULL,
  `email` varchar(255) default NULL,
  `disabled` tinyint(4) NOT NULL default '1',
  `last_login` datetime default NULL,
  `creation_date` datetime default NULL,
  `admin` tinyint(4) default '0',
  `role` varchar(30) default NULL,
  `modification_date` datetime default NULL,
  `prefs` blob,
  PRIMARY KEY  (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;


--
-- DEFAULT DATA INSERT 
--

INSERT INTO `webfinance_users` (`id_user`, `last_name`, `first_name`, `login`, `password`, `email`, `disabled`, `last_login`, `creation_date`, `admin`, `role`, `modification_date`, `prefs`) VALUES (1, NULL, NULL, 'admin', '21232f297a57a5a743894a0e4a801fc3', NULL, 0, '2006-04-06 16:34:51', NULL, 1, NULL, NULL, '');
INSERT INTO `webfinance_type_suivi` VALUES 
(NULL,'Création entreprise',0),
(NULL,'Contact Téléphonique',1),
(NULL,'Courier envoyé',1),
(NULL,'Courier reçu',1),
(NULL,'Rendez-vous',1),
(NULL,'Intervention sur site',1);

INSERT INTO `webfinance_type_tva` VALUES
(NULL,'Taux normal 19,6%', 19.6),
(NULL,'Pas de tva facturée (export...)', 0) ;

INSERT INTO `webfinance_company_types` (nom) VALUES
    ('Client'),('Prospect'),('Fournisseur'),('Archive');

INSERT INTO `webfinance_banks` (`id`, `name`, `short_name`, `phone`, `mail`, `comment`) VALUES 
(1, 'My bank', 'mybank', '', '', '');

INSERT INTO `webfinance_categories` (`id`, `name`, `class`) VALUES 
(NULL, 'Salaire', 'salaires'),
(NULL, 'Loyer', 'loyer'),
(NULL, 'Téléphone mobile', 'telecom'),
(NULL, 'FT', 'telecom'),
(NULL, 'Internet', 'telecom'),
(NULL, 'Matériel', 'fournitures'),
(NULL, 'Serveur', 'fourniteures'),
(NULL, 'Impots - IS', 'impots'),
(NULL, 'Impots - TVA', 'impots');

-- INSERT INTO `webfinance_clients` (`id_client`, `nom`, `date_created`, `tel`, `fax`, `addr1`, `cp`, `ville`, `addr2`, `addr3`, `pays`, `vat_number`, `has_unpaid`, `state`, `ca_total_ht`, `ca_total_ht_year`, `has_devis`, `email`, `siren`, `total_du_ht`, `id_company_type`) VALUES (1, 'Entreprise X', '2006-04-06 10:57:27', '313131', '', 'Antananarivo', '', '', '', '', 'France', '', 1, 'Madagascar', 42.0000, 42.0000, 0, '', '', 42.0000, 1);

INSERT INTO `webfinance_company_types` (`id_company_type`, `nom`) VALUES (1, 'Client'),
(2, 'Prospect'),
(3, 'Fournisseur'),
(4, 'Archive');

INSERT INTO `webfinance_pref` (`id_pref`, `owner`, `type_pref`, `value`) VALUES (6, -1, 'rib', 0x547a6f344f694a7a644752446247467a637949364f447037637a6f324f694a6959573578645755694f334d364d545936496b4a68626e46315a5342776233423162474670636d55694f334d364d544d36496d527662576c6a6157787059585270623234694f334d364d544136496b4e6f5a58705957466859574667694f334d364d544536496d4e765a475666596d46756358566c496a747a4f6a5536496a45794d544978496a747a4f6a45794f694a6a6232526c5832643161574e6f5a5851694f334d364d7a6f694e6a497a496a747a4f6a5936496d4e76625842305a534937637a6f324f69497a4d54497a4d5449694f334d364e446f695932786c5a694937637a6f794f6949324e794937637a6f304f694a70596d4675496a747a4f6a5536496b6c4351553467496a747a4f6a5536496e4e3361575a30496a747a4f6a5936496b466152564a555753493766513d3d),
(5, -1, 'societe', 0x547a6f344f694a7a644752446247467a637949364e7a7037637a6f784e446f69636d46706332397558334e7659326c68624755694f334d364f546f6954586c446232317759573535496a747a4f6a49794f694a30646d466661573530636d466a62323174645735686458526861584a6c496a747a4f6a413649694937637a6f314f694a7a61584a6c62694937637a6f314f69497a4d544d784d694937637a6f314f694a685a4752794d534937637a6f784d6a6f695157353059573568626d467961585a76496a747a4f6a5536496d466b5a484979496a747a4f6a413649694937637a6f314f694a685a4752794d794937637a6f774f6949694f334d364d544d36496d52686447566659334a6c59585270623234694f334d364d446f69496a7439);


--
-- Constraints for dumped tables
--
ALTER TABLE `webfinance_accounts`
  ADD CONSTRAINT `webfinance_accounts_ibfk_1` FOREIGN KEY (`id_bank`) REFERENCES `webfinance_banks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ALTER TABLE `webfinance_dns`
--   ADD CONSTRAINT `pfk_domain` FOREIGN KEY (`id_domain`) REFERENCES `webfinance_domain` (`id_domain`) ON DELETE CASCADE;
ALTER TABLE `webfinance_expense_details`
  ADD CONSTRAINT `webfinance_expense_details_ibfk_1` FOREIGN KEY (`id_expense`) REFERENCES `webfinance_expenses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `webfinance_personne`
  ADD CONSTRAINT `pfk_client` FOREIGN KEY (`client`) REFERENCES `webfinance_clients` (`id_client`);
ALTER TABLE `webfinance_transactions`
  ADD CONSTRAINT `webfinance_transactions_ibfk_1` FOREIGN KEY (`id_account`) REFERENCES `webfinance_accounts` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- vim: fileencoding=utf8
-- EOF
