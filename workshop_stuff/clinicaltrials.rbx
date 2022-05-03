#sigma

-- Contracts
@open:string
@single_blind:string
@double_blind:string
@masking:string

--Domain constraints
open notin {'Yes', 'No'}
single_blind notin {'Yes', 'No'}
double_blind notin {'Yes', 'No'}
masking notin {'0','1','2','>2'}

--Interaction constraints
open == 'Yes' & double_blind == 'Yes'
single_blind == 'Yes' & double_blind == 'Yes'
open == 'Yes' & single_blind == 'Yes'
single_blind == 'No' & masking == '1'
double_blind == 'No' & masking == '2'
double_blind == 'Yes' & masking in {'0','1'}
single_blind == 'Yes' & masking == '0'