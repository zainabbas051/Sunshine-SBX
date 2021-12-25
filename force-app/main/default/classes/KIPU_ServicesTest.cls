@isTest
private class KIPU_ServicesTest {
    
    static Account a;
    static Account a1;
    static Opportunity o;
    static{
        
        Sunshine_Center_Id__c sc = new Sunshine_Center_Id__c();
        sc.Name = 'Chapters Capistrano';
        SC.Secret_Key__c = '123';
        SC.KIPU_Access_ID__c ='123';
        SC.SFDC_API_ID__c ='123';
        //SC.Health_Care_Practitioner_Role_ID__c = [select id from UserRole where name like '%Health care%'].id;
        insert sc;
        
        a = new Account();
        a.Name = 'test';
        a.Type = 'Treatment Center';
        insert a;
        
        a1 = new Account();
        a1.Name = 'Chapters Capistrano';
        a1.Type = 'Internal Center';
        insert a1;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Sunshine_Center__c = a1.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.State__c = 'Michigan';
        insert o;
    }
    
    static testMethod void method1() {
        
        string response = KIPU_Services.CreatePatient(o.id);
    }
    
    static testMethod void method2(){
        
        KIPUPatientsBatchSchd  obj = new KIPUPatientsBatchSchd ();
        obj.execute(null);
        //o.KIPU_Status__c = 'Review Pending';
        //update o;
        
        KIPU_PatientsBatch kpb = new KIPU_PatientsBatch ();
        database.executebatch(kpb);
    }
    
    static testmethod void method3(){
        
        Test.setCurrentPageReference(Page.page_CreateKIPUChart);

        System.currentPageReference().getParameters().put('id', o.id);
        
        ctrl_CreateKIPUChart obj = new ctrl_CreateKIPUChart();
        
        obj.CreatePatient();
    }
    
    static testmethod void method4(){
        
        KIPU_APIs_Wrappers.createPatientMain c1 = new KIPU_APIs_Wrappers.createPatientMain();
        KIPU_APIs_Wrappers.kipudocument c2 = new KIPU_APIs_Wrappers.kipudocument();
        KIPU_APIs_Wrappers.CreatePatient c3 = new KIPU_APIs_Wrappers.CreatePatient();
        KIPU_APIs_Wrappers.InsuranceAttributes c4 = new KIPU_APIs_Wrappers.InsuranceAttributes();
        KIPU_APIs_Wrappers.PatientContactsAttributes c5 = new KIPU_APIs_Wrappers.PatientContactsAttributes();
        KIPU_APIs_Wrappers.PatientsData c6 = new KIPU_APIs_Wrappers.PatientsData();
        KIPU_APIs_Wrappers.PatientData c7 = new KIPU_APIs_Wrappers.PatientData();
        KIPU_APIs_Wrappers.apps c8 = new KIPU_APIs_Wrappers.apps();
    }
}