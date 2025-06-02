-- show the available spots at ampelokipoi and nea smrni for cars
SELECT 
    AVG(TIMESTAMPDIFF(MINUTE, cs.StartDate, cs.EndDate)) AS AvgDuration,
    AVG(pr.PaymentRent) AS AvgPaymentRent
FROM 
    ChargingSession cs
INNER JOIN 
    Vehicle v ON cs.VehicleID = v.VehicleID
INNER JOIN 
    PaymentRent pr ON cs.StartDate = pr.StartDate AND cs.EndDate = pr.EndDate
WHERE 
    v.VehicleType = 'car';