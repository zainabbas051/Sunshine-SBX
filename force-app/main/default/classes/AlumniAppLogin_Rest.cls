/*
Test Class : AlumniAppLogin_Rest_Test
*/
@RestResource(urlMapping='/Login/*')
global  class AlumniAppLogin_Rest {
    
    @HttpGet
    global static void getLogin(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
         Map<string,string> mapOfRequest = new Map<string,string>();

        try{
        
            if(RestContext.request.params.isEmpty()){
            
               
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }
            
            LoginWrapperRequest loginObj = new LoginWrapperRequest(RestContext.request.params.get('email'),
                                                                    RestContext.request.params.get('password'),
                                                                    RestContext.request.params.get('device_token'));

            List<Alumni_App_Detail__c> lstAppDetail = AlumniAppDetail_Selector.getAppDetailByEmail(loginObj.email,loginObj.password);
            if(lstAppDetail.isEmpty()){
                mapOfRequest = new Map<string,string>();
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','No Record Found');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }

            LoginResponseWrapper loginResponseWrapperObj = new LoginResponseWrapper(lstAppDetail[0]);        
            res.responseBody = Blob.valueOf(System.JSON.serialize(loginResponseWrapperObj));
            res.statusCode = 200;
            lstAppDetail[0].Device_Token__c = loginObj.devieToken;
            updateDetails(lstAppDetail[0]);
        }
        catch(Exception ex){
            res.responseBody = Blob.valueOf(ex.getMessage() + ' ' + ex.getLineNumber());
            res.statusCode = 500;
        }
    }
    
    private static void updateDetails(Alumni_App_Detail__c appDetailObj){
        
        appDetailObj.First_Login__c = false;
        update appDetailObj;
    }
    public class LoginWrapperRequest{
        public String email;
        public String password;
        public String devieToken;

        public LoginWrapperRequest(string aEmail,string aPassword,
                                    string aDeviceToken){
            email = aEmail;
            password = aPassword;
            devieToken = aDeviceToken;
        }
    }
    public class LoginResponseWrapper{
        public boolean first_login {get;set;}
        public boolean success {get;set;}
        public decimal days_sober {get;set;} 
        public string app_detail_Id {get;set;}
        public boolean isEditable {get;set;}

        public LoginResponseWrapper(Alumni_App_Detail__c appDetailObj){
        
            first_login = appDetailObj.First_Login__c;
            success = true;
            days_sober = appDetailObj.Number_of_Days_Sober__c;
            app_detail_Id = appDetailObj.Id;
            isEditable = !appDetailObj.Alumni_App_Sobriety_Checkins__r.isEmpty();
            
        }
    }
}