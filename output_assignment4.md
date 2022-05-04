Assignment4 - Edit Rules - Eli Lauwers
================

# About this document

This document is the answer to the fourth databases assignment on
database edit rules. The workflow for this assignment is as follows.

# 1.Data exploration

Provide solutions to the following data exploration exercises related to
the data in the `purpose` table (so not the example data given in Table
1) in your report.

### Exercise 1.1

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

2.  Get the total number of rows in which both attributes cst and dst
    take value ‘Interventional’.

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

3.  Get the total number of rows in which the attributes cp and dp take
    equal, non-NULL values (so, different values with the same
    semantical meaning should not be considered equal). Make sure to
    check this in a case insensitive way.

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

4.  Get the total number of rows containing at least one NULL-value.

**Answer**: There are 258 (61 + 186 + 11) such rows

**Argumentation**: I find it a little bit easier to answer question 4
and 5 in one go, please see question 5 below for the answer.

5.  Get the total number of rows containing at least two NULL-values.

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

6.  Get, for each attribute, the total number of rows containing a
    NULL-value for the corresponding attribute.

**Answer**:

| Attribute                        | code | non-null vals |
|----------------------------------|:----:|:-------------:|
| study\_type\_non\_interventional | stni |     1511      |
| ctgov\_purpose                   |  cp  |     1268      |
| drks\_purpose                    |  dp  |     1303      |
| drks\_study\_type                | dst  |     1512      |
| ctgov\_study\_type               | cst  |     1512      |
| observational\_model             |  om  |     1500      |

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

1.  Explain in your own words the underlying meaning of edit rules

<!-- -->

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

<!-- -->

2.  List, for each of the following edit rules, which attributes are
    involved in the edit rule.

<!-- -->

1.  E1: {`stni`, `cp`}
2.  E5: {`cp`, `dp`}
3.  E14: {`dst`, `stni`}
4.  E17: {`stni`, `om`}

<!-- -->

3.  For each of the following sets of attributes, list those edit rules
    that involve all attributes in that set.

<!-- -->

1.  {stni}: E1, E2, E12, E13, E14, E15, E16, E17
2.  {cp,dp}: E3, E4, E5, E6, E7, E8, E9, 10, E11
3.  {dst,om}: None (empty set)

# 3.Redundancy

Provide answers to the following exercises in your report.

1.  Construct an edit rule Er that is redundant to E2 and in which
    exactly 4 attributes are involved.

**Answer**: (**NOT SURE**): stni:{Epidemiological study, Observational
study, Other} x dp:{Treatment} x cst: {Interventional} x
dst:{Interventional}

2.  Is it possible to construct an edit rule Er that is redundant to E14
    in which attribute stni is not involved? Why (not)?

**Answer**: (**NOT SURE**) Not possible, an edit rule Er can only be
redundant to E14 if Er is a subset of E14. If we try to lose attribute
`stni`, than Er can never be fully contained in E14.

# 4. Error detection

Provide solutions to the following error detection exercises related to
the example data (Table 1) in your report.

1.  List, for each row given in Table 1, which edit rules in E are
    failed by the corresponding row.

| Row Index | failed edit rules |
|-----------|-------------------|
| 1         | E1, E3            |
| 2         | E16               |
| 3         | None              |
| 4         | E5, E12, E17      |

2.  Is it possible to give an example row that fails both edit rules E5
    and E8, but no additional ones. If so, give such an example row. If
    not, explain why.

**Answer**: Not possible. To fail both E5 and E8, an example row should
have a `dp` value of both ‘Diagnostic’ and ‘Health Care System’ at the
same time, as otherwise edit rules E5 and E8 can never be failed at the
same time. This is not possible, as the `dp` attribute always takes on
only one value at a time, so to construct such an example row is not
possible.

