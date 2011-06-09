# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v5.2.2                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          ads.dez                                         #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database creation script                        #
# Created on:            2009-12-14 04:35                                #
# Model version:         Version 2009-12-14                              #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #

# ---------------------------------------------------------------------- #
# Add table "AdCampaign"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdCampaign` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `advertiserID` INTEGER UNSIGNED,
    `isEnabled` BOOL NOT NULL,
    `condCount` INTEGER UNSIGNED NOT NULL,
    `isAllConditions` BOOL NOT NULL,
    `validFrom` DATETIME,
    `validTo` DATETIME,
    `name` VARCHAR(100),
    CONSTRAINT `PK_AdCampaign` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdBanner"                                                   #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdBanner` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `campaignID` INTEGER UNSIGNED,
    `zoneID` INTEGER UNSIGNED,
    `isEnabled` BOOL NOT NULL,
    `type` TINYINT UNSIGNED NOT NULL COMMENT '0 - image 1 - HTML 2 - Flash',
    `priority` INTEGER NOT NULL,
    `name` VARCHAR(100),
    `url` VARCHAR(255),
    `filename` VARCHAR(255),
    `html` TEXT,
    `width` INTEGER UNSIGNED,
    `height` INTEGER UNSIGNED,
    `target` VARCHAR(100),
    CONSTRAINT `PK_AdBanner` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdAdvertiser"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdAdvertiser` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100),
    CONSTRAINT `PK_AdAdvertiser` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdAdvertiserUser"                                           #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdAdvertiserUser` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `advertiserID` INTEGER UNSIGNED,
    `userID` INTEGER UNSIGNED,
    CONSTRAINT `PK_AdAdvertiserUser` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdZone"                                                     #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdZone` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `position` TINYINT UNSIGNED NOT NULL,
    `maxCount` INTEGER,
    `block` VARCHAR(100),
    `name` TEXT,
    CONSTRAINT `PK_AdZone` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdCampaignCondition"                                        #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdCampaignCondition` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `campaignID` INTEGER UNSIGNED,
    `categoryID` INTEGER UNSIGNED,
    `manufacturerID` INTEGER UNSIGNED,
    `productID` INTEGER UNSIGNED,
    `userID` INTEGER UNSIGNED,
    `userGroupID` INTEGER UNSIGNED,
    `languageID` CHAR(2),
    CONSTRAINT `PK_AdCampaignCondition` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Add table "AdBannerStats"                                              #
# ---------------------------------------------------------------------- #

CREATE TABLE `AdBannerStats` (
    `ID` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `bannerID` INTEGER UNSIGNED,
    `views` INTEGER UNSIGNED NOT NULL,
    `clicks` INTEGER UNSIGNED NOT NULL,
    `time` DATETIME,
    CONSTRAINT `PK_AdBannerStats` PRIMARY KEY (`ID`)
);

# ---------------------------------------------------------------------- #
# Foreign key constraints                                                #
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
