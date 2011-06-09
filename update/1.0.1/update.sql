# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v5.2.2                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          ads.dez                                         #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Alter database script                           #
# Created on:            2011-06-10 00:03                                #
# Model version:         Version 2011-06-10                              #
# From model version:    Version 2009-03-22                              #
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
# Drop table "AdBannerAction"                                            #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `AdBannerAction` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `AdBannerAction`;

# ---------------------------------------------------------------------- #
# Modify table "AdCampaign"                                              #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdCampaign` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdCampaign` ADD COLUMN `validFrom` DATETIME;

ALTER TABLE `AdCampaign` ADD COLUMN `validTo` DATETIME;

ALTER TABLE `AdCampaign` MODIFY `validFrom` DATETIME AFTER `isAllConditions`;

ALTER TABLE `AdCampaign` MODIFY `validTo` DATETIME AFTER `validFrom`;

ALTER TABLE `AdCampaign` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

# ---------------------------------------------------------------------- #
# Modify table "AdBanner"                                                #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBanner` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdBanner` ADD COLUMN `priority` INTEGER NOT NULL;

ALTER TABLE `AdBanner` ADD COLUMN `url` VARCHAR(255);

ALTER TABLE `AdBanner` ADD COLUMN `filename` VARCHAR(255);

ALTER TABLE `AdBanner` ADD COLUMN `html` TEXT;

ALTER TABLE `AdBanner` ADD COLUMN `width` INTEGER UNSIGNED;

ALTER TABLE `AdBanner` ADD COLUMN `height` INTEGER UNSIGNED;

ALTER TABLE `AdBanner` ADD COLUMN `target` VARCHAR(100);

ALTER TABLE `AdBanner` MODIFY `priority` INTEGER NOT NULL AFTER `type`;

ALTER TABLE `AdBanner` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

# ---------------------------------------------------------------------- #
# Modify table "AdZone"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdZone` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdZone` ADD COLUMN `maxCount` INTEGER;

ALTER TABLE `AdZone` MODIFY `maxCount` INTEGER AFTER `position`;

ALTER TABLE `AdZone` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

# ---------------------------------------------------------------------- #
# Modify table "AdBannerDailyStats"                                      #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBannerDailyStats` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdBannerDailyStats` DROP PRIMARY KEY;

RENAME TABLE `AdBannerDailyStats` TO `AdBannerStats`;

ALTER TABLE `AdBannerStats` ADD COLUMN `time` DATETIME;

ALTER TABLE `AdBannerStats` ADD CONSTRAINT `PK_AdBannerStats` 
    PRIMARY KEY (`ID`);

ALTER TABLE `AdBannerStats` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

# ---------------------------------------------------------------------- #
# Add foreign key constraints                                            #
# ---------------------------------------------------------------------- #

ALTER TABLE `AdCampaign` ADD CONSTRAINT `AdAdvertiser_AdCampaign` 
    FOREIGN KEY (`advertiserID`) REFERENCES `AdAdvertiser` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdBanner` ADD CONSTRAINT `AdCampaign_AdBanner` 
    FOREIGN KEY (`campaignID`) REFERENCES `AdCampaign` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdBanner` ADD CONSTRAINT `AdZone_AdBanner` 
    FOREIGN KEY (`zoneID`) REFERENCES `AdZone` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `AdAdvertiserUser` ADD CONSTRAINT `AdAdvertiser_AdAdvertiserUser` 
    FOREIGN KEY (`advertiserID`) REFERENCES `AdAdvertiser` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdAdvertiserUser` ADD CONSTRAINT `User_AdAdvertiserUser` 
    FOREIGN KEY (`userID`) REFERENCES `User` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `AdCampaign_AdCampaignCondition` 
    FOREIGN KEY (`campaignID`) REFERENCES `AdCampaign` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `User_AdCampaignCondition` 
    FOREIGN KEY (`userID`) REFERENCES `User` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `Category_AdCampaignCondition` 
    FOREIGN KEY (`categoryID`) REFERENCES `Category` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `Manufacturer_AdCampaignCondition` 
    FOREIGN KEY (`manufacturerID`) REFERENCES `Manufacturer` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `Product_AdCampaignCondition` 
    FOREIGN KEY (`productID`) REFERENCES `Product` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `UserGroup_AdCampaignCondition` 
    FOREIGN KEY (`userGroupID`) REFERENCES `UserGroup` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdCampaignCondition` ADD CONSTRAINT `Language_AdCampaignCondition` 
    FOREIGN KEY (`languageID`) REFERENCES `Language` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `AdBannerStats` ADD CONSTRAINT `AdBanner_AdBannerStats` 
    FOREIGN KEY (`bannerID`) REFERENCES `AdBanner` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
