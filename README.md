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
* Run the file with `python sofa_score.py <N>` where N is the number of patients that you want the SOFA scores (and the time of onset of sepsis) for
