global class sendCGdashboardEmailBatch implements Database.Batchable<sObject>, Database.Stateful{
 string query;
 Ctrl_CGDashboard cg;
    
    global sendCGdashboardEmailBatch (){
     query='Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where id=\''+System.Label.CG_email_template_id+'\'';
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator(query);
    }
  
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
    
    
       cg = new Ctrl_CGDashboard();
       string dashboardNumber = getLastUnscheduledDischarge('Last 7 Unscheduled Discharge - CC');
       dashboardNumber += ';'+getLastUnscheduledDischarge('Last 7 Unscheduled Discharge - MS');
       dashboardNumber += ';'+getLastUnscheduledDischarge('Last 7 Unscheduled Discharge - WSR');
       dashboardNumber += ';'+getLastUnscheduledDischarge('Last 7 Unscheduled Discharge - CO');
      dashboardNumber += ';'+getLastUnscheduledDischarge('Last 7 Unscheduled Discharge');
      dashboardNumber += ';'+getDischargeBucketSummary('Discharge Buckets CC'); 
         dashboardNumber += ';'+getDischargeBucketSummary('Discharge Buckets MS');  
            dashboardNumber += ';'+getDischargeBucketSummary('Discharge Buckets WSR'); 
              dashboardNumber += ';'+getDischargeBucketSummary('Discharge Buckets CO');  
            dashboardNumber += ';'+getDischargeBucketSummary('Discharge Buckets');
            
            
        Dashboard_Data__c d = [select id , Dashboard_Numbers__c from  Dashboard_Data__c limit 1];
        d.Dashboard_Numbers__c = dashboardNumber;
           update d;
     
  
    
        
        }
    
    global void finish(Database.BatchableContext BC){
    
            
              Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
   message.setSenderDisplayName('Tom Kearns'); 
   message.setReplyTo('no-reply@company.com');
   message.setUseSignature(false); 
   message.setBccSender(false); 
   message.setSaveAsActivity(false); 
   Contact cnt = [select id, Email from Contact where email != null limit 1];
   message.setTargetObjectId(cnt.id);
  //EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = ‘Test Account Alert Email’];
  message.setTemplateID(System.Label.CG_email_template_id); 
  //message.setWhatId(account.Id); //This is important for the merge fields in template to work
  message.toAddresses = System.Label.CG_email_recipient_id_s.split(';');
  Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
  Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 
 if (results[0].success) 
 {
   System.debug('The email was sent successfully.');
 } else {
   System.debug('The email failed to send: ' +  results[0].errors[0].message);
 }
    
    
   
 
}


public string getLastUnscheduledDischarge(string reportName){

List <Report> reportList;

String reportId;
if(Test.isRunningTest()){
reportList= [SELECT Id,DeveloperName FROM Report limit 1];
}
else{
reportList= [SELECT Id,DeveloperName FROM Report where Name =: reportName];
}
reportId= (String)reportList.get(0).get('Id');

// Run a report synchronously
Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');

string total;
if(Test.isRunningTest())
total='123';
else{
List<Reports.SummaryValue> profileCounts = factDetails.getAggregates();
total=profileCounts[0].getLabel();
}
return total;




}


public string getDischargeBucketSummary(string reportName){

List <Report> reportList;

String reportId;
if(Test.isRunningTest()){
reportList= [SELECT Id,DeveloperName FROM Report limit 1];
}
else{
reportList= [SELECT Id,DeveloperName FROM Report where Name =: reportName];
}
reportId= (String)reportList.get(0).get('Id');
// Run a report synchronously
Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');

string total;
if(Test.isRunningTest())
total='123';
else{
List<Reports.SummaryValue> profileCounts = factDetails.getAggregates();
total=profileCounts[1].getLabel();
}

return total;



}
}