@isTest
private class BizibleTouchpointUtilityTest{
    
    Public static Lead l;
    Public static bizible2__Bizible_Person__c bp;
    Public static bizible2__Bizible_Touchpoint__c bt;
    
    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        l.recordTypeId = recTypeId;
        l.Test_Class_Checkbox__c = True;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        l.OwnerId = label.Naveen_User_Id;
        insert l;
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setOwnerId(label.Naveen_User_Id);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        bp = new bizible2__Bizible_Person__c ();
        bp.Name = '586-342-47@invoca.net';
        bp.bizible2__Lead__c = l.id;
        bp.bizible2__UniqueId__c = '586-342-47@invoca.net';
        insert bp;
        
         bt = new bizible2__Bizible_Touchpoint__c();
        bt.bizible2__Bizible_Person__c = bp.id;
        bt.bizible2__Ad_Campaign_Name__c = 'Google Bing';
        bt.bizible2__Ad_Content__c = 'Google Bing';
        bt.bizible2__Ad_Destination_URL__c = 'www.google.com';
        bt.bizible2__Ad_Group_Name__c = 'GOOGLE PIXEL';
        bt.bizible2__Browser__c = 'Google';
        bt.bizible2__Form_URL__c = 'www.google.com';
        bt.bizible2__Geo_City__c = 'Macomb';
        bt.bizible2__Geo_Country__c = 'United States';
        bt.bizible2__Geo_Region__c = 'Michigan';
        bt.bizible2__Keyword_Text__c = 'Google Keyword';
        bt.bizible2__Landing_Page__c = 'www.eliterehabplacement.com';
        bt.bizible2__Marketing_Channel_Path__c = 'Direct';
        bt.bizible2__Marketing_Channel__c = 'Direct';
        bt.bizible2__Medium__c = 'Web';
        bt.bizible2__Platform__c = 'Android (5.1)';
        bt.bizible2__Referrer_Page__c = 'www.addictionnetwork.com';
        bt.bizible2__Segment__c = 'Segment';
        bt.bizible2__Touchpoint_Position__c = 'FT';
        bt.bizible2__Touchpoint_Source__c = 'Web Direct';
        bt.bizible2__Touchpoint_Type__c = 'Web Visit';
        bt.bizible2__UniqueId__c = 'a19857894231';
        insert bt;
        
    }
    
   
    
    public Static testmethod void testCase1(){
        test.startTest();
        
        createSampleData();
        
        Lead tempLead = new Lead();
        tempLead = [Select id, ConvertedOpportunityId from lead where id=: l.id];
        
        Opportunity tempOpp = new Opportunity();
        tempOpp = BizibleTouchpointUtility.updateOpp(tempLead.ConvertedOpportunityId,bt);
         
        test.StopTest();
    }
    
     
}