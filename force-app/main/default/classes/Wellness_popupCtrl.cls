//Author : DANISH FAROOQ
//test class : COWS_popupCtrlTest
public class Wellness_popupCtrl extends RA_Handler{

	public string clientChartId {
	    
	    get;
	    set;
	}
	public Recurring_Assessment__c raNew {
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

  

	public Wellness_popupCtrl() {

	//	clientChartId = 'a1V1D0000015Gt0UAE';
		accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
		raNew = new Recurring_Assessment__c();                                    
	
	}

	public void saveWellness() {
        
        system.debug('$$$$$$$ '+ clientChartId );
                                                       
		list < Recurring_Assessment__c > lstRAWS = [Select ID,Time_Due__c from Recurring_Assessment__c where Client_Chart__c = :clientChartId
		                                             AND RecordTypeId =: Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Wellness Check').getRecordTypeId()
		                                             AND Status__c = 'Open'];
        
        if(!lstRAWS.isEmpty())	
		    raNew.ID = lstRAWS[0].ID;

		
		
		raNew.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        raNew.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        raNew.Doctor_Signed_Date__c = DateTime.Now();
        raNew.Status__c = 'Closed';
		upsert raNew;
		
		system.debug('$$$$$$$ '+ raNew.ID );
		
        //extend class
        CreateOpenWellNess(clientChartId);
        
        raNew = new Recurring_Assessment__c();                                    
	
	  
	}

	
	
}