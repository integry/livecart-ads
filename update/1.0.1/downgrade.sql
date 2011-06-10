# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v5.2.2                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          ads.dez                                         #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Alter database script                           #
# Created on:            2011-06-10 05:39                                #
# Model version:         Version 2009-09-01                              #
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
# Modify table "AdBanner"                                                #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdBanner` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdBanner` DROP COLUMN `priority`;

ALTER TABLE `AdBanner` DROP COLUMN `target`;

ALTER TABLE `AdBanner` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

# ---------------------------------------------------------------------- #
# Modify table "AdZone"                                                  #
# ---------------------------------------------------------------------- #

# Remove autoinc for PK drop #

ALTER TABLE `AdZone` MODIFY `ID` INTEGER UNSIGNED NOT NULL;

ALTER TABLE `AdZone` DROP COLUMN `maxCount`;

ALTER TABLE `AdZone` MODIFY `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT;

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
