@isTest
private class DrugScreenViewCompExtTest{
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static Medical__c medical ;
    Public static User u_test;
    public Static Profile adminProfile;
    
     
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
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        Schema.DescribeSObjectResult chart = Schema.SObjectType.Client_Chart__c;
        Map<String, Schema.RecordTypeInfo> rtMapByNameChart = Chart.getRecordTypeInfosByName();
        Id recTypeIdchart = rtMapByNamechart.get('Monarch Shores').getRecordTypeId(); 
        
        cc = new Client_Chart__c();
        cc.name = 'test';
        cc.RecordTypeId = recTypeIdchart;
        insert cc;
        
        
        medical = new Medical__c();
        medical.Client_Chart__c = cc.id;
        insert medical;
        
     }
     
     public Static testmethod void DrugScreenViewCompExtTest(){
     
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
          ApexPages.currentPage().getParameters().put('Id', cc.id);
          ApexPages.CurrentPage().getParameters().put('rId',medical.id);
          
           
          DrugScreenViewCompExt dsvc = new DrugScreenViewCompExt();
          
          dsvc.AddAttachment(); 
                             
       }       
       test.StopTest();
             
      }
      
            
}