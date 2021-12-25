/*
    controller class for PHILogDetailPage
    @author: Danish Farooq
    @Test class : PHILogDetailCtrlTest
*/
public class PHILogDetailCtrl{
    
    public PHI_Log__c phiLog{get;set;}
    public Client_Chart__c cc{get;set;}
    public boolean EditPage{get;set;}
    public string ImageUrlAddress{get;set;}
    public string SelectedSignedOption{get;set;}
    public string RecordType {get;set;}
    public boolean IsOpen {get; set;}
     //AWS Constant
    
    public final string accessKeyId {get;set;}
    public final string secretAccessKey {get;set;}
    public final string OrgName {get;set;}
    final string AWSURL;
    User u;
    
    final string PHIENTRY_RECORDTYPE = 'PHI Entry';
    final string PHIAUTH_RECORDTYPE = 'Authorization for Release of Confidential Information';
    public boolean displayPopUp{get;set;}
    
    public List<string> AttachmentFileName {get;set;}
    
    id ccId;
    
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('PHILog');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public PHILogDetailCtrl(){
        
        accessKeyId  = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey ;
        
        u =  [Select Name ,title,User_Role__c from User where ID =: UserInfo.getUserID() limit 1];
        
        EditPage =    (ApexPages.CurrentPage().getParameters().get('edit') != null)? true : false;
        cc = [select id, Treatment_Center__c, Treatment_Center__r.Name, Name, SSN__c from Client_Chart__c 
        where id=: ApexPages.CurrentPage().getParameters().get('id')];
        
        ID logID = ApexPages.CurrentPage().getParameters().get('PHIID');
        
         phiLog = [select id ,contact__r.Address__c, Contact__r.Phone, Contact__r.OtherPhone,Contact__r.Type__c,Contact__r.Relationship__c , 
                Client_Chart__c, Contact__r.Email, event_condition__c,contact__r.Name,Other__c,Contact__c,
                Name_of_Person_Agency__c,  Reason_for_Request__c,Client_Chart__r.Client_Status__c,
                Relationship_to_Patient__c, Telephone_Calls_info_to_released__c, Biopsychosocial_Assessment__c,
                Cooperation__c, Discharge_Summary__c, Intake_Evaluation__c, Laboratory_Report__c, Letters_if_available__c,
                Medical_History__c, Motivation__c, Other_checkbox__c, Presence_in_Treatment__c, Prognosis__c, Progress__c,
                Progress_Notes__c, Psychiatric_Evaluation__c, Return_to_Work__c, Staff_Conference_Treatment_Plans_Revie__c,
                Telephone_Calls__c, Treatment_Dates__c,Client_Image_Url__c ,Client_Signed_User__c,Client_Closed_Date__c,
                Staff_Image_Url__c ,Signed_User__c ,Staff_Closed_Date__c ,Status__c ,Old_PHI_Log_ID__c,SignedBy__c,RecordType.Name,
               Client_Chart__r.Treatment_Center__r.Name,Client_Chart__r.Name,Date_Disclosure__c,Date_Requested__c,
               Request_Type__c,Disclose_to_full_name__c,Address_if_known__c,Description_of_disclosure__c,
               Purpose_of_disclosure__c,Disclosed_by__c ,Contact__r.MailingStreet ,Contact__r.MailingPostalCode ,
               Contact__r.MailingCountry,Contact__r.MailingCity, Contact__r.MailingState , Contact__r.Fax,CreatedBy.Name, Active_Date__c,Expiration_Date__c,
               Attachment1_Id_URl__c,  Attachment2_Id_URl__c,  Attachment3_Id_URl__c,
                 Attachment4_Id_URl__c,  Attachment5_Id_URl__c,  Attachment6_Id_URl__c,  Attachment7_Id_URl__c,
                   Attachment8_Id_URl__c,  Attachment9_Id_URl__c,  Attachment10_Id_URl__c,Attachment_Date_Time__c 
                 from PHI_Log__c  where id=: logID];
                 
        RecordType = phiLog.RecordType.Name;
        
        if(RecordType == PHIENTRY_RECORDTYPE || (phiLog.Client_Chart__r.Client_Status__c == 'Discharged' && RecordType == PHIAUTH_RECORDTYPE)){
            
            phiLog.SignedBy__c = 'Client';
        }
        else if(phiLog.SignedBy__c == null)
            phiLog.SignedBy__c = 'None';
       
       if(RecordType == PHIAUTH_RECORDTYPE &&  phiLog.Client_Chart__r.Client_Status__c == 'Discharged'){
            
            AttachmentFileName = new List<string>();
            CreateAttachmentFileName();
        }
        
        
        activeLogsFromContact();
        
    }
    
