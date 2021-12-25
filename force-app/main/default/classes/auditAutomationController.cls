//Test Class :
global without sharing class auditAutomationController{
    
    public auditAutomationController(){
        kiso = new KIPU_Integration_Support_Object__c();        
    }
    
    Public KIPU_Integration_Support_Object__c kiso{
        get{
            if(kiso == null){
                kiso = new KIPU_Integration_Support_Object__c();
                return kiso;
            }else
                return kiso;
        }
        set;
    }
    
    public void callLoginAPI(){
       
       kiso.KIPU_Chart_Audit__c = apexPages.currentPage().getParameters().get('Id');
       insert kiso; 
       
       KIPU_Chart_Audits_Services.LoginRequest(apexPages.currentPage().getParameters().get('Id'), kiso.id);
    }
    
    public pageReference saveKISO(){
       
       if(kiso.KIPU_Passcode__c != null)
           update kiso;
       else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Enter Passcode Received in Your Email or Phone Number Before Clicking on Save!!!'));
           return null;
       }
       PageReference pr = new PageReference('/'+apexPages.currentPage().getParameters().get('Id'));
       return pr;
       
    }
}