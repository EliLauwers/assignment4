#sigma

-- Contracts
@masking:string
@single_blind:string
@open:string
@double_blind:string

--Domain constraints

open notin {'No','Yes'}
single_blind notin {'No','Yes'}
double_blind notin {'No','Yes'}
masking notin {'0','1','2','>2'}

--Interaction constraints

masking in {'1'} & single_blind in {'No'}
single_blind in {'Yes'} & open in {'Yes'}
single_blind in {'Yes'} & double_blind in {'Yes'}
masking in {'0','1'} & double_blind in {'Yes'}
double_blind in {'Yes'} & open in {'Yes'}
masking in {'2'} & double_blind in {'No'}
masking in {'1'} & open in {'Yes'}
masking in {'2'} & single_blind in {'Yes'}
masking in {'2'} & open in {'Yes'}
masking in {'0'} & single_blind in {'Yes'}

#assertions


#fd

