@isTest
public  class SendEmailOutreachAccountCtrlTest{

        static testmethod void SendEmailOutreachAccountCtrlTest(){
             test.startTest();
        User u = [Select id from User where isActive =: True AND Profile.Name =: 'System Administrator' LIMIT 1];
        user urpof=[SELECT Id, Name, IsActive, ProfileId FROM User where IsActive=true and Profile.Name =: 'Digital Marketing - Outreach Associate' LIMIT 1];
        system.runAs(u){
            OUTREACH_ACCOUNT__c outReq = new OUTREACH_ACCOUNT__c();
            outReq.Prospect_URL__c = 'www.google.com';
            outReq.Category__c = 'State';
            outReq.Contact_Email_Address__c = 'test@gmail.com';
            outReq.Contact_Phone_Number__c = '5863424795';
            outReq.From_Email_Adresses__c = 'charleswatson013@gmail.com';
            outReq.Sub_Category__c = 'Michigan';
            OutReq.Recipient_Name__c='Zoobeez fatima';
            OutReq.Email_Type__c='Custom';
            outreq.CC_Email__c = 'test@gmail.com';
            insert outReq;
            
            Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=outReq.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
        
        
       // SendEmailOutreachAccountCtrl testIns = new SendEmailOutreachAccountCtrl();
        
        PageReference myVfPage = Page.SendEmailOutreachAccount;
Test.setCurrentPage(myVfPage);

// Put Id into the current page Parameters
ApexPages.currentPage().getParameters().put('id',outReq.Id);

//pexPages.StandardController sc = new ApexPages.StandardController(Opp);
//AssociateECPController ac = new AssociateECPController(sc);

        SendEmailOutreachAccountCtrl testIns = new SendEmailOutreachAccountCtrl();
            testIns.OutreachIns=outReq;
            testIns.attachment=attach;
        testIns.SendEmail();

        
}

}



}