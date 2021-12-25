//Author : DANISH FAROOQ
//test class : COWS_popupCtrlTest
public class VS_popupCtrl extends RA_Handler{
    
    public string clientChartId {
	    
	    get;
	    set;
	}

	public Recurring_Assessment__c vitalSign {
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
    
    public string ImageUrlAddress {
        
        get;
        set;
    }
     final string AWSURL;
     
     List<Recurring_Assessment__c> listCOnfigRA;
     
     User userObj;
    
    
	public VS_popupCtrl() {

    //	clientChartId = 'a1V1D0000015Gt0UAE';
    	accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
    	vitalSign = new Recurring_Assessment__C();
    }
    
    
    	public void saveVS() {
        
            system.debug('$$$$$$$ '+ clientChartId );
            string recordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();                                               
    		list < Recurring_Assessment__c > lstRACows = [Select ID,Time_Due__c from Recurring_Assessment__c where Client_Chart__c = :clientChartId
    		                                             AND RecordTypeId =: Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId()
    		                                             AND Status__c = 'Open'];
            
            if(!lstRACows.isEmpty())	
    		    vitalSign.ID = lstRACows[0].ID;
    
    		
    		
    		vitalSign.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
            vitalSign.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            vitalSign.Doctor_Signed_Date__c = DateTime.Now();
            vitalSign.Status__c = 'Closed';
    		upsert vitalSign;
    	
            //extend class
            CreateOpenVS(clientChartId,recordTypeId);
            
    		vitalSign = new Recurring_Assessment__C();
	  
	}
    
    

}