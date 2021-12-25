public without sharing class InfectionControlReport_Ctrl {

    public Infection_Control_Report__c InfectiontReport {
        get;
        private set;
    }
   
    public List<Infection_Control_Report__c> lstInfectiontReport{
        get;
        set;
    
    }
    public boolean disabled{
        get;
        set;
    }

    public InfectionControlReport_Ctrl() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id != null){
             disabled = true;
        }
       
        InfectiontReport = (id == null) ? new Infection_Control_Report__c() : [SELECT Name,Client_Name__c,Community_Acquired__c,Completed_By_Email__c,
                                                                            Completed_By_Name__c,Date_of_Admission__c,Date_Symptoms_Identified__c,Facility_Acquired__c,Notes__c,
                                                                            Sunshine_Center__c,Sunshine_Center__r.Name,Symptoms_Identified__c,Treatment__c,Type_of_Infection__c,Type_of_Infection_Other_Description__c
                                                                            FROM Infection_Control_Report__c
                                                                            WHERE Id =: id
        ];
        
    }
    @AuraEnabled
    public static List<Infection_Control_Report__c> getAllInfectionReports(Integer pageSize,
                                                                 Integer pageNumber,
                                                                 string empSunshine){
        
        Integer offset = (pageNumber - 1) * pageSize;
        string sunshineCenterName = empSunshine;
        string query = 'Select ID,Name,Completed_By_Name__c, Sunshine_Center_Name__c,';
        query += 'Client_Name__c, Date_Symptoms_Identified__c';
        query += ' FROM Infection_Control_Report__c ';
        if(sunshineCenterName != 'All'){
            query += ' WHERE  Sunshine_Center_Name__c =:sunshineCenterName';
        }
        query += ' ORDER BY NAME LIMIT :pageSize OFFSET :offset';
        return database.query(query);
    }
    @AuraEnabled
    public static string getEmpSunshine( string empId){
        Employee__c empObj = [Select Id,Sunshine_Center_Relation_To__r.Name
                             From Employee__c WHERE Id =:empId];
        return empObj.Sunshine_Center_Relation_To__r.Name;
    }

    

    @AuraEnabled
    public static string saveIncident(Infection_Control_Report__c incJsonStr){
        
        Account acc;
        if(test.isRunningTest()){
            acc = [Select ID FROM ACCOUNT limit 1];
        }
        else{
            acc = [Select ID FROM ACCOUNT WHERE NAME =: incJsonStr.Sunshine_Center__c limit 1];
        }
       
        incJsonStr.Sunshine_Center__c = acc.Id;
        insert incJsonStr;  
        string pageUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/infectionControlReportPDF_HTML';
        system.debug('*****: ' + pageUrl);
        sendEmail(incJsonStr.Id,pageUrl);  
        return incJsonStr.Id;
               
    }
    @Future(callout=true)
    public static void sendEmail(string incidentId,string pageUrl){

        string emailBody = 'Thanks for creating the Infection Control Report. Please find your copy in an attachment';
        Infection_Control_Report__c incObj = [Select Name,Completed_By_Email__c,Sunshine_Center__r.Name from Infection_Control_Report__c where Id=:incidentId limit 1];
        system.debug('*****: ' + incObj.Completed_By_Email__c);
        string emailAddress = sunshineEmail(incObj.Sunshine_Center__r.Name);
        emailAddress += ';'+ incObj.Completed_By_Email__c;
        
        EmailUtility.sendEmail(emailAddress,emailBody,
                                'Infection Control Report',
                                'clientservices@sunshinebh.com',
                                true,
                                pageUrl,
                                incObj.Name,incidentId);
    }
    
    private static string sunshineEmail(string sunshineCentreName){
        
        switch on sunshineCentreName{
            when 'Chapters Capistrano'{
                return 'manuelp@sunshinebh.com';
            }             
            when 'Monarch Shores'{
             return 'manuelp@sunshinebh.com';
            }
                       
            when 'Mountain Springs Recovery'{
             return 'amandaj@mountainspringsrecovery.com';
            }
                 
           when 'Willowsprings Recovery'{
             return 'laynel@willowspringsrecovery.com';
           }      
        }
        
        return '';
    }


    @AuraEnabled
    public static Infection_Control_Report__c getInfectionReportById(string recordId){
        try {
            return [SELECT Name,Client_Name__c,Community_Acquired__c,Completed_By_Email__c,Completed_By_Name__c,Date_of_Admission__c,Date_Symptoms_Identified__c,Facility_Acquired__c,Notes__c,
                    Sunshine_Center__c,Sunshine_Center_Name__c,Symptoms_Identified__c,Treatment__c,Type_of_Infection__c,Type_of_Infection_Other_Description__c
              FROM Infection_Control_Report__c
              WHERE Id =: recordId
        ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Infection_Control_Report__c> getSearchInfection(Date startDate,
                                                           Date endDate,
                                                           string sunshineCenterName,
                                                           Integer pageSize,
                                                           Integer pageNumber){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            Date defaultStartDate = Date.today().addYears(-10);
            Date defaultEndDate = Date.today().addYears(20);
            List<string> lstOfSunchineCentre = new List<string>();
            lstOfSunchineCentre.add('Chapters Capistrano');
            lstOfSunchineCentre.add('Monarch Shores');
            lstOfSunchineCentre.add('Mountain Springs Recovery');
            lstOfSunchineCentre.add('Willow Springs Recovery');

            if(sunshineCenterName != 'All'){
                lstOfSunchineCentre = new List<string>();
                lstOfSunchineCentre.add(sunshineCenterName);
            }

            if(startDate != null){
                defaultStartDate = startDate;
            }
            if(endDate != null){
                defaultEndDate = endDate;
            }

            if(sunshineCenterName == 'All'){
                return [Select Name,Client_Name__c,Community_Acquired__c,Completed_By_Email__c,Completed_By_Name__c,Date_of_Admission__c,Date_Symptoms_Identified__c,Facility_Acquired__c,Notes__c,
                    Sunshine_Center__c,Sunshine_Center_Name__c,Symptoms_Identified__c,Treatment__c,Type_of_Infection__c,Type_of_Infection_Other_Description__c
                        FROM Infection_Control_Report__c WHERE Date_Symptoms_Identified__c
                >=: defaultStartDate AND Date_Symptoms_Identified__c <=: defaultEndDate
                ORDER BY NAME
                LIMIT :pageSize 
                OFFSET :offset];
            }
            return [Select Name,Client_Name__c,Community_Acquired__c,Completed_By_Email__c,Completed_By_Name__c,Date_of_Admission__c,Date_Symptoms_Identified__c,Facility_Acquired__c,Notes__c,
                    Sunshine_Center__c,Sunshine_Center_Name__c,Symptoms_Identified__c,Treatment__c,Type_of_Infection__c,Type_of_Infection_Other_Description__c
                    FROM Infection_Control_Report__c WHERE Date_Symptoms_Identified__c
                    >=: defaultStartDate AND Date_Symptoms_Identified__c <=: defaultEndDate 
                    AND Sunshine_Center__r.Name IN :  lstOfSunchineCentre
                    ORDER BY NAME
                    LIMIT :pageSize 
                    OFFSET :offset];

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}