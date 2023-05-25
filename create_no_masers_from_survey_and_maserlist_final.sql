SELECT *

FROM AllSurveyed2021_NoDup survey

WHERE 

survey.ra IN (
    SELECT  survey.ra,
            survey.dec, 
            known_masers.RA_(J2000),
            known_masers.Dec_(J2000)
    FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
    WHERE
        survey.ra IN (
            SELECT survey.ra
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE known_masers.RA_(J2000) BETWEEN survey.ra - 5/3600 and survey.ra + 5/3600
        ) AND
        survey.dec IN (
            SELECT survey.dec
            FROM AllSurveyed2021_NoDup survey, MCPMaser2020 known_masers
            WHERE known_masers.Dec_(J2000) BETWEEN survey.dec - 5/3600 and survey.dec + 5/3600
        ) AND
        (5/3600) > ( SQRT((POWER( ( ( (survey.ra * (PI()/180)) - (known_masers.RA_(J2000) * (PI()/180)) )*( COS( (survey.dec * (PI()/180)) )) ),2) )+(POWER(( (survey.dec * (PI()/180)) - (known_masers.Dec_(J2000) * (PI()/180)) ),2))) ) * (180/PI())

)

INTO MyDB.GBT_no_maser_no_duplicates