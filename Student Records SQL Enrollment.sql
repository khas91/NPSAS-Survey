IF OBJECT_ID('tempdb..#t1') IS NOT NULL
	DROP TABLE #t1
IF OBJECT_ID('tempdb..#t2') IS NOT NULL
	DROP TABLE #t2
IF OBJECT_ID('tempdb..#t3') IS NOT NULL
	DROP TABLE #t3
IF OBJECT_ID('tempdb..#degrank') IS NOT NULL
	DROP TABLE #degrank


SELECT DISTINCT
	gen.FIELD_VALUE AS AWD_TYPE
	,CAST(gen2.FIELD_VALUE AS INT) AS DEGRANK
INTO
	#degrank
FROM
	MIS.dbo.UTL_CODE_TABLE_120 code
	INNER JOIN MIS.dbo.UTL_CODE_TABLE_GENERIC_120 gen ON gen.ISN_UTL_CODE_TABLE = code.ISN_UTL_CODE_TABLE
	INNER JOIN MIS.dbo.ST_PROGRAMS_A_136 prog ON prog.AWD_TY = gen.FIELD_VALUE
	INNER JOIN MIS.dbo.UTL_CODE_TABLE_GENERIC_120 gen2 ON gen2.ISN_UTL_CODE_TABLE = code.ISN_UTL_CODE_TABLE
WHERE
	code.TABLE_NAME = 'AWARD-LVL'
	AND code.STATUS = 'A'
	AND gen.cnxarraycolumn = 0
	AND gen2.cnxarraycolumn = 7
	AND prog.EFF_TRM_D <> ''
	AND prog.END_TRM = ''

SELECT
	npsas.[Institute ID]
	,npsas.[Case ID]
	,npsas.SSN
	,ISNULL(SUBSTRING(MIN(hist.sessBegDt), 5, 2), 0) AS [MinDate_mm]
	,ISNULL(RIGHT(MIN(hist.sessBegDt), 2), 0) AS [MinDate_dd]
	,ISNULL(LEFT(MIN(hist.sessBegDt), 4), 0) AS [MinDate_yyyy]
	,ISNULL(SUBSTRING(MAX(hist.sessEndDt), 5, 2), 0) AS [MaxDate_mm]
	,ISNULL(RIGHT(MAX(hist.sessEndDt), 2), 0) AS [MaxDate_dd]
	,ISNULL(LEFT(MAX(hist.sessEndDt), 4), 0) AS [MaxDate_yyyy]
INTO
	#t1
FROM
	Adhoc.dbo.[NPSASSurveyStudents] npsas
	LEFT JOIN MIS.dbo.ST_ACDMC_HIST_A_154 hist ON hist.STUDENT_ID = npsas.SSN
											   AND hist.sessBegDt <> ''
GROUP BY
	npsas.[Institute ID]
	,npsas.[Case ID]
	,npsas.SSN

