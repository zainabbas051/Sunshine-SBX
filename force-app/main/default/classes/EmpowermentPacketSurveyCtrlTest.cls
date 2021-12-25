@isTest
private class EmpowermentPacketSurveyCtrlTest{
      
    
     @testSetup static void setup() {
        
        Account a;
         Opportunity oms;
        
      
        a = new Account();
        a.Name = 'Chapters Capistrano';
        a.Type = 'Internal Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Addiction Network').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Discharged';
        oms.CloseDate = date.Today();
        oms.Sunshine_Center__c = a.id;
        oms.Check_Out_Date__c = Date.today().addDays(-1);  
        insert oms;
        
      
        
        
     }
     
          Static testmethod void ProcessTest(){
          
               EmpowermentPacketSurveyCtrl.GetOpportunityRecord();
               
                  Empowerment_Packet_Survey__c emp = new Empowerment_Packet_Survey__c();
                emp.Related_Opportunity__c = [Select id from Opportunity LIMIT 1].ID;
                emp.Street_Address__c = '123';
                emp.City__c = 'Macomb';
                emp.State__c = 'Michigan';
                emp.Zip_Code__c = 123;
                emp.Support_Meetings_Interested_In__c = 'Al-Anon';
                
               
               EmpowermentPacketSurveyCtrl.saveEmpowerment(emp);
          }
          
}