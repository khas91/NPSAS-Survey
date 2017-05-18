 -- IF OBJECT_ID ('tempdb..#MAXAIDYR') IS NOT NULL
	--DROP TABLE #MAXAIDYR

--SELECT distinct xwlk.STUDENT_SSN, AIDYR.WW_STUDENT_ID, MAX([WF_AID_YEAR]) AS MAX_AID_YR

-- --INTO #FSCJ_ENROLL
--  FROM [Adhoc].[dbo].['Student List$'] main
--  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
--  inner JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
--  inner JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.WW_STUDENT_ID = aidyr.ww_student_id
--  group by xwlk.STUDENT_SSN, AIDYR.ww_student_id 


  SELECT 
  --main.SSN
  main.[Institute ID]
  ,main.[Case ID]
  ,case  
     when [WW_ST_RT1_TIM] = 'F' AND [WW_ST_RT2_TIM] = 'F' AND [WW_ST_RT3_TIM] = 'F' then '1'
	 when [WW_ST_RT1_TIM] = 'F' OR [WW_ST_RT2_TIM] = 'F' OR [WW_ST_RT3_TIM] = 'F' then '2'
	 when [WW_ST_RT1_TIM] = 'T' AND [WW_ST_RT2_TIM] = 'T' AND [WW_ST_RT3_TIM] = 'T' then '3'
	 when [WW_ST_RT1_TIM] = 'T' OR [WW_ST_RT2_TIM] = 'T' OR [WW_ST_RT3_TIM] = 'T'then '4'
	 when [WW_ST_RT1_TIM] = 'H' AND [WW_ST_RT2_TIM] = 'H' AND [WW_ST_RT3_TIM] = 'T' then '5'
	 when [WW_ST_RT1_TIM] = 'H' OR [WW_ST_RT2_TIM] = 'H' OR [WW_ST_RT3_TIM] = 'T' then '6'
	 when [WW_ST_RT1_TIM] = 'L' AND [WW_ST_RT2_TIM] = 'L' AND [WW_ST_RT3_TIM] = 'L' then '7'
	 when [WW_ST_RT1_TIM] = 'L' OR [WW_ST_RT2_TIM] = 'L' OR [WW_ST_RT3_TIM] = 'L' then '8'
	 else '9'
	 end AS 'Budget_Period'
  ,'' as Stu_Residence
  ,ISNULL([WF_AY_M2_C1] + [WF_AY_M2_C2],0) as Tuition
  ,ISNULL([WF_AY_M2_C3],0) as Room_Board
  ,ISNULL([WF_AY_M2_C4],0) as Books_Supplies
  ,ISNULL([WF_AY_M2_C5],0) as Transportation
  ,0 as Computer_Tech
  ,0 as Health_Ins
  ,ISNULL([WF_AY_M2_C6],0) as All_Other
  ,ISNULL([WF_AY_M2_BUDGET],0) as Budget_COA
  FROM [Adhoc].[dbo].[NPSASSurveyStudents] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON main.SSN = stdnt.STUDENT_ID
  LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON main.SSN = WSTDNT.[WW_ST_SID] 
  LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] and aidyr.WF_AID_YEAR = '2017'
