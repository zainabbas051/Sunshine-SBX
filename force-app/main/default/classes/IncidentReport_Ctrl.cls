public without sharing class IncidentReport_Ctrl {

    public Incident_Report_SBH__c IncidentReport {
        get;
        private set;
    }
    public string selectedOptions {
        get;
        set;
    }
    public string selectedOptionsL1 {
        get;
        set;
    }
    public string selectedOptionsL2 {
        get;
        set;
    }
    public string selectedOptionsL3 {
        get;
        set;
    }
    public List<Incident_Report_SBH__c> lstIncidentReport{
        get;
        set;
    
    }
    public boolean disabled{
        get;
        set;
    }

    public IncidentReport_Ctrl() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id != null){
             disabled = true;
        }
       
        IncidentReport = (id == null) ? new Incident_Report_SBH__c() : [SELECT Name,CreatedDate, Name_of_Person_s_Involved__c, Observed_by_Writer__c, Date_Time_of_Incident__c, Location_of_Incident__c,
            Reported_to_Writer__c, Check_All_That_Apply__c, Level_One_Incident_Type__c, Level_Three_Incident_Type__c, Level_Two_Incident_Type__c, Level_One_Incident_Other_Description__c,
            Level_Two_Incident_Other_Description__c, Level_Three_Incident_Other_Description__c, Detailed_Description_Of_Incident__c,
            What_Actions_Were_Taken__c, Completed_By_Name__c, Completed_By_Position_Title__c, Completed_By_Email__c,Sunshine_Center_Name__c
            FROM Incident_Report_SBH__c
            WHERE Id =: id
        ];
        
    }
    @AuraEnabled
    public static List<Incident_Report_SBH__c> getAllIncidents(Integer pageSize,
                                                                Integer pageNumber,
                                                                string empSunshine,
                                                              	List<String> empSunshineAccess,
                                                               date startDate,
                                                               date endDate
                                                               ){
        
        Integer offset = (pageNumber - 1) * pageSize;
        string sunshineCenterName = empSunshine;
        string query = 'Select ID,Name,Completed_By_Name__c, Sunshine_Center_Name__c,CreatedDate,';
        query += 'Completed_By_Position_Title__c,Name_of_Person_s_Involved__c, Date_Time_of_Incident__c';
        query += ' FROM Incident_Report_SBH__c ';
       
     /*                                                               
                                                                    
  //  if(sunshineCenterName != 'All'){
		query += ' WHERE  Sunshine_Center_Name__c IN :empSunshineAccess';
          //   query += ' WHERE  Sunshine_Center_Name__c =:sunshineCenterName';
   		 //    }
        query += ' order by Date_Time_of_Incident__c desc LIMIT :pageSize OFFSET :offset';
     
     */
                                                                   
     //If Date Filters are not applied                                                              
	 if (startDate == null || endDate == null ){
                                                                   
     //Logic to handle next and previous   
                                                            
       If ((pageNumber == 1 && sunshineCenterName == 'All') || (pageNumber != 1 && sunshineCenterName == 'All') ){
		query += ' WHERE  Sunshine_Center_Name__c IN :empSunshineAccess';
           	
      }                                                                  
         
		If ((pageNumber != 1 && sunshineCenterName != 'All') || (pageNumber == 1 && sunshineCenterName != 'All') ){
		query += ' WHERE  Sunshine_Center_Name__c  =: sunshineCenterName';
     	
        }     
     
     }
    //If date filters are applied                                                               
      if (startDate != null && endDate != null ){
      dateTime defaultEndDate =   endDate;
      defaultEndDate.addHours(24);
      //Logic to handle next and previous   
      return  getSearchIncident(startDate, endDate, sunshineCenterName, pageSize, pageNumber, empSunshineAccess);
      
     }                                                                                                                         
		query += ' order by Date_Time_of_Incident__c desc LIMIT :pageSize OFFSET :offset';                                                                    
        return database.query(query);
    }
    
    @AuraEnabled
    public static List<String> getEmpSunshine( string empId){
        Employee__c empObj = [Select Id,Sunshine_Center_Access__c,Sunshine_Center_Relation_To__r.Name
                             From Employee__c WHERE Id =:empId];
        
        List<String> SunshineAccessValues = empObj.Sunshine_Center_Access__c.split(';');
        
        If(SunshineAccessValues.size()>0){
          return SunshineAccessValues;    
        }
        
        return null;
    }

    @AuraEnabled
    public static List<string> getPickListValues(string fieldApiName){
        try {
            List<string> pickListValues = new List<string>();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Incident_Report_SBH__c');
            Map < String, Schema.SObjectField > field_map = targetType.newSObject().getSObjectType().getDescribe().fields.getMap();
            for (Schema.PicklistEntry f: field_map.get(fieldApiName).getDescribe().getPicklistValues()) {
                pickListValues.add(f.getValue());
            }
            return pickListValues;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string saveIncident(Incident_Report_SBH__c incJsonStr){
        
        Account acc;
        if(test.isRunningTest()){
            acc = [Select ID FROM ACCOUNT limit 1];
        }
        else{
            acc = [Select ID FROM ACCOUNT WHERE NAME =: incJsonStr.Sunshine_Center__c limit 1];
        }
       
        incJsonStr.Sunshine_Center__c = acc.Id;
        insert incJsonStr;  
        string pageUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/IncidentReportPDF_HTML';
        system.debug('*****: ' + pageUrl);
        sendEmail(incJsonStr.Id,pageUrl);  
        return incJsonStr.Id;
               
    }
    @Future(callout=true)
    public static void sendEmail(string incidentId,string pageUrl){

        string emailBody = 'Thanks for raising the incident Please find your copy in an attachment';
        Incident_Report_SBH__c incObj = [Select Name,Completed_By_Email__c,
                                         Sunshine_Center__r.Name from Incident_Report_SBH__c where Id=:incidentId limit 1];
        
        string emailAddress = sunshineEmail(incObj.Sunshine_Center__r.Name);
        emailAddress += ';'+ incObj.Completed_By_Email__c;
        string fromaddress;
        
        if(System.Label.Production_or_Sanbox == 'Sandbox'){       
         fromaddress =   'naveenc@sunshinebh.com';
        }

        if(System.Label.Production_or_Sanbox == 'Production'){       
         fromaddress =   'clientservices@sunshinebh.com';
        }
        
       // string emailAddress = incObj.Completed_By_Email__c;
        EmailUtility.sendEmail(emailAddress,emailBody,
                                'Incident Report Copy',
                                fromaddress,
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
    public static Incident_Report_SBH__c getIncidentById(string recordId){
        try {
            return [SELECT Name, Name_of_Person_s_Involved__c,CreatedDate,
             Observed_by_Writer__c, Date_Time_of_Incident__c,
              Location_of_Incident__c,Sunshine_Center_Name__c,
              Reported_to_Writer__c, Check_All_That_Apply__c,
              Level_One_Incident_Type__c, Level_Three_Incident_Type__c,
              Level_Two_Incident_Type__c, Level_One_Incident_Other_Description__c,
              Level_Two_Incident_Other_Description__c, Level_Three_Incident_Other_Description__c, Detailed_Description_Of_Incident__c,
              What_Actions_Were_Taken__c, Completed_By_Name__c, 
              Completed_By_Position_Title__c, Completed_By_Email__c
              FROM Incident_Report_SBH__c
              WHERE Id =: recordId
        ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Incident_Report_SBH__c> getSearchIncident(Date startDate,
                                                           Date endDate,
                                                           string sunshineCenterName,
                                                           Integer pageSize,
                                                           Integer pageNumber,
                                                           List<String> sunshineCentersAccess){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            DateTime defaultStartDate = Date.today().addYears(-10);
            DateTime defaultEndDate = Date.today().addYears(20);
        
            List<string> lstOfSunchineCentre = new List<string>();
            lstOfSunchineCentre.add('Chapters Capistrano');
            lstOfSunchineCentre.add('Monarch Shores');
            lstOfSunchineCentre.add('Lincoln Recovery');
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
			
             Datetime dEnd;
            if(sunshineCenterName == 'All'){
  				
                 dEnd =  defaultEndDate.addHours(24);
                
                return [Select Name,Date_Time_of_Incident__c,Name_of_Person_s_Involved__c,CreatedDate,
                Completed_By_Name__c,Completed_By_Email__c,Sunshine_Center_Name__c
                FROM Incident_Report_SBH__c WHERE Date_and_Time_of_Incident_formula__c
                >=: startDate AND Date_and_Time_of_Incident_formula__c <=: endDate
                 AND Sunshine_Center_Name__c IN :  sunshineCentersAccess        
                ORDER BY Date_Time_of_Incident__c DESC 
                LIMIT :pageSize 
                OFFSET :offset];
            }
             dEnd =  defaultEndDate.addHours(24); 

            return [Select Name,Date_Time_of_Incident__c,Name_of_Person_s_Involved__c,CreatedDate,
                    Completed_By_Name__c,Completed_By_Email__c,Sunshine_Center_Name__c
                    FROM Incident_Report_SBH__c WHERE Date_and_Time_of_Incident_formula__c
                    >=: startDate AND Date_and_Time_of_Incident_formula__c <=: endDate 
                    AND Sunshine_Center_Name__c =:  sunshineCenterName
                    ORDER BY Date_Time_of_Incident__c DESC
                    LIMIT :pageSize 
                    OFFSET :offset];

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}