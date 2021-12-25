//testclass :COWS_popupCtrlTest
public class CIWA_popupCtrl extends RA_Handler {

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
     
     List<Recurring_Assessment__c> lstRACIWA;
     
     User userObj;
     

  

    public CIWA_popupCtrl() {

    //  clientChartId = 'a1V1D0000015Gt0UAE';
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
          userObj = [select id,name, title from user where id=:UserInfo.getUserID()];
        
    /*  raNew = new Recurring_Assessment__c(Name = 'COWS-' + Crypto.getRandomInteger(), 
                                            RecordTypeId = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('COWS').getRecordTypeId(), 
                                            Client_Chart__c = clientChartId, 
                                            Status__c = 'Open', 
                                            Time_Due__c = DateTime.now());*/
        raNew = new Recurring_Assessment__c();                                    
        vitalSign = new Recurring_Assessment__C();
    }

    public void saveRA() {
        
        system.debug('$$$$$$$ '+ clientChartId );
        list < Recurring_Assessment__c > lstRACIWA = [Select ID,Time_Due__c from Recurring_Assessment__c where Client_Chart__c = :clientChartId
                                                     AND RecordTypeId =: Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('CIWA').getRecordTypeId()
                                                     AND Status__c = 'Open'];
        
        
        raNew.ID = lstRACIWA[0].ID;

        SaveVS(lstRACIWA[0]);
        
        if (vitalSign.Id != NULL) {
            raNew.Related_To__c = vitalSign.Id;
        
        }
        
     
        raNew.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
        raNew.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
        raNew.Doctor_Signed_Date__c = DateTime.Now();
        raNew.Status__c = 'Closed';
        update raNew;
        
         system.debug('$$$$$$$ '+ raNew.ID );
        
        
        CreateOpenCIWA(clientChartId);
        
            raNew = new Recurring_Assessment__c();                                    
        vitalSign = new Recurring_Assessment__C();
      
    }

    	void SaveVS(Recurring_Assessment__c aCIWA) {

     
        string vitalSignID = Schema.SObjectType.Recurring_Assessment__C.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
 
            
            
           List < Recurring_Assessment__c > lstExistingVital = [Select ID from Recurring_Assessment__C where RecordTypeId = :vitalSignID  and Status__c = 'Open'
                                                                and Client_Chart__c = :clientChartId];

            if (!lstExistingVital.isEmpty()) vitalSign.ID = lstExistingVital[0].ID;
            
            vitalSign.Status__c = 'Closed';
            vitalSign.Name = 'VS-' + Crypto.getRandomInteger();
            vitalSign.Time_Due__c = aCIWA.Time_Due__c;
            vitalSign.RecordTypeId = vitalSignID ;
            vitalSign.Client_Chart__c = clientChartId;
            vitalSign.Related_To__c = raNew.ID;
            vitalSign.Doctor_Signature_URL__c = AWSURL + ImageUrlAddress;
            vitalSign.Doctor_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            vitalSign.Doctor_Signed_Date__c = DateTime.Now();
            
            
            
            upsert vitalSign;
            
            CreateOpenVS(clientChartId,vitalSignID);
          
      

    }
}