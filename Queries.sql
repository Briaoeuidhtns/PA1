
/* 1 */
SELECT ID, TWLength FROM Tollway
WHERE CYear < 1990;


/* 2 */
SELECT D.FullName, D.License FROM Driver D
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
/* You have to use GROUP BY twice, once for inner query that groups and counts reading records for each vehicle and multiply the counts and the rates,
 and use the inner query in the from clause of the outer query and use GROUP BY again in the outer query for all vehicles owned by each driver, 
 and finally use SUM function to get the total for each driver. */


 SELECT D.FullName, SUM ( E.spent ) as spent
 FROM 
 (
	(SELECT Driver.FullName, Driver.License FROM Driver) AS D

	INNER JOIN
 
	(SELECT ETCReading.ID, Vehicle.License, Vehicle.TollRate * COUNT
		 (
			(SELECT ETCReading.ETAG FROM ETCReading WHERE ETCReading.ETAG = Vehicle.ETag) 
		 ) as spent
	FROM ETCReading, Vehicle
	) AS E
	ON D.License = E.License
 )


/* 1 */
/* Get the drivers name and their total ETCReadings in decending order */
SELECT Driver.FullName, 
COUNT( * ) AS Readings FROM Driver, ETCReading, Vehicle
WHERE Vehicle.ETag = ETCReading.ETag AND Vehicle.License = Driver.License
GROUP BY Driver.FullName
ORDER BY COUNT( * ) DESC;

/* 2 */
/* Get the drivers name and their total readings between the dates '2018/03/01 and 2018/03/10 using an INNER JOIN */
SELECT D.FullName, ETC.Readings FROM 
(
	SELECT Vehicle.License, COUNT (ETCReading.ID) as Readings FROM Vehicle, ETCReading
	WHERE ETCReading.DTime > '2018/03/01' AND ETCReading.DTime < '2018/03/10'
	AND Vehicle.ETag = ETCReading.ETag
	GROUP BY Vehicle.License
) as ETC
INNER JOIN
(
	SELECT Driver.FullName, Driver.License FROM Driver
) as D
ON D.License = ETC.License;


/* 3 */

/* 3 */
/* Get the gates that aren't*/
SELECT TollGate.ID
FROM TollGate
WHERE TollGate.ID in 
(SELECT TGID
FROM ETCReading
GROUP BY TGID
HAVING COUNT(TGID) < 3);