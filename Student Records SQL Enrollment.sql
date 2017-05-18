IF OBJECT_ID ('tempdb..#FSCJ_ENROLL') IS NOT NULL
	DROP TABLE #FSCJ_ENROLL

SELECT  
	STUDENT_ID
	,MIN([effTrm]) AS FIRST_TERM
	,MAX([effTrm]) AS LAST_TERM
INTO 
	#FSCJ_ENROLL
FROM 
	[MIS].[dbo].[ST_ACDMC_HIST_A_154] 
WHERE 
	LEFT(CLASS_KEY,1) NOT IN ('B', 'M') 
	AND [effTrm] != ''
GROUP BY 
	STUDENT_ID

IF OBJECT_ID ('tempdb..#FSCJ_SCLS') IS NOT NULL
	DROP TABLE #FSCJ_SCLS

SELECT 
	DISTINCT STDNT_ID AS STUDENT_ID
	,'20163' AS FIRST_TERM
	,'20163' AS LAST_TERM
INTO 
	#FSCJ_SCLS
FROM 
	[MIS].[dbo].[ST_STDNT_CLS_A_235] 
WHERE 
	EFF_TRM = '20163'


INSERT INTO #FSCJ_ENROLL
	SELECT 
		scls.STUDENT_ID
		,'20163'
		,'20163'
	FROM 
		#FSCJ_SCLS scls 
		LEFT JOIN #FSCJ_ENROLL ahist ON ahist.student_id = scls.STUDENT_ID
	WHERE 
		ahist.student_id IS NULL

UPDATE ahist
	SET last_term = '20163'
	FROM
		#FSCJ_ENROLL ahist
		INNER JOIN #FSCJ_SCLS scls ON ahist.student_id = scls.student_id


IF OBJECT_ID ('tempdb..#TRNSFR') IS NOT NULL
	DROP TABLE #TRNSFR

SELECT 
	DISTINCT [STDNT_ID] 
INTO 
	#TRNSFR
    FROM 
		[MIS].[dbo].[ST_EXTRNL_CRDNTL_A_141] ex_cred 
		INNER JOIN [MIS].[dbo].[ST_EXTRNL_CRDNTL_A_POST_SECONDARY_AWARD_141] ps_awd ON ex_cred.[ISN_ST_EXTRNL_CRDNTL_A] = ps_awd.[ISN_ST_EXTRNL_CRDNTL_A]
WHERE
	[CRDNTL_CD] = 'PC' 
GROUP BY
	stdnt_id
					
IF OBJECT_ID ('tempdb..#ACT') IS NOT NULL
	DROP TABLE #ACT

SELECT 
	DISTINCT TST.STUDENT_ID
	,SUBSTRING(SUBTEST,1,1) AS TEST_TY
	,MAX(TST_SCR) AS HIGH_SCR
INTO #ACT
FROM 
		[Adhoc].[dbo].[NPSASSurveyStudents] main
		INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
		INNER JOIN [MIS].[dbo].[ST_SUBTEST_A_155] TST ON TST.STUDENT_ID = XWLK.STUDENT_SSN
where 
	[TST_TY] = 'ACT' 
	and [SUBTEST] IN ('EN','MA','RE','SR','TC') AND TST_SCR > 0
GROUP BY 
	TST.STUDENT_ID, SUBSTRING(SUBTEST,1,1)

IF OBJECT_ID ('tempdb..#SAT') IS NOT NULL
	DROP TABLE #SAT

SELECT 
	DISTINCT TST.STUDENT_ID, SUBSTRING(SUBTEST,1,1) AS TEST_TY, MAX(TST_SCR) AS HIGH_SCR
INTO #SAT
from 
	[Adhoc].[dbo].[NPSASSurveyStudents] main
	INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
	INNER JOIN [MIS].[dbo].[ST_SUBTEST_A_155] TST ON TST.STUDENT_ID = XWLK.STUDENT_SSN
where 
	[TST_TY] = 'SAT' 
	and [SUBTEST] IN ('X3','MA','VE','VR') AND TST_SCR > 0
GROUP BY 
	TST.STUDENT_ID, SUBSTRING(SUBTEST,1,1)

IF OBJECT_ID ('tempdb..#FTIC') IS NOT NULL
	DROP TABLE #FTIC

