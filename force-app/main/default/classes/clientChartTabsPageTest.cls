@isTest
public class clientChartTabsPageTest {
    
    
      static testMethod void clientChartTabs_Test(){
         
          test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         cl.Diagnosis_Code__c = 'abc;xyz';
         cl.DOB__c = Date.Today();
         insert cl;
         
         Allergies__c allerg = new Allergies__c();
         allerg.Client_Chart__c = cl.ID;
         insert allerg;
         
         
       
         System.currentPageReference().getParameters().put('ID',cl.ID);
         clientChartTabsPage clt = new clientChartTabsPage(null);
         clientChartTabsPage clt2 = new clientChartTabsPage();
         clt2.client = cl;
         clt2.RACIWA();
         clt2.RAMain();
         clt2.PHIMain();
         clt2.AIRMain();
         clt2.CNMain();
         clt2.TxDcMain();
         clt2.CEMain();
         clt2.IntakeMain();
         clt2.FSMain();
         clt2.URMain();
         clt2.MedsMain();
         clt2.MedicalMain();
         clt2.IRMain();
         clt2.updateRAConfig();
         
         test.stopTest();
         
      }
      
        public Static Profile adminProfile;
     public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id , Acess_Type__c = 'Admin',
                            LanguageLocaleKey='en_US', User_Role__c = NULL);
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    
     public Static testmethod void ClientTabTest(){
         
         test.startTest();
         
           system.runAs(userAdmin){
               
               TabViews__c tb = new TabViews__c();
               tb.Is_Main_Tab__c = false;
               tb.Tabs_Access_Type__c = 'Admin;Clinical;Medical;Operations';
               tb.Name = 'Client';
               
               insert tb;
               
               clientChartTabsPage clt2 = new clientChartTabsPage();
           }
         
         
         test.stopTest();
     
     }

}