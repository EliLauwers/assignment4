Assignment4 - Edit Rules - Eli Lauwers
================

# About this document

This document is the answer to the fourth databases assignment on
database edit rules. The workflow for this assignment is as follows.

# 1.Data exploration

Provide solutions to the following data exploration exercises related to
the data in the `purpose` table (so not the example data given in
Table1) in your report.

## Exercise 1.1

**assignment**: Get the total number of rows.

**Answer**: There are 1512 rows in the `purpose` table

``` bash
echo -e "SELECT * FROM purpose" | java -jar rulebox.jar explore stats --d ctgov_drks.json
```

    ## Reading data...
    ## SQL query:
    ## #Rows: 1512
    ## #Attributes: 6
    ## 
    ## Attribute: study_type_non_interventional
    ## Datatype: string
    ## Non-null values: 1511
    ## Null values: 1
    ## Unique non-null values: 4
    ## 
    ## Attribute: ctgov_purpose
    ## Datatype: string
    ## Non-null values: 1268
    ## Null values: 244
    ## Unique non-null values: 8
    ## 
    ## Attribute: drks_purpose
    ## Datatype: string
    ## Non-null values: 1303
    ## Null values: 209
    ## Unique non-null values: 9
    ## 
    ## Attribute: drks_study_type
    ## Datatype: string
    ## Non-null values: 1512
    ## Null values: 0
    ## Unique non-null values: 2
    ## 
    ## Attribute: ctgov_study_type
    ## Datatype: string
    ## Non-null values: 1512
    ## Null values: 0
    ## Unique non-null values: 3
    ## 
    ## Attribute: observational_model
    ## Datatype: string
    ## Non-null values: 1500
    ## Null values: 12
    ## Unique non-null values: 8

## Exercise 1.2

**Assignment**: Get the total number of rows in which both attributes
cst and dst take value ‘Interventional’.

**Answer**: There are 1284 where attributes cst and dst take value
‘Interventional’

``` bash
echo -e "SELECT * FROM purpose WHERE ctgov_study_type = 'Interventional' AND drks_study_type = 'Interventional'" | 
java -jar rulebox.jar explore stats --d ctgov_drks.json
```

    ## Reading data...
    ## SQL query:
    ## #Rows: 1284
    ## #Attributes: 6
    ## 
    ## Attribute: study_type_non_interventional
    ## Datatype: string
    ## Non-null values: 1284
    ## Null values: 0
    ## Unique non-null values: 1
    ## 
    ## Attribute: ctgov_purpose
    ## Datatype: string
    ## Non-null values: 1267
    ## Null values: 17
    ## Unique non-null values: 8
    ## 
    ## Attribute: drks_purpose
    ## Datatype: string
    ## Non-null values: 1254
    ## Null values: 30
    ## Unique non-null values: 9
    ## 
    ## Attribute: drks_study_type
    ## Datatype: string
    ## Non-null values: 1284
    ## Null values: 0
    ## Unique non-null values: 1
    ## 
    ## Attribute: ctgov_study_type
    ## Datatype: string
    ## Non-null values: 1284
    ## Null values: 0
    ## Unique non-null values: 1
    ## 
    ## Attribute: observational_model
    ## Datatype: string
    ## Non-null values: 1284
    ## Null values: 0
    ## Unique non-null values: 1

## Exercise 1.3

**Assignment**: Get the total number of rows in which the attributes cp
and dp take equal, non-NULL values (so, different values with the same
semantical meaning should not be considered equal). Make sure to check
this in a case insensitive way.

**Answer**: There are 1205 such rows.

``` bash
echo -e "SELECT * FROM purpose WHERE ctgov_purpose ilike drks_purpose AND ctgov_purpose IS NOT null" | 
java -jar rulebox.jar explore stats --d ctgov_drks.json
```

    ## Reading data...
    ## SQL query:
    ## #Rows: 1205
    ## #Attributes: 6
    ## 
    ## Attribute: study_type_non_interventional
    ## Datatype: string
    ## Non-null values: 1205
    ## Null values: 0
    ## Unique non-null values: 2
    ## 
    ## Attribute: ctgov_purpose
    ## Datatype: string
    ## Non-null values: 1205
    ## Null values: 0
    ## Unique non-null values: 6
    ## 
    ## Attribute: drks_purpose
    ## Datatype: string
    ## Non-null values: 1205
    ## Null values: 0
    ## Unique non-null values: 6
    ## 
    ## Attribute: drks_study_type
    ## Datatype: string
    ## Non-null values: 1205
    ## Null values: 0
    ## Unique non-null values: 2
    ## 
    ## Attribute: ctgov_study_type
    ## Datatype: string
    ## Non-null values: 1205
    ## Null values: 0
    ## Unique non-null values: 1
    ## 
    ## Attribute: observational_model
    ## Datatype: string
    ## Non-null values: 1204
    ## Null values: 1
    ## Unique non-null values: 1

## Exercise 1.4

**Assignment**: Get the total number of rows containing at least one
NULL-value.

**Answer**: There are 258 (61 + 186 + 11) such rows

**Argumentation**: I find it a little bit easier to answer question 4
and 5 in one go, please see question 5 below for the answer.

