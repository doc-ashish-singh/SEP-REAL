select c.SUBJECT_ID, c.ITEMID, max(c.STARTTIME) as STARTTIME, max(c.AMOUNT) as AMOUNT, "mg" as UNIT
from `physionet-data.mimiciii_clinical.inputevents_mv` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (
    221662, --Dopamine
    221906, --Norepinephrine
    221653, --Dobutamine
    221749  --Phenylephrine
)
and c.STARTTIME < w.WI_1
group by c.SUBJECT_ID, c.ITEMID

UNION ALL

select c.SUBJECT_ID, c.ITEMID, c.STARTTIME, c.AMOUNT, "mg" as UNIT
from `physionet-data.mimiciii_clinical.inputevents_mv` as c
join `eco-rune-309016.mimic_iii_data.window_of_interest` as w
on c.SUBJECT_ID=w.subject_id
where ITEMID IN (
    221662, --Dopamine
    221906, --Norepinephrine
    221653, --Dobutamine
    221749  --Phenylephrine
)
and c.STARTTIME between w.WI_1 and w.WI_2;