SELECT DISTINCT MAIN.[Case ID], XWLK.STUDENT_SSN
  INTO #FTIC
  from [Adhoc].[dbo].[NPSASSurveyStudents] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
  INNER JOIN [StateSubmission].[SDB].[RecordType1] rec1 ON (xwlk.STUDENT_SSN = rec1.[STUDENT-ID] or xwlk.STUDENT_SSN = substring(rec1.[STUDENT-ID],2,9)) and rec1.[SubmissionType] = 'E' and rec1.[TERM-ID] in ('115','215','316') and [DE1005-FTIC-FLG] in ('D','Y')

IF OBJECT_ID ('tempdb..#DEV') IS NOT NULL
	DROP TABLE #DEV

SELECT 
	DISTINCT MAIN.[Case ID]
	,main.SSN
INTO #DEV
from 
	[Adhoc].[dbo].[NPSASSurveyStudents] main
	INNER JOIN [MIS].[dbo].[ST_STDNT_TEST_DEMO_A_174] demo ON demo.[STDNT_ID] = main.SSN
	LEFT JOIN [MIS].[dbo].[ST_STDNT_TEST_DEMO_A_CHAIN_1_174] chain1 ON demo.[ISN_ST_STDNT_TEST_DEMO_A] = chain1.[ISN_ST_STDNT_TEST_DEMO_A] 
																	and [SATISFIED_1_IND] = 'G' 
																	AND SUBSTRING(COURSE_CHAIN_1,4,2) = '00'
	LEFT JOIN [MIS].[dbo].[ST_STDNT_TEST_DEMO_A_CHAIN_2_174] chain2 ON demo.[ISN_ST_STDNT_TEST_DEMO_A] = chain2.[ISN_ST_STDNT_TEST_DEMO_A] 
																	and [SATISFIED_2_IND] = 'G' 
																	AND SUBSTRING(COURSE_CHAIN_2,4,2) = '00'
WHERE 
	CHAIN1.[ISN_ST_STDNT_TEST_DEMO_A] IS NOT NULL AND CHAIN2.[ISN_ST_STDNT_TEST_DEMO_A] IS NOT NULL


IF OBJECT_ID ('tempdb..#CREDITS') IS NOT NULL
	DROP TABLE #CREDITS

SELECT 
	main.[Case ID]
	,isnull(term_20153.hrs_ern,0) as Cred_Units_20153
	,isnull(term_20161.hrs_ern,0) as Cred_Units_20161
	,isnull(term_20162.hrs_ern,0) as Cred_Units_20162
	,isnull(term_20163.hrs_ern,0) as Cred_Units_20163
	,isnull(clk_20153.clk_hrs,0) as Clk_Hrs_20153
	,isnull(clk_20161.clk_hrs,0) as Clk_Hrs_20161
	,isnull(clk_20162.clk_hrs,0) as Clk_Hrs_20162
	,isnull(clk_20163.clk_hrs,0) as Clk_Hrs_20163
INTO 
	#CREDITS
