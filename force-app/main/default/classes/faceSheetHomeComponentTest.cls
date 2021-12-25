@isTest
public class faceSheetHomeComponentTest{
    
    public static account a;
    public static opportunity o;
    public static Client_Chart__c cl;
    public static Allergies__c al;
    public Static Profile adminProfile;
    public static Insurance_Information__c ii;
    public static Insurance_Verification__c iv;
    public static awsBucket__c awsb;
    
    public static void createSampleData(){
       awsBucket__c AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
        insert AmazonBucketValue;
       
         a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        insert a;
         
         o = new Opportunity();
         o.Name = 'test opp';
         o.Account = a;
         o.Selected_Treatment_Center__c = a.id;
         o.Closing_Agent__c = userAdmin.id;
         o.Amount = 999;
         o.StageName = 'Paid';
         o.CloseDate = date.Today();
         o.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         o.Test_Class_Checkbox__c  = true;
         o.Cash_Client__c = False;
         o.Insurance_Providers__c= 'Spectra';
         insert o;
         
         cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Opportunity__c = o.id;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         ii = new Insurance_Information__c();
         ii.Opportunity__c = o.id;
         ii.Insurance_Status__c = 'Primary';
         insert ii;
         
         iv = new Insurance_Verification__c();
         iv.Related_Insurance_Information__c = ii.id;
         iv.Opportunity__c = o.id;
         insert iv;
         
         al = new Allergies__c();
         al.Client_Chart__c = cl.id;
         insert al;
         
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
    
    static testMethod void testCase1(){
        
         test.startTest();
         
             createSampleData();
             
             ApexPages.CurrentPage().getParameters().put('id',cl.id);
             
             faceSheetHomeComponent fshc = new faceSheetHomeComponent();
             
             PageReference pr1 = fshc.uploadClientChartImages();
             
             Boolean var1 = fshc.displayUploadClientChartImages; 
             
             fshc.editCCRecord();
             
             fshc.saveCCRecord();
             
             fshc.EditInsuranceComponent();
             
             fshc.ContIns.LastName = 'Test Contact';
             
             fshc.SaveContact();
             
             List<contact> contactList = fshc.getContactLst();
             
             fshc.ContClientID = contactList[0].id;
             
             fshc.EditContact();
             
             fshc.UpdateContact();
             
             fshc.deleteContact();
             
             fshc.SaveInsuranceComponent();
             
             list <Allergies__C> allergiesList =  fshc.getAllergiesLst();
             
             
         test.stopTest();
        
    }
}