  IF OBJECT_ID ('tempdb..#State_Awards_Det') IS NOT NULL
	DROP TABLE #State_Awards_Det

SELECT distinct xwlk.STUDENT_SSN
  ,case
     when substring(award.[WF_FUND_ID],3,2) = 'BF' THEN '2'
	 else '1' end as AID_TYPE
  , AWARD.WF_AW_DIS as State_Loan_Amt
  ,fund.[WF_FU_NAME] as State_Fund_Name
 INTO #State_Awards_Det
  FROM [Adhoc].[dbo].['Student List$'] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
  inner JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
  inner join [MIS].[dbo].[WF_AWARD_810] award ON wstdnt.[WW_STUDENT_ID] = award.[WW_STUDENT_ID] and substring(award.[WF_FUND_ID],1,2) = 'FL' AND award.WF_AID_YEAR = '2016' AND award.WF_AW_DIS > 0
  inner join [MIS].[dbo].[WF_FUND_817] fund on award.wf_aid_year = fund.[WW_FISCAL_YEAR] and award.wf_fund_id = fund.wf_fund_id
  ORDER BY XWLK.STUDENT_SSN

  IF OBJECT_ID ('tempdb..#State_Awards') IS NOT NULL
	DROP TABLE #State_Awards

SELECT STUDENT_SSN, AID_TYPE, State_Loan_Amt, State_Fund_Name
 ,ROW_NUMBER() OVER (PARTITION BY STUDENT_SSN ORDER BY AID_TYPE) as Row_Num
into #State_Awards
FROM #State_Awards_Det s_awd

  IF OBJECT_ID ('tempdb..#Inst_Award') IS NOT NULL
	DROP TABLE #Inst_Award