## Exercise 1.5

**Assignment**: Get the total number of rows containing at least two
NULL-values.

**Answer**: There are 197 (186 + 11) such rows.

**Argumentation**: I wrote an SQL query to get a count of null-values
per row.

``` sql
SELECT 
  sum_of_nulls
  , COUNT(*) number_of_rows
FROM (
    SELECT (
        (CASE WHEN ctgov_study_type IS null THEN 1 ELSE 0 END)
        + (CASE WHEN drks_study_type IS null THEN 1 ELSE 0 END)
        + (CASE WHEN study_type_non_interventional IS null THEN 1 ELSE 0 END)
        + (CASE WHEN observational_model IS null THEN 1 ELSE 0 END)
        + (CASE WHEN ctgov_purpose IS null THEN 1 ELSE 0 END)
        + (CASE WHEN drks_purpose IS null THEN 1 ELSE 0 END)
        ) sum_of_nulls
    FROM purpose
) sums
GROUP BY sum_of_nulls
ORDER BY sum_of_nulls asc 
```

<div class="knitsql-table">

| sum\_of\_nulls | number\_of\_rows |
|:---------------|-----------------:|
| 0              |             1254 |
| 1              |               61 |
| 2              |              186 |
| 3              |               11 |

4 records

</div>

## Exercise 1.6

**Assignment**: Get, for each attribute, the total number of rows
containing a NULL-value for the corresponding attribute.

**Answer**:

