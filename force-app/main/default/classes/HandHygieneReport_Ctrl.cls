public without sharing class HandHygieneReport_Ctrl {

    public Hand_Hygiene_Report__c HandHygieneReport {
        get;
        private set;
    }
   
    public List<Hand_Hygiene_Report__c> lstHandHygieneReport{
        get;
        set;
    
    }
    public boolean disabled{
        get;
        set;
    }

    public HandHygieneReport_Ctrl() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id != null){
             disabled = true;
        }
       
        HandHygieneReport = (id == null) ? new Hand_Hygiene_Report__c() : [select Id,AT_Cleaned_hands_with_alcohol_sanitizer__c,AT_Cleaned_hands_with_soap_and_water__c, 
                                                                            Before_Touching_Applied_appropriate_PPE__c, BT_Cleaned_hands_with_alcohol_sanitizer__c, 
                                                                            BT_Cleaned_hands_with_soap_and_water__c, Completed_By_Email__c, Completed_By_Name__c, 
                                                                            DateAndTime__c, Staff_Member_Observed__c, Sunshine_Center__c,Sunshine_Center__r.Name 
                                                                            from Hand_Hygiene_Report__c
                                                                            WHERE Id =: id
        ];
        
    }
    @AuraEnabled
    public static List<Hand_Hygiene_Report__c> getAllHandHygieneReports(Integer pageSize,
                                                                 Integer pageNumber,
                                                                 string empSunshine,
                                                                 List<String> empSunshineAccess,      
                                                                 date startDate,
                                                                 date endDate){
                                                                     
        Integer offset = (pageNumber - 1) * pageSize;
        string sunshineCenterName = empSunshine;
        string query = 'Select ID,Name,Completed_By_Name__c, Sunshine_Center_Name__c,';
        query += 'Staff_Member_Observed__c, DateAndTime__c';
        query += ' FROM Hand_Hygiene_Report__c ';
       /* if(sunshineCenterName != 'All'){
            query += ' WHERE  Sunshine_Center_Name__c =:sunshineCenterName';
        }*/
                                                                     
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
      return  getSearchHandHygiene(startDate, endDate, sunshineCenterName, pageSize, pageNumber, empSunshineAccess);
      
     }                                                                      

        query += ' ORDER BY DateAndTime__c desc LIMIT :pageSize OFFSET :offset';
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
    public static string saveHandHygiene(Hand_Hygiene_Report__c incJsonStr){
        
        Account acc;
        if(test.isRunningTest()){
            acc = [Select ID FROM ACCOUNT limit 1];
        }
        else{
            acc = [Select ID FROM ACCOUNT WHERE NAME =: incJsonStr.Sunshine_Center__c limit 1];
        }
       
        incJsonStr.Sunshine_Center__c = acc.Id;
        insert incJsonStr;  
        string pageUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/handHygieneReportPDF_HTML';
       // system.debug('*****: ' + pageUrl);
        sendEmail(incJsonStr.Id,pageUrl);  
        return incJsonStr.Id;
               
    }
    @Future(callout=true)
    public static void sendEmail(string incidentId,string pageUrl){

        string emailBody = 'Thanks for creating the Hand Hygiene Report. Please find your copy in the attachment';
        Hand_Hygiene_Report__c incObj = [Select Name,Sunshine_Center__r.Name,Completed_By_Email__c from Hand_Hygiene_Report__c where Id=:incidentId limit 1];
        system.debug('*****: ' + incObj.Completed_By_Email__c);
        string emailAddress = sunshineEmail(incObj.Sunshine_Center__r.Name);
        emailAddress += ';'+ incObj.Completed_By_Email__c;
       //string emailAddress=incObj.Completed_By_Email__c;
       
         string fromaddress;
        
        if(System.Label.Production_or_Sanbox == 'Sandbox'){       
         fromaddress =   'naveenc@sunshinebh.com';
        }

        if(System.Label.Production_or_Sanbox == 'Production'){       
         fromaddress =   'clientservices@sunshinebh.com';
        }
        
        EmailUtility.sendEmail(emailAddress,emailBody,
                                'Hand Hygiene Report',
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
    public static Hand_Hygiene_Report__c getHandHygieneReportById(string recordId){
        try {
            return [select Id,AT_Cleaned_hands_with_alcohol_sanitizer__c,AT_Cleaned_hands_with_soap_and_water__c, 
                                                                            Before_Touching_Applied_appropriate_PPE__c, BT_Cleaned_hands_with_alcohol_sanitizer__c, 
                                                                            BT_Cleaned_hands_with_soap_and_water__c, Completed_By_Email__c, Completed_By_Name__c, 
                                                                            DateAndTime__c, Staff_Member_Observed__c, Sunshine_Center__c,Sunshine_Center_Name__c 
                                                                            from Hand_Hygiene_Report__c
                                                                              WHERE Id =: recordId
        ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Hand_Hygiene_Report__c> getSearchHandHygiene(Date startDate,
                                                           Date endDate,
                                                           string sunshineCenterName,
                                                           Integer pageSize,
                                                           Integer pageNumber,
                                                           List<String> sunshineCentersAccess){
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
            
            Datetime dEnd;
    

            if(sunshineCenterName == 'All'){
			
           //     dEnd =  defaultEndDate.addHours(23);
           //     dEnd =  defaultEndDate.addminutes(59);
                return [SELECT Id,Name,
                        Completed_By_Name__c,
                        Sunshine_Center_Name__c,
                        Staff_Member_Observed__c,
                        DateAndTime__c
                        FROM Hand_Hygiene_Report__c 
                        WHERE Date_and_Time_Formula__c
                        >=: startDate AND Date_and_Time_Formula__c <=: endDate AND Sunshine_Center_Name__c IN :  sunshineCentersAccess
                        ORDER BY DateAndTime__c DESC
                        LIMIT :pageSize 
                        OFFSET :offset];
            }
            
           // dEnd =  defaultEndDate.addHours(23); 
           // dEnd =  defaultEndDate.addminutes(59);

            return [SELECT Id,Name,
                    Completed_By_Name__c,
                    Sunshine_Center_Name__c,
                    Staff_Member_Observed__c,
                    DateAndTime__c
                    FROM Hand_Hygiene_Report__c 
                    WHERE Date_and_Time_Formula__c>=: startDate 
                    AND Date_and_Time_Formula__c <=: endDate 
                    AND Sunshine_Center_Name__c =:  sunshineCenterName
                    ORDER BY DateAndTime__c DESC
                    LIMIT :pageSize 
                    OFFSET :offset];

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}