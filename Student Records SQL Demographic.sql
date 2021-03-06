/****** Script for SelectTopNRows command from SSMS  ******/
SELECT '1' 
      , [Institute ID]
      ,main.[Study ID]
	  ,stdnt.STUDENT_ID
      ,[First Name]
      ,stdnt.MDL_NM
      ,[Last Name]
	  ,stdnt.APPEND
	  ,stdnt.STUDENT_ID
	  ,substring(stdnt.dob,5,2) as DOB_Month
	  ,substring(stdnt.dob,7,2) as DOB_Day
	  ,substring(stdnt.dob,1,4) as DOB_Year
	  , case 
	      when stdnt.sex = 'M' then '0'
		  when stdnt.sex = 'F' then '1'
		  else '-1' end as Gender
	  ,'-1' as marital_status
	  ,isnull(fname.FRMR_LST_NM,'') as maiden_name
	  ,'' as Spouse_First_Name
	  ,'' as Spouse_Mid_Name
	  ,'' as Spouse_Last_Name
	  ,case
	      when stdnt.[IMMIG_STAT] = 'C' then '1'
		  when stdnt.[IMMIG_STAT] in ('P','RE')  then '2'   -- Resident alien, permanent resident, or other eligible non-citizen
		  when stdnt.[IMMIG_STAT] = 'F' then '3'   -- Foreign/International Student or Non-resident Alien
		  else '-1' end as Citizen_Status
	  ,case  
	      when va.VA_VSD_STATUS = 'V' then '1'
		  else '-1' end as Vet_Stat
	  , case 
	      when ext_cred.[DIPL_TYPE] IN ('W06','W43','WFT') then '1'
		  when ext_cred.[DIPL_TYPE] IN ('W10','W45','WGD','OSGE') then '2'
		  when ext_cred.[DIPL_TYPE] = 'FORN' then '4'
		  when ext_cred.[DIPL_TYPE] = 'HOME' THEN '5'
		  else '-1' END AS HS_COMPL_TYPE
	  , isnull(substring(ext_cred.ACT_GRAD_DT,1,4),'') as HS_Comp_year
	  , case 
	      when [ETHNICITY] = 'H' then '1'
		  when [ETHNICITY] = 'N' then '0'
		  else '-1' end as 'Ethnicity'
	  , case
	      when RACE_WHITE.ISN_ST_STDNT_A IS NOT NULL THEN '1' 
		  else '0' end as 'RACE:WHITE'
	  , case
	      when RACE_BLACK.ISN_ST_STDNT_A IS NOT NULL THEN '1' 
		  else '0' end as 'RACE:BLACK'
	  , case
	      when RACE_ASIAN.ISN_ST_STDNT_A IS NOT NULL THEN '1' 
		  else '0' end as 'RACE:ASIAN'
	  , case
	      when RACE_INDIAN.ISN_ST_STDNT_A IS NOT NULL THEN '1' 
		  else '0' end as 'RACE:AMER_INDIAN_OR_ALASKA'
	  , case
	      when RACE_PACIFIC.ISN_ST_STDNT_A IS NOT NULL THEN '1' 
		  else '0' end as 'RACE:HAW_OR_PAC'
	  , case 
	    when addr.[STREET_1] is null then isnull(l_addr.[STREET_1],'')
		  else isnull(addr.[STREET_1],'') end as 'Perm_Addr_Line1'
	  , case
	    when addr.[STREET_2] is null then isnull(l_addr.[STREET_2],'')
	      else isnull(addr.[STREET_2],'') end as 'Perm_Addr_Line2'
	  , case
	    when addr.[CITY] is null then isnull(l_addr.[CITY],'') 
		  else isnull(addr.[CITY],'') end as 'Perm_City'
	  , case
	    when addr.[STATE] is null then isnull(l_addr.[STATE],'') 
		  else isnull(addr.[STATE],'') end as 'Perm_State'
	  , case
	    when addr.[ZIP_CD] is null then isnull(l_addr.[ZIP_CD],'')
		  else isnull(addr.[ZIP_CD],'') end as 'Perm_Zip'
	  ,'' as 'Perm_Country'
      , case  
	    when term.[RES_ST_CD] = 'FL' then '1'
		when term.[RES_ST_CD] in  ('57','') then '-1'
		else '0' end as 'Perm_Resident'
	  , isnull(l_addr.[STREET_1],'') as 'Local_Addr_Line1'
	  , isnull(l_addr.[STREET_2],'') as 'Local_Addr_Line2'
	  , isnull(l_addr.[CITY],'') as 'Local_City'
	  , isnull(l_addr.[STATE],'') as 'Local_State'
	  , isnull(l_addr.[ZIP_CD],'') as 'Local_Zip'
	  ,  [Phone_1] as 'Phone_1'
	  , '1' as 'Phone_1_type'
	  , [Phone_2] as 'Phone_2'
	  ,'2' as 'Phone_2_type'
	  ,stdnt.[FCCJ_EMAIL_ADDR] as 'Campus_Email'
	  ,stdnt.[EMAIL_ADDR] as 'Personal_Email'
	  ,'' as 'Parent_First_Name'
	  ,'' as 'Parent_Mid_Name'
	  ,'' as 'Parent_Last_Name'
	  ,'' as 'Parent_Suffix'
	  ,'' as 'Parent_Address_Line_1'
	  ,'' as 'Parent_Address_Line_2'
	  ,'' as 'Parent_City'
	  ,'' as 'Parent_State'
	  ,'' as 'Parent_Zip'
	  ,'' as 'Parent_Country'
	  ,'' as 'Parent_Email'
	  ,'' as 'Parent_Phone'
	  ,'' as 'Parent_Cell'
	  ,'' as 'Parent_Intnl_Phone'
	  ,'' as 'Other_First_Name'
	  ,'' as 'Other_Mid_Name'
	  ,'' as 'Other_Last_Name'
	  ,'' as 'Other_Suffix'
	  ,'-1' as 'Other_Relat'
	  ,'' as 'Other_Address_Line_1'
	  ,'' as 'Other_Address_Line_2'
	  ,'' as 'Other_City'
	  ,'' as 'Other_State'
	  ,'' as 'Other_Zip'
	  ,'' as 'Other_Country'
	  ,'' as 'Other_Email'
	  ,'' as 'Other_Phone'
	  ,'' as 'Other_Cell'
	  ,'' as 'Addl_First_Name'
	  ,'' as 'Addl_Mid_Name'
	  ,'' as 'Addl_Last_Name'
	  ,'' as 'Addl_Suffix'
	  ,'' as 'Addl_Phone'
	  ,'-1' as 'Addl_Relat'
  FROM [Adhoc].[dbo].['Student List$'] main
  INNER JOIN [MIS].[dbo].[ST_STDNT_SSN_SID_XWALK_606] xwlk ON main.[Student ID] = xwlk.STUDENT_ID
  INNER JOIN [MIS].[dbo].[ST_STDNT_A_125] stdnt ON xwlk.STUDENT_SSN = stdnt.STUDENT_ID
  LEFT JOIN [MIS].[dbo].[ST_ADDRESSES_A_153] addr on stdnt.STUDENT_ID = ADDR.[STUDENT_ID] AND ADDR.[ADDR_TY] = '02'
  LEFT JOIN [MIS].[dbo].[ST_ADDRESSES_A_153] l_addr on stdnt.STUDENT_ID = L_ADDR.[STUDENT_ID] AND L_ADDR.[ADDR_TY] = '01'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_FORMER_NAME_125] fname on xwlk.STUDENT_SSN = fname.[STUDENT_ID] and fname.[cnxarraycolumn] = 0 and stdnt.LST_NM != fname.FRMR_LST_NM
  LEFT JOIN [MIS].[dbo].[ST_EXTRNL_CRDNTL_A_141] ext_cred on stdnt.student_id = ext_cred.STDNT_ID and ext_cred.[CRDNTL_CD] = 'HC' and [EVAL_CD] = 'Y' AND ACT_GRAD_DT != ''
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_RACE_125] RACE_WHITE ON RACE_WHITE.ISN_ST_STDNT_A = STDNT.ISN_ST_STDNT_A AND RACE_WHITE.RACE = 'W'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_RACE_125] RACE_BLACK ON RACE_BLACK.ISN_ST_STDNT_A = STDNT.ISN_ST_STDNT_A AND RACE_BLACK.RACE = 'B'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_RACE_125] RACE_ASIAN ON RACE_ASIAN.ISN_ST_STDNT_A = STDNT.ISN_ST_STDNT_A AND RACE_ASIAN.RACE = 'A'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_RACE_125] RACE_INDIAN ON RACE_INDIAN.ISN_ST_STDNT_A = STDNT.ISN_ST_STDNT_A AND RACE_INDIAN.RACE = 'I'
  LEFT JOIN [MIS].[dbo].[ST_STDNT_A_RACE_125] RACE_PACIFIC ON RACE_PACIFIC.ISN_ST_STDNT_A = STDNT.ISN_ST_STDNT_A AND RACE_PACIFIC.RACE = 'P'
  LEFT JOIN (SELECT STDNT_ID, MAX(TRM_YR) AS TERM
					FROM [MIS].[dbo].[ST_STDNT_TERM_A_236] 
					WHERE TRM_YR IN ('20153','20161','20162','20163')
					GROUP BY STDNT_ID) term_info on term_info.stdnt_id = stdnt.student_id
  LEFT JOIN [MIS].[dbo].[ST_STDNT_TERM_A_236] TERM on TERM.TRM_YR = TERM_INFO.TERM AND TERM.STDNT_ID = STDNT.STUDENT_ID
  LEFT JOIN [MIS].[dbo].[ST_VA_INT_A_212] va ON va.[VA_H_STDNT_ID] = stdnt.student_id
  LEFT JOIN [Adhoc].[dbo].[NPSAS_PHONE_NUMBERS] pn ON pn.[Study ID] = main.[Study ID]
  WHERE main.[Student ID] != ''
  ORDER BY MAIN.SSN