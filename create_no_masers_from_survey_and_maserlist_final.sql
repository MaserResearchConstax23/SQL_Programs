SELECT *

FROM AllSurveyed2021_NoDup S

WHERE 

    S.ra NOT IN (
        SELECT S.ra
        FROM AllSurveyed2021_NoDup S, MCPMaser2020 M
        WHERE
        -- Small angular distance approximation
        (5.0/3600.0) > ( SQRT((POWER( ( ( (S.ra * (PI()/180.0)) - (M.[RA_(J2000)] * (PI()/180.0)) )*( COS( (S.dec * (PI()/180.0)) )) ),2) )+(POWER(( (S.dec * (PI()/180.0)) - (M.[Dec_(J2000)] * (PI()/180.0)) ),2))) ) * (180.0/PI())
    )


INTO MyDB.GBT_no_maser_no_duplicates