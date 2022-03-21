@isTest
private class Ctrl_AlumniApp_DailyContentTest {
 
 
 
 static testMethod void Ctrl_AlumniApp_DailyContentTest() {
 
 
 
 Test.startTest();

   List<Alumni_App_Daily_Content__c>  successstories = Ctrl_AlumniApp_DailyContent.GetSuccessStories();  
   List<Alumni_App_Challenges_Configurations__c> challenges = Ctrl_AlumniApp_DailyContent.GetChallengesConfig();
   List<Alumni_App_Daily_Content__c> motivationalqoutes = Ctrl_AlumniApp_DailyContent.GetMotivationalQoutes();
   List<Alumni_App_Daily_Content__c> clinical = Ctrl_AlumniApp_DailyContent.GetClinicalQoutes();
  // String file = Ctrl_AlumniApp_DailyContent.uploadFileToAWS('test', 'pdf','avd');
    
    
    
 Test.stopTest();
 
 }

}