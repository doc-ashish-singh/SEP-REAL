select 
case when t1.subject_id is null then t2.subject_id
else t1.subject_id end as subject_id,

case when prescription_ts < culture_ts then TIMESTAMP_SUB(prescription_ts, INTERVAL 48 HOUR)

when culture_ts < prescription_ts then TIMESTAMP_SUB(culture_ts, INTERVAL 48 HOUR)

when prescription_ts is null then TIMESTAMP_SUB(culture_ts, INTERVAL 48 HOUR)

when culture_ts is null then TIMESTAMP_SUB(prescription_ts, INTERVAL 48 HOUR)

else null end as WI_1,

case when prescription_ts < culture_ts then TIMESTAMP_ADD(prescription_ts, INTERVAL 24 HOUR)

when culture_ts < prescription_ts then TIMESTAMP_ADD(culture_ts, INTERVAL 24 HOUR)

when prescription_ts is null then TIMESTAMP_ADD(culture_ts, INTERVAL 24 HOUR)

when culture_ts is null then TIMESTAMP_ADD(prescription_ts, INTERVAL 24 HOUR)

else null end as WI_2

FROM
(
select a.subject_id, min(p.startdate) as prescription_ts
from `eco-rune-309016.mimic_iii_data.subject` as a
join `eco-rune-309016.mimic_iii_data.microbiologyevents` as m on a.subject_id=m.subject_id
join `eco-rune-309016.mimic_iii_data.prescriptions` as p on a.subject_id=p.subject_id
where TIMESTAMP_DIFF(m.charttime, p.startdate, HOUR) < 3*24
and TIMESTAMP_DIFF(m.charttime, p.startdate, HOUR) > 0
group by a.subject_id
) t1

full JOIN

(
select a.subject_id, min(m.charttime) as culture_ts
from `eco-rune-309016.mimic_iii_data.subject` as a
join `eco-rune-309016.mimic_iii_data.microbiologyevents` as m on a.subject_id=m.subject_id
join `eco-rune-309016.mimic_iii_data.prescriptions` as p on a.subject_id=p.subject_id
where TIMESTAMP_DIFF(p.startdate, m.charttime, HOUR) < 24
and TIMESTAMP_DIFF(p.startdate, m.charttime, HOUR) > 0
group by a.subject_id
) t2

on t1.subject_id=t2.subject_id
