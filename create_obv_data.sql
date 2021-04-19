SELECT c.subject_id, c.charttime, d.LABEL, c.itemid, d.UNITNAME, c.value, a.diagnosis
from `physionet-data.mimiciii_clinical.admissions` as a
join `physionet-data.mimiciii_clinical.chartevents` as c on a.subject_id=c.subject_id
join `physionet-data.mimiciii_clinical.d_items` as d on c.ITEMID=d.ITEMID
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

-- where a.diagnosis like '%SEPSIS%'
where c.itemid in (220277, 618, 211, 51, 8368, 198, 676, 678)
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) > 18*365
and TIMESTAMP_DIFF(a.ADMITTIME, p.DOB, DAY) < 120*365
--and total_hours > 7
--and total_hours < 2000;