3.  Is it possible to give an example row that fails both edit rules E13
    and E15, but no additional ones. If so, give such an example row. If
    not, explain why.
    `**Answer**:`cst`: {Observational},`dst`:{Non-Interventional},`stni\`:{N/A} +
    any combination of the other attributes

Provide solutions to the following error detection exercises related to
the data in the purpose table (so not the example data) in your report.
For this, we ask to create a .rbx file containing all the given edit
rules defined on the data first. Add this .rbx file to the final .zip
file.

4.  Get the total number of rows failing at least one edit rule.

**Answer**: There are 40 such rows

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c purpose_rules.rbx
```

    ## Reading constraints
    ## Constraint file does not exist.

5.  Get the total number of rows failing edit rule E11.

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
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules_E11.rbx
```

    ## Reading constraints
    ## Reading data...
    ## SQL query:
    ## 
    ## Invalid rows (at least one error): 3
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 1509
    ##  Bin 2: 1 -> 3
    ##  Bin 3: 2 -> 0
    ##  Bin 4: 3 -> 0
    ##  Bin 5: 4 -> 0
    ##  Bin 6: 5 -> 0
    ##  Bin 7: 6 -> 0
    ##  Bin 8: 7 -> 0

6.  Get the total number of rows failing edit rules E1 and E17.

**Answer**: 0 rows fail both E1 and E17

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
java -jar rulebox.jar errors detect rows --d ctgov_drks.json --c edit_rules_E1_E17.rbx
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
    ##  Bin 8: 7 -> 0
    ##  Bin 9: 8 -> 0

7.  List all rows failing the highest number of edit rules? How many
    edit rules are failed by these rows?

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
    ## Invalid rows (at least one error): 40
    ## 
    ## Histogram for sigma rule failures
    ## 
    ##  Bin 1: 0 -> 1472
    ##  Bin 2: 1 -> 39
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

8.  List all edit rules that are failed by the highest number of rows?
    How many rows fail these edit rules?

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
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & ctgov_study_type in {'Interventional'}
    ## Violations: 1
    ## 
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & drks_purpose in {'Treatment'}
    ## Violations: 15
    ## 
    ## Rule: study_type_non_interventional in {'Observational study','Epidemiological study','Other'} & ctgov_purpose in {'Treatment'}
    ## Violations: 1

# 5. Error Localization

| Edit Rule | Attributes involved |
|-----------|---------------------|
| E1        | {`stni`, `cp`}      |
| E2        | {`stni`, `dp`}      |
| E3        | {`cp`, `dp`}        |
| E4        | {`cp`, `dp`}        |
| E5        | {`cp`, `dp`}        |
| E6        | {`cp`, `dp`}        |
| E7        | {`cp`, `dp`}        |
| E8        | {`cp`, `dp`}        |
| E9        | {`cp`, `dp`}        |
| E10       | {`cp`, `dp`}        |
| E11       | {`cp`, `dp`}        |
| E12       | {`cst`, `stni`}     |
| E13       | {`cst`, `stni`}     |
| E14       | {`dst`, `stni`}     |
| E15       | {`dst`, `stni`}     |
| E16       | {`stni`, `om`}      |
| E17       | {`stni`, `om`}      |

| Row Index | failed edit rules | see table above                               | minimal set cover | Solution      |
|-----------|-------------------|-----------------------------------------------|-------------------|---------------|
| 1         | E1, E3            | {`stni`, `cp`}, {`cp`, `dp`}                  | {`cp`}            | Yes           |
| 2         | E16               | {`stni`, `om`}                                | {`stni`}          | No (E1 fails) |
|           |                   |                                               | {`om`}            | Yes (om: N/A) |
| 3         | None              | None                                          | None              |               |
| 4         | E5, E12, E17      | {`cp`, `dp`}, {`cst`, `stni`}, {`stni`, `om`} | {`cp`, `stni`}    | No            |
|           |                   |                                               | {`dp`, `stni`}    | No            |

# 6. Implication

| Edit Rule | Attributes involved |
|-----------|---------------------|
| E1        | {`stni`, `cp`}      |
| E2        | {`stni`, `dp`}      |
| E3        | {`cp`, `dp`}        |
| E4        | {`cp`, `dp`}        |
| E5        | {`cp`, `dp`}        |
| E6        | {`cp`, `dp`}        |
| E7        | {`cp`, `dp`}        |
| E8        | {`cp`, `dp`}        |
| E9        | {`cp`, `dp`}        |
| E10       | {`cp`, `dp`}        |
| E11       | {`cp`, `dp`}        |
| E12       | {`cst`, `stni`}     |
| E13       | {`cst`, `stni`}     |
| E14       | {`dst`, `stni`}     |
| E15       | {`dst`, `stni`}     |
| E16       | {`stni`, `om`}      |
| E17       | {`stni`, `om`}      |

| Type                        |     Er1      | Er2 | cst | dst |                        stni                         |  om   |     cp      |     dp      |
|-----------------------------|:------------:|:---:|:---:|:---:|:---------------------------------------------------:|:-----:|:-----------:|:-----------:|
| Tautology                   |     E16      | E17 |     |     |                        empty                        | empty |             |             |
| implied non-essentially new |      E1      | E17 |     |     | {Epidemiological study, Observational study, other} | {N/A} | {Treatment} |             |
| Essentially new             |      E1      | E4  |     |     | {Epidemiological study, Observational study, other} |       |    A\_cp    | {Treatment} |
| Contradiction               | not possible |     |     |     |                                                     |       |             |             |

# 7. Sufficient Set Generation

| node    | Excluded | Generator | Involved rules                           |
|---------|----------|-----------|------------------------------------------|
| \(1\)   |          | cp        | E1, E3, E4, E5, E6, E7, E8, E9, E10, E11 |
| \(12\)  | cp       | stni      | E2, E12, E13, E14, E15, E16, E17         |
| \(123\) | cp, stni | dp        | E18, E19, E20                            |

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
| E26  | \(12\) | E14 | E17 |        No         |                                                   |   {Interventional}   |                       A\_stni                       |                                              {N/A}                                               |       |             |

3.  Do you need to visit node (1234)? No, because node (123) did not
    produce anything new Do you need to visit node (124)? Yes, as
    node (12) produced some new nodes.

``` bash
java -jar rulebox.jar reason fcf --c edit_rules.rbx --of edit_rules_sufficient.rbx
```

    ## Reading constraints
    ## Computing sufficient set with FCF
    ## FCF will be executed with the simple implication manager
    ## Writing rubix file

list of rules in sufficient set but not in epsilon - dp: {‘Treatment’} x
om: {‘Case Control’,‘Cohort’,‘Ecologic or Community’,‘Case
Crossover’,‘Case Only’,‘Natural History’,‘Other’} - cst: {‘Observational
\[Patient Registry\]’,‘Observational’} x dp: {‘Treatment’} - cp:
{‘Prevention’,‘Screening’,‘Treatment’,‘Basic
Science’,‘Diagnostic’,‘Health Services Research’,‘Other’} dp: {} - cst:
{‘Observational \[Patient Registry\]’,‘Observational’} x cp:
{‘Treatment’} - om: {‘N/A’} x dst: {‘Non-interventional’} - cst:
{‘Interventional’} x om: {‘Case Control’,‘Cohort’,‘Ecologic or
Community’,‘Case Crossover’,‘Case Only’,‘Natural History’,‘Other’} - cp:
{‘Treatment’} x dst: {‘Non-interventional’} - cst: {‘Observational
\[Patient Registry\]’,‘Observational’} x dst: {‘Interventional’} - cp:
{‘Treatment’} x om: {‘Case Control’,‘Cohort’,‘Ecologic or
Community’,‘Case Crossover’,‘Case Only’,‘Natural History’,‘Other’} -
cst: {‘Observational \[Patient Registry\]’,‘Observational’} x om:
{‘N/A’} - dst: {‘Non-interventional’} x cst: {‘Interventional’} - dp:
{‘Treatment’} x dst {‘Non-interventional’}
