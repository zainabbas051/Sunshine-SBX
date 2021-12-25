//testclass :COWS_popupCtrlTest
public class COWS_popupCtrl extends RA_Handler{

	public string clientChartId {
	    
	    get;
	    set;
	}
	public Recurring_Assessment__c raNew {
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

  

	public COWS_popupCtrl() {

	//	clientChartId = 'a1V1D0000015Gt0UAE';
		accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
		raNew = new Recurring_Assessment__c();                                    
		vitalSign = new Recurring_Assessment__C();
	}

	public void saveCOWS() {
        
        system.debug('$$$$$$$ '+ clientChartId );
                                                       
		list < Recurring_Assessment__c > lstRACows = [Select ID,Time_Due__c from Recurring_Assessment__c where Client_Chart__c = :clientChartId
		                                             AND RecordTypeId =: Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('COWS').getRecordTypeId()
		                                             AND Status__c = 'Open'];
	
		raNew.ID = lstRACows[0].ID;

		SaveVS(lstRACows[0]);
		
		if (vitalSign.Id != NULL) {
		    raNew.Related_To__c = vitalSign.Id;
		
		}
		
		raNew.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        raNew.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        raNew.Doctor_Signed_Date__c = DateTime.Now();
        raNew.Status__c = 'Closed';
		upsert raNew;
		
		system.debug('$$$$$$$ '+ raNew.ID );
		
        //extend class
        CreateOpenCOWS(clientChartId);
        
        raNew = new Recurring_Assessment__c();                                    
		vitalSign = new Recurring_Assessment__C();
	  
	}

	void SaveVS(Recurring_Assessment__c aCOWS) {

		
		    string vitalSignID = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
		    
			List < Recurring_Assessment__c > lstExistingVital = [Select ID from Recurring_Assessment__C 
			                                                    where RecordTypeId =: vitalSignID
			                                                    and Status__c = 'Open'
			                                                    and Client_Chart__c = :clientChartId];

			if (!lstExistingVital.isEmpty()) vitalSign.ID = lstExistingVital[0].ID;
            
            vitalSign.Status__c = 'Closed';
            vitalSign.Name = 'VS-' + Crypto.getRandomInteger();
            vitalSign.Time_Due__c = aCOWS.Time_Due__c;
            vitalSign.RecordTypeId = vitalSignID;
            vitalSign.Client_Chart__c = clientChartId;
            vitalSign.Related_To__c = raNew.ID;
            vitalSign.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
            vitalSign.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            vitalSign.Doctor_Signed_Date__c = DateTime.Now();
		    upsert vitalSign;
		    
		    CreateOpenVS(clientChartId,vitalSignID);
		    
		  
            
		}
		
		
	
}