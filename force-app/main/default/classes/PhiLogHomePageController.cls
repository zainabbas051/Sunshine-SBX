/*
    controller class for PHILogHomeComponent    
    @author: Huma Zafar
    test class : PhiLogHomePageControllerTest
*/
public with sharing class PhiLogHomePageController {
    
  
    public list<PHI_Log__c> lstLogAuthorization {get;set;}
    public list<PHI_Log__c> lstLogAuth_InActive {get;set;}
    public list<PHI_Log__c> lstLogPHIEntry {get;set;}
    public list<PHI_Log__c> lstEmegencyAuth {get;set;}
    public List<Contact> lstContact {get; set;}
    public List<Contact> lstContact_Auth {get;set;}
    public string SelectedOption {get;set;}
    public string SelectedRecordType {get;set;}
    Set<Id> existingContactID;
    //CONSTANT
    final string AUTH_REC = 'Authorization for Release of Confidential Information';
    final string PHI_REC = 'PHI Entry';
    
    public boolean displayPopUp{get;set;}
    
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
    
    public PhiLogHomePageController(){
        
        ccId = ApexPages.CurrentPage().getParameters().get('id');
        
        loadLogs();
        GetUnauthorizedContact();
     
    }
    
    void GetUnauthorizedContact(){
        
        lstContact = new List<Contact>();
        lstContact_Auth= new List<Contact>();
        lstContact = [Select ID, Status__c ,Name from Contact where Client_Chart__c =: ccId
                    and RecordType.Name = 'Client Chart Contact' and ID not IN :existingContactID ];
        
        lstContact_Auth = [Select ID, Status__c ,Name from Contact where Client_Chart__c =: ccId
                    and RecordType.Name = 'Client Chart Contact' and Status__c = 'PHI Authorized'];
         
        
    }
    
    public PageReference RedirectSamePage(){
        
         string rtype = ApexPages.CurrentPage().getParameters().get('rt')!=null? ApexPages.CurrentPage().getParameters().get('rt'):'';
         PageReference pr = new PageReference('/apex/PHILogHomePage');
         pr.getParameters().put('ID',ccId);
         pr.getParameters().put('rt',rtype);
         pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
         return pr;
    
    
    }
    
    
    void loadLogs(){
        
        existingContactID = new Set<Id>();
        lstLogAuthorization = new List<PHI_Log__c>();
        lstLogPHIEntry = new List<PHI_Log__c>();
        lstLogAuth_InActive = new List<PHI_Log__c>();
        for(PHI_Log__c pLog : [select id, RecordType.Name,Date_Disclosure__c,Client_Chart__r.Name,Contact__r.Name,Request_Type__c,
                                CreatedBy.Name,Active_Date__c,Expiration_Date__c,In_Active_Date__c,Signed_User__c ,
                                Contact__r.Status__c, Status__c,Client_Chart__c from PHI_Log__c 
                               where Client_Chart__c =:ccId  order by ID desc]){
            //show open and Active PHI log                                                                
            if(pLog.RecordType.Name == AUTH_REC && (pLog.Status__c == 'Active' || pLog.Status__c == 'Open')){
                
                lstLogAuthorization.add(pLog);
                existingContactID.add(pLog.Contact__c);
            }
                
            //show record type PHI Entry    
            else if(pLog.RecordType.Name == PHI_REC )
                lstLogPHIEntry.add(pLog);
            
            else if(pLog.RecordType.Name == AUTH_REC && pLog.Status__c == 'In Active')
                lstLogAuth_InActive.add(pLog);
            
        }
    }
    //apex action function
    public void SaveNewLogs(){
        
        ID AuthRecTypeID =  Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get(AUTH_REC).getRecordTypeId();
        ID PhiRecTypeID = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get(PHI_REC).getRecordTypeId();
        PHI_Log__c newPhiLog;
        List<PHI_Log__c> lstPhLog = new List<PHI_Log__c>();
        SelectedOption = SelectedOption.subString(0,SelectedOption.length() - 1);
        List<ID> ContactsID = SelectedOption.split(',');
        Map<ID,PHI_Log__c> mapOFAuth_Con = new Map<ID,PHI_Log__c>();
        for(PHI_Log__c pLog : [Select ID,Contact__c,Client_Chart__c,
                                Biopsychosocial_Assessment__c,Letters_if_available__c,
                                Psychiatric_Evaluation__c,Presence_in_Treatment__c,
                                Laboratory_Report__c,Treatment_Dates__c,
                                Progress_Notes__c,Progress__c,
                                Medical_History__c,Cooperation__c,
                                Staff_Conference_Treatment_Plans_Revie__c,
                                Motivation__c,Intake_Evaluation__c,
                                Return_to_Work__c,Discharge_Summary__c,Prognosis__c,
                                Telephone_Calls__c,Telephone_Calls_info_to_released__c,
                                Other_checkbox__c,
                                Other__c from PHI_Log__c where Contact__c in: ContactsID AND RecordTypeID =: AuthRecTypeID and status__c = 'Active'])
            mapOFAuth_Con.put(pLog.Contact__c,pLog);
            
        for(string iContactID : ContactsID ){
            
            newPhiLog = new PHI_Log__c();
            
            if(SelectedRecordType == AUTH_REC)
                newPhiLog.RecordTypeID = AuthRecTypeID; 
            else{
                
                if(mapOFAuth_Con.containsKey(iContactID ))
                   newPhiLog = mapOFAuth_Con.get(iContactID);
                    newPhiLog.PHI_Log_Auth__c = mapOFAuth_Con.get(iContactID).ID;
                    
                    newPhiLog.RecordTypeID = PhiRecTypeID;
                
            }
          
             newPhiLog.ID = NULL;
            newPhiLog.Contact__c = iContactID;
            newPhiLog.status__c = 'Open';
            lstPhLog.add(newPhiLog);
            
        }
        
        if(!lstPhLog.isEmpty()){
            insert lstPhLog;
            loadLogs();
            GetUnauthorizedContact();
        }
            
    }
    
    
    
 
}