FROM 
	[Adhoc].[dbo].[NPSASSurveyStudents] main
	INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
	LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
	LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] and aidyr.WF_AID_YEAR = '2016'
	LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] term_20153 ON term_20153.stdnt_id = xwlk.student_ssn and term_20153.trm_yr = '20153'
	LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] term_20161 ON term_20161.stdnt_id = xwlk.student_ssn and term_20161.trm_yr = '20161'
	LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] term_20162 ON term_20162.stdnt_id = xwlk.student_ssn and term_20162.trm_yr = '20162'
	--LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] term_20163 ON term_20163.stdnt_id = xwlk.student_ssn and term_20163.trm_yr = '20163'
	left join (SELECT
					scls.stdnt_id as student_id
					,sum([EVAL_CRED_HRS]) as hrs_ern 
				FROM 
					[Adhoc].[dbo].[NPSASSurveyStudents] main 
					inner join [MIS].[dbo].[ST_STDNT_CLS_A_235] scls ON scls.STDNT_ID = main.SSN 
																	 AND scls.cred_ty in ('01','02','14','15') 
																	 AND scls.[EFF_TRM] = '20163'
					INNER JOIN [MIS].[dbo].[ST_CLASS_A_151] cls ON scls.ref_num = cls.ref_num
				GROUP BY
					scls.stdnt_id) term_20163 ON xwlk.student_ssn = term_20163.student_id
  left join (SELECT
				ahist.student_id
				,sum([EXTRNL_CNTCT_HRS]) as clk_hrs 
			FROM 
				[Adhoc].[dbo].[NPSASSurveyStudents] main
				inner join [MIS].[dbo].[ST_ACDMC_HIST_A_154] ahist ON ahist.student_id = main.SSN
																   AND ahist.cred_ty = '05'
																   AND [effTrm] = '20153'
			GROUP BY
					ahist.student_id) clk_20153 on xwlk.student_ssn = clk_20153.student_id
  LEFT JOIN (SELECT 
				ahist.student_id
				,sum([EXTRNL_CNTCT_HRS]) as clk_hrs 
			FROM 
				[Adhoc].[dbo].[NPSASSurveyStudents] main 
				inner join [MIS].[dbo].[ST_ACDMC_HIST_A_154] ahist ON ahist.student_id = main.SSN 
																   AND ahist.cred_ty = '05' 
																   AND [effTrm] = '20161'
			GROUP BY 
				ahist.student_id) clk_20161 on xwlk.student_ssn = clk_20161.student_id
  LEFT JOIN (SELECT
				 ahist.student_id
				 ,sum([EXTRNL_CNTCT_HRS]) as clk_hrs 
			FROM 
				[Adhoc].[dbo].[NPSASSurveyStudents] main
				inner join [MIS].[dbo].[ST_ACDMC_HIST_A_154] ahist ON ahist.student_id = main.[Student ID] 
																   AND ahist.cred_ty = '05' 
																   AND [effTrm] = '20162'
			GROUP BY 
				ahist.student_id) clk_20162 on xwlk.student_ssn = clk_20162.student_id
  left join (SELECT
				scls.stdnt_id as student_id
				,sum([CNTCT_HRS]) as clk_hrs 
			FROM 
				[Adhoc].[dbo].[NPSASSurveyStudents] main
				inner join [MIS].[dbo].[ST_STDNT_CLS_A_235] scls ON scls.STDNT_ID = main.SSN 
																 AND scls.cred_ty = '05' 
																 AND scls.[EFF_TRM] = '20163'
				INNER JOIN [MIS].[dbo].[ST_CLASS_A_151] cls ON scls.ref_num = cls.ref_num
			GROUP BY 
				scls.stdnt_id) clk_20163 on xwlk.student_ssn = clk_20163.student_id


IF OBJECT_ID ('tempdb..#Fees') IS NOT NULL
	DROP TABLE #Fees

SELECT 
	main.[Case ID]
	,sum([FEE_ASSESS_AMOUNT]) as Tuition_Fees_Amt
into #Fees
	from 
		[Adhoc].[dbo].[NPSASSurveyStudents] main
		INNER JOIN [MIS].[dbo].[IT_STUDENT_FEES_A_145] fees ON main.[Student ID] = fees.[stdntId]
															and [trmYr] in ('20153','20161','20162','20163')  
GROUP BY
	 main.[Case ID]

