import pandas as pd
from datetime import datetime, timedelta
import random
import json
from pathlib import Path
import sys

"""
download the files from BigQuery and change 
the following path the wherever your files are stored.
"""
data_folder = "/Users/mihirsawant/Downloads/"


def get_sofa_score(n):

    # get all dataframes
    # TODO refactor
    gcs = pd.read_csv(data_folder + 'gcs')
    gcs['CHARTTIME'] = pd.to_datetime(gcs['CHARTTIME'])
    fio2 = pd.read_csv(data_folder + 'FiO2')
    fio2['CHARTTIME'] = pd.to_datetime(fio2['CHARTTIME'])
    spo2 = pd.read_csv(data_folder + 'SpO2')
    spo2['CHARTTIME'] = pd.to_datetime(spo2['CHARTTIME'])
    bilirubin = pd.read_csv(data_folder + 'bilirubin.csv')
    bilirubin['CHARTTIME'] = pd.to_datetime(bilirubin['CHARTTIME'])
    platelets = pd.read_csv(data_folder + 'platelets.csv')
    platelets['CHARTTIME'] = pd.to_datetime(platelets['CHARTTIME'])
    creatinine = pd.read_csv(data_folder + 'creatinine.csv')
    creatinine['CHARTTIME'] = pd.to_datetime(creatinine['CHARTTIME'])
    # mean_arterial_pressure = pd.read_csv(data_folder + 'MAP.csv')
    # mean_arterial_pressure['CHARTTIME'] = pd.to_datetime(mean_arterial_pressure['CHARTTIME'])
    # dopamine = pd.read_csv(data_folder + 'dopamine.csv')
    # dopamine['STARTTIME'] = pd.to_datetime(dopamine['STARTTIME'])

    window_of_interest = pd.read_csv(data_folder + 'window_of_interest')


    all_intervals = []

    # get sofa score and sepsis onset for N random subject IDs
    window_of_interest = window_of_interest.sample(frac=1)
    test_s_id = list(window_of_interest['subject_id'])[:n]
    sofa_test_res = []

    for t_s_id in test_s_id:

        s_id = t_s_id
        sofa_score = []
        for i in range(75):
            
            if i == 0:
                # initialize last sofa score to compare with current iteration
                last_sofa = 0

            # upper and lower bounds of window of interest
            t1 = window_of_interest.loc[window_of_interest['subject_id'] == s_id]['WI_1'].values[0]
            t2 = window_of_interest.loc[window_of_interest['subject_id'] == s_id]['WI_2'].values[0]

            # timestamp at current iteration
            t = datetime.fromisoformat(t1) + timedelta(hours=(i))

            # check if current ts is within window of interest
            if t >  datetime.fromisoformat(t2):
                break
            else:
                all_intervals.append(t)

            # initialize SOFA score
            sofa_at_t = 0

            # GCS

            # only get values before the current ts
            mask = (gcs['CHARTTIME'] <= t) & (gcs['SUBJECT_ID'] == s_id)
            gcs_at_t = gcs.loc[mask]

            gcs_val = -1

            if not gcs_at_t.empty:
        
                # get the latest gcs value
                gcs_val = float(gcs_at_t['VALUENUM'].values[-1])

                # calculate SOFA score
                if gcs_val >= 13 and gcs_val <=14:
                    sofa_at_t += 1
                elif gcs_val >= 10 and gcs_val <=12:
                    sofa_at_t += 2
                elif gcs_val >= 6 and gcs_val <=9:
                    sofa_at_t += 3
                elif gcs_val <=6:
                    sofa_at_t += 4

            # FiO2 and SpO2
            mask_fio2 = (fio2['CHARTTIME'] <= t) & (fio2['SUBJECT_ID'] == s_id)
            fio2_at_t = fio2.loc[mask_fio2]
            mask_spo2 = (spo2['CHARTTIME'] <= t) & (spo2['SUBJECT_ID'] == s_id)
            spo2_at_t = spo2.loc[mask_spo2]

            fio2_val = -1
            spo2_val = -1

            if not fio2_at_t.empty:
                fio2_val = float(fio2_at_t['VALUENUM'].values[-1])
                fio2_val /= 100

            if not spo2_at_t.empty:
                spo2_val = float(spo2_at_t['VALUENUM'].values[-1])

            if fio2_val > -1 and spo2_val > -1:
                if spo2_val/fio2_val > 221 and spo2_val/fio2_val <= 302:
                    sofa_at_t += 1
                elif spo2_val/fio2_val > 142 and spo2_val/fio2_val <= 221:
                    sofa_at_t += 2
                elif spo2_val/fio2_val > 67 and spo2_val/fio2_val <= 142:
                    sofa_at_t += 3
                elif spo2_val/fio2_val <= 67:
                    sofa_at_t += 4

            # cardio

            #TODO

            mask_map = (mean_arterial_pressure['CHARTTIME'] <= t) & (mean_arterial_pressure['SUBJECT_ID'] == s_id)
            map_at_t = mean_arterial_pressure.loc[mask]
            mask_dopamine = (dopamine['STARTTIME'] <= t) & (dopamine['SUBJECT_ID'] == s_id)
            dopamine_at_t = dopamine.loc[mask]


            # bilirubin
            mask = (bilirubin['CHARTTIME'] <= t) & (bilirubin['SUBJECT_ID'] == s_id)
            bilirubin_at_t = bilirubin.loc[mask]
            
            bilirubin_val = -1

            if not bilirubin_at_t.empty:
                bilirubin_val = float(bilirubin_at_t['VALUENUM'].values[-1])
                if bilirubin_val >= 1.2 and bilirubin_val <=1.9:
                    sofa_at_t += 1
                elif bilirubin_val > 1.9 and bilirubin_val <=5.9:
                    sofa_at_t += 2
                elif bilirubin_val > 5.9 and bilirubin_val <=11.9:
                    sofa_at_t += 3
                elif bilirubin_val >11.9:
                    sofa_at_t += 4


            # creatinine
            mask = (creatinine['CHARTTIME'] <= t) & (creatinine['SUBJECT_ID'] == s_id)
            creatinine_at_t = creatinine.loc[mask]
            
            creatinine_val = -1

            if not creatinine_at_t.empty:
                creatinine_val = float(creatinine_at_t['VALUENUM'].values[-1])
                if creatinine_val >= 1.2 and creatinine_val <=1.9:
                    sofa_at_t += 1
                elif creatinine_val > 1.9 and creatinine_val <=3.4:
                    sofa_at_t += 2
                elif creatinine_val > 3.4 and creatinine_val <=4.9:
                    sofa_at_t += 3
                elif creatinine_val >4.9:
                    sofa_at_t += 4

            # platelets
            mask = (platelets['CHARTTIME'] <= t) & (platelets['SUBJECT_ID'] == s_id)
            platelets_at_t = platelets.loc[mask]
            
            platelets_val = -1

            if not platelets_at_t.empty:
                platelets_val = float(platelets_at_t['VALUENUM'].values[-1])
                if platelets_val > 100 and platelets_val <=150:
                    sofa_at_t += 1
                elif platelets_val > 50 and platelets_val <=100:
                    sofa_at_t += 2
                elif platelets_val > 20 and platelets_val <=50:
                    sofa_at_t += 3
                elif platelets_val <= 20:
                    sofa_at_t += 4


            # create json with SOFA values and variable values for testing and demonstration purposes
            sofa_score_row = {
                'ts': t.strftime("%Y/%m/%d, %H:%M:%S"), 
                'sofa': sofa_at_t
            }
            
            if gcs_val >-1:
                sofa_score_row['gcs'] = gcs_val
            if fio2_val >-1:
                sofa_score_row['fio2'] = fio2_val
            if spo2_val >-1:
                sofa_score_row['spo2'] = spo2_val
            if bilirubin_val >-1:
                sofa_score_row['bilirubin'] = bilirubin_val
            if creatinine_val >-1:
                sofa_score_row['creatinine'] = creatinine_val
            if platelets_val >-1:
                sofa_score_row['platelets'] = platelets_val
                
            if sofa_at_t - last_sofa > 2:
                sofa_score_row['sepsis_onset'] = t.strftime("%Y/%m/%d, %H:%M:%S")
                sofa_score.append(sofa_score_row)
                break
            else:
                sofa_score.append(sofa_score_row)
            
            # update SOFA score for next iteration
            last_sofa = sofa_at_t
            
        sofa_test_res.append((t_s_id, sofa_score))

    print(json.dumps(sofa_test_res, indent=4))


arg = sys.argv[1]
get_sofa_score(int(arg))