IF OBJECT_ID ('tempdb..#State_Awards_Det') IS NOT NULL
	DROP TABLE #State_Awards_Det
IF OBJECT_ID ('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp

SELECT DISTINCT xwlk.STUDENT_SSN
	,CASE
		WHEN substring(award.[WF_FUND_ID],3,2) = 'BF' THEN '2'
	ELSE '1' END AS AID_TYPE
	,AWARD.WF_AW_DIS AS State_Loan_Amt
	,fund.[WF_FU_NAME] AS State_Fund_Name
INTO 
	#State_Awards_Det
FROM 
	[Adhoc].[dbo].[NPSASSurveyStudents] main
	INNER  JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
	INNER  JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
	INNER  JOIN [MIS].[dbo].[WF_AWARD_810] award ON wstdnt.[WW_STUDENT_ID] = award.[WW_STUDENT_ID] 
											AND  substring(award.[WF_FUND_ID],1,2) = 'FL' 
											AND  award.WF_AID_YEAR = '2016' 
											AND  award.WF_AW_DIS > 0
	INNER  JOIN [MIS].[dbo].[WF_FUND_817] fund ON award.wf_aid_year = fund.[WW_FISCAL_YEAR] 
											   AND  award.wf_fund_id = fund.wf_fund_id
ORDER BY 
	XWLK.STUDENT_SSN

IF OBJECT_ID ('tempdb..#State_Awards') IS NOT NULL
	DROP TABLE #State_Awards

SELECT 
	STUDENT_SSN
	,AID_TYPE
	,State_Loan_Amt
	,State_Fund_Name
	,ROW_NUMBER() OVER (PARTITION BY STUDENT_SSN ORDER BY AID_TYPE) AS Row_Num
INTO 
	#State_Awards
FROM 
	#State_Awards_Det s_awd

IF OBJECT_ID ('tempdb..#Inst_Award') IS NOT NULL
	DROP TABLE #Inst_Award




SELECT
	main.[Institute ID]
	,main.[Case ID]
	,main.SSN
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2011-12]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2012-13]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2013-14]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2014-15]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2015-16]
	,CAST('' AS VARCHAR(MAX)) AS [Enrolled 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Warning 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Prob 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Inelig 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Pell 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_subLoan 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_unsubLoan 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Parent_PLUS 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Grad_PLUS 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Teach_Grant 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Perkins_Grant 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_SEOG_Grant 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Work_Study 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [FA_Service_Grant 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Veterans_Benefit 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State1_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State2_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [State3_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst1_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst2_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Inst3_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad1_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad2_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Grad3_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv1_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv2_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Priv3_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr_Aid 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Source 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr1_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Source 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr2_Amt 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Name 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Type 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Source 2016-17]
	,CAST('' AS VARCHAR(MAX)) AS [Othr3_Amt 2016-17]
INTO
	#temp
FROM
	Adhoc.dbo.NPSASSurveyStudents main

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
SELECT DISTINCT 
	xwlk.STUDENT_SSN
	,CASE
		WHEN substring(award.[WF_FUND_ID],3,2) = ''AM'' THEN 2
		WHEN substring(award.[WF_FUND_ID],3,2) = ''PS'' THEN 3
		WHEN award.[WF_FUND_ID] = ''IFSIGSN'' THEN 4
	ELSE 1 END AS AID_TYPE
	,AWARD.WF_AW_DIS AS Loan_Amt
	,fund.[WF_FU_NAME] AS Inst_Fund_Name
INTO 
	#Inst_Award
FROM
	[Adhoc].[dbo].[NPSASSurveyStudents] main
	INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
	INNER JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
	INNER JOIN [MIS].[dbo].[WF_AWARD_810] award ON wstdnt.[WW_STUDENT_ID] = award.[WW_STUDENT_ID] 
												AND substring(award.[WF_FUND_ID],1,2) = ''IF'' 
												AND award.WF_AID_YEAR = ''' + @curYearString + ''' AND award.WF_AW_DIS > 0
	INNER JOIN [MIS].[dbo].[WF_FUND_817] fund ON award.wf_aid_year = fund.[WW_FISCAL_YEAR] 
											  AND award.wf_fund_id = fund.wf_fund_id
ORDER BY 
	XWLK.STUDENT_SSN

UPDATE main
	SET [Enrolled ' + @academicYear + '] = CASE
										WHEN class' + @curYearString + '.STDNT_ID IS NOT NULL THEN ''1''
										ELSE ''0''
									END
	,[FA_Warning ' + @academicYear + '] = CASE
									WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
									WHEN WF_AY_S_RT1_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
									WHEN WF_AY_S_RT2_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
									WHEN WF_AY_S_RT3_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
									ELSE ''0'' END
	,[FA_Prob ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[FA_Inelig ' + @academicYear + '] = CASE
								WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
								WHEN WF_AY_S_RT1_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
								WHEN WF_AY_S_RT2_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
								WHEN WF_AY_S_RT3_SAP in (''B'',''E'',''G'',''H'',''T'') THEN ''1''
								ELSE ''0'' END 
	,[FA_Aid ' + @academicYear + '] = CASE 
							WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
							WHEN fedpell.[WF_AW_DIS] > 0 THEN ''1''
							WHEN fedsub.[WF_AW_DIS] > 0 THEN ''1''
							WHEN fedunsub.[WF_AW_DIS] > 0 THEN ''1''
							WHEN fedplus.[WF_AW_DIS] > 0 THEN ''1''
							WHEN fedseog.[WF_AW_DIS] > 0 THEN ''1''
							WHEN fedcws.[WF_AW_DIS] > 0 THEN ''1''
							ELSE ''0'' END 
	,[FA_Pell ' + @academicYear + '] = CASE
										WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
										ELSE CAST(ISNULL(fedpell.[WF_AW_DIS],0) AS VARCHAR)
										END
	,[FA_subLoan ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(isnull(fedsub.[WF_AW_DIS],0) AS VARCHAR) END
	,[FA_unsubLoan ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(isnull(fedunsub.[WF_AW_DIS],0) AS VARCHAR) END
	,[FA_Parent_PLUS ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(isnull(fedplus.[WF_AW_DIS],0) AS VARCHAR) END
	,[FA_Grad_PLUS ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END  
	,[FA_Teach_Grant ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[FA_Perkins_Grant ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[FA_SEOG_Grant ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(isnull(fedseog.[WF_AW_DIS],0) AS VARCHAR) END
	,[FA_Work_Study ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE CAST(isnull(fedcws.[WF_AW_DIS] + fedswso.[WF_AW_DIS],0) AS VARCHAR) END
	,[FA_Service_Grant ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[Veterans_Benefit ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[State_Aid ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''  
											WHEN s_awd.student_ssn IS NOT NULL THEN ''1''
											ELSE ''0'' END  
	,[State1_Name ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s_awd.student_ssn IS NOT NULL THEN s_awd.State_Fund_Name 
											ELSE ''0'' END 
	,[State1_Type ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s_awd.student_ssn IS NOT NULL THEN s_awd.AID_TYPE 
											ELSE ''0'' END 
	,[State1_Amt ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s_awd.student_ssn IS NOT NULL THEN CAST(s_awd.State_Loan_Amt AS VARCHAR)
											ELSE ''0'' END 
	,[State2_Name ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s2_awd.student_ssn IS NOT NULL THEN s2_awd.State_Fund_Name 
											ELSE ''0'' END 
	,[State2_Type ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s2_awd.student_ssn IS NOT NULL THEN s2_awd.AID_TYPE 
											ELSE ''0'' END 
	,[State2_Amt ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN s2_awd.student_ssn IS NOT NULL THEN CAST(s2_awd.State_Loan_Amt AS VARCHAR)
											ELSE ''0'' END 
	,[State3_Name ' + @academicYear + '] = '''' 
	,[State3_Type ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[State3_Amt ' + @academicYear + '] = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst_Aid ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN i_awd.student_ssn IS NOT NULL THEN ''1''
											ELSE ''0'' END 
	,[Inst1_Name ' + @academicYear + '] = CASE 
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN i_awd.student_ssn IS NOT NULL THEN i_awd.Inst_Fund_Name 
											ELSE ''0'' END
	,[Inst1_Type ' + @academicYear + '] = CASE 
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN i_awd.student_ssn IS NOT NULL THEN CAST(i_awd.AID_TYPE AS VARCHAR)
											ELSE ''0'' END 
	,[Inst1_Amt ' + @academicYear + '] = CASE 
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN i_awd.student_ssn IS NOT NULL THEN CAST(i_awd.Loan_Amt AS VARCHAR)
											ELSE ''0'' END  
	,[Inst2_Name ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst2_Type ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst2_Amt ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst3_Name ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst3_Type ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Inst3_Amt ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad_Aid ' + @academicYear + '] =	    CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[Grad1_Type ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad1_Amt ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad2_Type ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad2_Amt ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad3_Type ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Grad3_Amt ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Priv_Aid ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN ''''
											WHEN altawd.[WW_STUDENT_ID] IS NOT NULL THEN ''1''
											ELSE ''0'' END 
	,[Priv1_Type ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN altawd.[WW_STUDENT_ID] IS NOT NULL THEN ''6''
											ELSE ''0'' END 
	,[Priv1_Amt ' + @academicYear + '] = CASE
											WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' 
											WHEN altawd.[WW_STUDENT_ID] IS NOT NULL THEN CAST(altawd.WF_AW_DIS AS VARCHAR)
											ELSE ''0'' END 
	,[Priv2_Type ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Priv2_Amt ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Priv3_Type ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Priv3_Amt ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr_Aid ' + @academicYear + ']	  = CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END
	,[Othr1_Name ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr1_Type ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr1_Source ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr1_Amt ' + @academicYear + ']  =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr2_Name ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr2_Type ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr2_Source ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr2_Amt ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr3_Name ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr3_Type ' + @academicYear + ']   =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr3_Source ' + @academicYear + '] =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
	,[Othr3_Amt ' + @academicYear + ']  =	CASE WHEN class' + @curYearString + '.STDNT_ID IS NULL THEN '''' ELSE ''0'' END 
FROM 
	#temp main
	INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON main.SSN = stdnt.STUDENT_ID
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
					class.STDNT_ID) class' + @curYearString + ' ON class' + @curYearString + '.STDNT_ID = main.SSN
	LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON main.SSN = WSTDNT.[WW_ST_SID] 
	LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] 
												 AND aidyr.WF_AID_YEAR = ''' + @curYearString + '''
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedpell ON wstdnt.[WW_STUDENT_ID] = fedpell.[WW_STUDENT_ID] 
												 AND fedpell.[WF_FUND_ID] = ''FEDPELL'' 
												 AND fedpell.WF_AID_YEAR = ''' + @curYearString + ''' 
												 AND fedpell.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedsub ON wstdnt.[WW_STUDENT_ID] = fedsub.[WW_STUDENT_ID] 
												AND fedsub.[WF_FUND_ID] = ''FEDDLSUB'' 
												AND fedsub.WF_AID_YEAR = ''' + @curYearString + ''' 
												AND fedsub.WF_AW_DIS > 0 
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedunsub ON wstdnt.[WW_STUDENT_ID] = fedunsub.[WW_STUDENT_ID] 
												  AND fedunsub.[WF_FUND_ID] = ''FEDDLUNSB'' 
												  AND fedunsub.WF_AID_YEAR = ''' + @curYearString + ''' 
												  AND fedunsub.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedplus ON wstdnt.[WW_STUDENT_ID] = fedplus.[WW_STUDENT_ID] 
												 AND fedplus.[WF_FUND_ID] = ''FEDDLPLUS'' 
												 AND fedplus.WF_AID_YEAR = ''' + @curYearString + ''' 
												 AND fedplus.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedseog ON wstdnt.[WW_STUDENT_ID] = fedseog.[WW_STUDENT_ID] 
												 AND fedseog.[WF_FUND_ID] = ''FEDSEOG'' 
												 AND fedseog.WF_AID_YEAR = ''' + @curYearString + ''' 
												 AND fedseog.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedcws ON wstdnt.[WW_STUDENT_ID] = fedcws.[WW_STUDENT_ID] 
												AND fedcws.[WF_FUND_ID] = ''FEDCWS'' 
												AND fedcws.WF_AID_YEAR = ''' + @curYearString + ''' 
												AND fedcws.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] fedswso ON wstdnt.[WW_STUDENT_ID] = fedswso.[WW_STUDENT_ID] 
												 AND fedswso.[WF_FUND_ID] = ''FEDSWSO'' 
												 AND fedswso.WF_AID_YEAR = ''' + @curYearString + ''' 
												 AND fedswso.WF_AW_DIS > 0
	LEFT JOIN [MIS].[dbo].[WF_AWARD_810] altawd ON wstdnt.[WW_STUDENT_ID] = altawd.[WW_STUDENT_ID] 
												AND (altawd.[WF_FUND_ID] = ''ALTLOAN'' 
												OR SUBSTRING(ALTAWD.[WF_FUND_ID],1,2) = ''PD'') 
												AND altawd.WF_AID_YEAR = ''' + @curYearString + ''' 
												AND altawd.WF_AW_DIS > 0
	LEFT JOIN #State_Awards s_awd ON s_awd.STUDENT_SSN = main.SSN 
								  AND s_awd.Row_Num = 1
	LEFT JOIN #State_Awards s2_awd ON s2_awd.STUDENT_SSN = main.SSN 
								   AND s2_awd.Row_num = 2
	LEFT JOIN #Inst_Award i_awd ON i_awd.STUDENT_SSN = main.SSN')

	SET @curYear = @curYear + 1

END

SELECT
	*
FROM
	#temp