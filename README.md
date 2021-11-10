# SEP-REAL

Some ETLs and preprocessing as of now. To check out SOFA score implementation (work in progress), follow these steps -
* Install Pandas using `pip install pandas` (I'll add in a requirements.txt file later)
* Download the data files from bigquery - 
    -   gcs
    -   fio2
    -   spo2
    -   creatinine
    -   bilirubin
    -   platelets
* Change the `data_folder` variable to point it to the location where the files were downloaded
* Run the file with `python get_sofa_score.py <N>` where N is the number of patients that you want the SOFA scores (and the time of onset of sepsis) for


### ITEMIDs-

* For SOFA score -
    - SpO2 = 220277
    - FiO2 = 223835
    - MAP = 220052
    - Dopamine = 221662
    - Norepinephrine = 221906
    - Dobutamine = 221653
    - Phenylephrine = 221749
    - Bilirubin = 225690
    - Creatinine = 220615
    - Platelets = 227457
    - GCS = 220739, 223900, 223901