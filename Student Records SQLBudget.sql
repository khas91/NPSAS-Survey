IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp

SELECT
    1 as [File Spec]
	,[Institute ID]
	,[Case ID]
	,[SSN]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_Period 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Stu_Residence 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Tuition 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Room_Board 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Books_Supplies 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Transportation 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Computer_Tech 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Health_Ins 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [All_Other 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Budget_COA 2016-17]
INTO
	#temp
FROM
	[Adhoc].[dbo].[NPSASSurveyStudents] main

DECLARE @curYear INT = 2012
DECLARE @curYearString CHAR(4)
DECLARE @academicYear CHAR(7)
DECLARE @nextYearString CHAR(4)

WHILE @curYear <= 2017
BEGIN

	SET @academicYear = CAST(@curYear - 1 AS VARCHAR) + '-' + RIGHT(CAST(@curYear AS VARCHAR), 2)

	SET @curYearString = CAST(@curYear AS VARCHAR)

	SET @nextYearString = CAST(@curYear + 1 AS VARCHAR)

EXEC('
UPDATE t
	SET 
	t.[Enrolled ' + @academicYear + '] = CASE
										WHEN class' + @curYearString + '.STDNT_ID IS NOT NULL THEN ''1''
										ELSE ''0''
									END
	,t.[Budget_Period ' + @academicYear + ']  = CASE
		WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''F'' AND wstdnt.[WW_ST_RT2_TIM] = ''F''	AND wstdnt.[WW_ST_RT3_TIM] = ''F''	THEN ''1''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''F'' OR wstdnt.[WW_ST_RT2_TIM] = ''F''	OR wstdnt.[WW_ST_RT3_TIM] = ''F''		THEN ''2''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''T'' AND wstdnt.[WW_ST_RT2_TIM] = ''T''	AND wstdnt.[WW_ST_RT3_TIM] = ''T''	THEN ''3''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''T'' OR wstdnt.[WW_ST_RT2_TIM] = ''T''	OR wstdnt.[WW_ST_RT3_TIM] = ''T''		THEN ''4''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''H'' AND wstdnt.[WW_ST_RT2_TIM] = ''H''	AND wstdnt.[WW_ST_RT3_TIM] = ''T''	THEN ''5''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''H'' OR wstdnt.[WW_ST_RT2_TIM] = ''H''	OR wstdnt.[WW_ST_RT3_TIM] = ''T''		THEN ''6''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''L'' AND wstdnt.[WW_ST_RT2_TIM] = ''L''	AND wstdnt.[WW_ST_RT3_TIM] = ''L''	THEN ''7''
		WHEN wstdnt.[WW_ST_RT1_TIM] = ''L'' OR wstdnt.[WW_ST_RT2_TIM] = ''L''	OR wstdnt.[WW_ST_RT3_TIM] = ''L''		THEN ''8''
		ELSE ''9''
	END 
	,t.[Stu_Residence ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''-1'' END
	,t.[Tuition ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL(aidyr.[WF_AY_M2_C1] + [WF_AY_M2_C2],0) AS VARCHAR) END
	,t.[Room_Board ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL(aidyr.[WF_AY_M2_C3],0) AS VARCHAR) END
	,t.[Books_Supplies ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL(aidyr.[WF_AY_M2_C4],0) AS VARCHAR) END 
	,t.[Transportation ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL(aidyr.[WF_AY_M2_C5],0) AS VARCHAR) END 
	,t.[Computer_Tech ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,t.[Health_Ins ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,t.[All_Other ' + @academicYear + '] =  CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL([WF_AY_M2_C6],0) AS VARCHAR) END
	,t.[Budget_COA ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(ISNULL([WF_AY_M2_BUDGET],0) AS VARCHAR) END
FROM 

	#temp t
	INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON t.SSN = stdnt.STUDENT_ID
	LEFT JOIN (SELECT
					class.STDNT_ID
					,MAX(class.CRS_ID) AS CRS_ID
				FROM
					MIS.dbo.ST_STDNT_CLS_A_235 class
					INNER JOIN MIS.dbo.ST_ACDMC_HIST_A_154 hist ON hist.REF_NUM = class.REF_NUM
				WHERE
					LEFT(class.EFF_TRM, 4) = ''' + @curYearString + '''
					AND LEFT(hist.CLASS_KEY, 1) NOT IN (''B'', ''M'')
				GROUP BY
					class.STDNT_ID) class' + @curYearString + ' ON class' + @curYearString + '.STDNT_ID = t.SSN
	LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON t.SSN = WSTDNT.[WW_ST_SID] 
	LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] and aidyr.WF_AID_YEAR = ''' + @nextYearString + '''')


	SET @curYear = @curYear + 1
END

SELECT
	*
FROM
	#temp