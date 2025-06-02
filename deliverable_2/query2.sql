-- shows the average payment energy o chargingstation with id 55
SELECT 
    cs.Location,
    COUNT(cspot.ChargingSpotID) AS AvailableSpots
FROM 
    ChargingStation cs
INNER JOIN 
    ChargingSpot cspot ON cs.ChargingStationID = cspot.ChargingStationID
WHERE 
    cspot.Availability = 'Yes'  
    AND cspot.SpotType = 'Car' 
    AND (cs.Location = 'Ampelokipoi,Athens' OR cs.Location='Nea Smirni, Athens')
GROUP BY 
    cs.Location;