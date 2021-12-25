@isTest
private class VOBOpportunityUpdateProcessTest{
    Public static Opportunity o;
    Public static Account a;
    Public static Account aip;
    public Static Profile adminProfile;
    public static vob_request__C V;
    public static Insurance_Information__c II;
     public static Insurance_Information__c IIi ;
    public static Insurance_Information__c II2;
    public static Insurance_Verification__c IV;
    public static Insurance_Verification__c IV2;
    public static list<vob_request__C > VobList;
    public static list<opportunity> OppLst;


    
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
        o.Insurance_Provider__c=aip.id;
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
        
         IIi = new Insurance_Information__c();
        IIi .opportunity__C = o.id;
        IIi .VOB_Request__c = V.id;
        IIi .Insurance_Status__c = 'Primary';
        IIi .Insurance_Policy__c = '123456';
        IIi .Employer__c='88687';
        IIi .Insurance_Provider__c=aip.id;
        insert IIi ;
        
        
        
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
        IV.DED_INNET__c=12;
        IV.DED_met_INNET__c=12;
        IV.OOP_INNET__c = 23;
        IV.OOP_met_INNET__c=34;
        IV.Individual_or_Family_INNET__c = 'Family';
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
        iv.Detox_Benefits_Covered_INNET__c=34;
        iv.Detox_Benefits_Max_Per_Day_INNET__c=30;
        iv.Residential_Benefits_Covered_INNET__c=34;
        IV.Residential_Benefits_Max_Per_Day_INNET__c=45;
        iv.Part_Hospital_Covered_INNET__c=45;
        iv.Part_Hospital_Max_Per_Day_INNET__c=45;
        iv.Carve_Out_for_Behavioral_Health__c='6876hdjfdhfdj';
        iv.Precert_Company__c = 'abc';
             iv.Precert_Phone_Number__c='112';
             iv.Carve_Out_Phone_Number__c='223';
             iv.Carve_Out_Policy_Number__c='334';
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
    
    public Static testmethod void VOBOpportunityUpdateProcessTest(){
        test.startTest();
            createSampleData();
            Opportunity opp = [select id, Latest_VOB_Request__c from Opportunity where id=:o.id];
            voblist = new list<vob_request__C >();
            OppLst = new list<opportunity>();
            VobList.add(v);
            OppLst.add(o);
            
            VOBOpportunityUpdateProcess.UpdateOpportunities(OppLst,VobList);
           

        test.stopTest();
    }
    
      public Static testmethod void VOBOpportunityUpdateProcessTest_transferPrimaryToSecondary(){
        test.startTest();
            createSampleData();
            Opportunity opp = [select id, Latest_VOB_Request__c from Opportunity where id=:o.id];
             
             II.Insurance_Status__c = null;
             update II;
             
             IIi.Insurance_Status__c = 'Secondary';
              update IIi;
             
             voblist = new list<vob_request__C >();
            OppLst = new list<opportunity>();
            
             VobList.add(v);
             OppLst.add(o);
             VOBOpportunityUpdateProcess.UpdateOpportunities(OppLst,VobList);
          
             
             

            test.stopTest();
    }
            
    
}