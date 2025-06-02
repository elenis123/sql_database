-- shows the average duration  and rent of scooters' sessions
SELECT 
    AVG(cs.Energy) AS AvgEnergy,
    AVG(pe.PaymentEnergy) AS AvgPaymentEnergy
FROM 
    ChargingSession cs
INNER JOIN 
    Vehicle v ON cs.VehicleID = v.VehicleID
INNER JOIN 
    PaymentEnergy pe ON cs.ChargingSessionID = pe.ChargingSessionID
WHERE 
    v.VehicleType = 'car'
    AND cs.ChargingStationID = 55;