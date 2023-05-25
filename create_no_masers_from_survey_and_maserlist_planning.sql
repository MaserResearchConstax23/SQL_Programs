    -- Goal 1:
    --     Compare the two databases, and get a database of galaxies without masers.

    --     sql functions
    --     SQRT()
    --     COS(a) - cos of angle a in radians 
    --     POWER(a,b) a^b
    --     PI()
    --     use the small angle approximation of angular distance

    --     theta = SQRT((POWER( ( ( ra_a - ra_b )*( COS( dec_a )) ),2) )+(POWER(( dec_a - dec_b ),2)))

    --     where ra_a, ra_b, and dec_a, dec_b are in radians

    --     to convert from degrees to radians, multiply deg by (PI()/180)

    --     theta = ( SQRT((POWER( ( ( (ra_a * (PI()/180)) - (ra_b * (PI()/180)) )*( COS( (dec_a * (PI()/180)) )) ),2) )+(POWER(( (dec_a * (PI()/180)) - (dec_b * (PI()/180)) ),2))) ) * (180/PI())

    --     so now theta is in degrees.

    --     We want to use a search radius of x arcsec, so that is x/3600 degrees

    --     if theta < search radius, then the two objects are the same

    --     if there is an object in both tables, then we don't want it.

    --     English version 1
    --     for each database record in AllSurveyed2021_NoDup,
    --     if the dec distance is within 5/3600 degrees of 



SELECT *

FROM AllSurveyed2021_NoDup survey

WHERE 

survey.ra IN (
    SELECT  survey.ra AS ra_a,
            survey.dec AS dec_a, 
            known_masers.RA_(J2000) AS ra_b,
            known_masers.Dec_(J2000) AS dec_b
    FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
    WHERE
        ra_a IN (
            SELECT survey.ra
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE known_masers.RA_(J2000) BETWEEN survey.ra - 5/3600 and survey.ra + 5/3600
        ) AND
        dec_a IN (
            SELECT survey.dec
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE known_masers.Dec_(J2000) BETWEEN survey.dec - 5/3600 and survey.dec + 5/3600
        ) AND
        (5/3600) > ( SQRT((POWER( ( ( (ra_a * (PI()/180)) - (ra_b * (PI()/180)) )*( COS( (dec_a * (PI()/180)) )) ),2) )+(POWER(( (dec_a * (PI()/180)) - (dec_b * (PI()/180)) ),2))) ) * (180/PI())

)

INTO MyDB.GBT_no_maser_no_duplicates

-- survey.ra IN (
--     SELECT survey.ra
--     FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
--     WHERE known_masers.RA_(J2000) BETWEEN survey.ra - 5/3600 and survey.ra + 5/3600
-- ) AND
-- survey.dec IN (
--     SELECT survey.dec
--     FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
--     WHERE known_masers.Dec_(J2000) BETWEEN survey.dec - 5/3600 and survey.dec + 5/3600
-- )


SELECT *

FROM AllSurveyed2021_NoDup survey

WHERE 

survey.ra IN (
    SELECT  survey.ra
    FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
    WHERE
        survey.ra IN (
            SELECT survey.ra
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE 
            POWER(known_masers.[RA_(J2000)] -survey.ra,2) <= POWER(5/3600,2) AND
            POWER(known_masers.[Dec_(J2000)] - survey.dec,2) <= POWER(5/3600,2)
            -- known_masers.[RA_(J2000)] BETWEEN survey.ra - 5/3600 and survey.ra + 5/3600 AND
            -- known_masers.[Dec_(J2000)] BETWEEN survey.dec - 5/3600 and survey.dec + 5/3600 AND
            (5/3600) > ( SQRT((POWER( ( ( (survey.ra * (PI()/180)) - (known_masers.[RA_(J2000)] * (PI()/180)) )*( COS( (survey.dec * (PI()/180)) )) ),2) )+(POWER(( (survey.dec * (PI()/180)) - (known_masers.[Dec_(J2000)] * (PI()/180)) ),2))) ) * (180/PI())

        ) AND
        survey.dec IN (
            SELECT survey.dec
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE known_masers.[Dec_(J2000)] BETWEEN survey.dec - 5/3600 and survey.dec + 5/3600
        ) AND
        (5/3600) > ( SQRT((POWER( ( ( (survey.ra * (PI()/180)) - (known_masers.[RA_(J2000)] * (PI()/180)) )*( COS( (survey.dec * (PI()/180)) )) ),2) )+(POWER(( (survey.dec * (PI()/180)) - (known_masers.[Dec_(J2000)] * (PI()/180)) ),2))) ) * (180/PI())

)

INTO MyDB.GBT_no_maser_no_duplicates






SELECT s.source,s.ra,m.[RA_(J2000)] as Maser_ra
FROM AllSurveyed2021_NoDup s, MCPMaser2020 m
WHERE

POWER(m.[RA_(J2000)] - s.ra,2) <= POWER(200.0/3600.0,2) AND
POWER(m.[Dec_(J2000)] - s.dec,2) <= POWER(200.0/3600.0,2)
--known_masers.[RA_(J2000)] BETWEEN survey.ra - 1000/3600 and survey.ra + 1000/3600 AND
--known_masers.[Dec_(J2000)] BETWEEN survey.dec - 1000/3600 and survey.dec + 1000/3600