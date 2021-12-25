@isTest
private class tempLeadCreationServiceTest{
    
    Public static Lead l;
    
    public Static void createSampleData(){
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Insurance Form';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        l.Status = 'Open';
        insert l;
        
        feedItem fi = new feedItem();
        fi.ParentId = l.id;
        fi.type = 'TextPost';
        fi.title = 'FileName';
        fi.body = 'Hello There'; 
        insert fi;
    }
    
    public Static testmethod void tempLeadCreationService(){
        test.startTest();
        
        createSampleData();          
        
        list<createLeadWrapper.feedItems> feedItemsList = new List<createLeadWrapper.feedItems>();
        
        Lead tempLead = [select id, Owner.id, firstName, lastName, company, Opening_Agent__c, Patient_DOB__c, LeadSource, monarch_shores_lead__c,
        Referred_by__c, Referral_Agent__c, Smile_and_Dial__c, HMO_Lead__c, Status, Phone, Email, Preferred_Contact__c, Incoming_Number__c,
        Referral_Verified__c, Subscriber_Name__c, Insurance_Providors__c, Insurance_Policy__c, Group_Number__c, Insurance_Provider_Phone_Number__c, 
        Subscriber_DOB_Text__c, SSN_Last_4__c, Street_Address__c, Address_2__c, City__c, State__c, Zip_Code__c, Country__c, Employer__c, Phone_Web__c,
        Cash_Client__c, Out_of_Network__c, In_Network_Residential__c, OON_Partial_Hospitalization__c, In_Network_Partial_Hospitalization__c, 
        JACHO_CARF_RES_PHP_IOP_Required__c, State_Licensed__c, Free_Standing__c, Precertification_Number__c, Insurance_Notes__c, Percentage_Coverage_OON__c,
        Percent_Coverage_In_Network__c, Deductible__c, OON_Deductible__c, OON_Deductible_Met__c, Deductible_Met__c, OOP_Max__c, OON_OOP_Max__c, OOP_Met__c,
        OON_OOP_Met__c, Usual_and_Customary__c, Assignment_of_Benefits__c, CreatedDate, CreatedBy.id, RecordType.Name, RT_Source__c, RT_Channel__c, 
        Campaign__c, Hubspot_Source__c, Hubspot_Source_Data_1__c, Hubspot_Source_Data_2__c, Additional_Notes__c, Subscriber_First_Name__c, Subscriber_Last_Name__c
        from Lead where id=:l.id];
        
        for(FeedItem fi : [Select id, ParentId, Body, InsertedById, Type, Title, status from FeedItem Where ParentId =: l.id]){
            createLeadWrapper.feedItems fis =new createLeadWrapper.feedItems(fi.parentId, fi.insertedById, fi.type, fi.title, fi.body, fi.status);
            feedItemsList.add(fis);
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeStringField('owner_id','');
            gen.writeStringField('old_sf_id',l.id);
            gen.writeStringField('first_name',tempLead.firstName);
            gen.writeStringField('last_name',tempLead.lastName);
            gen.writeStringField('Company',tempLead.company);
            gen.writeStringField('intake_agent_id','');
            gen.writeStringField('client_dob','');       
            gen.writeStringField('lead_source',tempLead.LeadSource);
            gen.writeBooleanField('monarch_shores_lead',FALSE);
            gen.writeStringField('external_referred_by','');
            gen.writeStringField('referral_agent_id','');
            gen.writeBooleanField('smile_and_dial',FALSE);
            gen.writeBooleanField('hmo_lead',FALSE);
            gen.writeStringField('lead_status',tempLead.Status);
            gen.writeStringField('phone','');
            gen.writeStringField('email',tempLead.Email);
            gen.writeStringField('preferred_contact','');
            gen.writeStringField('incoming_number','');
            gen.writeBooleanField('referral_verified',FALSE);
            gen.writeStringField('Subscriber_Last_Name','');
            gen.writeStringField('Subscriber_First_Name','');
            gen.writeStringField('subscriber_name','');
            gen.writeStringField('insurance_providers','');
            gen.writeStringField('insurance_policy','');
            gen.writeStringField('group_number','');
            gen.writeStringField('Insurance_Provider_Phone_Number','');
            gen.writeStringField('Subscriber_DOB','');
            gen.writeStringField('SSN_Last_4','');
            gen.writeStringField('Street_Address','');
            gen.writeStringField('Address_2','');
            gen.writeStringField('City','');
            gen.writeStringField('State','');
            gen.writeStringField('Zip_Code','');
            gen.writeStringField('Country','');
            gen.writeStringField('Employer','');
            gen.writeStringField('Call_Web','');
            gen.writeBooleanField('Cash_Client',FALSE);
            gen.writeBooleanField('OON_Residential',FALSE);
            gen.writeBooleanField('In_Network_Residential',FALSE);
            gen.writeBooleanField('OON_Partial_Hospitalization',FALSE);
            gen.writeBooleanField('In_Network_Partial_Hospitalization',FALSE);
            gen.writeBooleanField('JACHO_Required',FALSE);
            gen.writeBooleanField('State_Licensed',FALSE);
            gen.writeBooleanField('Free_Standing',FALSE);
            gen.writeStringField('Precertification_Number','');
            gen.writeStringField('Insurance_Notes','');
            gen.writeNumberField('Percentage_Coverage_OON',100);
            gen.writeNumberField('Percent_Coverage_In_Network',100);
            gen.writeNumberField('In_Net_Deductible',100);
            gen.writeNumberField('OON_Deductible',100);
            gen.writeNumberField('In_Net_Deductible_Met',100);
            gen.writeNumberField('OON_Deductible_Met',100);
            gen.writeNumberField('OOP_Max_In_Net',100);
            gen.writeNumberField('OON_OOP_Max',100);
            gen.writeNumberField('OOP_Met_In_Net',100);
            gen.writeNumberField('OON_OOP_Met',100);
            gen.writeStringField('Usual_and_Customary','');
            gen.writeStringField('Assignment_of_Benefits','');
            gen.writeStringField('Additional_Notes','');
            gen.writeDateTimeField('Created_Date_Time',DateTime.NOW());
            gen.writeStringField('Create_By_ID','');
            gen.writeStringField('Lead_Record_Type','Monarch Shores');
            gen.writeStringField('RT_Source','');
            gen.writeStringField('RT_Channel','');
            gen.writeStringField('Campaign','');
            gen.writeStringField('Hubspot_Source','');
            gen.writeStringField('Hubspot_Source_Data_1','');
            gen.writeStringField('Hubspot_Source_Data_2','');
            gen.writeObjectField('feedItemsList',feedItemsList);
        gen.writeEndObject();
            
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
       
        req.requestURI = '/services/apexrest/temp_lead_creation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        
        RestContext.request = req;
        RestContext.response= res;
       
        req.requestBody = blob.valueOf(gen.getAsString());
        
        tempLeadCreationService.tempLeadCreate(); 
        
        createLeadWrapper clw = new createLeadWrapper();
        clw.tempString = 'Test'; 
                   
        test.StopTest();
    }
}