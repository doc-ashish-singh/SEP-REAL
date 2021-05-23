SELECT a.subject_id
from `physionet-data.mimiciii_clinical.admissions` as a
join `physionet-data.mimiciii_clinical.patients` as p on a.subject_id=p.subject_id

join (
    select subject_id, sum(num_hours) as total_hours
    from
        (select subject_id, admittime, dischtime, TIMESTAMP_DIFF(DISCHTIME, ADMITTIME, HOUR) AS num_hours
        from `physionet-data.mimiciii_clinical.admissions`)
    group by subject_id
    having sum(num_hours) > 7
    and sum(num_hours) < 2000
) x on a.subject_id=x.subject_id
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) > 18*365
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) < 120*365;
