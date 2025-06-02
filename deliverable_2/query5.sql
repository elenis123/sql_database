-- shows the consuming energy of ChargeNet Enterprises
SELECT 
    cs.ChargingStationID,
    SUM(cs.Energy) AS TotalEnergyConsumed
FROM 
    ChargingSession cs
INNER JOIN 
    Power p ON cs.ChargingStationID = p.ChargingStationID
INNER JOIN 
    EnergyProvider ep ON p.EnergyProviderID = ep.EnergyProviderID
WHERE 
    ep.ProviderName = 'ChargeNet Enterprises'
GROUP BY 
    cs.ChargingStationID;

