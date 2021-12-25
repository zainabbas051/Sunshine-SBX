@isTest()

private class monthlyCommissionsCalculatorERPTest{
    Public static Opportunity oppCurrentMonth;
    Public static Opportunity oppPreviousMonth;
    Public static Opportunity oppCurrentMonth2;
    Public static Opportunity oppPreviousMonth2;
    Public static Account a;
    public Static Profile adminProfile;
    public Static Profile csrProfile;
    public static user scUser;
    
    
    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        List<User> u = [Select id from User where Profile.Name=:'Custom - CSR' AND isActive=:True LIMIT 3];
        List<User> uSC = [Select id from User where Profile.Name=:'Custom - Standard User' AND isActive=:True LIMIT 1];
        List<Opportunity> currentMonthInsertList = new List<Opportunity>();
        List<Opportunity> previousMonthInsertList = new List<Opportunity>();
        scUser = uSC[0];
        For(Integer i=0;i<50;i++){
            
        }
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.Account = a;
        opp.Selected_Treatment_Center__c = a.id;
        opp.Closing_Agent__c = userAdmin.id;
        opp.Amount = 6000;
        opp.OwnerId=uSC[0].id;
        opp.Referral_Agent__c = uSC[0].id;
        opp.Opening_Agent__c = u[0].id;
        opp.Referral_Verified__c = True;
        opp.StageName = 'Paid';
        opp.CloseDate = date.Today();
        opp.recordTypeId = recTypeId;
        opp.Test_Class_Checkbox__c  = true;
        opp.Cash_Client__c = False;
        opp.Insurance_Providers__c= 'Spectra';
        opp.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        opp.LeadSource='Repeat Business';
        opp.StageName='Rescued';
        insert opp;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'test opp';
        opp2.Account = a;
        opp2.Selected_Treatment_Center__c = a.id;
        opp2.Closing_Agent__c = userAdmin.id;
        opp2.Amount = 6000;
        opp2.OwnerId=uSC[0].id;
        opp2.Referral_Agent__c = uSC[0].id;
        opp2.Opening_Agent__c = u[0].id;
        opp2.Referral_Verified__c = True;
        opp2.StageName = 'Paid';
        opp2.CloseDate = date.Today().addMonths(-1);
        opp2.recordTypeId = recTypeId;
        opp2.Test_Class_Checkbox__c  = true;
        opp2.Cash_Client__c = False;
        opp2.Insurance_Providers__c= 'Spectra';
        opp2.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        opp2.LeadSource='Repeat Business';
        opp2.StageName='Rescued';
        insert opp2;
        
        oppCurrentMonth = new Opportunity();
        oppCurrentMonth.Name = 'test opp';
        oppCurrentMonth.Account = a;
        oppCurrentMonth.Selected_Treatment_Center__c = a.id;
        oppCurrentMonth.Closing_Agent__c = userAdmin.id;
        oppCurrentMonth.Amount = 6000;
        oppCurrentMonth.Referral_Agent__c = u[0].id;
        oppCurrentMonth.Opening_Agent__c = u[0].id;
        oppCurrentMonth.Referral_Verified__c = True;
        oppCurrentMonth.StageName = 'Paid';
        oppCurrentMonth.CloseDate = date.Today();
        oppCurrentMonth.recordTypeId = recTypeId;
        oppCurrentMonth.Test_Class_Checkbox__c  = true;
        oppCurrentMonth.Cash_Client__c = False;
        oppCurrentMonth.Insurance_Providers__c= 'Spectra';
        oppCurrentMonth.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        oppCurrentMonth.LeadSource='Repeat Business';
        insert oppCurrentMonth;
        
        oppPreviousMonth = new Opportunity();
        oppPreviousMonth.Name = 'test opp';
        oppPreviousMonth.Account = a;
        oppPreviousMonth.Selected_Treatment_Center__c = a.id;
        oppPreviousMonth.Closing_Agent__c = userAdmin.id;
        oppPreviousMonth.Amount = 6000;
        oppPreviousMonth.Referral_Agent__c = u[0].id;
        oppPreviousMonth.Opening_Agent__c = u[0].id;
        oppPreviousMonth.Referral_Verified__c = True;
        oppPreviousMonth.StageName = 'Paid';
        oppPreviousMonth.CloseDate = date.Today().addMonths(-1);
        oppPreviousMonth.recordTypeId = recTypeId;
        oppPreviousMonth.Test_Class_Checkbox__c  = true;
        oppPreviousMonth.Cash_Client__c = False;
        oppPreviousMonth.Insurance_Providers__c= 'Spectra';
        oppPreviousMonth.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        oppPreviousMonth.LeadSource='Repeat Business';
        insert oppPreviousMonth;
        
