@isTest
private class monarchShoresOpportunitiesTest{
    Public static Account a;
    Public static Opportunity oms;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController opportunityController;
    public Static monarchShoresOpportunities monarchShoresOpp;
 
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        List<Opportunity_Transfer_Fields__c> otfInsertList = new List<Opportunity_Transfer_Fields__c>();
        List<String> otfNameList = new List<String>();
        otfNameList.add('Closing_Agent__c');
        otfNameList.add('Opening_Agent__c');
        otfNameList.add('LeadSource');
        otfNameList.add('Assignment_of_Benefits__c');
        otfNameList.add('Usual_and_Customary__c');
        otfNameList.add('Insurance_Verified_By__c');
        otfNameList.add('Insurance_Verified_Time_Stamp__c');
        otfNameList.add('Name');
        otfNameList.add('CloseDate');
        
        for(string s : otfNameList){
            Opportunity_Transfer_Fields__c otf = new Opportunity_Transfer_Fields__c();
            otf.Name = s;
            otfInsertList.add(otf);
        }
        
        if(otfInsertList.size()>0){
            insert otfInsertList;
        }
        
        
        Monarch_Shores_Closing_Agents__c msca = new Monarch_Shores_Closing_Agents__c();
        msca.Name = 'Test User';
        msca.Closing_Agent_Id__c = userAdmin.id;
        msca.Monarch_Shores_User__c = False;
        insert msca;
     } 
     
     public Static testmethod void test_monarchShoresOpportunities_Class(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           opportunityController = new ApexPages.StandardController(oms);
           monarchShoresOpp = new monarchShoresOpportunities(opportunityController); 
           ApexPages.currentPage().getParameters().put('Id', oms.id);
           ApexPages.currentPage().getParameters().put('record_type_id', oms.recordTypeId);
           
           monarchShoresOpp.setClosingAgent(userAdmin.id);
           
           monarchShoresOpp.createEliteRehabPlacementOpportunity();
           
           List<SelectOption> so2 = new List<SelectOption>();
           so2 = monarchShoresOpp.getItems();
           
           monarchShoresOpp.createMonarchShoresOpportunity();
           
           monarchShoresOpp.cancel1();
           
           List<SelectOption> sol = new List<SelectOption>();
           sol = monarchShoresOpp.getItems();
           
           
           
       }       
       test.StopTest();
             
      }
  }