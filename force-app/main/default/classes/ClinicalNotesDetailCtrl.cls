/*
Test Class : ClinicalNotesDetailCtrlTest
*/
public class ClinicalNotesDetailCtrl{
    
    public Clinical_Note__c ClinicalNotes { get;set;}
    public string RecordType { get ;set;}
    public string ClientChartID {get;set;}
    public string rtype {get; set;}
    public boolean EditPage{get;set;}
        public String Client_imageURL {
        get;
        set;

    }

    public String Staff_imageURL {
        get;
        set;

    }
    //hidden field
    public string SelectedSignedOption{get; set;}
    public string ImageUrlAddress{get; set;}
    
      //AWS
    public string accessKeyId  {get ;set;}
    public string secretAccessKey {get; set;}
    public string OrgName {get; set;}
    final string AWSURL;
    string ID ;
    
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(string.isBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ClinicalNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
    
    public ClinicalNotesDetailCtrl(){
        
          accessKeyId  = Constants.accessKeyId;
          OrgName = Constants.OrgName;
          AWSURL = 'http://freepu.s3.amazonaws.com/';
          secretAccessKey = Constants.secretAccessKey ;
          EditPage =    (ApexPages.CurrentPage().getParameters().get('edit') != null)? true : false;
         rtype = ApexPages.CurrentPage().getParameters().get('rt') != null? ApexPages.CurrentPage().getParameters().get('rt'):'';
         ID = ApexPages.currentPage().getParameters().get('clNID');
         ClientChartID  = ApexPages.currentPage().getParameters().get('ID');
         ClinicalNotes = [Select ID,Date__c,End_Time__c,Start_Time__c,Status__c,Group_Description__c,Topic__c,
                         RecordType.Name,CreatedBy.Name,Client_Chart__c,SignedBy__c,Duration__c,
                         Client_Chart__r.Name,Signature_URL__c,Staff_Signed_User__c ,Staff_Closed_Date__c , Attendence__c,
                          Client_Image_Url__c ,Client_Signed_User__c ,Client_Closed_Date__c ,Intern_Signature_URL__c ,Intern_Signed_User__c,Intern_Closed_Date__c 
                         ,Client_Chart__r.Treatment_Center__r.Name, Attendant__c,Group_Name__c,Group_Close_Date__c from Clinical_Note__c where ID =: ID limit 1];
         RecordType = ClinicalNotes.RecordType.Name;
         
         
    }
    
    public void getAttachment() {

    //  Staff_imageURL = '/servlet/servlet.FileDownload?file=';
    //  Client_imageURL = '/servlet/servlet.FileDownload?file=';

    
        List < Attachment > documentList = [select id, name from attachment where
        ParentID = :ID limit 2];
        
        system.debug('$$$$$$' + documentList);

        if (!documentList.isEmpty()) {

            for (Attachment attr: documentList) {

                if (attr.Name == 'Staff') Staff_imageURL = '/servlet/servlet.FileDownload?file=' + attr.id;
                else Client_imageURL = '/servlet/servlet.FileDownload?file=' + attr.id;
            }

        }
    }
    
    public void ChangeInProgress(){
        
        if(ClinicalNotes.Status__c == 'Open'){
            
            ClinicalNotes.Status__c = 'In-Progress';
            ClinicalNotes.SignedBy__c = 'Client';
          
        }
        
        update ClinicalNotes;
        
    }
    

        
    public PageReference CloseClinicalNotes(){
        
        //update intake Form with the user signature    
       
        User u =  [Select Name ,title,User_Role__c from User where ID =: UserInfo.getUserID() limit 1];
        
        if(SelectedSignedOption == 'Staff' && u.User_Role__c == NULL){
            
             ClinicalNotes.Signature_URL__c= AWSURL  + ImageUrlAddress;
             ClinicalNotes.Staff_Signed_User__c = 'Staff present: ' + u.Name+',' +u.Title;
             ClinicalNotes.Staff_Closed_Date__c = DateTime.Now();
             ClinicalNotes.SignedBy__c  = 'Staff';
        }
      
          else if(u.User_Role__c != NULL){
            
             ClinicalNotes.Intern_Signature_URL__c = AWSURL  + ImageUrlAddress ;
             ClinicalNotes.Intern_Signed_User__c = u.User_Role__c+' present: ' +  u.Name+',' +u.Title;
             ClinicalNotes.Intern_Closed_Date__c = DateTime.Now();
             ClinicalNotes.SignedBy__c  = 'Client';
        }
        
      
     
    
      if((ClinicalNotes.Staff_Signed_User__c != null || String.isNotBlank(ClinicalNotes .Staff_Signed_User__c ))){
              ClinicalNotes.Status__c  = 'Closed';
               ClinicalNotes.SignedBy__c  = 'All';
            
        }
        
           update ClinicalNotes;
        
        if(ClinicalNotes.status__c == 'Closed'){
        
            PageReference pr = new PageReference('/apex/ClinicalNotesHomePage');
            pr.getParameters().put('ID',ClientChartID);
            pr.getParameters().put('rt',rtype);
            pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
            return pr;
        }
        
         PageReference pr = new PageReference('/apex/ClinicalNotesDetail');
         pr.getParameters().put('ID',ClientChartID);
         pr.getParameters().put('clNID',ID );
         pr.getParameters().put('rt',rtype);
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
            
    }
}