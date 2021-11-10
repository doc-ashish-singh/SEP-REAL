select c.SUBJECT_ID, c.ITEMID, max(c.CHARTTIME) as CHARTTIME, max(c.VALUENUM) as VALUENUM
from `physionet-data.mimiciii_clinical.chartevents` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (
                220277, --SpO2
                223835, --FiO2
                220052, --MAP
                225690, --Bilirubin
                220615, --Creatinine
                227457 --Platelets
                )
and c.CHARTTIME < w.WI_1
group by c.SUBJECT_ID, c.ITEMID

UNION ALL


select c.SUBJECT_ID, c.ITEMID, c.CHARTTIME, c.VALUENUM
from `physionet-data.mimiciii_clinical.chartevents` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (
                220277, --SpO2
                223835, --FiO2
                220052, --MAP
                225690, --Bilirubin
                220615, --Creatinine
                227457 --Platelets
                )
and c.CHARTTIME between w.WI_1 and w.WI_2;

-- CHECK FOR CORRECTNESS