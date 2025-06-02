-- shows the addresses of vehicle with license plate:'NKK741'

SELECT 
    st.Location,
    cs.StartDate
FROM 
    ChargingSession cs
INNER JOIN 
    ChargingStation st ON cs.ChargingStationID = st.ChargingStationID
INNER JOIN 
    Vehicle v ON cs.VehicleID = v.VehicleID
WHERE 
    v.LicensePlate = 'NKK741';