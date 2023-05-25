-- to reproduce, run this comparision in the sql query
SELECT S.ra AS NODUP_RA, S.dec as NODUP_DEC, S.source as NODUP_NAME, M.[RA_(J2000)] AS MASER_RA, M.[Dec_(J2000)] AS MASER_DEC, M.Source_Name AS MASER_NAME
FROM    ConstantinResearchGroup.WilliamStJohn.AllSurveyed2021_NoDup S, 
        ConstantinResearchGroup.CameronKelahan.MCPMaser2020 M
WHERE
-- Small angular distance approximation
(5.0/3600.0) > ( SQRT((POWER( ( ( (S.ra * (PI()/180.0)) - (M.[RA_(J2000)] * (PI()/180.0)) )*( COS( (S.dec * (PI()/180.0)) )) ),2) )+(POWER(( (S.dec * (PI()/180.0)) - (M.[Dec_(J2000)] * (PI()/180.0)) ),2))) ) * (180.0/PI())

-- you will see obvious duplicates from inside NoDup
-- one obvious example is NGC17, in NoDup as NGC0017 and NGC17