SELECT
	npsas.*
	,CASE
		WHEN obj.STDNT_ID IS NOT NULL THEN 1
		ELSE 0
	END AS [Expected To Graduate]
	,CASE
		WHEN cred.STDNT_ID IS NOT NULL THEN 1
		ELSE 0
	END AS [Transfer Credit]
	,-1 AS [Remedial Courses]
	,CASE
		WHEN ftic.[STUDENT-ID] IS NOT NULL THEN 1
		ELSE 0
	END AS [FTIC]
	,CASE
		WHEN baccext.STDNT_ID + intbacc.STDNT_ID IS NOT NULL THEN 1
		ELSE 0
	END AS [Received Bacc]
	,CASE 
		WHEN baccext.ACT_GRAD_DT IS NOT NULL THEN CAST(SUBSTRING(baccext.ACT_GRAD_DT, 3, 2) AS INT)
		ELSE 0
	END AS [Date_Bacc_Received_mm]
	,CASE 
		WHEN baccext.ACT_GRAD_DT IS NOT NULL THEN CAST(SUBSTRING(baccext.ACT_GRAD_DT, 5, 2) AS INT)
		ELSE 0
	END AS [Date_Bacc_Received_dd]
	,CASE 
		WHEN baccext.ACT_GRAD_DT IS NOT NULL THEN CAST(SUBSTRING(baccext.ACT_GRAD_DT, 1, 4) AS INT)
		ELSE 0
	END AS [Date_Bacc_Received_yyyy]
	,ISNULL(act_eng.TST_SCR, 0) AS [ACT_Eng_Score]
	,ISNULL(act_mat.TST_SCR, 0) AS [ACT_Math_Score]
	,ISNULL(act_rea.TST_SCR, 0) AS [ACT_Rea_Score]
	,ISNULL(act_comp.TST_SCR, 0) AS [ACT_Comp_Score]
	,ISNULL(sat_crit.TST_SCR, 0) AS [SAT_Crit_Score]
	,ISNULL(sat_math.TST_SCR, 0) AS [SAT_Math_Score]
	,ISNULL(sat_wri.TST_SCR, 0) AS [SAT_Writing_Score]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20121]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20121]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20122]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20122]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20123]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20123]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20131]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20131]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20132]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20132]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20133]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20133]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20141]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20141]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20142]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20142]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20143]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20143]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20151]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20151]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20152]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20152]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20153]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20153]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20161]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20161]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20162]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20162]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20163]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20163]
	,CAST('' AS VARCHAR(MAX)) AS [Attended 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [prog 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad Degree 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Class_Level 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_mm 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_dd 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Deg_Compl_yyyy 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Cumm GPA 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [First_Major_CIP 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Second_Major_CIP 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Undeclared 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Clock Hours 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Clock Hours 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Total Reqd Credit Hours 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Total Cmpltd Credit Hours 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Total Fees charged 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Res for Tuition 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20171]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20171]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20172]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20172]
	,CAST('' AS VARCHAR(MAX)) AS [Enrollment Status 20173]
	,CAST('' AS VARCHAR(MAX)) AS [Hrs 20173]
INTO
	#t2
