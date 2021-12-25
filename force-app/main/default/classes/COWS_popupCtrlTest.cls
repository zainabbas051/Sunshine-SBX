@isTest
public class COWS_popupCtrlTest {
    
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
    
      static testMethod void COWSTest(){
          
          
           awsBucket__c AmazonBucketValue = new awsBucket__c();
            AmazonBucketValue.name='FREEPU';
            AmazonBucketValue.accessKeyId__c='testAcess';
            AmazonBucketValue.secretAccessKey__c='secretKey';
            AmazonBucketValue.Bucket__c='freepu';
            insert AmazonBucketValue;
         
           Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a; 
         
         Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = a.id;
        scid.Dr_Alva_Forms__c = True;
        insert scid;
        
        
        List<Recurring_Assessment__c> lstRA = new List<Recurring_Assessment__c>();
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = userAdmin.id;
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.Client_Status__c = 'Admitted';
         cl.Program__c = 'Detox';
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
     
         insert cl;
         
         Recurring_Assessment__c ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('COWS').getRecordTypeId();
         lstRA.add(ra);
         
         ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('CIWA').getRecordTypeId();
         lstRA.add(ra);
         
         ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Detox Check').getRecordTypeId();
         lstRA.add(ra);
         
          ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('BMI').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Blood Glucose').getRecordTypeId();
         lstRA.add(ra);
         
           ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Status__c = 'Open';
         ra.Time_Due__c = Date.Today();
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Wellness Check').getRecordTypeId();
         lstRA.add(ra);
         
          ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Vital_SIgns_Required__c = true;
         ra.Vital_SIgns_Recurring_Time__c = 'Q2 Hours';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
           ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.COWS_Assessment_Required__c = true;
         ra.COWS_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra =new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.CIWA_Assessment_Required__c = true;
         ra.CIWA_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.CIWA_Assessment_Required__c = true;
         ra.CIWA_Assessment_Recurring_Time__c = 'Q2 Hours';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Detox_Required__c = true;
         ra.Detox_Recurring_Time__c = 'Q30';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.BMI_Assessment_Required__c = true;
         ra.BMI_Assessment_Recurring_Time__c = '24 Hours';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Blood_Glucose_Assessment_Required__c = true;
         ra.Blood_Glucose_Assessment_Recurring_Time__c = 'BID';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         ra = new Recurring_Assessment__c();
         ra.Client_Chart__c = cl.ID;
         ra.Wellness_Check_Required__c = true;
         ra.Wellness_Recurring_Time__c = 'Q15';
         ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
         lstRA.add(ra);
         
         insert lstRA;
         
         
         test.startTest();
         
         COWS_popupCtrl cows = new COWS_popupCtrl();
         cows.clientChartId = cl.ID;
         cows.saveCOWS();
         
         
         CIWA_popupCtrl ciwa = new CIWA_popupCtrl();
         ciwa.clientChartId = cl.ID;
         ciwa.saveRA();
         
         Detox_popupCtrl detox = new Detox_popupCtrl();
         detox.clientChartId = cl.Id;
         detox.saveDetox();
         
         BMMI_popupCtrl bmi = new BMMI_popupCtrl();
         bmi.clientChartId = cl.Id;
         bmi.saveBMI();
         
         Glucose_popupCtrl gl = new Glucose_popupCtrl();
         gl.clientChartId = cl.Id;
         gl.saveGlucose();
         
         Wellness_popupCtrl wi = new Wellness_popupCtrl();
         wi.clientChartId = cl.ID;
         wi.saveWellness();
         
       
         VS_popupCtrl vp = new VS_popupCtrl();
         vp.clientChartId = cl.ID;
         vp.saveVS();
         
          test.stopTest();
       
         
         
         
         
         
         
         
           
      }

}