
/* 1 */
SELECT ID, TWLength FROM Tollway
WHERE  CYear < 1990;


/* 2 */
SELECT D.FullName, D.License From Driver D
WHERE (
SELECT COUNT( * )
FROM Vehicle
WHERE license = D.License
) >= 2;

/* 3 */
SELECT TollGate.TGLength, TollGate.ID FROM TollGate
WHERE TollGate.ID in 
(SELECT TOP 3 TGID
FROM ETCReading 
GROUP BY TGID
ORDER BY Count(TGID) DESC);

/* 4 */
 
SELECT License  FROM Vehicle WHERE Vehicle.ETag in
(SELECT ETag FROM ETCReading WHERE ETCReading.TGID in
(SELECT ID FROM TollGate WHERE TollGate.TWID = 1)
GROUP BY ETCReading.ETag
HAVING COUNT (ETCReading.ETag) > 2);

/* 5 */
SELECT 
	Vehicle.TollRate * 
	(SELECT Count( * ) FROM ETCReading 
	WHERE Year(DTime) = 2018 and ETCReading.ETag = Vehicle.ETag and Vehicle.License = Driver.License
	) as spent,
Driver.FullName FROM Vehicle, Driver
WHERE Vehicle.License = Driver.License 
ORDER BY (spent) DESC;






/* 1 */