        oppCurrentMonth2= new Opportunity();
        oppCurrentMonth2.Name = 'test opp';
        oppCurrentMonth2.Account = a;
        oppCurrentMonth2.Selected_Treatment_Center__c = a.id;
        oppCurrentMonth2.Closing_Agent__c = userAdmin.id;
        oppCurrentMonth2.Amount = 4000;
        oppCurrentMonth2.Referral_Agent__c = u[1].id;
        oppCurrentMonth2.Opening_Agent__c = u[0].id;
        oppCurrentMonth2.Referral_Verified__c = True;
        oppCurrentMonth2.StageName = 'Paid';
        oppCurrentMonth2.CloseDate = date.Today();
        oppCurrentMonth2.recordTypeId = recTypeId;
        oppCurrentMonth2.Test_Class_Checkbox__c  = true;
        oppCurrentMonth2.Cash_Client__c = False;
        oppCurrentMonth2.Insurance_Providers__c= 'Spectra';
        oppCurrentMonth2.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        oppCurrentMonth2.LeadSource='Personal Referral';
        insert oppCurrentMonth2;
        
        oppPreviousMonth2 = new Opportunity();
        oppPreviousMonth2.Name = 'test opp';
        oppPreviousMonth2.Account = a;
        oppPreviousMonth2.Selected_Treatment_Center__c = a.id;
        oppPreviousMonth2.Closing_Agent__c = userAdmin.id;
        oppPreviousMonth2.Amount = 4000;
        oppPreviousMonth2.Referral_Agent__c = u[2].id;
        oppPreviousMonth2.Opening_Agent__c = u[0].id;
        oppPreviousMonth2.Referral_Verified__c = True;
        oppPreviousMonth2.StageName = 'Paid';
        oppPreviousMonth2.CloseDate = date.Today().addMonths(-1);
        oppPreviousMonth2.recordTypeId = recTypeId;
        oppPreviousMonth2.Test_Class_Checkbox__c  = true;
        oppPreviousMonth2.Cash_Client__c = False;
        oppPreviousMonth2.Insurance_Providers__c= 'Spectra';
        oppPreviousMonth2.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        oppPreviousMonth2.LeadSource='Personal Referral';
        insert oppPreviousMonth2;
        
     }
     
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
    
    public static User userCSR
    {
        get{
            if (userAdmin == null )
            {
                csrProfile = [Select Id, Name From Profile where name = 'Custom - CSR' limit 1];
                userCSR  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', profileId=csrProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userCSR;             
             }
             return userCSR;
            }
        set;
    }
    
    public Static testmethod void test_ClaimToVOB_Class(){
           test.startTest();
       //system.runAs(userAdmin){
               
               createSampleData();
               oppCurrentMonth.StageName='Rescued';
               update oppCurrentMonth;
               
               oppPreviousMonth.StageName='Rescued';
               update oppPreviousMonth;
               
               oppCurrentMonth2.StageName='Rescued';
               update oppCurrentMonth2;
               
               oppPreviousMonth2.StageName='Rescued';
               update oppPreviousMonth2;
               
               monthlyCommissionsCalculatorERP.commissionCalculator();
               
               
               monthlyCommissionDisplayERP mcd = new monthlyCommissionDisplayERP();
               mcd.monthlyCommissions();
               
               List<SelectOption> monthsList = mcd.getMonths(); 
               List<SelectOption> yearsList = mcd.getYears(); 
               
               decimal scTotal = monthlyCommissionDisplayERP.totalSCCommission;
               decimal csrTotal = monthlyCommissionDisplayERP.totalCSRCommission;
               decimal muTotal = monthlyCommissionDisplayERP.totalMUCommission;
               
               monthlyCommissionsCalculatorERPScheduled m = new monthlyCommissionsCalculatorERPScheduled();
               String sch = '20 30 8 10 2 ?';
               String jobID = system.schedule('Commission Calculation Job', sch, m);
               
               system.runAs(scUser){
                   monthlyCommissionDisplayERP_Individual mcdi = new monthlyCommissionDisplayERP_Individual();
                   mcdi.monthlyCommissions();
                   
                   boolean mcFlag = monthlyCommissionDisplayERP_Individual.displayManagementCommission;
                   boolean csrFlag = monthlyCommissionDisplayERP_Individual.displayCSRCommission;
                   boolean scFlag = monthlyCommissionDisplayERP_Individual.displaySCCommission;
                   
                   List<SelectOption> monthsListInd = mcdi.getMonths(); 
                   List<SelectOption> yearsListInd = mcdi.getYears();
               }

           //}
          test.StopTest();
             
      }
    
}