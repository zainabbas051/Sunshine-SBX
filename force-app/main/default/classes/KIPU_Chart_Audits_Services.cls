global class KIPU_Chart_Audits_Services{
    
    @Future(callout=true)   
    webservice static void LoginRequest(id auditId, id kisoId){
        
        KIPU_Chart_Audit__c aud = [Select id, Medical_Record_Number__c, Sunshine_Center__c from KIPU_Chart_Audit__c where id =: auditId];
        
        //Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(opp.Sunshine_Center_Name__c);
        
        //KIPU_Integration_Support_Object__c kiso = new KIPU_Integration_Support_Object__c();
        //kiso.KIPU_Chart_Audit__c = aud.id;
        //insert kiso;
        
        
        loginWrapper lw = new loginWrapper();
        //lw.KIPU_Login_URL = 'https://chapterscapistrano.kipuworks.com/users/sign_in';
        lw.KIPU_Login_URL = 'https://monarchshores.kipuworks.com/users/sign_in';
        lw.KIPU_MRN = aud.Medical_Record_Number__c;
        //**Chapters Username and Pass**
        //lw.Username = 'NaveenChugh';
        //lw.Password = 'Chapters123!!';
        //**Monarch Username and Pass**
        lw.Username = 'Meghaku1';
        lw.Password = 'Lion@2020';
        lw.KIPU_Chart_Audit_Id = aud.id;
        lw.Integration_Support_Record_Id = kisoId;
        
        string JSONString = System.JSON.serialize(lw);
        
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('Authorization','5a876cbb9ea16bca47b3973d3c13ac5b');
        req.setHeader('Content-Type','application/json');
        req.setEndpoint('https://kipu-audit-automation.herokuapp.com/audit_login'); 
        req.setBody (JSONString );
        HTTPResponse res = new HTTPResponse();
        if(!Test.isRunningTest()){
            res = http.send(req);
        }
        system.debug('Response ::::'+res);
        system.debug('Response Body ::::'+res.getBody());
        //return null;
        
        
    }
    
    public class loginWrapper{
        
        public string KIPU_Login_URL{get;set;}
        public string KIPU_MRN{get;set;}
        public string Username{get;set;}
        public string Password{get;set;}
        public string KIPU_Chart_Audit_Id{get;set;}
        public string Integration_Support_Record_Id{get;set;}
        
        public loginWrapper(){
        
        }
    }
    
}