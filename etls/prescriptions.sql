select s.subject_id, p.STARTDATE
from `eco-rune-309016.mimic_iii_data.subjects` as s
join `physionet-data.mimiciii_clinical.prescriptions` as p
on s.subject_id=p.SUBJECT_ID;
