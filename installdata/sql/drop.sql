# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v5.2.2                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          ads.dez                                         #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database drop script                            #
# Created on:            2009-12-14 04:35                                #
# Model version:         Version 2009-12-14                              #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Drop foreign key constraints                                           #
# ---------------------------------------------------------------------- #

ALTER TABLE `AdCampaign` DROP FOREIGN KEY `AdAdvertiser_AdCampaign`;

ALTER TABLE `AdBanner` DROP FOREIGN KEY `AdCampaign_AdBanner`;

ALTER TABLE `AdBanner` DROP FOREIGN KEY `AdZone_AdBanner`;

ALTER TABLE `AdAdvertiserUser` DROP FOREIGN KEY `AdAdvertiser_AdAdvertiserUser`;

ALTER TABLE `AdAdvertiserUser` DROP FOREIGN KEY `User_AdAdvertiserUser`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `AdCampaign_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `User_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Category_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Manufacturer_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Product_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `UserGroup_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Language_AdCampaignCondition`;

ALTER TABLE `AdBannerStats` DROP FOREIGN KEY `AdBanner_AdBannerStats`;

# ---------------------------------------------------------------------- #
# Drop table "AdCampaign"                                                #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdCampaign` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdCampaign` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdCampaign`;

# ---------------------------------------------------------------------- #
# Drop table "AdBanner"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBanner` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdBanner` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdBanner`;

# ---------------------------------------------------------------------- #
# Drop table "AdAdvertiser"                                              #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdAdvertiser` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdAdvertiser` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdAdvertiser`;

# ---------------------------------------------------------------------- #
# Drop table "AdAdvertiserUser"                                          #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdAdvertiserUser` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdAdvertiserUser` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdAdvertiserUser`;

# ---------------------------------------------------------------------- #
# Drop table "AdZone"                                                    #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdZone` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdZone` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdZone`;

# ---------------------------------------------------------------------- #
# Drop table "AdCampaignCondition"                                       #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdCampaignCondition` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdCampaignCondition` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdCampaignCondition`;

# ---------------------------------------------------------------------- #
# Drop table "AdBannerStats"                                             #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBannerStats` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdBannerStats` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdBannerStats`;
