SELECT distinct a.subject_id
from `physionet-data.mimiciii_clinical.admissions` as a
join `physionet-data.mimiciii_clinical.patients` as p on a.subject_id=p.subject_id
join `physionet-data.mimiciii_clinical.microbiologyevents` as m on a.SUBJECT_ID=m.SUBJECT_ID
join `physionet-data.mimiciii_clinical.prescriptions` as pres on a.SUBJECT_ID=pres.SUBJECT_ID
join (
    select subject_id, sum(num_hours) as total_hours
    from
        (select subject_id, admittime, dischtime, TIMESTAMP_DIFF(DISCHTIME, ADMITTIME, HOUR) AS num_hours
        from `physionet-data.mimiciii_clinical.admissions`)
    group by subject_id
    having sum(num_hours) > 7
    and sum(num_hours) < 2000
) x on a.subject_id=x.subject_id
join (
    select drug from `eco-rune-309016.mimic_iii_data.drug_names`
) y on pres.DRUG=y.drug
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) > 18*365
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) < 120*365
and (m.SPEC_TYPE_DESC like '%BLOOD CULTURE%'
or m.SPEC_TYPE_DESC like '%URINE%'
or m.SPEC_TYPE_DESC like '%STOOL%'
or m.SPEC_TYPE_DESC like '%CSF%');
