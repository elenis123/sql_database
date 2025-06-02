-- -------------------------------------------
-- Script for creating roles, users, and assigning permissions
-- -------------------------------------------
-- Drop existing roles (if any)
DROP ROLE IF EXISTS AdminRole;
DROP ROLE IF EXISTS EnergyProviderRole;
DROP ROLE IF EXISTS VehicleOwnerRole;

-- Drop existing users (if any)
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'energy_provider_user'@'localhost';
DROP USER IF EXISTS 'vehicle_owner_user'@'localhost';

-- Drop existing views (if any)
DROP VIEW IF EXISTS `ChargeTrack`.`EnergyProviderChargingStations`;
DROP VIEW IF EXISTS `ChargeTrack`.`VehicleOwnerChargingSessions`;
DROP VIEW IF EXISTS `ChargeTrack`.`VehicleOwnerPaymentRent`;
DROP VIEW IF EXISTS `ChargeTrack`.`VehicleOwnerDataSent`;

-- Create roles
CREATE ROLE AdminRole;
CREATE ROLE EnergyProviderRole;
CREATE ROLE VehicleOwnerRole;

-- Grant privileges to Admin Role (Full Access)
GRANT ALL PRIVILEGES ON `ChargeTrack`.* TO 'AdminRole';

-- Grant privileges to EnergyProvider Role
-- EnergyProvider can only update their own record in the EnergyProvider table and see Charging Stations related to them
GRANT SELECT ON `ChargeTrack`.`ChargingStation` TO 'EnergyProviderRole';
GRANT UPDATE ON `ChargeTrack`.`EnergyProvider` TO 'EnergyProviderRole';

-- Grant privileges to VehicleOwner Role
GRANT SELECT ON `ChargeTrack`.`ChargingSession` TO 'VehicleOwnerRole';
GRANT SELECT ON `ChargeTrack`.`ChargingSpot` TO 'VehicleOwnerRole';
GRANT SELECT ON `ChargeTrack`.`PaymentRent` TO 'VehicleOwnerRole';
GRANT SELECT ON `ChargeTrack`.`DataSent` TO 'VehicleOwnerRole';

-- Create users
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'energy_provider_user'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'vehicle_owner_user'@'localhost' IDENTIFIED BY 'password';

-- Assign roles to users
GRANT AdminRole TO 'admin_user'@'localhost';
GRANT EnergyProviderRole TO 'energy_provider_user'@'localhost';
GRANT VehicleOwnerRole TO 'vehicle_owner_user'@'localhost';

-- EnergyProvider can only see Charging Stations they are associated with
CREATE VIEW EnergyProviderChargingStations AS
SELECT st.*
FROM `ChargeTrack`.`ChargingStation` st
JOIN `ChargeTrack`.`Power` p ON st.ChargingStationID = p.ChargingStationID
JOIN `ChargeTrack`.`EnergyProvider` ep ON p.EnergyProviderID = ep.EnergyProviderID
WHERE ep.EnergyProviderID = (SELECT ep2.EnergyProviderID
                              FROM `ChargeTrack`.`EnergyProvider` ep2
                              WHERE ep2.EnergyProviderID = CURRENT_USER());

GRANT SELECT ON `ChargeTrack`.`EnergyProviderChargingStations` TO 'EnergyProviderRole';

-- -------------------------------------------
-- View for row-level security (RLS) for VehicleOwner
-- -------------------------------------------
-- VehicleOwner can only see their Charging Sessions
CREATE VIEW VehicleOwnerChargingSessions AS
SELECT cs.*
FROM `ChargeTrack`.`ChargingSession` cs
JOIN `ChargeTrack`.`Vehicle` v ON cs.VehicleID = v.VehicleID
JOIN `ChargeTrack`.`Posses` p ON v.VehicleID = p.VehicleID
JOIN `ChargeTrack`.`VehicleOwner` vo ON p.VehicleOwnerID = vo.VehicleOwnerID
WHERE vo.VehicleOwnerID = CURRENT_USER();

CREATE VIEW VehicleOwnerPaymentRent AS
SELECT pr.*
FROM `ChargeTrack`.`PaymentRent` pr
JOIN `ChargeTrack`.`ChargingSession` cs ON pr.ChargingSessionID = cs.ChargingSessionID
JOIN `ChargeTrack`.`Vehicle` v ON cs.VehicleID = v.VehicleID
JOIN `ChargeTrack`.`Posses` p ON v.VehicleID = p.VehicleID
JOIN `ChargeTrack`.`VehicleOwner` vo ON p.VehicleOwnerID = vo.VehicleOwnerID
WHERE vo.VehicleOwnerID = CURRENT_USER();

CREATE VIEW VehicleOwnerDataSent AS
SELECT ds.*
FROM `ChargeTrack`.`DataSent` ds
JOIN `ChargeTrack`.`ChargingSession` cs ON ds.ChargingSessionID = cs.ChargingSessionID
JOIN `ChargeTrack`.`Vehicle` v ON cs.VehicleID = v.VehicleID
JOIN `ChargeTrack`.`Posses` p ON v.VehicleID = p.VehicleID
JOIN `ChargeTrack`.`VehicleOwner` vo ON p.VehicleOwnerID = vo.VehicleOwnerID
WHERE vo.VehicleOwnerID = CURRENT_USER();

GRANT SELECT ON `ChargeTrack`.`VehicleOwnerChargingSessions` TO 'VehicleOwnerRole';
GRANT SELECT ON `ChargeTrack`.`VehicleOwnerPaymentRent` TO 'VehicleOwnerRole';
GRANT SELECT ON `ChargeTrack`.`VehicleOwnerDataSent` TO 'VehicleOwnerRole';


-- Flush privileges to apply the changes
FLUSH PRIVILEGES;