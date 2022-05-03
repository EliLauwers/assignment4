Assignment4 - Edit Rules - Eli Lauwers
================

# About this document

This document is the answer to the fourth databases assignment on
database edit rules. The workflow for this assignment is as follows.

# 1.Data exploration

Provide solutions to the following data exploration exercises related to
the data in the `purpose` table (so not the example data given in Table
1) in your report.

1.  Get the total number of rows.

**Answer**: There are 1511 rows in the `purpose` table

``` bash
echo -e "SELECT * FROM purpose" | java -jar rulebox.jar explore stats --d clinicaltrials.json
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
java -jar rulebox.jar explore stats --d clinicaltrials.json
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
java -jar rulebox.jar explore stats --d clinicaltrials.json
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

| Attribute                        | no. null values |
|----------------------------------|-----------------|
| study\_type\_non\_interventional | 1               |
| ctgov\_purpose                   | 244             |
| drks\_purpose                    | 209             |
| drks\_study\_type                | 0               |
| ctgov\_study\_type               | 0               |
| observational\_model             | 0               |

``` bash
echo -e "SELECT * FROM purpose" |
java -jar rulebox.jar explore stats --d clinicaltrials.json
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
2.  E12: The `dst` attribute can take on two potential values. The
    `stni` attribute is used to further specify the ‘non interventional’
    value for the `dst` attribute. When the `dst` attribute takes on the
    value of ‘interventional’, the `stni` should take on the value of
    ‘N/A’. It means that a valid pattern is `cst`: Interventional,
    `dst`: Interventional, `stni`: N/A. Edit rule E12 makes this a bit
    more concrete. The rule states that whenever `cst` takes on a value
    of ‘Interventional’, the `stni` attribute cannot take on any other
    value than the value of ‘N/A’.
3.  E16: the `stni` and `om` attributes further specify observational
    studies (From the `cst` and `dst` attributes, we know that
    observational is equivalent to non-interventional). Edit rule E16
    states that whenever the `stni` attribute indicates a interventional
    study instead of a non-interventional one, the `om` attribute should
    not indicate a further specification of an observational study. It
    does so by implying that `stni`:‘N/A’ can only be coupled with
    `om`:‘N/A’ and not with any of the 7 other specifications of
    observational studies.

<!-- -->

2.  List, for each of the following edit rules, which attributes are
    involved in the edit rule.

<!-- -->

1.  E1
2.  E5
3.  E14
4.  E17

<!-- -->

3.  For each of the following sets of attributes, list those edit rules
    that involve all attributes in that set.

<!-- -->

1.  {stni}
2.  {cp,dp}
3.  {dst,om}
