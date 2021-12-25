//TEST Class :  tempLeadCreationServiceTest
@RestResource(urlMapping='/temp_lead_creation')
global without sharing class tempLeadCreationService {
    
    @HttpPost
    global static void tempLeadCreate() {
         
        System.debug('POST Request Body :::::'+RestContext.request.requestBody.toString());
        createLeadWrapper leadRecord = (createLeadWrapper)JSON.deserializeStrict(RestContext.request.requestBody.toString(),createLeadWrapper.class);
        list<feedItem> fiList = new List<feedItem>(); 
        
        List<User> userList = [Select id, Old_SF_ID__c from User 
        where Old_SF_ID__c=: leadRecord.intake_agent_id OR 
        Old_SF_ID__c =: leadRecord.owner_id OR 
        Old_SF_ID__c =: leadRecord.referral_agent_id OR 
        Old_SF_ID__c =: leadRecord.Create_By_ID];
        
        lead tempLead = new lead(); 
        
        for(User u : userList){
            
            if(u.Old_SF_ID__c == leadRecord.owner_id && leadRecord.owner_id != null && leadRecord.lead_owner_is_queue == False){
                tempLead.ownerID = u.id;
            }
            if(u.Old_SF_ID__c == leadRecord.intake_agent_id && leadRecord.intake_agent_id != null){
                tempLead.Opening_Agent__c = u.id;
            }
            if(u.Old_SF_ID__c == leadRecord.referral_agent_id && leadRecord.referral_agent_id != null){
                tempLead.Referral_Agent__c = u.id;
            }
            if(u.Old_SF_ID__c == leadRecord.Create_By_ID && leadRecord.Create_By_ID != null){
                tempLead.CreatedById = u.id;
            }
        }
        if(leadRecord.lead_owner_is_queue == True && leadRecord.owner_queue_name != ''){
            for(Group g : [Select id, Name from Group where Name =: leadRecord.owner_queue_name AND Type=: 'Queue']){
                tempLead.ownerID = g.id;
            }
        }
        tempLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(leadRecord.Lead_Record_Type).getRecordTypeId();
        tempLead.Old_SF_id__c =  leadRecord.old_sf_id;
        tempLead.firstName = leadRecord.first_name;
        tempLead.lastName = leadRecord.last_name;
        tempLead.company = leadRecord.Company;
        tempLead.Patient_DOB__c = leadRecord.client_dob;       
        tempLead.LeadSource = leadRecord.lead_source;
        tempLead.monarch_shores_lead__c = leadRecord.monarch_shores_lead;
        tempLead.Referred_by__c = leadRecord.external_referred_by;
        tempLead.Smile_and_Dial__c = leadRecord.smile_and_dial;
        tempLead.HMO_Lead__c = leadRecord.hmo_lead;
        tempLead.Status = leadRecord.lead_status;
        tempLead.Phone = leadRecord.phone;
        tempLead.Email = leadRecord.email;
        tempLead.Preferred_Contact__c = leadRecord.preferred_contact;
        tempLead.Incoming_Number__c = leadRecord.incoming_number;
        tempLead.Referral_Verified__c = leadRecord.referral_verified;
        tempLead.Subscriber_Name__c = leadRecord.subscriber_name;
        tempLead.Subscriber_Last_Name__c = leadRecord.Subscriber_Last_Name;
        tempLead.Subscriber_First_Name__c = leadRecord.Subscriber_First_Name;
        tempLead.Insurance_Providors__c = leadRecord.insurance_providers;
        tempLead.Insurance_Policy__c = leadRecord.insurance_policy;
        tempLead.Group_Number__c = leadRecord.group_number;
        tempLead.Insurance_Provider_Phone_Number__c = leadRecord.Insurance_Provider_Phone_Number;
        tempLead.Subscriber_DOB_Text__c = leadRecord.Subscriber_DOB;
        tempLead.SSN_Last_4__c = leadRecord.SSN_Last_4;
        tempLead.Street_Address__c = leadRecord.Street_Address;
        tempLead.Address_2__c = leadRecord.Address_2;
        tempLead.City__c = leadRecord.City;
        tempLead.State__c = leadRecord.State;
        tempLead.Zip_Code__c = leadRecord.Zip_Code;
        tempLead.Country__c = leadRecord.Country;
        tempLead.Employer__c = leadRecord.Employer;
        tempLead.Phone_Web__c = leadRecord.Call_Web;
        tempLead.Cash_Client__c = leadRecord.Cash_Client;
        tempLead.Out_of_Network__c = leadRecord.OON_Residential;
        tempLead.In_Network_Residential__c = leadRecord.In_Network_Residential;
        tempLead.OON_Partial_Hospitalization__c = leadRecord.OON_Partial_Hospitalization;
        tempLead.In_Network_Partial_Hospitalization__c = leadRecord.In_Network_Partial_Hospitalization;
        tempLead.JACHO_CARF_RES_PHP_IOP_Required__c = leadRecord.JACHO_Required;
        tempLead.State_Licensed__c = leadRecord.State_Licensed;
        tempLead.Free_Standing__c = leadRecord.Free_Standing;
        tempLead.Precertification_Number__c = leadRecord.Precertification_Number;
        tempLead.Insurance_Notes__c = leadRecord.Insurance_Notes;
        tempLead.Percentage_Coverage_OON__c = leadRecord.Percentage_Coverage_OON;
        tempLead.Percent_Coverage_In_Network__c = leadRecord.Percent_Coverage_In_Network;
        tempLead.Deductible__c = leadRecord.In_Net_Deductible;
        tempLead.OON_Deductible__c = leadRecord.OON_Deductible;
        tempLead.Deductible_Met__c = leadRecord.In_Net_Deductible_Met;
        tempLead.OON_Deductible_Met__c = leadRecord.OON_Deductible_Met;
        tempLead.OOP_Max__c = leadRecord.OOP_Max_In_Net;
        tempLead.OON_OOP_Max__c = leadRecord.OON_OOP_Max;
        tempLead.OOP_Met__c = leadRecord.OOP_Met_In_Net;
        tempLead.OON_OOP_Met__c = leadRecord.OON_OOP_Met;
        tempLead.Usual_and_Customary__c = leadRecord.Usual_and_Customary;
        tempLead.Assignment_of_Benefits__c = leadRecord.Assignment_of_Benefits;
        tempLead.Additional_Notes__c = leadRecord.Additional_Notes;
        tempLead.CreatedDate = leadRecord.Created_Date_Time;
        tempLead.RT_Source__c = leadRecord.RT_Source;
        tempLead.RT_Channel__c = leadRecord.RT_Channel;
        tempLead.Campaign__c = leadRecord.Campaign;
        tempLead.Hubspot_Source__c = leadRecord.Hubspot_Source;
        tempLead.Hubspot_Source_Data_1__c = leadRecord.Hubspot_Source_Data_1;
        tempLead.Hubspot_Source_Data_2__c = leadRecord.Hubspot_Source_Data_2;
        
        insert tempLead;
        
        if(leadRecord.feedItemsList != null){
            for(createLeadWrapper.feedItems fis : leadRecord.feedItemsList){
                if(fis.body != null && fis.body != ''){
                    feedItem fi = new feedItem();
                    fi.ParentId = tempLead.id;
                    fi.type = 'TextPost';
                    fi.title = fis.title;
                    fi.body = fis.body;
                    fi.status = fis.status; 
                    fiList.add(fi);
                }
            }
            
            if(fiList.size()>0)
                insert fiList;
        }
        
    }
}