SELECT distinct xwlk.STUDENT_SSN
  ,case
     when substring(award.[WF_FUND_ID],3,2) = 'AM' THEN '2'
	 when substring(award.[WF_FUND_ID],3,2) = 'PS' THEN '3'
	 when award.[WF_FUND_ID] = 'IFSIGSN' THEN '4'
	 else '1' end as AID_TYPE
  , AWARD.WF_AW_DIS AS Loan_Amt
  , fund.[WF_FU_NAME] as Inst_Fund_Name
 INTO #Inst_Award
  FROM [Adhoc].[dbo].['Student List$'] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
  inner JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
  inner join [MIS].[dbo].[WF_AWARD_810] award ON wstdnt.[WW_STUDENT_ID] = award.[WW_STUDENT_ID] and substring(award.[WF_FUND_ID],1,2) = 'IF' AND award.WF_AID_YEAR = '2016' AND award.WF_AW_DIS > 0
  inner join [MIS].[dbo].[WF_FUND_817] fund on award.wf_aid_year = fund.[WW_FISCAL_YEAR] and award.wf_fund_id = fund.wf_fund_id
  ORDER BY XWLK.STUDENT_SSN


  SELECT 
  --main.SSN
  main.[Institute ID]
  ,main.[Study ID]
  ,case 
    when WF_AY_S_RT1_SAP in ('B','E','G','H','T') then '1'
	when WF_AY_S_RT2_SAP in ('B','E','G','H','T') then '1'
	when WF_AY_S_RT3_SAP in ('B','E','G','H','T') then '1'
	 else '0' end as FA_Warning
  ,0 as FA_Prob
  ,case 
    when WF_AY_S_RT1_SAP in ('B','E','G','H','T') then '1'
	when WF_AY_S_RT2_SAP in ('B','E','G','H','T') then '1'
	when WF_AY_S_RT3_SAP in ('B','E','G','H','T') then '1'
	 else '0' end as FA_Inelig
  ,case 
    when fedpell.[WF_AW_DIS]> 0 then '1'
	when fedsub.[WF_AW_DIS]> 0 then '1'
	when fedunsub.[WF_AW_DIS]> 0 then '1'
	when fedplus.[WF_AW_DIS]> 0 then '1'
	when fedseog.[WF_AW_DIS]> 0 then '1'
	when fedcws.[WF_AW_DIS]> 0 then '1'
	else '0' end as FA_Aid
  ,isnull(fedpell.[WF_AW_DIS],0) as FA_Pell
  ,isnull(fedsub.[WF_AW_DIS],0) as FA_subLoan
  ,isnull(fedunsub.[WF_AW_DIS],0) as FA_unsubLoan
  ,isnull(fedplus.[WF_AW_DIS],0) as FA_Parent_PLUS
  ,0 as FA_Grad_PLUS
  ,0 as FA_Teach_Grant
  ,0 as FA_Perkins_Grant
  ,isnull(fedseog.[WF_AW_DIS],0) as FA_SEOG_Grant
  ,isnull(fedcws.[WF_AW_DIS] + fedswso.[WF_AW_DIS],0) as FA_Work_Study
  ,0 as FA_Service_Grant
  ,'' as Veterans_Benefit
  ,case  
    when s_awd.student_ssn is not null then '1'
	else '0' end  as State_Aid
  ,case when s_awd.student_ssn is not null then s_awd.State_Fund_Name else '' end as State1_Name
  ,case when s_awd.student_ssn is not null then s_awd.AID_TYPE else '' end as State1_Type
  ,case when s_awd.student_ssn is not null then cast(s_awd.State_Loan_Amt as varchar) else '' end as State1_Amt
  ,case when s2_awd.student_ssn is not null then s2_awd.State_Fund_Name else '' end as State2_Name
  ,case when s2_awd.student_ssn is not null then s2_awd.AID_TYPE else '' end as State2_Type
  ,case when s2_awd.student_ssn is not null then cast(s2_awd.State_Loan_Amt as varchar) else '' end as State2_Amt
  ,'' as State3_Name
  ,'' as State3_Type
  ,'' as State3_Amt
  ,case
    when i_awd.student_ssn is not null then '1'
	else '0' end as Inst_Aid  
  ,case when i_awd.student_ssn is not null then i_awd.Inst_Fund_Name else '' end as Inst1_Name
  ,case when i_awd.student_ssn is not null then i_awd.AID_TYPE else '' end as Inst1_Type
  ,case when i_awd.student_ssn is not null then cast(i_awd.Loan_Amt as varchar) else '' end as Inst1_Amt
  ,'' as Inst2_Name
  ,'' as Inst2_Type
  ,'' as Inst2_Amt
  ,'' as Inst3_Name
  ,'' as Inst3_Type
  ,'' as Inst3_Amt
  ,'0' as Grad_Aid  
  ,'' as Grad1_Type
  ,'' as Grad1_Amt
  ,'' as Grad2_Type
  ,'' as Grad2_Amt
  ,'' as Grad3_Type
  ,'' as Grad3_Amt
  ,case
    when altawd.[WW_STUDENT_ID] is not null then '1' 
    else '0' end as Priv_Aid  
  ,case when altawd.[WW_STUDENT_ID] is not null then '6'
    else '' end as Priv1_Type
  ,case when altawd.[WW_STUDENT_ID] is not null then cast(altawd.WF_AW_DIS as varchar)
    else '' end as Priv1_Amt
  ,'' as Priv2_Type
  ,'' as Priv2_Amt
  ,'' as Priv3_Type
  ,'' as Priv3_Amt
  ,'0' as Othr_Aid  
  ,'' as Othr1_Name
  ,'' as Othr1_Type
  ,'' as Othr1_Source
  ,'' as Othr1_Amt
  ,'' as Othr2_Name
  ,'' as Othr2_Type
  ,'' as Othr2_Source
  ,'' as Othr2_Amt
  ,'' as Othr3_Name
  ,'' as Othr3_Type
  ,'' as Othr3_Source
  ,'' as Othr3_Amt
  FROM [Adhoc].[dbo].['Student List$'] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
  INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON xwlk.STUDENT_SSN = stdnt.STUDENT_ID
  LEFT JOIN [MIS].[dbo].[WW_STUDENT_822] wstdnt ON xwlk.student_SSN = WSTDNT.[WW_ST_SID] 
  LEFT JOIN [MIS].[dbo].[WF_AIDYEAR_825] aidyr ON wstdnt.[WW_STUDENT_ID] = aidyr.[WW_STUDENT_ID] and aidyr.WF_AID_YEAR = '2016'
  left join [MIS].[dbo].[WF_AWARD_810] fedpell ON wstdnt.[WW_STUDENT_ID] = fedpell.[WW_STUDENT_ID] and fedpell.[WF_FUND_ID] = 'FEDPELL' AND fedpell.WF_AID_YEAR = '2016' and fedpell.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] fedsub ON wstdnt.[WW_STUDENT_ID] = fedsub.[WW_STUDENT_ID] and fedsub.[WF_FUND_ID] = 'FEDDLSUB' AND fedsub.WF_AID_YEAR = '2016' and fedsub.WF_AW_DIS > 0 
  left join [MIS].[dbo].[WF_AWARD_810] fedunsub ON wstdnt.[WW_STUDENT_ID] = fedunsub.[WW_STUDENT_ID] and fedunsub.[WF_FUND_ID] = 'FEDDLUNSB' AND fedunsub.WF_AID_YEAR = '2016' and fedunsub.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] fedplus ON wstdnt.[WW_STUDENT_ID] = fedplus.[WW_STUDENT_ID] and fedplus.[WF_FUND_ID] = 'FEDDLPLUS' AND fedplus.WF_AID_YEAR = '2016' and fedplus.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] fedseog ON wstdnt.[WW_STUDENT_ID] = fedseog.[WW_STUDENT_ID] and fedseog.[WF_FUND_ID] = 'FEDSEOG' AND fedseog.WF_AID_YEAR = '2016' and fedseog.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] fedcws ON wstdnt.[WW_STUDENT_ID] = fedcws.[WW_STUDENT_ID] and fedcws.[WF_FUND_ID] = 'FEDCWS' AND fedcws.WF_AID_YEAR = '2016' and fedcws.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] fedswso ON wstdnt.[WW_STUDENT_ID] = fedswso.[WW_STUDENT_ID] and fedswso.[WF_FUND_ID] = 'FEDSWSO' AND fedswso.WF_AID_YEAR = '2016' and fedswso.WF_AW_DIS > 0
  left join [MIS].[dbo].[WF_AWARD_810] altawd ON wstdnt.[WW_STUDENT_ID] = altawd.[WW_STUDENT_ID] and (altawd.[WF_FUND_ID] = 'ALTLOAN' OR SUBSTRING(ALTAWD.[WF_FUND_ID],1,2) = 'PD') AND altawd.WF_AID_YEAR = '2016' and altawd.WF_AW_DIS > 0
  left join #State_Awards s_awd ON s_awd.STUDENT_SSN = XWLK.STUDENT_SSN and s_awd.Row_Num = 1
  left join #State_Awards s2_awd ON s2_awd.STUDENT_SSN = XWLK.STUDENT_SSN and s2_awd.Row_num = 2
  left join #Inst_Award i_awd ON i_awd.STUDENT_SSN = XWLK.STUDENT_SSN
  
<<<<<<< HEAD
order by main.[Case ID]
=======
  order by main.[Study ID]

  --select * from #State_Awards
>>>>>>> parent of 2b3370f... Changed structure
