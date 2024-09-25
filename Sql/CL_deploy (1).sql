--  for testing purposes old Credolab will used here
--  credolabScore_SCR
--  mainVersion_SCR
--  monthlyIncome_SCR
--  tsa_time_SCR
--  telco_name_SCR
with master as (
select 
cast(credolabScore as float64) as credolabScore,
----------------
ROUND(TIMESTAMP_DIFF(termsAndConditionsSubmitDateTime, tsa_onboarding_time, SECOND) / 3600.0, 2) AS tsa_time,
--------------------
cast(monthlyIncome as float64) as monthlyIncome,
--------------------
SPLIT(osVersion, '.')[OFFSET(0)] AS mainVersion,
--------------------
mobileNo
---------------------
from risk_credit_mis.loan_master_table 
)
--------------------------------------------------
select distinct  
w.credolabScore_SCR
 + w.mainVersion_SCR
 + w.monthlyIncome_SCR
 + w.tsa_time_SCR
 + w.telco_name_SCR
 as SCORE,
 w.*
from (
    select
    case
        when credolabScore < 450.5 then 74
        when credolabScore < 460.5 then 80
        when credolabScore < 528.5 then 88
        when credolabScore >= 528.5 then 104
        when credolabScore is null then 90
        else 90
        end as credolabScore_SCR,
    case
        when mainVersion = 'android10' then 80
        when mainVersion = 'android11' then 80
        when mainVersion = 'android12' then 82
        when mainVersion = 'android13' then 92
        when mainVersion = 'android14' then 92
        when mainVersion = 'android9' then 80
        when mainVersion = 'ios15' then 80
        when mainVersion = 'ios16' then 98
        when mainVersion = 'android6' then 80
        when mainVersion = 'android7' then 80
        when mainVersion = 'android8' then 80
        when mainVersion = 'ios12' then 80
        when mainVersion = 'ios13' then 80
        when mainVersion = 'ios14' then 80
        when mainVersion = 'ios17' then 98
        when mainVersion = 'na' then 80
        when mainVersion is null then 87
        else 87
        end as mainVersion_SCR,
    case
        when monthlyIncome < 42700 then 84
        when monthlyIncome < 81800 then 93
        when monthlyIncome >= 81800 then 104
        when monthlyIncome is null then 87
        else 87
        end as monthlyIncome_SCR,
    case
        when tsa_time < 0.195 then 76
        when tsa_time < 0.285 then 82
        when tsa_time >= 0.285 then 90
        when tsa_time is null then 87
        else 87
        end as tsa_time_SCR,
  CASE
    WHEN SUBSTR(mobileNo, 3, 3) IN ( '961',  '962', '963', '964', '968', '922', '923', '924', '925', '931', '932', '933', '934', '940', '941', '942', '943', '944', '973', '974', '991', '993', '895', '896', '897', '898', '992', '994','960', '965','966', '967', '969', '970', '981', '985', '987'  ) THEN 82
    WHEN SUBSTR(mobileNo, 3, 3) IN ('817', '904', '905', '906', '915', '916', '917', '926', '927', '935', '936', '945', '953', '954', '955', '956', '975', '976', '977', '978', '979', '995','996','997') THEN 88 
    WHEN SUBSTR(mobileNo, 3, 3) IN ( '813', '907', '908', '909', '910', '911', '912', '913', '914', '918', '919', '920', '921', '928', '929', '930', '938', '939', '946', '947', '948', '949', '950', '951', '998', '999') THEN 86
    ELSE 87 
  END AS telco_name_SCR
    from master
) w

