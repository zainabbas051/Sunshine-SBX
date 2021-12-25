//Test Class : txdc_PersonalItemsReturned_CtrlTest
public class txdc_PersonalItemsReturned_Ctrl{

     public Tx_and_D_C_Plans__c txdcObj {get;set;}
     public boolean readOnly {get;set;}
     
     //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    final string AWSURL;
    
      public User userObj{
    
        get;
        set;
    }
    
     //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
     
     public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('TxDCPlans');
        
        if( visibleTab.Button_Access_Type__c != null && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }
     
     
     public txdc_PersonalItemsReturned_Ctrl(){
     
         string ID =  ApexPages.CurrentPage().getParameters().get('TXDX');
         string flag =  ApexPages.CurrentPage().getParameters().get('readOnly');
         
            accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
         userObj = [Select id, name, title, User_Role__c from user where id =: userinfo.getUserID()];
         
         readOnly = false;
         if(flag != null)
            readOnly = true;
         
         txdcObj  = [Select ID, chkPersonalItem1__c,chkPersonalItem2__c,Client_Chart__r.Name,Status__c ,
                     chkPersonalItem3__c,chkPersonalItem4__c, chkPersonalItem5__c, chkPersonalItem6__c,CreatedDate,
                     Client_Image_Url__c  ,
                    Staff_Signature_URL__c ,Staff_Signed_User__c,SignedBy__c ,Client_Signed_User__c,
                    Client_Closed_Date__c,Staff_Closed_Date__c,RecordType.DeveloperName,
                    Client_Image_Url_Closed__c,Client_Signed_User_Closed__c,Staff_Signed_User_Closed__c,
                    Staff_Signature_URL_Closed__c,
                     Client_chart__c, Client_Chart__r.Treatment_Center__r.Name from Tx_and_D_C_Plans__c  where ID =:ID ];
     
     }
     
     public void Submit(){
         
         upsert txdcObj;
         readOnly = false;
         
     }
     
       public void SaveSignature(){
         
           if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null) {


                txdcObj.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
                txdcObj.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                txdcObj.Staff_Closed_Date__c = DateTime.Now();
                txdcObj.SignedBy__c = 'Staff';
        } else if (SelectedSignedOption == 'Patient') {

            txdcObj.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
            txdcObj.Client_Signed_User_Closed__c = '(Patient) ' + txdcObj.Client_Chart__r.Name;
            txdcObj.Client_Closed_Date__c = DateTime.Now();
            txdcObj.SignedBy__c = 'Client';
        } else if (userObj.User_Role__c != null) {

            txdcObj.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            txdcObj.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            txdcObj.Intern_Closed_Date__c = DateTime.Now();
            txdcObj.SignedBy__c = 'Client';
            txdcObj.Status__c = 'Review Pending';
        }
        
         if ((txdcObj.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdcObj.Staff_Signed_User_Closed__c)) && (txdcObj.Client_Signed_User_Closed__c != null || String.isNotBlank(txdcObj.Client_Signed_User_Closed__c))) {
                txdcObj.Status__c = 'Closed';
                txdcObj.SignedBy__c = 'All'; // signing is complete


            }
            
              update txdcObj;
     }
     
     

}