| Attribute                        | code | non-null vals | null vals |
|----------------------------------|:----:|:-------------:|:---------:|
| study\_type\_non\_interventional | stni |     1511      |     1     |
| ctgov\_purpose                   |  cp  |     1268      |    244    |
| drks\_purpose                    |  dp  |     1303      |    209    |
| drks\_study\_type                | dst  |     1512      |     0     |
| ctgov\_study\_type               | cst  |     1512      |     0     |
| observational\_model             |  om  |     1500      |    12     |

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar explore stats --d ctgov_drks.json
```

    ## Reading data...
    ## SQL query:
    ## #Rows: 1512
    ## #Attributes: 6
    ## 
    ## Attribute: study_type_non_interventional
    ## Datatype: string
    ## Non-null values: 1511
    ## Null values: 1
    ## Unique non-null values: 4
    ## 
    ## Attribute: ctgov_purpose
    ## Datatype: string
    ## Non-null values: 1268
    ## Null values: 244
    ## Unique non-null values: 8
    ## 
    ## Attribute: drks_purpose
    ## Datatype: string
    ## Non-null values: 1303
    ## Null values: 209
    ## Unique non-null values: 9
    ## 
    ## Attribute: drks_study_type
    ## Datatype: string
    ## Non-null values: 1512
    ## Null values: 0
    ## Unique non-null values: 2
    ## 
    ## Attribute: ctgov_study_type
    ## Datatype: string
    ## Non-null values: 1512
    ## Null values: 0
    ## Unique non-null values: 3
    ## 
    ## Attribute: observational_model
    ## Datatype: string
    ## Non-null values: 1500
    ## Null values: 12
    ## Unique non-null values: 8

# 2. Basic definitions

Provide answers to the following exercises in your report.

## Exercise 2.1

**Assignment**: Explain in your own words the underlying meaning of edit
rules

1.  E3: For `cp`, there are 8 predefined study purposes (‘Screening’ + 7
    other unique purposes). Rule E3 states that none of the 7 other
    purposes can be linked to the ‘Screening’ purpose for `dp`. So when
    `dp` takes a value of ‘Screening’, the `cp` must do so too.
2.  E12: The `dst` attribute (so not the `cst` attribute) can take on
    two potential values. The `stni` attribute is used to further
    specify the ‘non interventional’ value for the `dst` attribute. When
    the `dst` attribute takes on the value of ‘interventional’, the
    `stni` should take on the value of ‘N/A’. It means that a valid
    pattern is `cst`: Interventional, `dst`: Interventional, `stni`:
    N/A. Edit rule E12 makes this a bit more concrete. The rule states
    that whenever `cst` takes on a value of ‘Interventional’, the `stni`
    attribute cannot take on any other value than the value of ‘N/A’, as
    `cst`: Interventional implies that ctgov indicates a
    non-observational study, so drks should not use `stni` to specify an
    observational study.
3.  E16: the `stni` and `om` attributes further specify observational
    studies (From the `cst` and `dst` attributes, we know that
    observational is equivalent to non-interventional). Edit rule E16
    states that whenever the `stni` attribute indicates a
    non-interventional study instead of an interventional one, the `om`
    attribute should also indicate a further specification of an
    observational study. It does so by implying that `stni`:‘N/A’ can
    only be coupled with `om`:‘N/A’ and not with any of the 7 other
    specifications of observational studies.

## Exercise 2.2

**Assignment**: List, for each of the following edit rules, which
attributes are involved in the edit rule.

1.  E1: {`stni`, `cp`}
2.  E5: {`cp`, `dp`}
3.  E14: {`dst`, `stni`}
4.  E17: {`stni`, `om`}

## Exercise 2.3

**Assignment**: For each of the following sets of attributes, list those
edit rules that involve all attributes in that set.

1.  {`stni`}: E1, E2, E12, E13, E14, E15, E16, E17
2.  {`cp`, `dp`}: E3, E4, E5, E6, E7, E8, E9, 10, E11
3.  {`dst`, `om`}: None (empty set)

# 3.Redundancy

Provide answers to the following exercises in your report.

## Exercise 3.1

**Assignment**: Construct an edit rule Er that is redundant to E2 and in
which exactly 4 attributes are involved.

**Answer**: stni:{Epidemiological study, Observational study, Other} x
dp:{Treatment} x cst: {Interventional} x dst:{Interventional}

## Exercise 3.2

**Assignment**: Is it possible to construct an edit rule Er that is
redundant to E14 in which attribute stni is not involved? Why (not)?

**Answer**: Not possible, an edit rule Er can only be redundant to E14
if Er is a subset of E14. If we try to lose attribute `stni`, than Er
can never be fully contained in E14.

# 4. Error detection

Provide solutions to the following error detection exercises related to
the example data (Table 1) in your report.

## Exercise 4.1

**Assignment**: List, for each row given in Table 1, which edit rules in
E are failed by the corresponding row.

**Answer**:

| Row Index | failed edit rules |
|:---------:|-------------------|
|     1     | E1, E3            |
|     2     | E16               |
|     3     | None              |
|     4     | E5, E12, E17      |

## Exercise 4.2

**Assignment**: Is it possible to give an example row that fails both
edit rules E5 and E8, but no additional ones. If so, give such an
example row. If not, explain why.

**Answer**: Not possible. To fail both E5 and E8, an example row should
have a `dp` value of both ‘Diagnostic’ and ‘Health Care System’ at the
same time, as otherwise edit rules E5 and E8 can never be failed at the
same time. This is not possible, as the `dp` attribute always takes on
only one value at a time. So to construct such an example row is not
possible.

## Exercise 4.3

**Assignment**: Is it possible to give an example row that fails both
edit rules E13 and E15, but no additional ones. If so, give such an
example row. If not, explain why.

**Answer**: In table 1 there is no such row, as no rows fail rule E13.
In theory however it is possible:

`cst`: {Observational} x `dst`:{Non-Interventional} x `stni`:{N/A} x
`om`: {N/A} x `cp`: {Prevention} x `dp`: {prevention}

## Exercise 4.4

Provide solutions to the following error detection exercises related to
the data in the purpose table (so not the example data) in your report.
For this, we ask to create a .rbx file containing all the given edit
rules defined on the data first. Add this .rbx file to the final .zip
file.

**Assignment**: Get the total number of rows failing at least one edit
rule.

**Answer**: There are 43 such rows

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules.rbx
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## 
    ## Invalid rows (at least one error): 43
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 1469
    ##  Bin 2: 1 -> 42
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 1
    ##  Bin 5: 4 -> 0
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0
    ##  Bin 8: 7 -> 0
    ##  Bin 9: 8 -> 0
    ##  Bin 10: 9 -> 0
    ##  Bin 11: 10 -> 0
    ##  Bin 12: 11 -> 0
    ##  Bin 13: 12 -> 0
    ##  Bin 14: 13 -> 0
    ##  Bin 15: 14 -> 0
    ##  Bin 16: 15 -> 0
    ##  Bin 17: 16 -> 0
    ##  Bin 18: 17 -> 0
    ##  Bin 19: 18 -> 0
    ##  Bin 20: 19 -> 0
    ##  Bin 21: 20 -> 0
    ##  Bin 22: 21 -> 0
    ##  Bin 23: 22 -> 0
    ##  Bin 24: 23 -> 0

## Exercise 4.5

**Assignment**: Get the total number of rows failing edit rule E11.

**Answer**: There are 3 such rows

``` sql
SELECT *
FROM purpose
WHERE (
  ctgov_purpose = 'Basic Science' 
  OR ctgov_purpose = 'Diagnostic'
  OR ctgov_purpose = 'Health Services Research'
  OR ctgov_purpose = 'Other'
  OR ctgov_purpose ='Supportive Care'
  OR ctgov_purpose ='Screening'
  OR ctgov_purpose ='Treatment'
  ) AND drks_purpose = 'Prevention'
