select s.subject_id, m.chartdate, m.CHARTTIME
from `eco-rune-309016.mimic_iii_data.subjects` as s
join `physionet-data.mimiciii_clinical.microbiologyevents` as m
on s.subject_id=m.SUBJECT_ID
where (m.SPEC_TYPE_DESC like '%BLOOD CULTURE%'
or m.SPEC_TYPE_DESC like '%URINE%'
or m.SPEC_TYPE_DESC like '%STOOL%'
or m.SPEC_TYPE_DESC like '%CSF%');