    public PageReference Cloning(){
        
        string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        
        PHI_Log__c cloneLog = phiLog;
        cloneLog.Status__c  = 'Open';
        cloneLog.SignedBy__c = 'none';
        cloneLog.Old_PHI_Log_ID__c = phiLog.ID;
        cloneLog.ID = null;
        cloneLog.Client_Closed_Date__c = null;
        cloneLog.Client_Image_Url__c = null;
        cloneLog.Client_Signed_User__c = null;
        cloneLog.Staff_Closed_Date__c = null;
        cloneLog.Staff_Image_Url__c = null;
        cloneLog.Signed_User__c = null;
        insert cloneLog ;
        
        PageReference pr = new PageReference('/apex/PHILogDetail');
         pr.getParameters().put('ID',cc.ID);
         pr.getParameters().put('PHIID',cloneLog.ID );
         pr.getParameters().put('rt',rtype );
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
    }
    
    public void InActive(){
        
        phiLog.Status__c = 'In Active';
        phiLog.In_Active_Date__c= Date.Today();
        update phiLog;  
        
        Contact con = new Contact();
        con.ID = phiLog.Contact__c;
        con.Status__c = 'PHI Unauthorized';
        update con;
        
        
        
    }
    
    // check any Phi log is open against this contact
    void activeLogsFromContact(){
        
          
         List<Phi_Log__c> lstPhLog = [Select ID from PHI_Log__c where Status__c = 'Open' and Contact__c =: phiLog.contact__c
                                      AND RecordTypeId =: Constants.PhiLogAuthRecordTypeId];
          
          if(lstPhLog.size() >= 1)  
              IsOpen = false;
          else
              IsOpen = true;
    }
    
    public PageReference submit(){
        
        upsert phiLog;
        
        //update contact as well
        Contact con = new Contact();
        con = phiLog.contact__r;
        upsert con;
        
        string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null? ApexPages.CurrentPage().getParameters().get('rt'):'';
        
        PageReference pr = new PageReference('/apex/PHILogDetail');
         pr.getParameters().put('ID',cc.ID);
         pr.getParameters().put('PHIID',phiLog.ID );
         pr.getParameters().put('rt',rtype );
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
      
    }
    
