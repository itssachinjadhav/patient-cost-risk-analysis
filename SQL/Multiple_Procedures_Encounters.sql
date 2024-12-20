 Objective:
--         Find patients who had multiple procedures across different encounters with the same ReasonCode. 


WITH Patient_Procedure_Count AS (
    SELECT 
        p.PATIENT,
        p.REASONCODE,
        COUNT(DISTINCT p.ENCOUNTER) AS DistinctEncounters,
        COUNT(p.CODE) AS TotalProcedures,
        COUNT(DISTINCT p.CODE) AS DistinctProcedures
    FROM 
        Proceduree p
    WHERE 
        p.REASONCODE IS NOT NULL -- Only include rows where ReasonCode is available
    GROUP BY 
        p.PATIENT, p.REASONCODE
),
Filtered_Patients AS (
    SELECT 
        PATIENT,
        REASONCODE,
        DistinctEncounters,
        TotalProcedures,
        DistinctProcedures
    FROM 
        Patient_Procedure_Count
    WHERE 
        DistinctEncounters > 1 -- Ensure multiple encounters
)
SELECT 
    fp.PATIENT,
    fp.REASONCODE,
    fp.DistinctEncounters,
    fp.TotalProcedures,
    fp.DistinctProcedures,
    pt.FIRST,
    pt.LAST,
    pt.GENDER,
    pt.BIRTHDATE
FROM 
    Filtered_Patients fp
JOIN 
    PATIENTS pt ON fp.PATIENT = pt.Id
ORDER BY 
    fp.DistinctEncounters DESC, fp.TotalProcedures DESC;
