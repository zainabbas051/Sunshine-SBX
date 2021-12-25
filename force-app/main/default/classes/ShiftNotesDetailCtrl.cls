/*
    controller class for shift notes Detail page
    author Huma Zafar
    Test CLass : ShiftNotesDetailCtrlTest
*/
public class ShiftNotesDetailCtrl{
    
    public list<Incident_Report__c> lstShiftNotes{get;set;}
    
    public boolean readMode{get;set;}
    
    public DateTime createdDate{get;set;}
    public string createdBy{get;set;}
    
    public Incident_Report__c ShiftNote{get;set;}
    
    public list<UtlizationReviewOrder__c> lstCreateShiftNotes{get;set;}
    
    String houseId='';
    public boolean showHouseField{get;set;}
    public boolean buttonAccessType{
        
        get {
                
        User u = [Select ID, UserName,Acess_Type__c FROM User where ID =: UserInfo.getUserId()];
        if(!string.isNotBlank(u.Acess_Type__c))
            return false;
      
        TabViews__c visibleTab = TabViews__c.getValues('ShiftNotes');
        
        if( visibleTab.Button_Access_Type__c != NULL && visibleTab.Button_Access_Type__c.contains(u.Acess_Type__c)) return true;
            
        return false;
        }
        set;
    }

    
    public string ImageUrlAddress {
        get;
        set;
    }
    
    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
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
    
    public ShiftNotesDetailCtrl(){
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        readMode = True;
        
        String rt = ApexPages.CurrentPage().getParameters().get('rt');
        Sunshine_Center_Id__c scid = Sunshine_Center_Id__c.getValues(rt);
        if(scid.House_Based_Selection__c == True)
            showHouseField = True;
        else
            showHouseField = False;
        
        OpenSN();
    }
    
    public void OpenSN(){
        string snid = system.CurrentPageReference().getParameters().get('SNID');
        ShiftNote = [select id, CreatedDate, CreatedById, CreatedBy.Name, Status__c, Staff_Image_Url__c , Staff_Closed_Date__c,
        Staff_Signed_User__c, House__c, House__r.House_Name__c , (select id, Incident_Report__c, Client_Chart__c, Client_Chart__r.Name ,Shift_Notes__c 
        from UtlizationReviewOrders__r) from Incident_Report__c where id=:snid];
        lstCreateShiftNotes = ShiftNote.UtlizationReviewOrders__r;
        
        if(ShiftNote.House__c != null)
            houseId = ShiftNote.House__c;
    }
    public void CloseShiftNote(){
        User userObj = [select id,name, title from user where id=:userinfo.getuserid()];
        
        string snid = system.CurrentPageReference().getParameters().get('SNID');
        system.debug(snid );
        Incident_Report__c IR = new Incident_Report__c();
        IR.id = snid;
        IR.Status__c = 'Closed';
        IR.Staff_Image_URL__c = AWSURL + ImageUrlAddress;
        IR.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        IR.Staff_Closed_Date__c =DateTime.newinstance(DateTime.Now().date(),datetime.now().time());
        IR.SignedBy__c= 'All';    
        update IR;
        
    }
    
    
    public void editSN(){
        readMode = False;
    }
    
    public void SaveShiftNotes(){
        
        list<UtlizationReviewOrder__c> lstsn = new list<UtlizationReviewOrder__c>();
        
        if(houseId == '')
            ShiftNote.House__c = null;
        else
            ShiftNote.House__c = houseId;
        
        for(UtlizationReviewOrder__c sn : lstCreateShiftNotes){
            if(sn.Shift_Notes__c !=null && sn.Shift_Notes__c !=''){
                lstsn.add(sn);
            }
        }
        
        if(lstsn.size()>0)
            upsert lstsn ;
        update ShiftNote;
        
        OpenSN();
        readMode = true;
    }
    
    public List<SelectOption> getHouseItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--NONE--'));
        string rt = ApexPages.CurrentPage().getParameters().get('rt');
        
        for(Bed_Board_Configuration__c bbc : [Select id, House_Name__c from Bed_Board_Configuration__c Where House_Name__c != null AND Sunshine_Center__r.Name=:rt]){
            options.add(new SelectOption(bbc.id,bbc.House_Name__c));
        }
        return options;
    }

    public String gethouseId() {
        return houseId;
    }

    public void sethouseId(String houseId) {
        this.houseId = houseId;
    }

}