//PURPOSE : Apex Class is used to Clone and ERP opportunity to MS Opportunity when the Transfer Button is Clicked on ERP Opp
//UPDATE : Apex Class is used to Clone and MS opportunity to ERP Opportunity when the Transfer Button is Clicked on MS Opp
//Author : Naveen Chugh on 03/07/2015
//Test Class : monarchShoresOpportunitiesTest
public without sharing class monarchShoresOpportunities{
    
    private final Opportunity opp;
    public String opp_id;
    public String opp_recordTypeId;
    //ID[] ClosingAgent = new ID[]{};
    //String ClosingAgent = null;
    Id ClosingAgent = null;

    
    Public monarchShoresOpportunities(ApexPages.StandardController controller){
        opp=(Opportunity)Controller.getRecord();
        
    }
    
    Public pagereference createMonarchShoresOpportunity(){//This method is used to clone the ERP opporutnity
        opp_id = ApexPages.currentPage().getParameters().get('id');//Getting the Id of the Opportunity to populate the fields in the Body
        /*Opportunity erpOpp = new Opportunity();
        Opportunity msOpp = new Opportunity();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
        
        if(opp_id!=Null){
            erpOpp = [Select Additional_Notes__c, Assignment_of_Benefits__c, Usual_and_Customary__c, Address_2__c, Address__c, Airline__c, Airport__c, Arrival_Time__c, 
                    Arriving_Airport__c, Cash_Client__c,Insurance_Verification_Created_Date_Time__c,
                     City__c, Client_DOB__c, Closing_Agent__c, Country__c, Insurance_Verified_By__c, Insurance_Verified_Time_Stamp__c,
                    Date_Time_Lead_Was_Created__c, Date__c, Deductible_Met__c, Deductible__c, Email__c, Flight_Number__c, 
                    Free_Standing__c, Group_Number__c, In_Network_Partial_Hospitalization__c, In_Network_Residential__c, 
                    Incoming_Number__c, Insurance_Notes__c, Insurance_Policy__c, Insurance_Provider_Phone_Number__c, 
                    Insurance_Providers__c, JACHO_CARF_RES_PHP_IOP_Required__c, Lead_Id__c, OON_Deductible_Met__c, OON_Deductible__c, 
                    OON_OOP_Max__c, OON_OOP_Met__c, OON_Partial_Hospitilization__c, OON_Residential__c, OOP_Max__c, OOP_Met__c, 
                    Percentage_Coverage_In_Network__c, Percentage_Coverage_OON__c, Precertification_Number__c, RT_Channel__c, 
                    RT_Source__c,  Referral_Verified__c, Referred_by__c, SSN_Last_4__c, Selected_Treatment_Center__c, 
                    State_Licensed__c, State__c, Subscriber_DOBtext__c, Subscriber_Name__c, Travel_Costs__c, Travel_Notes__c, 
                    Zip_Code__c, CloseDate, AccountId, Name, LeadSource,Last_Activity_Date__c ,
                    (Select Id, OpportunityId, ContactId, Role, IsPrimary 
                    From OpportunityContactRoles) From Opportunity where Id =: opp_id LIMIT 1];
                    //Only the fields in the above SOQL query would be cloned. Please add any other field into the QUERY.
                    
            if(erpOpp != Null){
                msOpp = erpOpp.clone(false, true);
                msOpp.Referred_by__c = erpOpp.Closing_Agent__c;
                msOpp.Closing_Agent__c = ClosingAgent;//Making sure the selected user from the intermediate VF page is made the closing agent
                msOpp.Opening_Agent__c = userInfo.getUserId();
                msOpp.OwnerId = ClosingAgent;
                msOpp.RecordTypeId = recTypeId;
                msOpp.StageName = 'Working';
                msOpp.Assignment_of_Benefits__c = erpOpp.Assignment_of_Benefits__c;
                msOpp.Usual_and_Customary__c = erpOpp.Usual_and_Customary__c;
                msOpp.LeadSource = 'Elite Rehab Placement';
                msOpp.Insurance_Verification_Created_Date_Time__c = erpOpp.Insurance_Verification_Created_Date_Time__c;
                msOpp.Insurance_Verified_By__c = erpOpp.Insurance_Verified_By__c;
                msOpp.Insurance_Verified_Time_Stamp__c = erpOpp.Insurance_Verified_Time_Stamp__c;
                msOpp.Last_Activity_Date__c = DateTime.now();
                String feedBody = 'This Opportunity Has Been Transferred to Monarch Shores';
            
                FeedItem fi = new FeedItem();
                fi.Body = feedBody;
                fi.Type = 'AdvancedTextPost';
                fi.ParentId = erpOpp.id;                                
                
                try{
                    erpOpp.Last_Activity_Date__c =DateTime.now();
                    update erpOpp;
                    insert msOpp;
                    insert fi;
                    
                    //associate contact role
                    if(erpOpp.OpportunityContactRoles.size()>0){
                        
                        list<OpportunityContactRole> lstCreateOCR = new list<OpportunityContactRole>();
                        
                        for(OpportunityContactRole OCR : erpOpp.OpportunityContactRoles){
                            OpportunityContactRole newOCR = new OpportunityContactRole();
                            newOCR.OpportunityId = msOpp.id;
                            newOCR.ContactId = OCR.ContactId;
                            newOCR.Role = OCR.Role;
                            newOCR.IsPrimary = OCR.IsPrimary;
                            lstCreateOCR.add(newOCR);
                        }
                        if(lstCreateOCR.size()>0)
                            insert lstCreateOCR;
                    }
                    
                }catch(exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage())); 
                }
            }
        }
    */
    string returnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp_id;
    return new PageReference(returnURL); 
     
    }
    
    Public pagereference createEliteRehabPlacementOpportunity(){//This method is used to clone the MS opporutnity
        opp_id = ApexPages.currentPage().getParameters().get('id');//Getting the Id of the Opportunity to populate the fields in the Body
        Opportunity erpOpp = new Opportunity();
        Opportunity msOpp = new Opportunity();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
        
        
        
        if(opp_id!=Null){
            /*
            msOpp = [Select Additional_Notes__c, Assignment_of_Benefits__c, Usual_and_Customary__c, Address_2__c, Address__c, Airline__c, Airport__c, Arrival_Time__c, 
                    Arriving_Airport__c, Cash_Client__c, City__c, Client_DOB__c, Closing_Agent__c, Country__c, 
                    Date_Time_Lead_Was_Created__c, Date__c, Deductible_Met__c, Deductible__c, Email__c, Flight_Number__c, 
                    Free_Standing__c, Group_Number__c, In_Network_Partial_Hospitalization__c, In_Network_Residential__c, 
                    Incoming_Number__c, Insurance_Notes__c, Insurance_Policy__c, Insurance_Provider_Phone_Number__c, 
                    Insurance_Providers__c, JACHO_CARF_RES_PHP_IOP_Required__c, Lead_Id__c, OON_Deductible_Met__c, OON_Deductible__c, 
                    OON_OOP_Max__c, OON_OOP_Met__c, OON_Partial_Hospitilization__c, OON_Residential__c, OOP_Max__c, OOP_Met__c, 
                    Percentage_Coverage_In_Network__c, Percentage_Coverage_OON__c, Precertification_Number__c, RT_Channel__c, 
                    RT_Source__c,  Referral_Verified__c, Referred_by__c, SSN_Last_4__c, Selected_Treatment_Center__c, 
                    State_Licensed__c, State__c, Subscriber_DOBtext__c, Subscriber_Name__c, Travel_Costs__c, Travel_Notes__c, 
                    Zip_Code__c, CloseDate, AccountId, Name, Opening_Agent__c,LeadSource, StageName ,Last_Activity_Date__c ,
                    (Select Id, OpportunityId, 
                    ContactId, Role, IsPrimary  From OpportunityContactRoles) From Opportunity where Id =: opp_id LIMIT 1];
                    //Only the fields in the above SOQL query would be cloned. Please add any other field into the QUERY.
             */
            
            String queryString = '';
            for(Opportunity_Transfer_Fields__c otf : Opportunity_Transfer_Fields__c.getall().values()){
                if(queryString == '')
                    queryString = 'Select '+otf.Name;
                else
                    queryString = queryString+', '+otf.Name;
            }
            system.debug('Interim queryString :::'+queryString);
            if(queryString.length()>7){
                queryString = queryString+', Insurance_Verification_Created_Date_Time__c, (Select Id, OpportunityId, ContactId, Role, IsPrimary  From OpportunityContactRoles) From Opportunity where Id =\'' +opp_id+ '\' limit 1';
            
                system.debug('Final queryString :::'+queryString);
                msOpp = Database.query(queryString);
            }
            system.debug('msOpp ::::'+msOpp);
            if(msOpp != Null){
                erpOpp = msOpp.clone(false, true);
                erpOpp.Referred_by__c = msOpp.Closing_Agent__c;
                erpOpp.Closing_Agent__c = ClosingAgent;//Making sure the selected user from the intermediate VF page is made the closing agent
                erpOpp.OwnerId = ClosingAgent;
                erpOpp.Opening_Agent__c = msOpp.Opening_Agent__c;
                erpOpp.RecordTypeId = recTypeId;
                erpOpp.StageName = 'Initial Qualified Contact';
                erpOpp.LeadSource = 'Monarch Shores';
                erpOpp.RT_Source__c  = msOpp.LeadSource;
                erpOpp.RT_Channel__c = 'Monarch Shores';
                erpOpp.Assignment_of_Benefits__c = msOpp.Assignment_of_Benefits__c;
                erpOpp.Usual_and_Customary__c = msOpp.Usual_and_Customary__c;
                erpOpp.Last_Activity_Date__c = DateTime.now();
                msOpp.StageName = 'Transferred To ERP';
                msOpp.Last_Activity_Date__c = DateTime.now();
                if(test.isRunningTest()){
                    erpOpp.Test_Class_Checkbox__c = True;
                    erpOpp.Name = 'test';
                    erpOpp.closeDate = Date.Today();
                }    
                String feedBody = 'This Opportunity Has Been Transferred to Elite Rehab Placements';
            
                FeedItem fi = new FeedItem();
                fi.Body = feedBody;
                fi.Type = 'AdvancedTextPost';
                fi.ParentId = msOpp.id;
                
                
                //try{
                    insert erpOpp;   
                    
                    if(msOpp.Id != null) 
                        update msOpp;
                    insert fi;
                    
                    //associate contact role
                    if(erpOpp.OpportunityContactRoles.size()>0){
                        
                        list<OpportunityContactRole> lstCreateOCR = new list<OpportunityContactRole>();
                        
                        for(OpportunityContactRole OCR : msOpp.OpportunityContactRoles){
                            OpportunityContactRole newOCR = new OpportunityContactRole();
                            newOCR.OpportunityId = erpOpp.id;
                            newOCR.ContactId = OCR.ContactId;
                            newOCR.Role = OCR.Role;
                            newOCR.IsPrimary = OCR.IsPrimary;
                            lstCreateOCR.add(newOCR);
                        }
                        if(lstCreateOCR.size()>0)
                            insert lstCreateOCR;
                    }
                    
               /* }catch(exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage())); 
                }*/
            }
        }
    
    string returnURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp_id;
    return new PageReference(returnURL); 
     
    }
    
    public pagereference cancel1(){
        return new pagereference('/'+opp.id); 
    }
    
    public List<SelectOption> getItems() {//This method is used to populate the possible closing agents using a custom setting that we have in place.
        opp_recordTypeId = ApexPages.currentPage().getParameters().get('record_type_id');//Getting the record type id of the Opportunity to populate the fields in the Body
        system.debug('opp_recordTypeId: '+opp_recordTypeId);
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId();
        system.debug('recTypeId: '+recTypeId);
        
        List<SelectOption> options = new List<SelectOption>();
        for(Monarch_Shores_Closing_Agents__c msca: [select id, Name, Closing_Agent_Id__c, Monarch_Shores_User__c from Monarch_Shores_Closing_Agents__c]){
            system.debug('1');
            if(recTypeId != opp_recordTypeId){
                system.debug('2');
                if(msca.Monarch_Shores_User__c == False){
                    system.debug('3');
                    options.add(new SelectOption(msca.Closing_Agent_Id__c,msca.Name));
                }
            }
            else{
                system.debug('4');
                if(msca.Monarch_Shores_User__c == True){
                    system.debug('5');
                    options.add(new SelectOption(msca.Closing_Agent_Id__c,msca.Name));
                }    
            }    
            
        }
        return options;
    } 
    
    
    public Id getClosingAgent() {
        return ClosingAgent;
    }

    public void setClosingAgent(Id ClosingAgent) {
        this.ClosingAgent = ClosingAgent;
    }

    
}