SELECT  
      main.[Institute ID]
      ,main.[Case ID]
	  ,main.[Student ID]
	  ,isnull(substring(fst_date.SESS_BEG_DT,5,2),'00') AS 'First_Enroll_mm'
	  ,isnull(substring(fst_date.SESS_BEG_DT,7,2),'00') as 'First_Enroll_dd'
	  ,isnull(substring(fst_date.SESS_BEG_DT,1,4),'00') as 'First_Enroll_yr'
	  ,isnull(substring(lst_date.SESS_END_DT,5,2),'00') as 'Last_Enroll_mm'
	  ,isnull(substring(lst_date.SESS_END_DT,7,2),'00') as 'Last_Enroll_dd'
	  ,isnull(substring(lst_date.SESS_END_DT,1,4),'00') as 'Last_Enroll_yr'
	  ,case
	     when obj.[EXPCTD_GRAD_TRM] <= '20163' and obj.grad_stat != 'G'
		   then '1'
		 when obj_prim.expctd_grad_trm <= '20163' and obj_prim.grad_stat != 'G' then '1'
		 when obj_gr.expctd_grad_trm <= '20163' and obj_gr.grad_stat != 'G' then '1'
		 else '0' end as 'Expect_To_Complete'
	  ,CASE when ps_trnsfr.[STDNT_ID] IS NOT NULL then '1'
	        else '0' end as 'Transfer_Cred'
	  ,'' as 'Remedial_courses'
	  ,case 
	    when ftic.[Case ID] is not null then '1'
		else '0' end as 'FTIC'
	  ,case 
	    when bac_degree.[STDNT_ID] is not null then '1'
		when obj_degree.stdnt_id is not null then '1'
		else '-1' end as 'Rcvd_Bacc'
	  ,case
	    when bac_degree.[stdnt_id] is not null then substring(bac_degree.GRAD_DT,5,2)
		when obj_degree.stdnt_id is not null then substring(obj_degree.grad_dt,5,2) 
		else '' end as 'Date_Rcvd_Bacc_MM'
	  ,case
	    when bac_degree.[stdnt_id] is not null then substring(bac_degree.GRAD_DT,7,2)
		when obj_degree.stdnt_id is not null then substring(obj_degree.grad_dt,7,2) 
		else '' end  as 'Date_Rcvd_Bacc_dd'
	  ,case
	    when bac_degree.[stdnt_id] is not null then substring(bac_degree.GRAD_DT,1,4)
		when obj_degree.stdnt_id is not null then substring(obj_degree.grad_dt,1,4) 
		else '' end  as 'Date_Rcvd_Bacc_yr'
	  ,isnull(cast(act_Eng.HIGH_SCR as varchar),'') as 'ACT_Eng_score'
	  ,isnull(cast(act_Mat.HIGH_SCR as varchar),'') as 'ACT_Math_score'
	  ,isnull(cast(act_REA.HIGH_SCR as varchar),'') as 'ACT_Read_score'
	  ,isnull(cast(act_SCI.HIGH_SCR as varchar),'') as 'ACT_Science_score'
	  ,isnull(cast(act_COM.HIGH_SCR as varchar),'') as 'ACT_Comp_score'
	  ,isnull(cast(SAT_CRT.HIGH_SCR as varchar),'') as 'SAT_crit_read_score'
	  ,isnull(cast(SAT_MAT.HIGH_SCR as varchar),'') as 'SAT_Mat_score'
	  ,isnull(cast(SAT_WRT.HIGH_SCR as varchar),'') as 'SAT_Write_score'
	  ,CASE
			WHEN class2012.STDNT_ID IS NULL THEN 0
			ELSE 1
		END AS [Enrolledin201213]
	  ,case
	    when [TRM_DEGREE] = 'ND' THEN '1'
		when obj_prim.AWD_TYPE = 'ND' THEN '1'
		when obj_gr.AWD_TYPE = 'ND' THEN '1'
		when [TRM_DEGREE] = 'VC' then '2'
		when obj_prim.AWD_TYPE = 'VC' THEN '2'
		when obj_gr.AWD_TYPE = 'VC' THEN '2'
		when substring([TRM_DEGREE],1,1) = 'A' then '3'
		when substring(obj_prim.AWD_TYPE,1,1) = 'A' THEN '3'
		when substring(obj_gr.AWD_TYPE,1,1) = 'A' THEN '3'
		when substring([TRM_DEGREE],1,1) = 'B' then '4'
		when substring(obj_prim.AWD_TYPE,1,1) = 'B' THEN '4'
		when substring(obj_gr.AWD_TYPE,1,1) = 'B' THEN '4'
		else '-1' end as 'Prog_Degree'
	--, stdnt.student_id
	  ,'' as 'Grad_Degree'
	  ,CASE
			WHEN lstdeggranted.GRAD_STAT = 'G' THEN SUBSTRING(lstdeggranted.ACT_GRAD_DT, 3, 2)
			ELSE ''
		END AS [Deg_Compl_mm]
		,CASE
			WHEN lstdeggranted.GRAD_STAT = 'G' THEN RIGHT(lstdeggranted.ACT_GRAD_DT, 2)
			ELSE ''
		END AS [Deg_Compl_dd]
		,CASE
			WHEN lstdeggranted.GRAD_STAT = 'G' THEN LEFT(lstdeggranted.ACT_GRAD_DT, 4)
			ELSE ''
		END AS [Deg_Compl_yyyy]
	  ,case 
	    when [TRM_CLASS] = 'FR' then '1'
		when [TRM_CLASS] = 'SO' then '2'
		when [TRM_CLASS] = 'JR' then '3'
		when [TRM_CLASS] = 'SR' then '4'
		when gpa.[T1_DE1012_CLASS_LEVEL] in ('1','2','3','4','6') then gpa.[T1_DE1012_CLASS_LEVEL]


		else '-1' end  as 'Class_Level'
	  ,case
	     when obj.grad_stat = 'G' then substring(obj.[ACT_GRAD_DT],5,2)
		 when obj_prim.grad_stat = 'G' then substring(obj_prim.[ACT_GRAD_DT],5,2)
		 when obj_gr.grad_stat = 'G' then substring(obj_gr.[ACT_GRAD_DT],5,2)
		 else '' end as 'Degree_Compl_MM'
	  ,case
	     when obj.grad_stat = 'G' then substring(obj.[ACT_GRAD_DT],7,2)
		 when obj_prim.grad_stat = 'G' then substring(obj_prim.[ACT_GRAD_DT],7,2)
		 when obj_gr.grad_stat = 'G' then substring(obj_gr.[ACT_GRAD_DT],7,2)
		 else '' end as 'Degree_Compl_DD'
	  ,case
	     when obj.grad_stat = 'G' then substring(obj.[ACT_GRAD_DT],1,4)
		 when obj_prim.grad_stat = 'G' then substring(obj_prim.[ACT_GRAD_DT],1,4)
		 when obj_gr.grad_stat = 'G' then substring(obj_gr.[ACT_GRAD_DT],1,4)
		 else '' end as 'Degree_compl_YR'
	  ,'' as 'Cumm_GPA'
	  ,'' as 'First_Major'
	  ,'' as 'First_Major_CIP'
	  ,'' as 'Second_Major'
	  ,'' AS 'Second_Major_CIP'
	  ,'' as 'Undeclared'
	  , ''  as 'Tot_#_clk_hrs_cmplt'
	  ,case 
	     when [T1_DE1024_TRM_CLOCK_HRS_EARNED] > 0 then cast([T1_DE1024_TRM_CLOCK_HRS_EARNED] as varchar)
		 else '' end as 'Cumm_Clk_hrs_cmplt'
	  ,'' as 'Tot_#_cred_hrs_cmplt'
	  ,case 
	     when [T1_DE1024_TRM_CLOCK_HRS_EARNED] > 0 then cast([T1_DE1024_TRM_CLOCK_HRS_EARNED] as varchar) 
		 else '' end as 'Cumm_Cred_hours_cmplt'
	  ,isnull(fees.Tuition_Fees_Amt,0) as 'Tuition_Fees_charged'
	  --,curterm.[RES_CD]
	  ,case 
	    when curterm.[RES_CD] in ('1','2','3') then curterm.[RES_CD]
		when curterm.[RES_CD] in ('4','5') then '3'
		else '' end as 'Res_for_tuition'
	  ,case 
		when cred.Cred_Units_20153 >= 12 then '1'
		when cred.Cred_Units_20153 >= 9 then '2'
		when cred.Cred_Units_20153 >= 6 then '3'
		when cred.Cred_Units_20153 > 0 then '4'
		when cred.Clk_Hrs_20153 >= 450 then '1'
		when cred.Clk_Hrs_20153 > 225 then '3'
		when cred.Clk_Hrs_20153 > 0 then '4'
		else '0' end as '20153_Enroll_stat'
	  ,isnull(cred.Cred_Units_20153,0) as '20153_Cred_units'
	  ,case 
	    when [WW_ST_RT1_TIM] = 'F' then '1'
		when [WW_ST_RT1_TIM] = 'T' then '2'
		when [WW_ST_RT1_TIM] = 'H' then '3'
		when [WW_ST_RT1_TIM] = 'L' then '4'
		when cred.Cred_Units_20161 >= 12 then '1'
		when cred.Cred_Units_20161 >= 9 then '2'
		when cred.Cred_Units_20161 >= 6 then '3'
		when cred.Cred_Units_20161 > 0 then '4'
		when cred.Clk_Hrs_20161 >= 450 then '1'
		when cred.Clk_Hrs_20161 > 225 then '3'
		when cred.Clk_Hrs_20161 > 0 then '4'
		else '0' end as '20161_Enroll_stat'
	  , isnull(cred.Cred_Units_20161,0) as '20161_Cred_units'
	  ,case 
	    when [WW_ST_RT2_TIM] = 'F' then '1'
		when [WW_ST_RT2_TIM] = 'T' then '2'
		when [WW_ST_RT2_TIM] = 'H' then '3'
		when [WW_ST_RT2_TIM] = 'L' then '4'
		when cred.Cred_Units_20162 >= 12 then '1'
		when cred.Cred_Units_20162 >= 9 then '2'
		when cred.Cred_Units_20162 >= 6 then '3'
		when cred.Cred_Units_20162 > 0 then '4'
		when cred.Clk_Hrs_20162 >= 450 then '1'
		when cred.Clk_Hrs_20162 > 225 then '3'
		when cred.Clk_Hrs_20162 > 0 then '4'
		else '0' end as '20162_Enroll_stat'
	  ,isnull(cred.Cred_Units_20162,0) as '20162_Cred_units'
	  ,case
	    when [WW_ST_RT2_TIM] = 'F' then '1'
		when [WW_ST_RT2_TIM] = 'T' then '2'
		when [WW_ST_RT2_TIM] = 'H' then '3'
		when [WW_ST_RT2_TIM] = 'L' then '4' 
		when cred.Cred_Units_20163 >= 12 then '1'
		when cred.Cred_Units_20163 >= 9 then '2'
		when cred.Cred_Units_20163 >= 6 then '3'
		when cred.Cred_Units_20163 > 0 then '4'
		when cred.Clk_Hrs_20163 >= 450 then '1'
		when cred.Clk_Hrs_20163 > 225 then '3'
		when cred.Clk_Hrs_20163 > 0 then '4'
		else '0' end as '20163_Enroll_stat'
	  ,isnull(cred.Cred_Units_20163,0) as '20163_Cred_units'