FROM
	#t1 npsas
	LEFT JOIN MIS.dbo.ST_STDNT_OBJ_AWD_A_178 obj ON obj.STDNT_ID = npsas.SSN
												 AND obj.PRIM_FLG = 1
												 AND obj.PGM_STAT <> 'IN'
												 AND obj.GRAD_STAT <> 'G'
												 AND obj.EXPCTD_GRAD_TRM <> ''	
												 AND obj.EXPCTD_GRAD_TRM <= '20173'
	LEFT JOIN (SELECT
					DISTINCT cred.STDNT_ID
					,ROW_NUMBER() OVER (PARTITION BY cred.STDNT_ID ORDER BY ps_award.cnxarraycolumn DESC) RN
				FROM
					MIS.dbo.ST_EXTRNL_CRDNTL_A_141 cred
					INNER JOIN MIS.dbo.[ST_EXTRNL_CRDNTL_A_POST_SECONDARY_AWARD_141] ps_award ON ps_award.ISN_ST_EXTRNL_CRDNTL_A = cred.ISN_ST_EXTRNL_CRDNTL_A
				WHERE
					cred.CRDNTL_CD = 'PC') cred ON cred.STDNT_ID = npsas.SSN
												AND cred.RN = 1	
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY r1.[STUDENT-ID] ORDER BY xwalk.OrionTerm ASC) RN
				FROM
					StateSubmission.SDB.RecordType1 r1
					INNER JOIN MIS.dbo.vwTermYearXwalk xwalk ON xwalk.StateReportingTerm = r1.[TERM-ID]
				WHERE
					r1.[DE1005-FTIC-FLG] IN ('D','Y')) ftic ON ftic.[STUDENT-ID] = npsas.SSN
															AND ftic.RN = 1
	LEFT JOIN (SELECT
					cred.*
					,ROW_NUMBER() OVER (PARTITION BY cred.STDNT_ID ORDER BY cred.ACT_GRAD_DT DESC) RN
				FROM
					MIS.dbo.ST_EXTRNL_CRDNTL_A_141 cred
				WHERE
					cred.CRDNTL_CD = 'PC'
					AND LEFT(cred.DIPL_TYPE, 1) = 'B') baccext ON baccext.STDNT_ID = npsas.SSN
															   AND cred.RN = 1
	LEFT JOIN MIS.dbo.ST_STDNT_OBJ_AWD_A_178 intbacc ON intbacc.STDNT_ID = npsas.SSN
													 AND intbacc.GRAD_STAT = 'G'
													 AND intbacc.PGM_STAT = 'GR'
													 AND LEFT(intbacc.AWD_TYPE, 1) = 'B'
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'ACT'
					AND [SUBTEST] = 'EN'
					AND TST_SCR > 0 ) act_eng ON act_eng.STUDENT_ID = npsas.SSN 
											  AND act_eng.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'ACT'
					AND [SUBTEST] = 'MA'
					AND TST_SCR > 0 ) act_mat ON act_mat.STUDENT_ID = npsas.SSN 
											  AND act_mat.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'ACT'
					AND [SUBTEST] = 'RE'
					AND TST_SCR > 0 ) act_rea ON act_rea.STUDENT_ID = npsas.SSN 
											  AND act_rea.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'ACT'
					AND [SUBTEST] = 'SR'
					AND TST_SCR > 0 ) act_sci ON act_sci.STUDENT_ID = npsas.SSN 
											  AND act_sci.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'ACT'
					AND [SUBTEST] = 'TC'
					AND TST_SCR > 0 ) act_comp ON act_comp.STUDENT_ID = npsas.SSN 
											   AND act_comp.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'SAT'
					AND [SUBTEST] IN ('VE','VR')
					AND TST_SCR > 0 ) sat_crit ON sat_crit.STUDENT_ID = npsas.SSN 
											   AND sat_crit.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'SAT'
					AND [SUBTEST] = 'MA'
					AND TST_SCR > 0 ) sat_math ON sat_math.STUDENT_ID = npsas.SSN 
											   AND sat_math.RN = 1
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY test.STUDENT_ID ORDER BY test.TST_SCR DESC) RN
				FROM
					MIS.dbo.ST_SUBTEST_A_155 test
				WHERE 
					test.TST_TY = 'SAT'
					AND [SUBTEST] = 'X3'
					AND TST_SCR > 0 ) sat_wri ON sat_wri.STUDENT_ID = npsas.SSN 
											  AND sat_wri.RN = 1


DECLARE @curYear INT = 2012
DECLARE @curYearString CHAR(4)
DECLARE @academicYear CHAR(7)
DECLARE @nextYearString CHAR(4)

WHILE @curYear <= 2017
BEGIN

	SET @academicYear = CAST(@curYear - 1 AS VARCHAR) + '-' + RIGHT(CAST(@curYear AS VARCHAR), 2)

	SET @curYearString = CAST(@curYear AS VARCHAR)

	SET @nextYearString = CAST(@curYear + 1 AS VARCHAR)