```

<div class="knitsql-table">

| ctgov\_study\_type | drks\_study\_type | study\_type\_non\_interventional | observational\_model | ctgov\_purpose | drks\_purpose |
|:-------------------|:------------------|:---------------------------------|:---------------------|:---------------|:--------------|
| Interventional     | Interventional    | N/A                              | N/A                  | Treatment      | Prevention    |
| Interventional     | Interventional    | N/A                              | N/A                  | Treatment      | Prevention    |
| Interventional     | Interventional    | N/A                              | N/A                  | Treatment      | Prevention    |

3 records

</div>

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect sigma --d ctgov_drks.json --c edit_rules.rbx --o ctgov_purpose,drks_purpose
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## Rule: drks_purpose in {'Prognosis'} & ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research'}
    ## Violations: 2
    ## 
    ## Rule: drks_purpose in {'Screening'} & ctgov_purpose in {'Prevention','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 1
    ## 
    ## Rule: drks_purpose in {'Treatment'} & ctgov_purpose in {'Prevention','Screening','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 10
    ## 
    ## Rule: drks_purpose in {'Other'} & ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research'}
    ## Violations: 9
    ## 
    ## Rule: drks_purpose in {'Prevention'} & ctgov_purpose in {'Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 3
    ## 
    ## Rule: ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Health Services Research','Other'} & drks_purpose in {'Supportive care'}
    ## Violations: 3

## Exercise 4.6

**Assignment**: Get the total number of rows failing edit rules E1 and
E17.

**Answer**: 0 rows fail both E1 and E17 simultaneously

``` sql
SELECT *
FROM purpose
WHERE 
    (study_type_non_interventional = 'Epidemiological study'
     OR study_type_non_interventional = 'Observational study'
     OR study_type_non_interventional = 'Other'
    )
    AND observational_model = 'N/A'
    AND ctgov_purpose = 'Treatment'
