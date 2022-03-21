public without sharing class AnonymousConcernCtrl {

    public Anonymous_Concern__c AnonymousConcern {
        get;
        private set;
    }
   
    public List<Anonymous_Concern__c> lstAnonymousConcern{
        get;
        set;
    
    }
    public boolean disabled{
        get;
        set;
    }

    public AnonymousConcernCtrl() {
        Id id = ApexPages.currentPage().getParameters().get('id');
        if(id != null){
             disabled = true;
        }
       
        AnonymousConcern = (id == null) ? new Anonymous_Concern__c() : [select Id,Date_Concern_Arose__c,Date_Submitted__c,Description__c,Facility__c,Issue_Witness__c,Occurence__c,Relates_to__c,Reported_to_Facility_Management__c,Severity__c
                                                                            from Anonymous_Concern__c
                                                                            WHERE Id =: id
        ];
        
    }
    @AuraEnabled
    public static List<Anonymous_Concern__c> getAllAnonymous_ConcernReports(Integer pageSize,
                                                                 Integer pageNumber,
                                                                 string empSunshine,
                                                                 List<String> empSunshineAccess,      
                                                                 date startDate,
                                                                 date endDate
                                                                 ){
                                                                     
        Integer offset = (pageNumber - 1) * pageSize;
        string sunshineCenterName = empSunshine;
        string query = 'Select ID,Severity__c,Date_Submitted__c, Facility__c';
        query += ' FROM Anonymous_Concern__c ';
                                                                
  if (startDate == null || endDate == null){
                                                                   
     //Logic to handle next and previous   
                                                            
       If ((pageNumber == 1 && sunshineCenterName == 'All') || (pageNumber != 1 && sunshineCenterName == 'All') ){
    query += ' WHERE  Facility__c IN :empSunshineAccess';
             
      }                                                                  
         
    If ((pageNumber != 1 && sunshineCenterName != 'All') || (pageNumber == 1 && sunshineCenterName != 'All') ){
    query += ' WHERE  Facility__c  =: sunshineCenterName';
        }
            
            
     }
                                                                     
  //If date filters are applied                                                                 
      if ((startDate != null && endDate != null) ){

      //Logic to handle next and previous   
      return  getSearchAnonConcern(startDate, endDate, sunshineCenterName, pageSize, pageNumber, empSunshineAccess);
      
     }                                                                       
     
        query += ' ORDER BY Date_Submitted__c desc LIMIT :pageSize OFFSET :offset';
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
    public static string saveAnonymousConcern(Anonymous_Concern__c incJsonStr){
        
       incJsonStr.Date_Submitted__c = System.today();
       
        insert incJsonStr;  
       // string pageUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/handHygieneReportPDF_HTML';
       // system.debug('*****: ' + pageUrl);
           system.debug('+++'+incJsonStr.Id);
        sendEmail(incJsonStr.Id);  
        return incJsonStr.Id;
               
    }
    @Future(callout=true)
    public static void sendEmail(string incidentId){

          system.debug('+++'+ incidentId);
       // Anonymous_Concern__c incObj = [select Id,Date_Concern_Arose__c,Date_Submitted__c,Description__c,Facility__c,Issue_Witness__c,Occurence__c,Relates_to__c,Reported_to_Facility_Management__c,Severity__c from Anonymous_Concern__c where Id=:incidentId limit 1];
        string emailAddress = System.Label.AnonymousConcernListener;
        string fromaddress;
        
        if(System.Label.Production_or_Sanbox == 'Sandbox'){       
         fromaddress =   'naveenc@sunshinebh.com';
        }

        if(System.Label.Production_or_Sanbox == 'Production'){       
         fromaddress =   'clientservices@sunshinebh.com';
        }
        string tempID=System.Label.AnonymousConcernEmailTemplateID;
        EmailUtility.sendEmailwithVFBody(emailAddress,tempID,fromaddress,incidentId);
                                
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
    public static Anonymous_Concern__c getAnonConcernById(string recordId){
        try {
            return [select Id,Date_Concern_Arose__c,Date_Submitted__c,Description__c,Facility__c,Issue_Witness__c,Occurence__c,Relates_to__c,Reported_to_Facility_Management__c,Severity__c  
                                                                            from Anonymous_Concern__c
                                                                              WHERE Id =: recordId
        ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Anonymous_Concern__c> getSearchAnonConcern(Date startDate,
                                                           Date endDate,
                                                           string sunshineCenterName,
                                                           Integer pageSize,
                                                           Integer pageNumber,
                                                           List<String> sunshineCentersAccess
                                                           ){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            Date defaultStartDate = Date.today().addYears(-10);
            Date defaultEndDate = Date.today().addYears(20);
            List<string> lstOfSunchineCentre = new List<string>();
            lstOfSunchineCentre.add('Chapters Capistrano');
            lstOfSunchineCentre.add('Monarch Shores');
            lstOfSunchineCentre.add('Mountain Springs Recovery');
            lstOfSunchineCentre.add('Willow Springs Recovery');
            lstOfSunchineCentre.add('Lincoln Recovery');

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
     


            if(sunshineCenterName == 'All'){
      
           //     dEnd =  defaultEndDate.addHours(23);
           //     dEnd =  defaultEndDate.addminutes(59);
                system.debug('When Sunshine Centre = All');
                return [select Id,Date_Concern_Arose__c,Date_Submitted__c,Description__c,Facility__c,Issue_Witness__c,Occurence__c,Relates_to__c,Reported_to_Facility_Management__c,Severity__c  
                        from Anonymous_Concern__c
                        WHERE Date_Submitted__c>=: startDate 
                        AND Date_Submitted__c <=: endDate 
                        AND Facility__c IN :  sunshineCentersAccess
                        ORDER BY Date_Submitted__c DESC
                        LIMIT :pageSize 
                        OFFSET :offset];
            }
            else {

                system.debug('When Sunshine Centre != All and centre = other');
                return [select Id,Date_Concern_Arose__c,Date_Submitted__c,Description__c,Facility__c,Issue_Witness__c,Occurence__c,Relates_to__c,Reported_to_Facility_Management__c,Severity__c  
                        from Anonymous_Concern__c
                        WHERE Date_Submitted__c>=: startDate 
                        AND Date_Submitted__c <=: endDate  
                     
                    AND Facility__c =:  sunshineCenterName
                    ORDER BY  Date_Submitted__c desc
                    LIMIT :pageSize 
                    OFFSET :offset];
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}