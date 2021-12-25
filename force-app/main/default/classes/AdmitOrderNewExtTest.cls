@isTest
private class AdmitOrderNewExtTest{
    Public static Account a;
    public static Client_Chart__c ClientIns;
    Public static Case c;
    public static Medical__c medical;
    Public static User u_test;
    public Static Profile adminProfile;
    public static Order__c order;
    public static Taper__c  taper;
    public static Taper__c  taper2;
    public static Taper__c  taper3;
     
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', User_Role__c = NULL);
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        /*AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name = 'FREEPU';
        AmazonBucketValue.accessKeyId__c = '1234';
        AmazonBucketValue.secretAccessKey__c= '1234';
        insert AmazonBucketValue; */
        
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
        
        ClientIns = new Client_Chart__c();
        ClientIns.name = 'test';
        ClientIns.RecordTypeId = recTypeIdchart;
        insert ClientIns;
       
        
        
        medical = new Medical__c();
        medical.Client_Chart__c = ClientIns.id;
        medical.Status__c = 'Open';
        insert medical;
        
        taper = new taper__c();
        taper.Dosage_Type__c ='Open Ended';
        taper.Active__c = true;
        taper.PRN_Medication_Type__c = 'Constipation Relief';
        insert taper;
        
        taper2 = new taper__c();
        taper2.Dosage_Type__c ='Open Ended';
        taper2.Active__c = true;
        taper2.PRN_Medication_Type__c = 'Constipation Relief';
        insert taper2;
        
        taper3 = new taper__c();
        taper3.Dosage_Type__c ='Taper';
        taper3.Active__c = true;
        taper3.PRN_Medication_Type__c = 'Constipation Relief';
        insert taper3;
        
        order = new order__c();
        order.Client_Chart__c = ClientIns.id;
        order.Medical__c = medical.id;
        order.Taper__c = taper.ID;
        insert order;
        }
     
     public Static testmethod void AdmitOrderNewExtTest(){
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
         ApexPages.currentPage().getParameters().put('Id', ClientIns.id);
         ApexPages.currentPage().getParameters().put('mcid', medical.id); 
          
          integer index; 
          List<AdmitOrderNewExt.wrapperOrder> w;
         AdmitOrderNewExt.wrapperOrder testorder = new AdmitOrderNewExt.wrapperOrder(order,1);
         AdmitOrderNewExt aone = new AdmitOrderNewExt();
         
         string flag = aone.taperId;
         
         string flag2= aone.OTCID ;
         string flag3 = aone.PSID ;
         string flag4 = aone.StomachPSID ;
         boolean flag5 = aone.readOnly;
         
          List<SelectOption> options = aone.getTaperLst();
          List<SelectOption> options1 = aone.getVital();
          List<SelectOption> options2 = aone.getCOWS();
          List<SelectOption> options3 = aone.getCIWA();
          List<SelectOption> options4 = aone.getVisual();    
          
          aone.taperID = taper3.id;
          
           aone.editRecord();
           aone.SaveRecord();
           aone.SaveMedical();
           aone.addmedi();
           //aone.deletemedi();
                                     
       }       
       test.StopTest();
             
      }
       
}