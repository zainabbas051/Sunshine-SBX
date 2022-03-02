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
       
        HandHygieneReport = (id == null) ? new Hand_Hygiene_Report__c() : [select Id,Sunshine_Center_Name__c,AT_Cleaned_hands_with_alcohol_sanitizer__c,AT_Cleaned_hands_with_soap_and_water__c, 
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
                                                                 date endDate,
                                                                 string houseLocation){
                                                                     
        Integer offset = (pageNumber - 1) * pageSize;
        string sunshineCenterName = empSunshine;
        string query = 'Select ID,Name,Completed_By_Name__c, Sunshine_Center_Name__c,';
        query += 'Staff_Member_Observed__c, DateAndTime__c';
        query += ' FROM Hand_Hygiene_Report__c ';
                                                                
	if (startDate == null || endDate == null){
                                                                   
     //Logic to handle next and previous   
                                                            
       If ((pageNumber == 1 && sunshineCenterName == 'All') || (pageNumber != 1 && sunshineCenterName == 'All') ){
		query += ' WHERE  Sunshine_Center_Name__c IN :empSunshineAccess';
           	
      }                                                                  
         
		If ((pageNumber != 1 && sunshineCenterName != 'All') || (pageNumber == 1 && sunshineCenterName != 'All') ){
		query += ' WHERE  Sunshine_Center_Name__c  =: sunshineCenterName';
        }
            
            
     }
                                                                     
	//If date filters are applied    	                                                           
      if ((startDate != null && endDate != null) || (houseLocation != null) ){

      //Logic to handle next and previous   
      return  getSearchHandHygiene(startDate, endDate, sunshineCenterName, pageSize, pageNumber, empSunshineAccess, houseLocation);
      
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
    public static List<String> getHouseLocations(string sunshineCentreName){
            
        House_Location__mdt[] houseLocationMetada = [SELECT Id,Sunshine_Centre__c,MasterLabel from House_Location__mdt where Sunshine_Centre__c =: sunshineCentreName];
        
        List<String> ListOfHouseLocationValues = New List<String>();
                
        for (House_Location__mdt rec : houseLocationMetada){
            ListOfHouseLocationValues.add(rec.MasterLabel);
        }

        If(ListOfHouseLocationValues.size()>0){
            ListOfHouseLocationValues.sort();
        	return ListOfHouseLocationValues;
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
        Hand_Hygiene_Report__c incObj = [Select Name,Sunshine_Center__r.Name,Sunshine_Center_Name__c,Completed_By_Email__c from Hand_Hygiene_Report__c where Id=:incidentId limit 1];
       
        Sunshine_Center_Id__C rec = Sunshine_Center_Id__c.getValues(incObj.Sunshine_Center__r.Name);

        
        system.debug('*****: ' + incObj.Completed_By_Email__c);
   //     string emailAddress = sunshineEmail(incObj.Sunshine_Center__r.Name);
        string emailAddress = rec.Additional_recipients_Email__c;

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
   /* private static string sunshineEmail(string sunshineCentreName){
        
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
    }*/

    @AuraEnabled
    public static Hand_Hygiene_Report__c getHandHygieneReportById(string recordId){
        try {
            return [select Id,AT_Cleaned_hands_with_alcohol_sanitizer__c,AT_Cleaned_hands_with_soap_and_water__c, 
                                                                            Before_Touching_Applied_appropriate_PPE__c, BT_Cleaned_hands_with_alcohol_sanitizer__c, 
                                                                            BT_Cleaned_hands_with_soap_and_water__c, Completed_By_Email__c, Completed_By_Name__c, 
                                                                            DateAndTime__c, Staff_Member_Observed__c, Sunshine_Center__c,Sunshine_Center_Name__c,
                                                                            House_location__c  
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
                                                           List<String> sunshineCentersAccess,
                                                           String houseLocation){
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

            system.debug('Sunshine_Center_Name__c ='+sunshineCenterName);
            system.debug('House_location__c=' + houseLocation );


            if(sunshineCenterName == 'All'){
			
           //     dEnd =  defaultEndDate.addHours(23);
           //     dEnd =  defaultEndDate.addminutes(59);
                system.debug('When Sunshine Centre = All');
                return [SELECT Id,Name,
                        Completed_By_Name__c,
                        Sunshine_Center_Name__c,
                        Staff_Member_Observed__c,
                        DateAndTime__c
                        FROM Hand_Hygiene_Report__c 
                        WHERE Date_and_Time_Formula__c>=: startDate 
                        AND Date_and_Time_Formula__c <=: endDate 
                        AND Sunshine_Center_Name__c IN :  sunshineCentersAccess
                        ORDER BY DateAndTime__c DESC
                        LIMIT :pageSize 
                        OFFSET :offset];
            }
            else {
                if(sunshineCenterName != 'All' && (sunshineCenterName == 'Chapters Capistrano' || sunshineCenterName == 'Monarch Shores')){

                    system.debug('When Sunshine Centre != All and centre = Chapters Capistrano or Monarch Shores ');
                    return [SELECT Id,Name,
                        Completed_By_Name__c,
                        Sunshine_Center_Name__c,
                        Staff_Member_Observed__c,
                        DateAndTime__c
                        FROM Hand_Hygiene_Report__c 
                        WHERE Date_and_Time_Formula__c>=: startDate 
                        AND Date_and_Time_Formula__c <=: endDate 
                        AND Sunshine_Center_Name__c =:  sunshineCenterName
                        AND House_location__c =: houseLocation
                        ORDER BY DateAndTime__c DESC
                        LIMIT :pageSize 
                        OFFSET :offset];
                }
                system.debug('When Sunshine Centre != All and centre = other');
                return [SELECT Id,Name,
                    Completed_By_Name__c,
                    Sunshine_Center_Name__c,
                    Staff_Member_Observed__c,
                    DateAndTime__c
                    FROM Hand_Hygiene_Report__c  
                    WHERE Date_and_Time_Formula__c>=: startDate
                    AND Date_and_Time_Formula__c <=: endDate 
                    AND Sunshine_Center_Name__c =:  sunshineCenterName
                    ORDER BY  DateAndTime__c desc
                    LIMIT :pageSize 
                    OFFSET :offset];
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}