EXECUTE('
UPDATE npsas
	SET 
		npsas.[Attended ' + @academicYear + '] = CASE
										WHEN class' + @curYearString + '.STDNT_ID IS NOT NULL THEN ''1''
										ELSE ''0''
									END
		,npsas.[prog ' + @academicYear + '] =  CASE
										WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
										WHEN deg' + @curYearString + '.AWD_TYPE = ''ND'' THEN ''1''
										WHEN deg' + @curYearString + '.AWD_TYPE = ''TC'' THEN ''2''
										WHEN LEFT(deg' + @curYearString + '.AWD_TYPE, 1) = ''A'' THEN ''3''
										WHEN LEFT(deg' + @curYearString + '.AWD_TYPE, 1) = ''B'' THEN ''4''
										ELSE 0
									END
		,npsas.[Deg_Compl_mm ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN deg' + @curYearString + '.PGM_ID IS NULL THEN ''0''
											WHEN deg' + @curYearString + '.ACT_GRAD_TRM = '''' THEN ''0''
											ELSE SUBSTRING(deg' + @curYearString + '.ACT_GRAD_DT, 5, 2)
										END
		,npsas.[Deg_Compl_dd ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN deg' + @curYearString + '.PGM_ID IS NULL THEN ''0''
											WHEN deg' + @curYearString + '.ACT_GRAD_TRM = '''' THEN ''0''
											ELSE RIGHT(deg' + @curYearString + '.ACT_GRAD_DT, 2)
										END
		,npsas.[Deg_Compl_yyyy ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN deg' + @curYearString + '.PGM_ID IS NULL THEN ''0''
											WHEN deg' + @curYearString + '.ACT_GRAD_TRM = '''' THEN ''0''
											ELSE LEFT(deg' + @curYearString + '.ACT_GRAD_DT, 4)
										END
		,npsas.[Total Reqd Clock Hours ' + @academicYear + '] = CASE
														WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
														WHEN prog.PGM_TTL_MIN_CNTCT_HRS_REQD > 0 THEN CAST(prog.PGM_TTL_MIN_CNTCT_HRS_REQD AS VARCHAR)
														ELSE ''0''
													END
		,npsas.[Total Cmpltd Clock Hours ' + @academicYear + '] = CASE
														WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
														WHEN prog.PGM_TTL_MIN_CNTCT_HRS_REQD > 0 THEN ISNULL(CAST(calc.T1_DE1024_TRM_CLOCK_HRS_EARNED AS VARCHAR), ''0'')
														ELSE ''0''
													END
		,npsas.[Total Reqd Credit Hours ' + @academicYear + '] = CASE
														WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
														WHEN prog.PGM_TTL_CRD_HRS > 0 THEN CAST(prog.PGM_TTL_CRD_HRS AS VARCHAR)
														ELSE ''0''
													END
		,npsas.[Total Cmpltd Credit Hours ' + @academicYear + '] = CASE
														WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
														WHEN prog.PGM_TTL_CRD_HRS > 0 THEN ISNULL(CAST(calc.T1_DE1025_TRM_CREDIT_HRS_EARNED AS VARCHAR), ''0'')
														ELSE ''0''
													END
		,npsas.[Total Fees charged ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ISNULL(CAST(fees.Amount AS VARCHAR), ''0'') END
		,npsas.[Res for Tuition ' + @academicYear + '] = case
												WHEN class' + @curYearString + '.STDNT_ID IS  NULL THEN '''' 
												when resterm.[RES_CD] in (''1'',''2'',''3'') then resterm.[RES_CD]
												when resterm.[RES_CD] in (''4'',''5'') then ''3''
												else ''-1'' 
											end
		,npsas.[Enrollment Status ' + @curYearString + '1] = CASE
												WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
												WHEN hrs' + @curYearString + '1.Hrs IS NULL THEN ''0''
												WHEN hrs' + @curYearString + '1.Hrs = 0 THEN ''0''
												WHEN hrs' + @curYearString + '1.Hrs >= 12 THEN ''1''
												WHEN hrs' + @curYearString + '1.Hrs >= 9 THEN ''2''
												WHEN hrs' + @curYearString + '1.Hrs >= 6 THEN ''3''
												ELSE ''4''
											END
		,npsas.[Hrs ' + @curYearString + '1] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ISNULL(CAST(hrs' + @curYearString + '1.Hrs AS VARCHAR), ''0'') END
		,npsas.[Enrollment Status ' + @curYearString + '2] = CASE
												WHEN class' + @curYearString + '.STDNT_ID IS  NULL THEN ''''
												WHEN hrs' + @curYearString + '2.Hrs IS NULL THEN ''0''
												WHEN hrs' + @curYearString + '2.Hrs = 0 THEN ''0''
												WHEN hrs' + @curYearString + '2.Hrs >= 12 THEN ''1''
												WHEN hrs' + @curYearString + '2.Hrs >= 9 THEN ''2''
												WHEN hrs' + @curYearString + '2.Hrs >= 6 THEN ''3''
												ELSE ''4''
											END
		,npsas.[Hrs ' + @curYearString + '2] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ISNULL(CAST(hrs' + @curYearString + '2.Hrs AS VARCHAR), ''0'') END
		,npsas.[Enrollment Status ' + @curYearString + '3] = CASE
												WHEN class' + @curYearString + '.STDNT_ID IS  NULL THEN ''''
												WHEN hrs' + @curYearString + '3.Hrs IS NULL THEN ''0''
												WHEN hrs' + @curYearString + '3.Hrs = 0 THEN ''0''
												WHEN hrs' + @curYearString + '3.Hrs >= 12 THEN ''1''
												WHEN hrs' + @curYearString + '3.Hrs >= 9 THEN ''2''
												WHEN hrs' + @curYearString + '3.Hrs >= 6 THEN ''3''
												ELSE ''4''
											END
		,npsas.[Hrs ' + @curYearString + '3] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ISNULL(CAST(hrs' + @curYearString + '3.Hrs AS VARCHAR), ''0'') END
		,npsas.[Class_Level ' + @academicYear + '] = CASE
													WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
													ELSE ISNULL(case 
													when clstatus.[TRM_CLASS] = ''FR'' then ''1''
													when clstatus.[TRM_CLASS] = ''SO'' then ''2''
													when clstatus.[TRM_CLASS] = ''JR'' then ''3''
													when clstatus.[TRM_CLASS] = ''SR'' then ''4''
													when calc.[T1_DE1012_CLASS_LEVEL] in (''1'',''2'',''3'',''4'',''6'') then calc.[T1_DE1012_CLASS_LEVEL]
												END, ''-1'') END
FROM
	#t2 npsas
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
					class.STDNT_ID) class' + @curYearString + ' ON class' + @curYearString + '.STDNT_ID = npsas.SSN
	LEFT JOIN (SELECT
					obj.*
					,ROW_NUMBER() OVER (PARTITION BY obj.STDNT_ID ORDER BY d.DEGRANK ASC) RN
				FROM
					MIS.dbo.ST_STDNT_OBJ_AWD_A_178 obj
					INNER JOIN #degrank d ON d.AWD_TYPE = obj.AWD_TYPE
				WHERE
					obj.EFF_TERM < ''' + @nextYearString + '1''
					AND obj.PGM_STAT IN (''GR'', ''AC'')
					AND obj.ADMT_STAT = ''Y'') deg' + @curYearString + ' ON deg' + @curYearString + '.STDNT_ID = npsas.SSN
													                     AND deg' + @curYearString + '.RN = 1
	LEFT JOIN MIS.dbo.ST_PROGRAMS_A_136 prog ON prog.PGM_CD = deg' + @curYearString + '.PGM_ID
											 AND prog.EFF_TRM_D <= deg' + @curYearString + '.EFF_TERM
											 AND prog.END_TRM >= deg' + @curYearString + '.EFF_TERM
											 AND prog.EFF_TRM_D <> ''''
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY SID ORDER BY TERM ASC) RN
				FROM
					MIS.dbo.SR_GPA_CALC_604) calc ON calc.SID = npsas.SSN
												  AND calc.TERM BETWEEN ''' + @curYearString + '1'' AND ''' + @curYearString + '3''
												  AND calc.RN = 1
	LEFT JOIN (SELECT
					fees.stdntId
					,xwalk.AcademicYear
					,SUM(fees.FEE_ASSESS_AMOUNT) AS [Amount]
				FROM
					[MIS].[dbo].[IT_STUDENT_FEES_A_145] fees
					INNER JOIN MIS.dbo.vwTermYearXwalk xwalk ON xwalk.OrionTerm = fees.trmYr
				GROUP BY
					fees.stdntId
					,xwalk.AcademicYear) fees ON fees.stdntId = npsas.SSN
											  AND fees.AcademicYear = ''' + @academicYear + '''
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY term.STDNT_ID ORDER BY TRM_YR ASC) RN
				FROM
					MIS.dbo.ST_STDNT_TERM_A_236 term
				WHERE
					LEFT(term.TRM_YR, 4) = ''' + @curYearString + ''') resterm ON resterm.STDNT_ID = npsas.SSN
														                       AND resterm.RN = 1
	LEFT JOIN (SELECT
					class.STDNT_ID
					,class.EFF_TRM
					,SUM(CASE
						WHEN class.CRED_TY IN (''01'',''02'',''03'',''14'',''15'') THEN course.EVAL_CRED_HRS
						ELSE course.CNTCT_HRS / 30.0
					END) AS Hrs
				FROM
					MIS.dbo.ST_STDNT_CLS_A_235 class
					INNER JOIN MIS.dbo.ST_CLASS_A_151 course ON course.REF_NUM = class.REF_NUM
				GROUP BY
					class.STDNT_ID
					,class.EFF_TRM) hrs' + @curYearString + '1 ON hrs' + @curYearString + '1.STDNT_ID = npsas.SSN
										                       AND hrs' + @curYearString + '1.EFF_TRM = ''' + @curYearString + '1''
	LEFT JOIN (SELECT
					class.STDNT_ID
					,class.EFF_TRM
					,SUM(CASE
						WHEN class.CRED_TY IN (''01'',''02'',''03'',''14'',''15'') THEN course.EVAL_CRED_HRS
						ELSE course.CNTCT_HRS / 30.0
					END) AS Hrs
				FROM
					MIS.dbo.ST_STDNT_CLS_A_235 class
					INNER JOIN MIS.dbo.ST_CLASS_A_151 course ON course.REF_NUM = class.REF_NUM
				GROUP BY
					class.STDNT_ID
					,class.EFF_TRM) hrs' + @curYearString + '2 ON hrs' + @curYearString + '2.STDNT_ID = npsas.SSN
															   AND hrs' + @curYearString + '2.EFF_TRM = ''' + @curYearString + '2''
	LEFT JOIN (SELECT
					class.STDNT_ID
					,class.EFF_TRM
					,SUM(CASE
						WHEN class.CRED_TY IN (''01'',''02'',''03'',''14'',''15'') THEN course.EVAL_CRED_HRS
						ELSE course.CNTCT_HRS / 30.0
					END) AS Hrs
				FROM
					MIS.dbo.ST_STDNT_CLS_A_235 class
					INNER JOIN MIS.dbo.ST_CLASS_A_151 course ON course.REF_NUM = class.REF_NUM
				GROUP BY
					class.STDNT_ID
					,class.EFF_TRM) hrs' + @curYearString + '3 ON hrs' + @curYearString + '3.STDNT_ID = npsas.SSN
										                       AND hrs' + @curYearString + '3.EFF_TRM = ''' + @curYearString + '3''
	LEFT JOIN (SELECT
					*
					,ROW_NUMBER() OVER (PARTITION BY STUDENT_ID, ACADEMIC_YEAR ORDER BY deg.DEGRANK) RN
				FROM
					MIS.dbo.IT_FREEZE_POINT_A_116 freeze
					INNER JOIN #degrank deg ON deg.AWD_TYPE = freeze.TRM_DEGREE) clstatus ON clstatus.STUDENT_ID = npsas.SSN
																						  AND clstatus.ACADEMIC_YEAR = '  + @curYearString + '
																						  AND clstatus.RN = 1')

	SET @curYear = @curYear + 1

END

	
SELECT
	*
FROM
	#t2
