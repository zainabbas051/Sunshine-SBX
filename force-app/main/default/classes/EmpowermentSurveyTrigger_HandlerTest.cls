@isTest
private class EmpowermentSurveyTrigger_HandlerTest{
      
    
     @testSetup static void setup() {
        
        Account a;
         Opportunity oms;
        
      
        a = new Account();
        a.Name = 'Chapters Capistrano';
        a.Type = 'Internal Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Sunshine_Center__c = a.id;
       
        insert oms;
        
      
        
        
     }
     
          Static testmethod void ProcessTest(){
          
                Opportunity oppty = [Select id from Opportunity limit 1];
                Empowerment_Packet_Survey__c emp = new Empowerment_Packet_Survey__c();
                emp.Related_Opportunity__c = oppty.Id;
                emp.Street_Address__c = '123';
                emp.City__c = 'Macomb';
                emp.State__c = 'Michigan';
                emp.Zip_Code__c = 123;
                emp.Support_Meetings_Interested_In__c = 'Al-Anon';
                insert emp;
          }
          
            Static testmethod void ProcessTest1(){
            
                  Account a;
         Opportunity oms;
        
      
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Sunshine_Center__c = a.id;
       
        insert oms;
          
              
                Empowerment_Packet_Survey__c emp = new Empowerment_Packet_Survey__c();
                emp.Related_Opportunity__c = oms.Id;
                emp.Street_Address__c = '123';
                emp.City__c = 'Macomb';
                emp.State__c = 'Michigan';
                emp.Zip_Code__c = 123;
                emp.Support_Meetings_Interested_In__c = 'Al-Anon';
                insert emp;
          }
          
          
          Static testmethod void ProcessTest2(){
            
                  Account a;
         Opportunity oms;
        
      
        a = new Account();
        a.Name = 'Willow Springs';
        a.Type = 'Internal Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Sunshine_Center__c = a.id;
       
        insert oms;
          
              
                Empowerment_Packet_Survey__c emp = new Empowerment_Packet_Survey__c();
                emp.Related_Opportunity__c = oms.Id;
                emp.Street_Address__c = '123';
                emp.City__c = 'Macomb';
                emp.State__c = 'Michigan';
                emp.Zip_Code__c = 123;
                emp.Support_Meetings_Interested_In__c = 'Al-Anon';
                insert emp;
          }
}