    public PageReference ActivePHILog(){
        string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null? ApexPages.CurrentPage().getParameters().get('rt'):'';
       
        if(SelectedSignedOption == 'Staff'){
            
             phiLog.Staff_Image_Url__c= AWSURL  + ImageUrlAddress;
             phiLog.Signed_User__c = 'Staff present: ' + u.Name+',' +u.Title;
             phiLog.Staff_Closed_Date__c = DateTime.Now();
             phiLog.SignedBy__c  = 'Staff';
        }
        else if(SelectedSignedOption == 'Patient'){
            
             phiLog.Client_Image_Url__c = AWSURL  + ImageUrlAddress ;
             phiLog .Client_Signed_User__c = '(Patient) ' + phiLog .Client_Chart__r.Name;
             phiLog.Client_Closed_Date__c = DateTime.Now();
             phiLog.SignedBy__c  = 'Client';
        }
      
      if(RecordType == PHIENTRY_RECORDTYPE){
          
          if(phiLog.Signed_User__c != null || String.isNotBlank(phiLog.Signed_User__c )){
               phiLog.Status__c  = 'Closed';
               phiLog.SignedBy__c  = 'All';
          }
      }
      if(phiLog.Client_Chart__r.Client_Status__c == 'Discharged' && RecordType == PHIAUTH_RECORDTYPE){
          
          if(phiLog.Signed_User__c != null || String.isNotBlank(phiLog.Signed_User__c )){
               phiLog.Status__c  = 'Active';
               phiLog.SignedBy__c  = 'All';
          }
      }
      
      else if((phiLog.Signed_User__c != null || String.isNotBlank(phiLog.Signed_User__c )) && (phiLog .Client_Signed_User__c != null || String.isNotBlank(phiLog .Client_Signed_User__c))){
              phiLog.Status__c  = 'Active';
               phiLog.SignedBy__c  = 'All';
               phiLog.Active_Date__c = Date.Today();
            
        }
        
           update phiLog;
           
          if((phiLog.status__c == 'Active' || phiLog.status__c == 'Closed' )){//closed for log entry , active for authorization
            //change status of contact as well
            Contact con = new Contact();
            con.ID = phiLog.Contact__c;
            con.Status__c = 'PHI Authorized';
            update con;
            
            if(phiLog.Old_PHI_Log_ID__c != null){
                PHI_Log__c existingLog = new PHI_Log__c();
                existingLog.Status__c  = 'In Active';
                existingLog.In_Active_Date__c= Date.Today();
                existingLog.ID = phiLog.Old_PHI_Log_ID__c;
                update  existingLog ;
            }
            PageReference pr = new PageReference('/apex/PHILogHomePage');
            pr.getParameters().put('ID',cc.ID);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
        }
           
         PageReference pr = new PageReference('/apex/PHILogDetail');
         pr.getParameters().put('ID',cc.ID);
         pr.getParameters().put('PHIID',phiLog.ID );
         pr.getParameters().put('rt',rtype);
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
        
    }
    
    void CreateAttachmentFileName(){
        
         if(phiLog.Attachment1_Id_URl__c!= null){
             
            
            AttachmentFileName .add(SubString(phiLog.Attachment1_Id_URl__c)); 
        }
        
        if(phiLog.Attachment2_Id_URl__c!= null){
            AttachmentFileName .add(SubString(phiLog.Attachment2_Id_URl__c)); 
        
        }
        
        
        if(phiLog.Attachment3_Id_URl__c!= null){
             AttachmentFileName .add(SubString(phiLog.Attachment3_Id_URl__c)); 
        }
        
        if(phiLog.Attachment4_Id_URl__c!= null){
             AttachmentFileName .add(SubString(phiLog.Attachment4_Id_URl__c)); 
        }
        
        if(phiLog.Attachment5_Id_URl__c!= null){
              AttachmentFileName .add(SubString(phiLog.Attachment5_Id_URl__c)); 
        }
        
        if(phiLog.Attachment6_Id_URl__c!= null){
            AttachmentFileName .add(SubString(phiLog.Attachment6_Id_URl__c));  
        }
        
        if(phiLog.Attachment7_Id_URl__c!= null){
              AttachmentFileName .add(SubString(phiLog.Attachment7_Id_URl__c)); 
        }
        
        if(phiLog.Attachment8_Id_URl__c!= null){
              AttachmentFileName .add(SubString(phiLog.Attachment8_Id_URl__c)); 
        }
        
        if(phiLog.Attachment9_Id_URl__c!= null){
             AttachmentFileName .add(SubString(phiLog.Attachment9_Id_URl__c)); 
        }
        
        if(phiLog.Attachment10_Id_URl__c!= null){
            AttachmentFileName .add(SubString(phiLog.Attachment10_Id_URl__c)); 
        }
    }
    
   string SubString(String aUrl){
        
         integer lastIndexOf =aUrl.lastIndexOf('/');
          
          string subResult = aUrl.substring(lastIndexOf +1);
          subResult = subResult.replace('%',' ');
          return subResult;
    }
    
   public pageReference AddAttachment(){
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_PHIAttachments?id='+phiLog.ID);
        return pr;
    } 
 
    
    

}