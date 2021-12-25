public  class SendEmailConfirmation_PdfCtrl {

   public string ppName{get;set;}
   public string referenceId {get;set;}
   public Payment_Plan_Line_Items__c pp {get;set;}
    string recordId;
   
    public void showRecord(){
    
       
        if(Test.isRunningTest()){
             ID pplid=[select id from Payment_Plan_Line_Items__c limit 1][0].id;
             recordId=String.ValueOf(pplid);
            }
         recordId = ApexPages.currentPage().getParameters().get('Id') ;
          
           pp = [select id,Status__c,Collection_Reference_ID__c,Date_of_Cash_Collection__c,Sunshine_Center__c,
                                          Email_Address_of_Person_Responsible__c,Name,Payment_Plan__r.Name,Amount_For_Collection__c,Closed_Date__c,Payment_Plan__r.Opportunity__r.Name 
                                          from Payment_Plan_Line_Items__c where id=: recordId];
                                          
         
    
    }
    
   
}