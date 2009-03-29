# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v5.2.2                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          ads.dez                                         #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database drop script                            #
# Created on:            2009-03-25 16:56                                #
# Model version:         Version 2009-03-25                              #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Drop foreign key constraints                                           #
# ---------------------------------------------------------------------- #

ALTER TABLE `AdCampaign` DROP FOREIGN KEY `AdAdvertiser_AdCampaign`;

ALTER TABLE `AdBanner` DROP FOREIGN KEY `AdCampaign_AdBanner`;

ALTER TABLE `AdBanner` DROP FOREIGN KEY `AdZone_AdBanner`;

ALTER TABLE `AdBannerAction` DROP FOREIGN KEY `AdBanner_AdBannerAction`;

ALTER TABLE `AdAdvertiserUser` DROP FOREIGN KEY `AdAdvertiser_AdAdvertiserUser`;

ALTER TABLE `AdAdvertiserUser` DROP FOREIGN KEY `User_AdAdvertiserUser`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `AdCampaign_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `User_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Category_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Manufacturer_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Product_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `UserGroup_AdCampaignCondition`;

ALTER TABLE `AdCampaignCondition` DROP FOREIGN KEY `Language_AdCampaignCondition`;

ALTER TABLE `AdBannerDailyStats` DROP FOREIGN KEY `AdBanner_AdBannerDailyStats`;

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
# Drop table "AdBannerAction"                                            #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `AdBannerAction` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdBannerAction`;

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
# Drop table "AdBannerDailyStats"                                        #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBannerDailyStats` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

# Drop constraints #

ALTER TABLE `AdBannerDailyStats` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdBannerDailyStats`;