select c.SUBJECT_ID, c.ITEMID, c.CHARTTIME, c.VALUE, c.VALUENUM, c.VALUEUOM
from `physionet-data.mimiciii_clinical.chartevents` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID=198
and c.CHARTTIME between w.WI_1 and w.WI_2
order by c.SUBJECT_ID, c.CHARTTIME;
