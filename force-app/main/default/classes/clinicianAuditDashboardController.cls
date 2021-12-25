//Test Class : clinicianAuditDashboardController_Test
global without sharing class clinicianAuditDashboardController{
    
    public clinicianAuditDashboardController(){
        displayDataTableFlag = False; 
    }
    
    
    public date inputDate{get;set;}
    public String sunshineCenterValue = '';
    public boolean displayDataTableFlag{get;set;}
    
    public boolean displayDataTables{
        get{
            return displayDataTableFlag;
        }set;
    }
    public list<totalHours> totalHoursList{
        get{
            if(totalHoursList == null){
                totalHoursList = new List<totalHours>();
            }
            return totalHoursList;
        }set;
    }
    
    public decimal totalHoursList_fourWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(totalHoursList != null){
                for(totalHours th : totalHoursList){
                    total = total+th.foursWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal totalHoursList_threeWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(totalHoursList != null){
                for(totalHours th : totalHoursList){
                    total = total+th.threeWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal totalHoursList_twoWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(totalHoursList != null){
                for(totalHours th : totalHoursList){
                    total = total+th.twoWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal totalHoursList_oneWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(totalHoursList != null){
                for(totalHours th : totalHoursList){
                    total = total+th.oneWeekPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal totalHoursList_allTotal{
        get{
            decimal total = totalHoursList_oneWeeksPriorTotal + totalHoursList_twoWeeksPriorTotal + totalHoursList_threeWeeksPriorTotal + totalHoursList_fourWeeksPriorTotal;
            return total;
        }set;
    }
    
    public list<individualSessionHours> individualSessionHoursList{
        get{
            if(individualSessionHoursList == null){
                individualSessionHoursList = new List<individualSessionHours>();
            }
            return individualSessionHoursList;
        }set;
    }
    
    public decimal individualSessionHoursList_fourWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(individualSessionHoursList != null){
                for(individualSessionHours th : individualSessionHoursList){
                    total = total+th.foursWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal individualSessionHoursList_threeWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(individualSessionHoursList != null){
                for(individualSessionHours th : individualSessionHoursList){
                    total = total+th.threeWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal individualSessionHoursList_twoWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(individualSessionHoursList != null){
                for(individualSessionHours th : individualSessionHoursList){
                    total = total+th.twoWeeksPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal individualSessionHoursList_oneWeeksPriorTotal{
        get{
            decimal total = 0.0;
            if(individualSessionHoursList != null){
                for(individualSessionHours th : individualSessionHoursList){
                    total = total+th.oneWeekPriorHours;
                }
            }
            return total;
        }set;
    }
    
    public decimal individualSessionHoursList_allTotal{
        get{
            decimal total = individualSessionHoursList_oneWeeksPriorTotal + individualSessionHoursList_twoWeeksPriorTotal + individualSessionHoursList_threeWeeksPriorTotal + individualSessionHoursList_fourWeeksPriorTotal;
            return total;
        }set;
    }
    
    public list<groupSessionHours> groupSessionHoursList{
        get{
            if(groupSessionHoursList == null){
                groupSessionHoursList = new List<groupSessionHours>();
            }
            return groupSessionHoursList;
        }set;
    }
    
    public decimal grouSessionHoursList_fourWeeksPriorCompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.foursWeeksPriorHoursComplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_fourWeeksPriorIncompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.foursWeeksPriorHoursIncomplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_threeWeeksPriorCompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.threeWeeksPriorHoursComplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_threeWeeksPriorIncompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.threeWeeksPriorHoursIncomplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_twoWeeksPriorCompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.twoWeeksPriorHoursComplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_twoWeeksPriorIncompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.twoWeeksPriorHoursIncomplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_oneWeeksPriorCompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.oneWeekPriorHoursComplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal grouSessionHoursList_oneWeeksPriorIncompleteTotal{
        get{
            decimal total = 0.0;
            if(groupSessionHoursList != null){
                for(groupSessionHours th : groupSessionHoursList){
                    total = total+th.oneWeekPriorHoursIncomplete;
                }
            }
            return total;
        }set;
    }
    
    public decimal groupSessionHoursList_allTotal{
        get{
            decimal total = grouSessionHoursList_fourWeeksPriorCompleteTotal + grouSessionHoursList_fourWeeksPriorIncompleteTotal + grouSessionHoursList_threeWeeksPriorCompleteTotal + grouSessionHoursList_threeWeeksPriorIncompleteTotal + grouSessionHoursList_twoWeeksPriorCompleteTotal + grouSessionHoursList_twoWeeksPriorIncompleteTotal + grouSessionHoursList_oneWeeksPriorCompleteTotal + grouSessionHoursList_oneWeeksPriorIncompleteTotal;
            return total;
        }set;
    }
    
    public string priorWeekHeaderValue{
        get{
            if(inputDate!=null){
                date priorWeekDate = inputDate.addDays(-6);
                String priorWeekHeaderValue = string.valueOf(priorWeekDate.Month())+'/'+string.valueOf(priorWeekDate.Day())+'/'+string.valueOf(priorWeekDate.Year())+' - '+string.valueOf(inputDate.Month())+'/'+string.valueOf(inputDate.Day())+'/'+string.valueOf(inputDate.Year());
                return priorWeekHeaderValue;
            }
            return null;
        }set;
    }
    public string priorTwoWeekHeaderValue{
        get{
            if(inputDate!=null){
                date priorTwoWeekStartDate = inputDate.addDays(-13);
                date priorTwoWeekEndDate = inputDate.addDays(-7);
                String priorTwoWeekHeaderValue = string.valueOf(priorTwoWeekStartDate.Month())+'/'+string.valueOf(priorTwoWeekStartDate.Day())+'/'+string.valueOf(priorTwoWeekStartDate.Year())+' - '+string.valueOf(priorTwoWeekEndDate.Month())+'/'+string.valueOf(priorTwoWeekEndDate.Day())+'/'+string.valueOf(priorTwoWeekEndDate.Year());
                return priorTwoWeekHeaderValue;
            }
            return null;
        }set;
    }
    
    public string priorThreeWeekHeaderValue{
        get{
            if(inputDate!=null){
                date priorThreeWeekStartDate = inputDate.addDays(-20);
                date priorThreeWeekEndDate = inputDate.addDays(-14);
                String priorThreeWeekHeaderValue = string.valueOf(priorThreeWeekStartDate.Month())+'/'+string.valueOf(priorThreeWeekStartDate.Day())+'/'+string.valueOf(priorThreeWeekStartDate.Year())+' - '+string.valueOf(priorThreeWeekEndDate.Month())+'/'+string.valueOf(priorThreeWeekEndDate.Day())+'/'+string.valueOf(priorThreeWeekEndDate.Year());
                return priorThreeWeekHeaderValue;
            }
            return null;
        }set;
    }
    
    public string priorFourWeekHeaderValue{
        get{
            if(inputDate!=null){
                date priorFourWeekStartDate = inputDate.addDays(-27);
                date priorFourWeekEndDate = inputDate.addDays(-21);
                String priorFourWeekHeaderValue = string.valueOf(priorFourWeekStartDate.Month())+'/'+string.valueOf(priorFourWeekStartDate.Day())+'/'+string.valueOf(priorFourWeekStartDate.Year())+' - '+string.valueOf(priorFourWeekEndDate.Month())+'/'+string.valueOf(priorFourWeekEndDate.Day())+'/'+string.valueOf(priorFourWeekEndDate.Year());
                return priorFourWeekHeaderValue;
            }
            return null;
        }set;
    }
    
    public void loadData(){
        if(inputDate != null && sunshineCenterValue!=null && sunshineCenterValue != '--NONE--'){
            displayDataTableFlag = True;
            totalHoursList.clear();
            groupSessionHoursList.clear();
            individualSessionHoursList.clear();
            
            system.debug('inputDate ::'+inputDate);
            system.debug('sunshineCenterValue :::'+sunshineCenterValue);
            dateTime tempDate = dateTime.NewInstance(inputDate.Year(),inputDate.Month(),inputDate.Day(),0,0,0);
            dateTime thirtyDaysPriorDate = tempDate.addDays(-30);
            Map<String,List<KIPU_Clinician_Audit__c>> totalHoursByClinicianMap = new Map<String,List<KIPU_Clinician_Audit__c>>();
            Map<String,List<KIPU_Clinician_Audit__c>> individualSessionHoursByClinicianMap = new Map<String,List<KIPU_Clinician_Audit__c>>();
            Map<String,List<KIPU_Clinician_Audit__c>> groupSessionHoursByClinicianMap = new Map<String,List<KIPU_Clinician_Audit__c>>();
            
            for(KIPU_Clinician_Audit__c kca : [Select id, Facilitator_Signed_By_Name__c, Type_of_Session__c, Duration__c, Status__c, Start_Date_Time__c, Sunshine_Center__c from KIPU_Clinician_Audit__c where Start_Date_Time__c >=: thirtyDaysPriorDate AND Sunshine_Center__c=:sunshineCenterValue ORDER BY Facilitator_Signed_By_Name__c ASC NULLS LAST]){
                if(kca.Facilitator_Signed_By_Name__c!='' && kca.Facilitator_Signed_By_Name__c!=null){
                    if(totalHoursByClinicianMap.containsKey(kca.Facilitator_Signed_By_Name__c)){
                        List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                        tempList = totalHoursByClinicianMap.get(kca.Facilitator_Signed_By_Name__c);
                        tempList.add(kca);
                        totalHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                    }else{
                        List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                        tempList.add(kca);
                        totalHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                    }
                
                    if(kca.Type_of_Session__c == 'Individual Session'){
                        if(individualSessionHoursByClinicianMap.containsKey(kca.Facilitator_Signed_By_Name__c)){
                            List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                            tempList = individualSessionHoursByClinicianMap.get(kca.Facilitator_Signed_By_Name__c);
                            tempList.add(kca);
                            individualSessionHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                        }else{
                            List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                            tempList.add(kca);
                            individualSessionHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                        }
                    }
                    
                    if(kca.Type_of_Session__c == 'Group Session'){
                        if(groupSessionHoursByClinicianMap.containsKey(kca.Facilitator_Signed_By_Name__c)){
                            List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                            tempList = groupSessionHoursByClinicianMap.get(kca.Facilitator_Signed_By_Name__c);
                            tempList.add(kca);
                            groupSessionHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                        }else{
                            List<KIPU_Clinician_Audit__c> tempList = new List<KIPU_Clinician_Audit__c>();
                            tempList.add(kca);
                            groupSessionHoursByClinicianMap.put(kca.Facilitator_Signed_By_Name__c,tempList);
                        }
                    }
                }
            }
            
            if(totalHoursByClinicianMap.keySet().isEmpty()==False){
                date priorWeekDate = inputDate.addDays(-6);
                date priorTwoWeekDate = inputDate.addDays(-13);
                date priorThreeWeekDate = inputDate.addDays(-20);
                date priorFourWeekDate = inputDate.addDays(-27);
                for(String clinicianName : totalHoursByClinicianMap.keySet()){
                    decimal oneWeekPriorHours = 0.0;
                    decimal twoWeeksPriorHours = 0.0;
                    decimal threeWeeksPriorHours = 0.0;
                    decimal fourWeeksPriorHours = 0.0;
                    
                    for(KIPU_Clinician_Audit__c kca : totalHoursByClinicianMap.get(clinicianName)){
                        if(date.Valueof(kca.Start_Date_Time__c)>=priorWeekDate){
                            oneWeekPriorHours = oneWeekPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorTwoWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorWeekDate){
                            twoWeeksPriorHours = twoWeeksPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorThreeWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorTwoWeekDate){
                            threeWeeksPriorHours = threeWeeksPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorFourWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorThreeWeekDate){
                            fourWeeksPriorHours = fourWeeksPriorHours+kca.Duration__c;
                        }
                    }
                    
                    totalHours th = new totalHours();
                    th.clinicianName = clinicianName;
                    th.oneWeekPriorHours = oneWeekPriorHours;
                    th.twoWeeksPriorHours = twoWeeksPriorHours;
                    th.threeWeeksPriorHours = threeWeeksPriorHours;
                    th.foursWeeksPriorHours = fourWeeksPriorHours;
                    th.totalHours = oneWeekPriorHours+twoWeeksPriorHours+threeWeeksPriorHours+fourWeeksPriorHours;
                    
                    totalHoursList.add(th);
                }
            }
            
            
            if(groupSessionHoursByClinicianMap.keySet().isEmpty()==False){
                date priorWeekDate = inputDate.addDays(-6);
                date priorTwoWeekDate = inputDate.addDays(-13);
                date priorThreeWeekDate = inputDate.addDays(-20);
                date priorFourWeekDate = inputDate.addDays(-27);
                for(String clinicianName : groupSessionHoursByClinicianMap.keySet()){
                    decimal oneWeekPriorHoursComplete = 0.0;
                    decimal oneWeekPriorHoursIncomplete = 0.0;
                    decimal twoWeeksPriorHoursComplete = 0.0;
                    decimal twoWeeksPriorHoursIncomplete = 0.0;
                    decimal threeWeeksPriorHoursComplete = 0.0;
                    decimal threeWeeksPriorHoursIncomplete = 0.0;
                    decimal fourWeeksPriorHoursComplete = 0.0;
                    decimal fourWeeksPriorHoursIncomplete = 0.0;
                    
                    for(KIPU_Clinician_Audit__c kca : groupSessionHoursByClinicianMap.get(clinicianName)){
                        if(date.Valueof(kca.Start_Date_Time__c)>=priorWeekDate){
                            if(kca.Status__c == 'Complete' || kca.Status__c == 'Ready For Review' || kca.Status__c == 'Pending Review')
                                oneWeekPriorHoursComplete = oneWeekPriorHoursComplete+kca.Duration__c;
                            else
                                oneWeekPriorHoursIncomplete = oneWeekPriorHoursIncomplete+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorTwoWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorWeekDate){
                            if(kca.Status__c == 'Complete' || kca.Status__c == 'Ready For Review' || kca.Status__c == 'Pending Review')
                                twoWeeksPriorHoursComplete = twoWeeksPriorHoursComplete+kca.Duration__c;
                            else
                                twoWeeksPriorHoursIncomplete = twoWeeksPriorHoursIncomplete+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorThreeWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorTwoWeekDate){
                            if(kca.Status__c == 'Complete' || kca.Status__c == 'Ready For Review' || kca.Status__c == 'Pending Review')
                                threeWeeksPriorHoursComplete = threeWeeksPriorHoursComplete+kca.Duration__c;
                            else
                                threeWeeksPriorHoursIncomplete = threeWeeksPriorHoursIncomplete+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorFourWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorThreeWeekDate){
                            if(kca.Status__c == 'Complete' || kca.Status__c == 'Ready For Review' || kca.Status__c == 'Pending Review')
                                fourWeeksPriorHoursComplete = fourWeeksPriorHoursComplete+kca.Duration__c;
                            else
                                fourWeeksPriorHoursIncomplete = fourWeeksPriorHoursIncomplete+kca.Duration__c;
                        }
                    }
                    
                    groupSessionHours th = new groupSessionHours();
                    th.clinicianName = clinicianName;
                    th.oneWeekPriorHoursComplete = oneWeekPriorHoursComplete;
                    th.oneWeekPriorHoursIncomplete = oneWeekPriorHoursIncomplete;
                    th.twoWeeksPriorHoursComplete = twoWeeksPriorHoursComplete;
                    th.twoWeeksPriorHoursIncomplete = twoWeeksPriorHoursIncomplete;
                    th.threeWeeksPriorHoursComplete = threeWeeksPriorHoursComplete;
                    th.threeWeeksPriorHoursIncomplete = threeWeeksPriorHoursIncomplete;
                    th.foursWeeksPriorHoursComplete = fourWeeksPriorHoursComplete;
                    th.foursWeeksPriorHoursIncomplete = fourWeeksPriorHoursIncomplete;
                    th.totalHours = oneWeekPriorHoursComplete+oneWeekPriorHoursIncomplete+twoWeeksPriorHoursComplete+twoWeeksPriorHoursIncomplete+threeWeeksPriorHoursComplete+threeWeeksPriorHoursIncomplete+fourWeeksPriorHoursComplete+fourWeeksPriorHoursIncomplete;
                                    
                    groupSessionHoursList.add(th);
                }
            }
            
            if(individualSessionHoursByClinicianMap.keySet().isEmpty()==False){
                date priorWeekDate = inputDate.addDays(-7);
                date priorTwoWeekDate = inputDate.addDays(-14);
                date priorThreeWeekDate = inputDate.addDays(-21);
                date priorFourWeekDate = inputDate.addDays(-28);
                for(String clinicianName : individualSessionHoursByClinicianMap.keySet()){
                    decimal oneWeekPriorHours = 0.0;
                    decimal twoWeeksPriorHours = 0.0;
                    decimal threeWeeksPriorHours = 0.0;
                    decimal fourWeeksPriorHours = 0.0;
                    
                    for(KIPU_Clinician_Audit__c kca : individualSessionHoursByClinicianMap.get(clinicianName)){
                        if(date.Valueof(kca.Start_Date_Time__c)>=priorWeekDate){
                            oneWeekPriorHours = oneWeekPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorTwoWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorWeekDate){
                            twoWeeksPriorHours = twoWeeksPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorThreeWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorTwoWeekDate){
                            threeWeeksPriorHours = threeWeeksPriorHours+kca.Duration__c;
                        }else if(date.Valueof(kca.Start_Date_Time__c)>=priorFourWeekDate && date.Valueof(kca.Start_Date_Time__c)<priorThreeWeekDate){
                            fourWeeksPriorHours = fourWeeksPriorHours+kca.Duration__c;
                        }
                    }
                    
                    individualSessionHours th = new individualSessionHours();
                    th.clinicianName = clinicianName;
                    th.oneWeekPriorHours = oneWeekPriorHours;
                    th.twoWeeksPriorHours = twoWeeksPriorHours;
                    th.threeWeeksPriorHours = threeWeeksPriorHours;
                    th.foursWeeksPriorHours = fourWeeksPriorHours;
                    th.totalHours = oneWeekPriorHours+twoWeeksPriorHours+threeWeeksPriorHours+fourWeeksPriorHours;
                    
                    individualSessionHoursList.add(th);
                }
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Select a Valid Date and Sunshine Center Name before Clicking on Load Data!!!'));
        }
    }
    
    public List<SelectOption> getSunshineCenterItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        options.add(new SelectOption('Chapters Capistrano','Chapters Capistrano'));
        options.add(new SelectOption('Monarch Shores','Monarch Shores'));
        options.add(new SelectOption('Mountain Springs Recovery','Mountain Springs Recovery'));
        options.add(new SelectOption('Willow Springs Recovery','Willow Springs Recovery'));
        return options;
    }
    
    public String getSunshineCenterValue() {
        return sunshineCenterValue;
    }
    
    public void setSunshineCenterValue(String sunshineCenterValue) {
        this.sunshineCenterValue = sunshineCenterValue;
    }
    
    public class totalHours{
        
        public string clinicianName{get;set;}
        public double foursWeeksPriorHours{get;set;}
        public double threeWeeksPriorHours{get;set;}
        public double twoWeeksPriorHours{get;set;}
        public double oneWeekPriorHours{get;set;}
        public double totalHours{get;set;}
        public totalHours(){
        }
    }

    public class individualSessionHours{
        
        public string clinicianName{get;set;}
        public double foursWeeksPriorHours{get;set;}
        public double threeWeeksPriorHours{get;set;}
        public double twoWeeksPriorHours{get;set;}
        public double oneWeekPriorHours{get;set;}
        public double totalHours{get;set;}
        public individualSessionHours(){
        }
    }
    
    public class groupSessionHours{
        
        public string clinicianName{get;set;}
        public double foursWeeksPriorHoursComplete{get;set;}
        public double foursWeeksPriorHoursIncomplete{get;set;}
        public double threeWeeksPriorHoursComplete{get;set;}
        public double threeWeeksPriorHoursIncomplete{get;set;}
        public double twoWeeksPriorHoursComplete{get;set;}
        public double twoWeeksPriorHoursIncomplete{get;set;}
        public double oneWeekPriorHoursComplete{get;set;}
        public double oneWeekPriorHoursIncomplete{get;set;}
        public double totalHours{get;set;}
        public groupSessionHours(){
        }
    }


}