```

<div class="knitsql-table">

| ctgov\_study\_type | drks\_study\_type | study\_type\_non\_interventional | observational\_model | ctgov\_purpose | drks\_purpose |
|:-------------------|:------------------|:---------------------------------|:---------------------|:---------------|:--------------|

0 records

</div>

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules.rbx --o study_type_non_interventional,ctgov_purpose,observational_model --se --srf 2
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## 
    ## Invalid rows (at least one error): 1
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 1511
    ##  Bin 2: 1 -> 1
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 0
    ##  Bin 5: 4 -> 0
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0

## Exercise 4.7

**Assignment**: List all rows failing the highest number of edit rules?
How many edit rules are failed by these rows?

**Answer**: There is 1 row that fails 3 rules

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules.rbx --se --srf 3
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=Treatment,drks_study_type=Non-interventional,observational_model=null,study_type_non_interventional=Observational study}
    ##   Failed sigma rules:
    ##   drks_purpose in {'Treatment'} & study_type_non_interventional in {'Observational study','Epidemiological study','Other'}
    ##   ctgov_study_type in {'Interventional'} & study_type_non_interventional in {'Observational study','Epidemiological study','Other'}
    ##   ctgov_purpose in {'Treatment'} & study_type_non_interventional in {'Observational study','Epidemiological study','Other'}
    ## 
    ## Invalid rows (at least one error): 43
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 1469
    ##  Bin 2: 1 -> 42
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 1
    ##  Bin 5: 4 -> 0
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0
    ##  Bin 8: 7 -> 0
    ##  Bin 9: 8 -> 0
    ##  Bin 10: 9 -> 0
    ##  Bin 11: 10 -> 0
    ##  Bin 12: 11 -> 0
    ##  Bin 13: 12 -> 0
    ##  Bin 14: 13 -> 0
    ##  Bin 15: 14 -> 0
    ##  Bin 16: 15 -> 0
    ##  Bin 17: 16 -> 0
    ##  Bin 18: 17 -> 0
    ##  Bin 19: 18 -> 0
    ##  Bin 20: 19 -> 0
    ##  Bin 21: 20 -> 0
    ##  Bin 22: 21 -> 0
    ##  Bin 23: 22 -> 0
    ##  Bin 24: 23 -> 0

## Exercise 4.8

**Assignment**: List all edit rules that are failed by the highest
number of rows? How many rows fail these edit rules?

**Answer** Edit rule E2 has the maximum of failed rows with 15 rows
failing the edit rule.

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect sigma --d ctgov_drks.json --c edit_rules.rbx
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## Rule: drks_purpose in {'Prognosis'} & ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research'}
    ## Violations: 2
    ## 
    ## Rule: drks_purpose in {'Screening'} & ctgov_purpose in {'Prevention','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 1
    ## 
    ## Rule: drks_purpose in {'Treatment'} & ctgov_purpose in {'Prevention','Screening','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 10
    ## 
    ## Rule: drks_purpose in {'Other'} & ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research'}
    ## Violations: 9
    ## 
    ## Rule: drks_purpose in {'Prevention'} & ctgov_purpose in {'Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'}
    ## Violations: 3
    ## 
    ## Rule: ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Health Services Research','Other'} & drks_purpose in {'Supportive care'}
    ## Violations: 3
    ## 
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & ctgov_study_type in {'Interventional'}
    ## Violations: 1
    ## 
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & drks_purpose in {'Treatment'}
    ## Violations: 15
    ## 
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & ctgov_purpose in {'Treatment'}
    ## Violations: 1

# 5. Error localization

Provide solutions to the following error localization exercises related
to the example data (Table1) in your report.

## Exercise 5.1

**Assignment**: List, for each row given in Table 1, all the minimal set
covers of the edit rules in E failed by the corresponding row. You may
assume that the weight to change an attribute is 1.

**Answer**: see exercise 5.2 below

## Exercise 5.2

**Assignment**: Indicate, for each minimal set cover of a failing row,
whether it is a correct solution to the error localization problem for
the corresponding row.

**Answer**:

| Row Index | failed edit rules | attributes involved in edit rules (table below) | minimal set cover | Solution |
|:---------:|-------------------|-------------------------------------------------|-------------------|:--------:|
|     1     | E1, E3            | {`stni`, `cp`}, {`cp`, `dp`}                    | {`cp`}            |   Yes    |
|     2     | E16               | {`stni`, `om`}                                  | {`stni`}          |    No    |
|           |                   |                                                 | {`om`}            |   Yes    |
|     3     | None              | None                                            | None              |          |
|     4     | E5, E12, E17      | {`cp`, `dp`}, {`cst`, `stni`}, {`stni`, `om`}   | {`cp`, `stni`}    |    No    |
|           |                   |                                                 | {`dp`, `stni`}    |    No    |

| Edit Rule | Attributes involved |
|:---------:|:-------------------:|
|    E1     |   {`stni`, `cp`}    |
|    E2     |   {`stni`, `dp`}    |
|    E3     |    {`cp`, `dp`}     |
|    E4     |    {`cp`, `dp`}     |
|    E5     |    {`cp`, `dp`}     |
|    E6     |    {`cp`, `dp`}     |
|    E7     |    {`cp`, `dp`}     |
|    E8     |    {`cp`, `dp`}     |
|    E9     |    {`cp`, `dp`}     |
|    E10    |    {`cp`, `dp`}     |
|    E11    |    {`cp`, `dp`}     |
|    E12    |   {`cst`, `stni`}   |
|    E13    |   {`cst`, `stni`}   |
|    E14    |   {`dst`, `stni`}   |
|    E15    |   {`dst`, `stni`}   |
|    E16    |   {`stni`, `om`}    |
|    E17    |   {`stni`, `om`}    |

# 6. Implication

**Assignment**: Indicate which of the following types of rules you can
retrieve by using generator cp, a contributing set Ec of exactly two
edit rules and the implication procedure described on slide TODO of the
theory lecture presentation, starting from the set of edit rules E.
Give, for each indicated type of rule, a contributing set Ec which leads
to a rule of this type after implication by means of generator cp. Write
your answers in the report.

**Answer**: The table below shows per type of rule (Tautology, implied
non-essentially new, ..) which two edit rules should be combined. empty
attribute cells indicate attributes that are not involved in the source
rules. An attribute cell like ‘A\_cp’, means that the attribute was
involved in the rules but the attribute is not involved in the resulting
rule. The capital A stands for the domain of that attribute.

| Type                        |     Er1      | Er2 | cst | dst |                        stni                         |  om   |     cp      |     dp      |
|-----------------------------|:------------:|:---:|:---:|:---:|:---------------------------------------------------:|:-----:|:-----------:|:-----------:|
| Tautology                   |     E16      | E17 |     |     |                        empty                        | empty |             |             |
| implied non-essentially new |      E1      | E17 |     |     | {Epidemiological study, Observational study, other} | {N/A} | {Treatment} |             |
| Essentially new             |      E1      | E4  |     |     | {Epidemiological study, Observational study, other} |       |    A\_cp    | {Treatment} |
| Contradiction               | not possible |     |     |     |                                                     |       |             |             |

# 7. Sufficient Set Generation

During this exercise, we will ask to generate a sufficient set of rules
Omega(E) starting from E. As you saw in the theory lecture and the lab
session, this can be done by applying the FCF algorithm. However, do not
write down the entire execution of FCF in your report as this will
require too much space and time, but follow the steps listed below.
Assume that the order of the attributes visited in the FCF tree is 1 =
cp, 2 = stni, 3 = dp, 4 = cst, 5 = dst, 6 = om.

## Exercise 7.1

**Assignment**: Obviously, start with node (1). List in your report (i)
which edit rules are selected as possible contributors and (ii) which
essentially new rules are generated from these edit rules in node (1).
List for each rule that is generated in either the root node or node (1)
whether it is redundant or not. If a rule is redundant, list which edit
rules are dominating this rule.

**Answer**: See answer for 7.2

## Exercise 7.2

**Assignment**: Apply the same procedure for node (12) and (123) and
write your results in the report.

**Answer**:

| node    | Generator | Excluded attributes | Possible Contributers                    |
|---------|-----------|---------------------|------------------------------------------|
| \(1\)   | cp        |                     | E1, E3, E4, E5, E6, E7, E8, E9, E10, E11 |
| \(12\)  | stni      | cp                  | E2, E12, E13, E14, E15, E16, E17         |
| \(123\) | dp        | cp, stni            | E18, E19, E20                            |

Empty attribute cells in the table below indicate attributes that are
not involved in the source rules. An attribute cell like ‘A\_cp’, means
that the attribute was involved in the rules but the attribute is not
involved in the resulting rule. The capital A stands for the domain of
said attribute.

| name |  node  | Er1 | Er2 |     redundant     |                        cst                        |         dst          |                        stni                         |                                                om                                                |  cp   |     dp      |
|:----:|:------:|:---:|:---:|:-----------------:|:-------------------------------------------------:|:--------------------:|:---------------------------------------------------:|:------------------------------------------------------------------------------------------------:|:-----:|:-----------:|
|      |  root  |     |     |                   |                                                   |                      |                                                     |                                                                                                  |       |             |
|      | \(1\)  | E1  | E4  | Yes: E2 dominates |                                                   |                      | {Epidemiological study, Observational study, Other} |                                                                                                  | A\_cp | {Treatment} |
| E18  | \(12\) | E2  | E13 |        No         | {Observational, Observational \[Patient Registry} |                      |                       A\_stni                       |                                                                                                  |       | {Treatment} |
| E19  | \(12\) | E2  | E15 |        No         |                                                   | {Non-Interventional} |                       A\_stni                       |                                                                                                  |       | {Treatment} |
| E20  | \(12\) | E2  | E16 |        No         |                                                   |                      |                       A\_stni                       | {Case Control, Case Crossover, Case Only, Cohort, Ecologic or Community, Natural History, Other} |       | {Treatment} |
| E21  | \(12\) | E12 | E15 |        No         |                 {Interventional}                  | {Non-Interventional} |                       A\_stni                       |                                                                                                  |       |             |
| E22  | \(12\) | E12 | E16 |        No         |                 {Interventional}                  |                      |                       A\_stni                       | {Case Control, Case Crossover, Case Only, Cohort, Ecologic or Community, Natural History, Other} |       |             |
| E23  | \(12\) | E13 | E14 |        No         | {Observational, Observational \[Patient Registry} |   {Interventional}   |                       A\_stni                       |                                                                                                  |       |             |
| E24  | \(12\) | E13 | E17 |        No         | {Observational, Observational \[Patient Registry} |                      |                       A\_stni                       |                                              {N/A}                                               |       |             |
| E25  | \(12\) | E14 | E16 |        No         |                                                   |   {Interventional}   |                       A\_stni                       | {Case Control, Case Crossover, Case Only, Cohort, Ecologic or Community, Natural History, Other} |       |             |
| E26  | \(12\) | E15 | E17 |        No         |                                                   | {Non-Interventional} |                       A\_stni                       |                                              {N/A}                                               |       |             |

## Exercise 7.3

**Assignment**: Do you need to visit node (1234) during the remainder of
the FCF algorithm? And node (124)? Why (not)?

**Answer**:

-   Visit (1234)? **No**, because node (123) did not produce anything
    new
-   Visit node (124)? **Yes**, as node (12) produced some new nodes.

## Exercise 7.4

**Assignment**: After termination of the FCF algorithm, a sufficient set
of edit rules ­(E) is returned. List all edit rules that are in ­(E) but
not in E in your report. Add a .rbx file in which all rules in ­(E) are
defined to your final .zip file.

``` bash
java -jar rulebox.jar reason fcf --c edit_rules.rbx --of edit_rules_sufficient.rbx
```

    ## Reading constraints
    ## Computing sufficient set with FCF
    ## FCF will be executed with the simple implication manager
    ## Writing rubix file

**Answer**: list of rules in sufficient set but not in epsilon

-   \[`E18`\] dp: {‘Treatment’} x om: {‘Case Control’,‘Cohort’,‘Ecologic
    or Community’,‘Case Crossover’,‘Case Only’,‘Natural
    History’,‘Other’}
-   \[`E19`\] cst: {‘Observational \[Patient
    Registry\]’,‘Observational’} x dp: {‘Treatment’}
-   \[`E20`\] cp: {‘Prevention’,‘Screening’,‘Treatment’,‘Basic
    Science’,‘Diagnostic’,‘Health Services Research’,‘Other’} x dp:
    {‘Supportive care’}
-   \[`E21`\] cst: {‘Observational \[Patient
    Registry\]’,‘Observational’} x cp: {‘Treatment’}
-   \[`E22`\] om: {‘N/A’} x dst: {‘Non-interventional’}
-   \[`E23`\] cst: {‘Interventional’} x om: {‘Case
    Control’,‘Cohort’,‘Ecologic or Community’,‘Case Crossover’,‘Case
    Only’,‘Natural History’,‘Other’}
-   \[`E24`\] cp: {‘Treatment’} x dst: {‘Non-interventional’}
-   \[`E25`\] cst: {‘Observational \[Patient
    Registry\]’,‘Observational’} x dst: {‘Interventional’}
-   \[`E26`\] cp: {‘Treatment’} x om: {‘Case Control’,‘Cohort’,‘Ecologic
    or Community’,‘Case Crossover’,‘Case Only’,‘Natural
    History’,‘Other’}
-   \[`E27`\] cst: {‘Observational \[Patient
    Registry\]’,‘Observational’} x om: {‘N/A’}
-   \[`E28`\] dst: {‘Non-interventional’} x cst: {‘Interventional’}
-   \[`E29`\] dp: {‘Treatment’} x dst :{‘Non-interventional’}

## Exercise 7.5

**Assignment**: List, for each row given in Table 1, which edit rules in
­(E0) are failed by the corresponding row and all the minimal set covers
of the edit rules in ­(E0) failed by the corresponding row. Because a
sufficient set was generated, these minimal set covers are now correct
minimal solutions to the error localization problem for the given rows
(check this!). You may assume that the weight to change the value of an
attribute is 1. Write your answer in the report.

| Row Index | failed edit rules      | attributes involved in edit rules (table below)                              | minimal set cover     |
|:---------:|------------------------|------------------------------------------------------------------------------|-----------------------|
|     1     | E1, E3, E21, E24, E26  | {`stni`, `cp`}, {`cp`, `dp`}, {`cst`, `cp`}, {`cp`, `dst`}, {`cp`, `om`}     | {`cp`}                |
|     2     | E16, E18, E23, E26     | {`stni`, `om`}, {`dp`, `om`}, {`cst`, `om`}, {`cp`, `om`}                    | {`om`}                |
|     3     | None                   | None                                                                         | None                  |
|     4     | E5, E12, E17, E22, E28 | {`cp`, `dp`}, {`cst`, `stni`}, {`stni`, `om`}, {`om`, `dst`}, {`dst`, `cst`} | {`cst`, `om`, `cp`}   |
|           |                        |                                                                              | {`cst`, `om`, `dp`}   |
|           |                        |                                                                              | {`stni`, `dst`, `cp`} |
|           |                        |                                                                              | {`stni`, `dst`, `dp`} |

# Exercise 8

A very straightforward imputation method is called donor imputation.
Suppose that a row r in a dataset fails some edit rules resulting in a
minimal solution S. Donor imputation is going to search for a repair r 0
(the donor) in the same dataset that (1) does not fail any edit rules,
(2) has at least different values for the attributes in S compared to r
and (3) has as many equal values for the other attributes compared to r
(i.e. the donor row r 0 should be as closely as possible to the original
row r ). Search, for each row given in Table 1, a donor row r 0 that
exists in the purpose table of the clinicaltrials database. Therefore,
consider one solution S for each failing row r (cfr. exercise 7.5) and
make sure that r 0 has at most one different value for the attributes
that are not in S compared to r . List, for each failing row, a
potential donor row that meets the above requirements in your report. If
no donor is found, mention this too. Write your answers in the report.

## Workflow for this exercise

For every row in the table:

1.  First created an SQL query with a `WHERE` and `AND` clauses to
    ‘recreate’ the row
    (e.g. `WHERE col_1 = row_att_1 AND col_2 = row_att_2 AND ..`)
2.  I chose a solution from the minimal set covers
3.  I negated the equality for the attribute(s) in the minimal set cover
    (Basically saying: "find a row where the minimal set attribute value
    is anything else than the current value)
4.  Upon to this point, the result of a query like that is a row where
    every minimal set attribute must be different than the current
    value, and the other attributes must be equal to the current values
5.  When I didn’t find any rows, I commented out one equality (Basically
    saying “Every minimal set attribute must be different than the
    current value and at most one of the other attribute values can be
    different than the current value.”)
6.  I commented out equalities iteratively until stumbling upon a query
    that resulted in at least one row.
7.  To check the resulting rows for the failing of edit rules, I used
    the SQL query as input for the java rulebox, and set the srf flag to
    0 (Basically saying: “Return every row from the input sql query
    where no edit rules are failed”.)
8.  The results are rows where (1) no edit rules are failed, (2) all
    values for the minimal set attributes are different than the
    original values and (3) At most one of the non-minimal set
    attributes is different from the original value.

## Exercise 8.1

For row 1: *No row exists*. In the SQL query below, one can iteratively
emit the next `AND` statement and it will not result in any rows,
meaning that there is no row that has another value for `cp` than
‘Treatment’ while all but at most one attributes keep their values.

``` sql
SELECT DISTINCT *
FROM purpose
WHERE ctgov_purpose != 'Treatment'
-- AND ctgov_study_type = 'Observational' 
AND drks_study_type = 'Non-interventional'
AND study_type_non_interventional = 'Epidemiological study'
AND observational_model = 'Case Crossover'
AND drks_purpose = 'Treament'
```

<div class="knitsql-table">

| ctgov\_study\_type | drks\_study\_type | study\_type\_non\_interventional | observational\_model | ctgov\_purpose | drks\_purpose |
|:-------------------|:------------------|:---------------------------------|:---------------------|:---------------|:--------------|

0 records

</div>

## Exercise 8.2

For row 2: If we remove the restraint on `dp` taking on the value of
‘Treatment’, we can find some rows which change `om` to ‘N/A’

``` bash
echo -e "SELECT DISTINCT * FROM purpose WHERE observational_model != 'Cohort'AND observational_model = 'N/A' AND ctgov_study_type = 'Interventional'AND drks_study_type = 'Interventional' AND study_type_non_interventional = 'N/A' AND ctgov_purpose = 'Treatment'-- AND drks_purpose = 'Treament" |
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules_sufficient.rbx --se --srf 0
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=null,drks_study_type=Interventional,observational_model=N/A,study_type_non_interventional=N/A}
    ##   Failed sigma rules:
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=Prevention,drks_study_type=Interventional,observational_model=N/A,study_type_non_interventional=N/A}
    ##   Failed sigma rules:
    ##   ctgov_purpose in {'Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research','Other'} & drks_purpose in {'Prevention'}
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=Supportive care,drks_study_type=Interventional,observational_model=N/A,study_type_non_interventional=N/A}
    ##   Failed sigma rules:
    ##   drks_purpose in {'Supportive care'} & ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Health Services Research','Other'}
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=Other,drks_study_type=Interventional,observational_model=N/A,study_type_non_interventional=N/A}
    ##   Failed sigma rules:
    ##   ctgov_purpose in {'Prevention','Screening','Treatment','Basic Science','Diagnostic','Supportive Care','Health Services Research'} & drks_purpose in {'Other'}
    ## {ctgov_purpose=Treatment,ctgov_study_type=Interventional,drks_purpose=Treatment,drks_study_type=Interventional,observational_model=N/A,study_type_non_interventional=N/A}
    ##   Failed sigma rules:
    ## 
    ## Invalid rows (at least one error): 3
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 2
    ##  Bin 2: 1 -> 3
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 0
    ##  Bin 5: 4 -> 0
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0
    ##  Bin 8: 7 -> 0
    ##  Bin 9: 8 -> 0
    ##  Bin 10: 9 -> 0
    ##  Bin 11: 10 -> 0
    ##  Bin 12: 11 -> 0
    ##  Bin 13: 12 -> 0
    ##  Bin 14: 13 -> 0
    ##  Bin 15: 14 -> 0
    ##  Bin 16: 15 -> 0
    ##  Bin 17: 16 -> 0
    ##  Bin 18: 17 -> 0
    ##  Bin 19: 18 -> 0
    ##  Bin 20: 19 -> 0
    ##  Bin 21: 20 -> 0
    ##  Bin 22: 21 -> 0
    ##  Bin 23: 22 -> 0
    ##  Bin 24: 23 -> 0
    ##  Bin 25: 24 -> 0
    ##  Bin 26: 25 -> 0
    ##  Bin 27: 26 -> 0
    ##  Bin 28: 27 -> 0
    ##  Bin 29: 28 -> 0
    ##  Bin 30: 29 -> 0
    ##  Bin 31: 30 -> 0
    ##  Bin 32: 31 -> 0
    ##  Bin 33: 32 -> 0
    ##  Bin 34: 33 -> 0
    ##  Bin 35: 34 -> 0
    ##  Bin 36: 35 -> 0

