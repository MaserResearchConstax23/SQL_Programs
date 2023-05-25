-- Small angular distance approximation
--(5.0/3600.0) > ( SQRT((POWER( ( ( (t1.ra * (PI()/180.0)) - (t2.ra * (PI()/180.0)) )*( COS( (t1.dec * (PI()/180.0)) )) ),2) )+(POWER(( (t1.dec * (PI()/180.0)) - (t2.dec * (PI()/180.0)) ),2))) ) * (180.0/PI())

-- Goal: make a new table with any duplacates by distance removed. It is
-- understood that the process may remove good data in the quest to purge the
-- bad data

-- I want to make a new table made from the top 1 result of each distance match.

SELECT  t1.source AS P_Name,
        t1.mcp_count AS entryID1,
        t1.ra AS P_ra, 
        t1.dec AS P_dec,
        t2.source AS S_Name,
        t2.mcp_count AS entryID2,
        t2.ra AS S_ra,
        t2.dec AS S_dec

FROM AllSurveyed2021_NoDup t1, AllSurveyed2021_NoDup t2

WHERE
-- the two objects are not the same literal entry
t1.source <> t2.source AND
-- ensure that each pair is returned only once
t1.mcp_count < t2.mcp_count AND
-- the distance between a pair is less than the threshold
(0.5/3600.0) > ( SQRT((POWER( ( ( (t1.ra * (PI()/180.0)) - (t2.ra * (PI()/180.0)) )*( COS( (t1.dec * (PI()/180.0)) )) ),2) )+(POWER(( (t1.dec * (PI()/180.0)) - (t2.dec * (PI()/180.0)) ),2))) ) * (180.0/PI())

------------------

-- To delete dupes from a table with dupe data,
DELETE FROM AllSurveyed2021_fewer_dupes

WHERE AllSurveyed2021_fewer_dupes.source IN (
    SELECT  t2.source

    FROM AllSurveyed2021_fewer_dupes t1, AllSurveyed2021_fewer_dupes t2

    WHERE
    -- the two objects are not the same literal entry
    t1.source <> t2.source AND
    -- ensure that each pair is returned only once
    t1.mcp_count < t2.mcp_count AND
    -- the distance between a pair is less than the threshold
    (0.5/3600.0) > ( SQRT((POWER( ( ( (t1.ra * (PI()/180.0)) - (t2.ra * (PI()/180.0)) )*( COS( (t1.dec * (PI()/180.0)) )) ),2) )+(POWER(( (t1.dec * (PI()/180.0)) - (t2.dec * (PI()/180.0)) ),2))) ) * (180.0/PI())
)