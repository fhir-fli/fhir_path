
using QDM version '5.5'

/*
The measure is to look for patients for whom TSH testing is performed at least once
every 8 weeks while receiving an ICI for a maximum duration of 1 year from the start
of ICI therapy. Therapy given from prior year through the measurement period. For
instance, if the measurement is 2021, we are only interested in therapy that starts in
2020. The therapy could end in 2020, or 2021, or does not end at all. Also, for the
purposes of the measure, we are only interested within 1 year of therapy from the
start of therapy. For example, if the patient starts therapy in January 2020 and
ends therapy March 2021 (that’s more than 1 year), we are only interested in
January 2020 – January 2021. The first 8-week time interval calculation begins
with the patient’s therapy start date. The actual date of each test does not
influence the subsequent intervals. The result is to calculate if the patient got
at least 1 TSH test per each 8-week period (Week 0-8, week 8-16, week 16-24,
week 24-32, week 32-40, week 40-48, week 48-56).

Calculation of the intervals using the following:

           Bin 1: Week 0-8 from therapy start date
           Bin 2: Week 8-16 from therapy start date
           Bin 3: Week 16-24 from therapy start date
           Bin 4: Week 24-32 from therapy start date
           Bin 5: Week 32-40 from therapy start date
           Bin 6: Week 40-48 from therapy start date
           Bin 7: Week 48-56 from therapy start date

       If patient stops therapy before exactly 12 months (1-year) from therapy start date,
       look for 1 TSH test within the bin the patient therapy end date falls into

       If patient is still on therapy when they reach 1-year from therapy start date,
       look for a final TSH test within bin 7 (week 48-56)

       If patient is on therapy for < 8 weeks, look for 1 TSH test within bin 1
*/

valueset "Cancer": 'TBD'
valueset "Immune Checkpoint Inhibitor": 'TBD'
valueset "Thyrotropin [Units/volume] in Serum or Plasma": 'TBD'
valueset "Thyroxine (T4) free [Mass/volume] in Serum or Plasma": 'TBD'

parameter "Measurement Period" Interval<DateTime>
