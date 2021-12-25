@isTest
private class ClinicalEvaluationDetailPage_Test{

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
                            LanguageLocaleKey='en_US', Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }

public Static testmethod void ClinicalEvaluationDetailPage_Test()
{
    Test.startTest();
    
    TabViews__c tv = new TabViews__c();
     tv.Name = 'ClinicalEvaluation';
     tv.Button_Access_Type__c = 'Admin';
     insert tv;
    
    system.runAs(userAdmin){
        ApexPages.currentPage().getParameters().put('ID', 'ID');
        ApexPages.currentPage().getParameters().put('ceId', 'ClientID');
        ApexPages.currentPage().getParameters().put('readOnly', 'true');
        ApexPages.currentPage().getParameters().put('type', 'Type');
        
        
        ClinicalEvaluationDetailPage CEDP = new ClinicalEvaluationDetailPage();
        CEDP.ceRecord= new Clinical_Evaluation__c();
        CEDP.BackToHome();
        
        Boolean Flag = CEDP.buttonAccessType;
    }
    
    Test.stopTest(); 
      
}

}