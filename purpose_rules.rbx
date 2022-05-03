#sigma

-- Contracts
@ctgov_study_type:string
@drks_study_type:string
@study_type_non_interventional:string
@observation_model:string
@ctgov_purpose:string
@drks_purpose:string


--Domain constraints
ctgov_study_type notin {'Interventional','Observational','Observational [Patient Registry]'}
drks_study_type notin {'Interventional','Non-interventional'}
study_type_non_interventional notin {'Epidemiological study', 'N/A','Observational study','Other'}
observation_model notin {'Case Control','Case Crossover','Case Only','Cohort','Ecological or Community','N/A','Natural History','Other'}
ctgov_purpose notin {'Basic Science','Diagnostic','Health Services Research', 'Other','Prevention','Screening','Supportive Care','Treatment'}
drks_purpose notin {'Basic research/physiological study','Diagnostic','Health care system', 'Other','Prevention','Prognosis','Screening','Supportive care','Treatment'}

--Interaction constraints
