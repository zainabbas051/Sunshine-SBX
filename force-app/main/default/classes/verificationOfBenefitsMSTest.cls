@isTest(seeAllData=true)
private class verificationOfBenefitsMSTest{
    
    Public static Opportunity o;
    Public static Account a;
    Public static Account aip;
    public Static Profile adminProfile;
        public static vob_request__C V;
      public static Insurance_Information__c II;
    public static Insurance_Information__c II2;
    public static Insurance_Verification__c IV;
    public static Insurance_Verification__c IV2;

    
    public Static void createSampleData(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        aip = new Account();
        aip.Name = 'test account';
        aip.Type = 'Insurance Provider';
        insert aip;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        insert o;
        
         v = new vob_request__c();
        v.opportunity__C=o.id;
        v.VOB_Request_Status__c = 'Complete';
        insert v;
        
        o.Latest_VOB_Request__c = v.id;
        update o;
        
          II = new Insurance_Information__c();
        II.opportunity__C = o.id;
        II.VOB_Request__c = V.id;
        II.Insurance_Status__c = 'Primary';
        II.Insurance_Policy__c = '123456';
        II.Employer__c='88687';
        II.Insurance_Provider__c=aip.id;
        insert II;
        
        
        
        IV = new Insurance_Verification__c();
        IV.Opportunity__c = o.id;
        IV.Related_Insurance_Information__c=II.id;
        IV.VOB_Request__c = v.id;
        IV.Effective_Date__c=date.today();
        Iv.Termination_Date__c = date.today();
        Iv.Calendar_Plan_Year__c='Calendar';
        IV.Substance_Abuse_DED__c=12;
        IV.Substance_Abuse_DED_met__c=12;
        IV.Substance_Abuse_OOP__c = 23;
        IV.Substance_Abuse_OOP_met__c=34;
        IV.Substance_Abuse_Individual_or_Family__c = 'Family';
        Iv.Rate_Type__c='MCR';
        IV.Covered__c =12;
        iv.State_Lic_Accepted__c ='OutPatient Only';
        iv.JCAHO_CARF_Req_Levels__c='InPatient Only';
        iv.Policy_Exclusions__c='Test18268';
        iv.Out_of_State_Restrictions__c='testststt';
        iv.Assignment_of_Benefits_Accepted__c='Yes';
        iv.Detox_Benefits_Covered__c=34;
        iv.Detox_Benefits_Max_Per_Day__c=30;
        iv.Residential_Benefits_Covered__c=34;
        IV.Residential_Benefits_Max_Per_Day__c=45;
        iv.Part_Hospital_Covered__c=45;
        iv.Part_Hospital_Max_Per_Day__c=45;
        iv.Carve_Out_for_Behavioral_Health__c='6876hdjfdhfdj';
        iv.Additional_Notes__c='jdfhdgjjh';
        iv.IOP_Covered__c=34;
        iv.IOP_Max_Per_Day__c=45;
        iv.OP_Covered__c=56;
        iv.OP_Max_Per_Day__c=89;
        insert IV;
        
        
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
    
    public Static testmethod void test_verificationOfBenefitsMS_justPrimary(){
        test.startTest();
            createSampleData();
            Opportunity opp = [select id, Latest_VOB_Request__c from Opportunity where id=:o.id];
            ApexPages.CurrentPage().GetParameters().put('oppId',o.id);//Setting the opportunity id for the page context
            ApexPages.CurrentPage().GetParameters().put('vobId',opp.Latest_VOB_Request__c);
            verificationOfBenefitsMS vobms = new verificationOfBenefitsMS();
            
            vobms.loadData(o.id);//Loading the initial data on the page
            
            vobms.editPrimaryInsuranceVerification();
            vobms.savePrimaryInsuranceVerification();
            
            PageReference pr = vobms.completeVOB();//Trying to Complete VOB with out putting in the Insurance Provider and Primary Insurance Status
            
            vobms.editPrimaryInsurance();
        vobms.insuranceInformation1=II;
            vobms.insuranceInformation1.Insurance_Status__c = 'Primary';//Updating Insurance Status
        vobms.insuranceInformation2=II;
            vobms.insuranceInformation2.Insurance_Status__c = 'Primary';
            vobms.oppInfo.Insurance_Provider__c= aip.id;//updating the Insurance Provider values
            vobms.savePrimaryInsurance();
            vobms.insuranceInformation2.id=null;
        vobms.savePrimaryInsurance();
            vobms.loadData(o.id);
            vobms.insuranceInformation1.Insurance_Policy__c = '123456';  
            PageReference pr2 = vobms.completeVOB();//Completing the VOB
        
         vobms.insuranceInformation1.id=null;
            
            vobms.oppInfo.Insurance_Provider__c= aip.id;//updating the Insurance Provider values
            vobms.savePrimaryInsurance();
            
            vobms.loadData(o.id);
            vobms.insuranceInformation1.Insurance_Policy__c = '123456';  
            PageReference pr3 = vobms.completeVOB();//Completing the VOB
        
           vobms.insuranceInformation1.Insurance_Status__c = '';
         vobms.savePrimaryInsurance();
            
            
       
        test.stopTest();
    }
    
    public Static testmethod void test_verificationOfBenefitsMS_transferSeondaryToPrimary(){
        test.startTest();
            createSampleData();
            Opportunity opp = [select id, Latest_VOB_Request__c from Opportunity where id=:o.id];
            ApexPages.CurrentPage().GetParameters().put('oppId',o.id);//Setting the opportunity id for the page context
            ApexPages.CurrentPage().GetParameters().put('vobId',opp.Latest_VOB_Request__c);
            verificationOfBenefitsMS vobms = new verificationOfBenefitsMS();
            
            vobms.loadData(o.id);
         vobms.insuranceInformation1=II;
            vobms.insuranceInformation1.Insurance_Status__c = 'Secondary';//Updating Insurance Status
                    vobms.insuranceInformation2.Insurance_Status__c = 'Secondary';//Updating Insurance Status

        vobms.insuranceInformation2.id=II.id;
            
            vobms.editPrimaryInsuranceVerification();
            vobms.savePrimaryInsuranceVerification();
            
            vobms.editPrimaryInsurance();
            vobms.savePrimaryInsurance();
       
            vobms.initiateSecondaryInsurance();//Creating the Secondary Insurance by clicking on Initiate Secondary Information button on the VF page
             
            PageReference pr = vobms.completeVOB();//Trying to Complete VOB with out putting in the Insurance Provider and Primary Insurance Status
            
            vobms.editSecondaryInsurance();
            vobms.insuranceInformation2.Insurance_Status__c = 'Primary';//On putting this value in the secondary insurance status and Saving, it would automatically update this insurance as the Primay Insurance on File
            vobms.saveSecondaryInsurance();
            
            vobms.oppInfo.Insurance_Provider__c= aip.id;//Setting the Insurance Provider
              
            PageReference pr2 = vobms.completeVOB();//Effectively we are just completing the VOB with just the primary insurance.
            
            vobms.insuranceInformation1.id=null;
            
            vobms.oppInfo.Insurance_Provider__c= aip.id;//updating the Insurance Provider values
            vobms.savePrimaryInsurance();
            
            vobms.loadData(o.id);
            vobms.insuranceInformation1.Insurance_Policy__c = '123456';  
            PageReference pr3 = vobms.completeVOB();//Completing the VOB
        
           vobms.insuranceInformation1.Insurance_Status__c = '';
         vobms.savePrimaryInsurance();
            
        test.stopTest();
    }
    
    public Static testmethod void test_verificationOfBenefitsMS_transferPrimaryToSecondary(){
        test.startTest();
            createSampleData();
            Opportunity opp = [select id, Latest_VOB_Request__c from Opportunity where id=:o.id];
            ApexPages.CurrentPage().GetParameters().put('oppId',o.id);//Setting the opportunity id for the page context
            ApexPages.CurrentPage().GetParameters().put('vobId',opp.Latest_VOB_Request__c);
            verificationOfBenefitsMS vobms = new verificationOfBenefitsMS();
            
            vobms.loadData(o.id);
            
            vobms.editPrimaryInsuranceVerification();
            vobms.savePrimaryInsuranceVerification();
        
      
           
            
            vobms.editPrimaryInsurance();
            vobms.insuranceInformation1.Insurance_Status__c = 'Secondary';//Updating the current on File Insurance as the Secondary Insurance
            vobms.savePrimaryInsurance();
            
            vobms.loadData(o.id);//Loading the contents of the VF page again
            
            vobms.initatePrimaryInsurance();//We are initiating the Primary Insurance on VF page by clicking the Button, as we transfered the original primary insurance over to the secondary
            
            vobms.editSecondaryInsurance();
            vobms.saveSecondaryInsurance();
            
            vobms.editSecondaryInsuranceVerification();
            vobms.saveSecondaryInsuranceVerification();
            
            PageReference pr = vobms.completeVOB();//Trying to Complete VOB with out putting in the Insurance Provider and Primary Insurance Status
            
            vobms.editPrimaryInsurance();
            vobms.insuranceInformation1.Insurance_Status__c = 'Primary';//Updating the Insurance Status on the Primary Insurance
            vobms.oppInfo.Insurance_Provider__c= aip.id;//Updating the Insurance provider value on the insurance.
            vobms.savePrimaryInsurance();
               
            PageReference pr2 = vobms.completeVOB();//Completing the VOB after putting in all the correct values for Primary and Secondary insurance.
                      vobms.insuranceInformation1.id=ii.id;
        vobms.insuranceInformation1.Insurance_Status__c = null;//Updating the Insurance Status on the Primary Insurance
            vobms.insuranceInformation2.Insurance_Status__c = 'Primary';//Updating the Insurance Status on the Primary Insurance

            vobms.savePrimaryInsurance();
               
            PageReference pr3 = vobms.completeVOB();//Completing the VOB after putting in all the correct values for Primary and Secondary insurance.
            
        
            vobms.insuranceInformation2.Insurance_Status__c = 'Primary';//Updating the Insurance Status on the Primary Insurance
         vobms.insuranceInformation1= new Insurance_Information__c();

            vobms.savePrimaryInsurance();
               vobms.displayPrimary = True;
        vobms.displaySecondary=False;
            PageReference pr4 = vobms.completeVOB();//Completing the VOB after putting in all the correct values for Primary and Secondary insurance.
            
        test.stopTest();
    }

}