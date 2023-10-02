
using QDM version '5.3'

valueset "Macular Exam": '1.1' // { ME001: Macular Exam }
valueset "Retinopathy Severity Finding": '2.1' // { F001: Retinopathy Severity }
valueset "Level of Severity of Retinopathy Findings": '3.1' // { Mild: Mild Retinopathy, Moderate: Moderate Retinopathy, Severe: Severe Retinopathy }
valueset "Macular Edema Finding": '2.2' // { F002: Macular Edema Finding }
valueset "Macular Edema Findings Absent": '3.2' // { Absent: No macular edema findings }
valueset "Macular Edema Findings Present": '3.3' // { Present: Macular edema findings present }

parameter "Measurement Period" Interval<DateTime>
