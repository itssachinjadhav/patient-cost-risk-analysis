Objective:
--         Analyze the top 3 most frequent diagnosis codes (ReasonCodes) and the associated patient demographic data to understand which groups 
--         are most affected by high-cost encounters.

SELECT 
    ec.REASONCODE,
	ec.REASONDESCRIPTION,
    p.GENDER,
    p.RACE,
    p.ETHNICITY,
    AVG(ec.TOTAL_CLAIM_COST - ec.PAYER_COVERAGE) AS AvgUncoveredCost,
    SUM(ec.TOTAL_CLAIM_COST - ec.PAYER_COVERAGE) AS TotalUncoveredCost,
    COUNT(*) AS TotalEncounters
FROM 
    ENCOUNTERS ec
JOIN 
    PATIENTS p ON ec.PATIENT = p.Id
WHERE 
    ec.REASONCODE IN (
        SELECT TOP 3 REASONCODE
        FROM ENCOUNTERS
        WHERE REASONCODE IS NOT NULL
        GROUP BY REASONCODE
        ORDER BY COUNT(*) DESC
    )
GROUP BY 
    ec.REASONCODE, p.GENDER, p.RACE, p.ETHNICITY, ec.REASONDESCRIPTION
ORDER BY 
    TotalUncoveredCost DESC;