FROM 
  [Adhoc].[dbo].[NPSASSurveyStudents] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON main.[Student ID] = stdnt.STUDENT_SSN
  LEFT JOIN (SELECT 
				STUDENT_ID, MAX(TERM_ID) AS MAX_TERM
			FROM 
				[MIS].[dbo].[IT_FREEZE_POINT_A_116]
			WHERE 
				TERM_ID IN ('20153','20161','20162','20163')
			GROUP BY 
				STUDENT_ID) freeze_info on freeze_info.STUDENT_ID = stdnt.STUDENT_ID
  left join [MIS].[dbo].[IT_FREEZE_POINT_A_116] freeze on stdnt.STUDENT_ID = freeze.STUDENT_ID and freeze.TERM_ID = freeze_info.MAX_TERM
  LEFT JOIN [MIS].[dbo].[ST_STDNT_OBJ_AWD_A_178] obj on stdnt.STUDENT_ID = obj.STDNT_ID AND obj.PGM_ID = freeze.[TRM_PGM] AND obj.admt_stat = 'Y' and pgm_stat != 'IN'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_OBJ_AWD_A_178] obj_prim on stdnt.STUDENT_ID = obj_prim.STDNT_ID AND  obj_prim.admt_stat = 'Y' and obj_prim.pgm_stat != 'IN' and obj_prim.PRIM_FLG = 1 
  left join [MIS].[dbo].[SR_GPA_CALC_604] gpa ON stdnt.student_id = gpa.[SID] and gpa.[TERM] = '20162' and gpa.[RUN_TYPE] = 'E'
  left join [MIS].[dbo].[ST_STDNT_TERM_A_236] term ON stdnt.student_id = term.stdnt_id and term.[TRM_YR] = freeze.term_id
  left join (select distinct
				[STDNT_ID]
				,max([PS_AWD_DT]) as grad_dt 
			from 
				[MIS].[dbo].[ST_EXTRNL_CRDNTL_A_141] ex_cred 
                inner join [MIS].[dbo].[ST_EXTRNL_CRDNTL_A_POST_SECONDARY_AWARD_141] ps_awd ON ex_cred.[ISN_ST_EXTRNL_CRDNTL_A] = ps_awd.[ISN_ST_EXTRNL_CRDNTL_A] 
																							AND substring(ps_awd.[PS_AWD_TY],1,1) = 'B'
			where 
				[CRDNTL_CD] = 'PC' 
			group by stdnt_id) bac_degree ON bac_degree.[STDNT_ID] = stdnt.student_id
  left join (select stdnt_id, max(act_grad_dt) as grad_dt   FROM [MIS].[dbo].[ST_STDNT_OBJ_AWD_A_178]
				where pgm_stat = 'GR' and substring(awd_type,1,1) = 'B'
				group by stdnt_id) obj_degree ON obj_degree.stdnt_id = stdnt.student_id
  left join #TRNSFR ps_trnsfr ON ps_trnsfr.[STDNT_ID] = stdnt.student_id
  LEFT JOIN #FSCJ_ENROLL fscj_enroll on fscj_enroll.STUDENT_ID = stdnt.STUDENT_ID
  left join [MIS].[dbo].[vwTermYearXwalk] fst_date on fscj_enroll.FIRST_TERM = fst_date.OrionTerm
  left join [MIS].[dbo].[vwTermYearXwalk] lst_date on fscj_enroll.LAST_TERM = lst_date.OrionTerm
  LEFT JOIN #ACT act_Eng ON stdnt.STUDENT_ID = act_Eng.STUDENT_ID and act_Eng.TEST_TY = 'E'
  LEFT JOIN #ACT act_MAT ON stdnt.STUDENT_ID = act_MAT.STUDENT_ID and act_MAT.TEST_TY = 'M'
  left join #ACT act_REA ON stdnt.STUDENT_ID = act_REA.STUDENT_ID and act_REA.TEST_TY = 'R'
  left join #ACT act_Sci ON stdnt.STUDENT_ID = act_Sci.STUDENT_ID and act_Sci.TEST_TY = 'S'
  left join #ACT act_Com ON stdnt.STUDENT_ID = act_Com.STUDENT_ID and act_Com.TEST_TY = 'T'
  left join #SAT SAT_CRT ON stdnt.STUDENT_ID = SAT_CRT.STUDENT_ID and SAT_CRT.TEST_TY = 'V'
  left join #SAT SAT_MAT ON stdnt.STUDENT_ID = SAT_MAT.STUDENT_ID and SAT_MAT.TEST_TY = 'M'
  left join #SAT SAT_WRT ON stdnt.STUDENT_ID = SAT_WRT.STUDENT_ID and SAT_WRT.TEST_TY = 'X'
  left join (select 
				stdnt_id
				,max(act_grad_dt) as grad_dt   
			FROM 
				[MIS].[dbo].[ST_STDNT_OBJ_AWD_A_178]
			where 
				pgm_stat = 'GR' 
			group by 
				stdnt_id) obj_gr_max ON obj_gr_max.stdnt_id = stdnt.student_id and obj.STDNT_ID is null and obj_prim.STDNT_ID is null
  LEFT JOIN [MIS].[dbo].[ST_STDNT_OBJ_AWD_A_178] obj_gr on stdnt.STUDENT_ID = obj_gr.STDNT_ID AND obj_gr.act_grad_dt = obj_gr_max.grad_dt
  LEFT JOIN #FTIC ftic ON ftic.[Case ID] = main.[Case ID]
  LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] curTerm ON stdnt.student_id = curterm.stdnt_id and curTerm.TRM_YR = '20163'
  LEFT JOIN #Credits cred on main.[Case ID] = cred.[Case ID]
  LEFT JOIN #Fees fees on main.[Case ID] = fees.[Case ID]
  LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON main.[Student ID] = WSTDNT.[WW_ST_SID] 
  LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] and aidyr.WF_AID_YEAR = '2016'
  LEFT JOIN (SELECT
					class.STDNT_ID
					,MAX(class.CRS_ID) AS CRS_ID
			FROM
				MIS.dbo.ST_STDNT_CLS_A_235 class
			WHERE
				LEFT(class.EFF_TRM, 4) = '2012'
			GROUP BY
				class.STDNT_ID) class2012 ON class2012.STDNT_ID = main.[Student ID]
  LEFT JOIN (SELECT
				*
				,ROW_NUMBER() OVER (PARTITION BY obj.STDNT_ID ORDER BY obj.EFF_TERM DESC) RN
			FROM
				MIS.dbo.ST_STDNT_OBJ_AWD_A_178 obj
			WHERE
				PGM_STAT <> 'IN'
				AND ADMT_STAT = 'Y'
				AND PRIM_FLG = '1') lstdeggranted ON lstdeggranted.STDNT_ID = main.[Student ID]
										          AND lstdeggranted.RN = 1
  --WHERE OBJ.STDNT_ID IS NULL AND obj_prim.STDNT_ID IS NULL AND obj_gr.STDNT_ID is null
ORDER BY
	[Case ID]
