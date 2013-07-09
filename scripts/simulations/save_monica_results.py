import os
import csv
import monica


def save_monica_results(result_object, output_path, standort, classification, ff, variante, profil_nr, location_nr):    
    
    print "Running save_monica_results.py"
    crop_file = standort + "_cropresults_class-" + str(classification) + "_ff" + ff + "-anlage-" + str(variante) + ".txt"
    monthly_file = standort + "_monthlyresults_class-" + str(classification) + "_ff" + ff + "-anlage-" + str(variante) + ".txt"
    
    # primaryYield, secondaryYield, sumFertiliser, sumIrrigation, 
    # sumMineralisation, sumETaPerCrop
    crop_ids = monica.eva2CropResultIds()
    crop_header = ["crop"]
    for id in crop_ids:
        print monica.resultIdInfo(id).shortName
        crop_header.append(monica.resultIdInfo(id).shortName)
    csv_crop = csv.writer(open(os.path.normpath(output_path +"/" + crop_file), "wb"),delimiter=';')
    csv_crop.writerow(crop_header)
    
    
    # avg10cmMonthlyAvgCorg, avg30cmMonthlyAvgCorg, mean90cmMonthlyAvgWaterContent,
    # monthlySumGroundWaterRecharge, monthlySumNLeaching
    monthly_ids = monica.eva2MonthlyResultIds()   
    print monthly_ids     
    month_header = ["id_pg", "profil_nr", "month"]
    for id in monthly_ids:
        print monica.resultIdInfo(id).shortName
        month_header.append(monica.resultIdInfo(id).shortName + " [" + monica.resultIdInfo(id).unit + "]")
    csv_month = csv.writer(open(os.path.normpath(output_path + "/" +  monthly_file), "wb"),delimiter=';')
    csv_month.writerow(month_header)
    
    
    # write results to file by analysing results for each crop
    crop_results_count = len(result_object.getResultsById(crop_ids[1]))    
    for crop_index in range(crop_results_count):
        output_list = [crop_index]
        for id in crop_ids:
            list = result_object.getResultsById(id)
            print "Crop_index", crop_index, "Id", monica.resultIdInfo(id).shortName, "List", list
            if (crop_index<len(list)):
                output_list.append(list[crop_index])
            else:
                output_list.append(None)
        csv_crop.writerow(output_list)
    
    # write results to file by analysing results for each month    
    month_results_count = len(result_object.getResultsById(monthly_ids[0]))    
    for month_index in range(month_results_count):
        output_list = [str(location_nr) + "1" + str(variante) + ff,  profil_nr, month_index]
        for id in monthly_ids:
            list = result_object.getResultsById(id)
            if (month_index<len(list)):
                output_list.append(list[month_index])
            else:
                output_list.append(None)
        csv_month.writerow(output_list)
    
