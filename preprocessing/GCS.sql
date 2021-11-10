select c.SUBJECT_ID, max(c.CHARTTIME) as CHARTTIME, SUM(c.VALUENUM) as VALUENUM
from `physionet-data.mimiciii_clinical.chartevents` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (220739, --GCS Eye Opening
                223901, --GCS Motor Response
                223900 --GCS Verbal Response
                )
and c.CHARTTIME < w.WI_1
group by c.SUBJECT_ID
having COUNT(c.VALUENUM) = 3
-- order by c.SUBJECT_ID, CHARTTIME;

UNION ALL

select c.SUBJECT_ID, c.CHARTTIME, SUM(c.VALUENUM)
from `physionet-data.mimiciii_clinical.chartevents` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (220739, --GCS Eye Opening
                223901, --GCS Motor Response
                223900 --GCS Verbal Response
                )
and c.CHARTTIME between w.WI_1 and w.WI_2
group by c.SUBJECT_ID, c.CHARTTIME
having COUNT(c.VALUENUM) = 3;

-- TODO check for correctness