## Exercise 8.3

For row 3: No action is needed as this row does not fail any rules.

## Exercise 8.4

For row 4:

``` bash
echo -e "SELECT DISTINCT * FROM purpose WHERE ctgov_study_type != 'Interventional' AND drks_study_type = 'Non-interventional' AND study_type_non_interventional = 'Other' AND observational_model != 'N/A' -- AND ctgov_purpose = 'Other' AND drks_purpose != 'Diagnostic'" | 
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules_sufficient.rbx --se --srf 0
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Other,drks_study_type=Non-interventional,observational_model=Case Control,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Diagnostic,drks_study_type=Non-interventional,observational_model=Case Only,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Diagnostic,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Other,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Prognosis,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Screening,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Treatment,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ##   drks_purpose in {'Treatment'} & study_type_non_interventional in {'Observational study','Epidemiological study','Other'}
    ##   ctgov_study_type in {'Observational [Patient Registry]','Observational'} & drks_purpose in {'Treatment'}
    ##   drks_study_type in {'Non-interventional'} & drks_purpose in {'Treatment'}
    ##   observational_model in {'Case Control','Cohort','Ecologic or Community','Case Crossover','Case Only','Natural History','Other'} & drks_purpose in {'Treatment'}
    ## {ctgov_purpose=null,ctgov_study_type=Observational,drks_purpose=Diagnostic,drks_study_type=Non-interventional,observational_model=Other,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational [Patient Registry],drks_purpose=Basic research/physiological study,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## {ctgov_purpose=null,ctgov_study_type=Observational [Patient Registry],drks_purpose=Diagnostic,drks_study_type=Non-interventional,observational_model=Cohort,study_type_non_interventional=Other}
    ##   Failed sigma rules:
    ## 
    ## Invalid rows (at least one error): 1
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 9
    ##  Bin 2: 1 -> 0
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 0
    ##  Bin 5: 4 -> 1
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0
    ##  Bin 8: 7 -> 0
    ##  Bin 9: 8 -> 0
    ##  Bin 10: 9 -> 0
    ##  Bin 11: 10 -> 0
    ##  Bin 12: 11 -> 0
    ##  Bin 13: 12 -> 0
    ##  Bin 14: 13 -> 0
    ##  Bin 15: 14 -> 0
    ##  Bin 16: 15 -> 0
    ##  Bin 17: 16 -> 0
    ##  Bin 18: 17 -> 0
    ##  Bin 19: 18 -> 0
    ##  Bin 20: 19 -> 0
    ##  Bin 21: 20 -> 0
    ##  Bin 22: 21 -> 0
    ##  Bin 23: 22 -> 0
    ##  Bin 24: 23 -> 0
    ##  Bin 25: 24 -> 0
    ##  Bin 26: 25 -> 0
    ##  Bin 27: 26 -> 0
    ##  Bin 28: 27 -> 0
    ##  Bin 29: 28 -> 0
    ##  Bin 30: 29 -> 0
    ##  Bin 31: 30 -> 0
    ##  Bin 32: 31 -> 0
    ##  Bin 33: 32 -> 0
    ##  Bin 34: 33 -> 0
    ##  Bin 35: 34 -> 0
    ##  Bin 36: 35 -> 0
