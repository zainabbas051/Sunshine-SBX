//Test Class : ContractDetailPageCtrlTest
public class ContractDetailPageCtrl {
    
    public string RecordType { get; set; }
    public Boolean IsEdit { get; set; }
    public string ID { get; set; }
    public Incident_Report__c contract {get;set;}
    public Client_Chart__c ClientChart_Record { get;set; }
    public string ContractId { get;set; }
    
    public User UserObj { get; set; }
    
    //hidden field
    public string SelectedSignedOption { get; set; }
    public string ImageUrlAddress { get; set; }
    
    //AWS
    public string accessKeyId { get; set; }
    public string secretAccessKey { get; set; }
    public string OrgName { get; set; }
     public List<string> AttachmentFileName {get;set;}
    final string AWSURL;
    
    public boolean buttonAccessType{
        
        get {
            
            User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
            if(!string.isNotBlank(u.Acess_Type__c))
                return false;
            
            TabViews__c visibleTab = TabViews__c.getValues('Assessments');
            
            if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
            return false;
        }
        set;
    }
    
    public ContractDetailPageCtrl(){
        
        IsEdit = false;
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        ID = ApexPages.CurrentPage().getParameters().get('ID');
        ContractId = ApexPages.CurrentPage().getParameters().get('cid');
        
        List<Incident_Report__c> contractList = [Select Id, Name, Status__c, SignedBy__c, Contract_Comments__c, 
                                                 Staff_Image_URL__c, Staff_Signed_User__c, Staff_Closed_Date__c, 
                                                 Client_Image_Url__c, Client_Signed_User__c, Client_Closed_Date__c,
                                                 Intern_Signature_URL__c, Intern_Signed_User__c, Intern_Closed_Date__c,
                                                 RecordType.Name, RecordType.DeveloperName ,RecordTypeId,
                                                 FRA_Acute_Intoxication__c, FRA_Acute_Pain__c, FRA_Elimination__c, 
                                                 FRA_Comments__c, FRA_Comments_Desc__c, FRA_If_Prior_Fall__c, FRA_Impaired_Hearing__c,
                                                 FRA_Impaired_Vision__c, FRA_Inability_to_Follow_Instruction__c, 
                                                 FRA_Language_Difficulty__c, FRA_Medical__c, FRA_Medication__c,
                                                 FRA_Mentation__c, FRA_Mobility__c, FRA_Negative_Change__c, FRA_Nursing_Assessment__c,
                                                 FRA_Precautions_Taken__c, FRA_Precautions_Taken_Other__c, FRA_Prior_Fall_Date__c,
                                                 FRA_Prior_Fall_History__c, FRA_Risk_Score_Assessment__c, Staff_Involved__c,
                                                 Date_Time__c, Medication_Error__c, Other_Incident__c, Describe_the_event_in_detail__c,
                                                 Adverse_Reaction__c, Describe_Adverse_Reaction__c, Corrective_Action_Taken__c,
                                                 Reported_to_Physician_Date_Time__c, Reported_to_Supervisor_Date_Time__c ,Attachment1_Id_URl__c, Attachment2_Id_URl__c,
                                                 Attachment3_Id_URl__c, Attachment4_Id_URl__c, Attachment5_Id_URl__c, Attachment6_Id_URl__c, 
                                                 Attachment7_Id_URl__c, Attachment8_Id_URl__c, Attachment9_Id_URl__c, Attachment10_Id_URl__c,Attachment_DateTime__c,Title_of_Attachment__c,Attachment_Note__c
                                                 from Incident_Report__c where Id=:ContractId Limit 1];
        

        if(contractList.size() > 0)
        {
            contract =  contractList[0];
            
            List<UtlizationReviewOrder__c> uroList = [Select Id,Name,Incident_Report__c,Client_Chart__c from UtlizationReviewOrder__c where Incident_Report__c =: contractId and Client_Chart__c =: ID];
            if(uroList.size() >0)
            {
                ClientChart_Record = [Select Id,Name,Treatment_Center__c, Treatment_Center__r.Name from Client_Chart__c where Id =: ID];
            }
            RecordType = contract.RecordType.Name;
        }
        UserObj = [Select Name ,title, User_Role__c from User where ID =: UserInfo.getUserID() limit 1];
        
        IsEdit = (ApexPages.CurrentPage().getParameters().get('edit') != null) ? true : false;
          if(contract.RecordTypeId == Constants.IR_MedicationIncidentAttachmentRecordTypeId){
            
            AttachmentFileName = new List<string>();
            CreateAttachmentFileName();
        }
    }
    
    
    public void changeStatus(){
        
        if(contract != null && contract.Status__c == 'Open'){
            contract.Status__c = 'In progress';
            contract.SignedBy__c = 'None';
          
            if(contract.RecordTypeId == Constants.IR_MedicationIncidentReportRecordTypeId|| contract.RecordTypeId == Constants.IR_MedicationIncidentAttachmentRecordTypeId)
                contract.SignedBy__c = 'Client';
            
            update contract;
        }
    }
    
