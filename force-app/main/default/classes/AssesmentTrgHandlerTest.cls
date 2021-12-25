@isTest
private class AssesmentTrgHandlerTest{
    
      public Static testmethod void TestMethod1(){
          
              
                 
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        Account aip = new Account();
        aip.Name = 'test account';
        aip.Type = 'Insurance Provider';
        insert aip;
        
        
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = UserInfo.getUserId();
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        o.Insurance_Provider__c=aip.id;
        insert o;
        
        Pre_Admission_Assessment__c  pre = new Pre_Admission_Assessment__c ();
        pre.Opportunity__c = o.Id;
        insert pre;
        
        Test.setCurrentPageReference(new PageReference('Page.Vfp_PreAdmissionAssesmentRedirect')); 
        System.currentPageReference().getParameters().put('OpptyId', o.Id);
        
        PreAdmissionAssesmentRedirect_Ctrl pre1 = new PreAdmissionAssesmentRedirect_Ctrl();
        pre1.redirect();
              
      }
      
        public Static testmethod void TestMethod2(){
          
              
                 
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        Account aip = new Account();
        aip.Name = 'test account';
        aip.Type = 'Insurance Provider';
        insert aip;
        
        
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = UserInfo.getUserId();
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        o.Insurance_Provider__c=aip.id;
        insert o;
        
       
        
        Test.setCurrentPageReference(new PageReference('Page.Vfp_PreAdmissionAssesmentRedirect')); 
        System.currentPageReference().getParameters().put('OpptyId', o.Id);
        
        PreAdmissionAssesmentRedirect_Ctrl pre1 = new PreAdmissionAssesmentRedirect_Ctrl();
        pre1.redirect();
              
      }
      
}