    public PageReference CloseContractForm(){
        
        //update AssementForm with the user signature    
         if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == NULL) {

                contract.Staff_Image_URL__c = AWSURL + ImageUrlAddress;
                contract.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                contract.Staff_Closed_Date__c = DateTime.Now();
                contract.SignedBy__c = 'Staff';
            } else if (SelectedSignedOption == 'Patient') {

                contract.Client_Image_Url__c = AWSURL + ImageUrlAddress;
                contract.Client_Signed_User__c = '(Patient) ' + ClientChart_Record.Name;
                contract.Client_Closed_Date__c = DateTime.Now();
                contract.SignedBy__c = 'Client';
            } 
            else if (userObj.User_Role__c != NULL) {

                contract.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
                contract.Intern_Signed_User__c = 'Intern present: ' + userObj.Name + ',' + userObj.Title;
                contract.Intern_Closed_Date__c = DateTime.Now();
                contract.SignedBy__c = 'Client';
                contract.Status__c = 'Review Pending';
            }
            
            if((contract.RecordTypeId == Constants.IR_MedicationIncidentReportRecordTypeId|| contract.RecordTypeId == Constants.IR_MedicationIncidentAttachmentRecordTypeId) && (contract.Staff_Signed_User__c != null || String.isNotBlank(contract.Staff_Signed_User__c ))){
                
                contract.Status__c = 'Complete';
                contract.SignedBy__c = 'All'; // signing is complete
            }
            else if ((contract.Staff_Signed_User__c != null || String.isNotBlank(contract.Staff_Signed_User__c )) &&
                     (contract.Client_Signed_User__c != null || String.isNotBlank(contract.Client_Signed_User__c ))) {
                contract.Status__c = 'Complete';
                contract.SignedBy__c = 'All'; // signing is complete
            }
        update contract;
        return null;
    }
    
    public pageReference submit() {
       
        string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null?ApexPages.CurrentPage().getParameters().get('rt'):'';
        
        //Using this field to save Body Chart Image.
        
        upsert contract;
        PageReference pr = new PageReference('/apex/ContractDetailPage');
        pr.getParameters().put('ID',ID);
        pr.getParameters().put('CID',contract.ID);
        pr.getParameters().put('rt',rtype);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }
    

    
    public pageReference AddAttachment(){
        string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null?ApexPages.CurrentPage().getParameters().get('rt'):'';
        PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/uploadDocuments_MedIncidentAttachment?id='+contract.ID+'&cid='+ID+'&rt='+rtype);
        return pr;
    } 
  public void editRecord() {
        IsEdit= True;
    }
    
    public void SaveRecord() {
        
        IsEdit = False;
        update contract ;
        
    }
     void CreateAttachmentFileName(){
        
         if(contract.Attachment1_Id_URl__c!= null){
             
            
            AttachmentFileName .add(SubString(contract.Attachment1_Id_URl__c)); 
        }
        
        if(contract.Attachment2_Id_URl__c!= null){
            AttachmentFileName .add(SubString(contract.Attachment2_Id_URl__c)); 
        
        }
        
        
        if(contract.Attachment3_Id_URl__c!= null){
             AttachmentFileName .add(SubString(contract.Attachment3_Id_URl__c)); 
        }
        
        if(contract.Attachment4_Id_URl__c!= null){
             AttachmentFileName .add(SubString(contract.Attachment4_Id_URl__c)); 
        }
        
        if(contract.Attachment5_Id_URl__c!= null){
              AttachmentFileName .add(SubString(contract.Attachment5_Id_URl__c)); 
        }
        
        if(contract.Attachment6_Id_URl__c!= null){
            AttachmentFileName .add(SubString(contract.Attachment6_Id_URl__c));  
        }
        
        if(contract.Attachment7_Id_URl__c!= null){
              AttachmentFileName .add(SubString(contract.Attachment7_Id_URl__c)); 
        }
        
        if(contract.Attachment8_Id_URl__c!= null){
              AttachmentFileName .add(SubString(contract.Attachment8_Id_URl__c)); 
        }
        
        if(contract.Attachment9_Id_URl__c!= null){
             AttachmentFileName .add(SubString(contract.Attachment9_Id_URl__c)); 
        }
        
        if(contract.Attachment10_Id_URl__c!= null){
            AttachmentFileName .add(SubString(contract.Attachment10_Id_URl__c)); 
        }
    }
    string SubString(String aUrl){
        
         integer lastIndexOf =aUrl.lastIndexOf('/');
          
          string subResult = aUrl.substring(lastIndexOf +1);
          subResult = subResult.replace('%',' ');
          return subResult;
    }
}