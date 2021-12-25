/*
Test Class : AlumniAppUpdate_RestTest
*/
@RestResource(urlMapping='/GetUser/*')
global  class AlumniAppUpdate_Rest {
    
    @HttpGet
    global static void getLogin(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
         Map<string,string> mapOfRequest = new Map<string,string>();

        try{
        
           
            if( !RestContext.request.headers.containsKey('id')){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }
            
            List<Alumni_App_Detail__c> lstAppDetail = AlumniAppDetail_Selector.getAppDetailById(RestContext.request.headers.get('id'));
            if(lstAppDetail.isEmpty()){
                mapOfRequest = new Map<string,string>();
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','No Record Found');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }

            LoginResponseWrapper loginResponseWrapperObj = new LoginResponseWrapper(
                                                                                    true,
                                                                                    lstAppDetail[0].Number_of_Days_Sober__c,
                                                                                    lstAppDetail[0].Id,
                                                                                    lstAppDetail[0]. Is_Intake__c,
                                                                                    !lstAppDetail[0].Alumni_App_Sobriety_Checkins__r.isEmpty());

           
            res.responseBody = Blob.valueOf(System.JSON.serialize(loginResponseWrapperObj));
            res.statusCode = 200;
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
   
    public class LoginResponseWrapper{
        
        public boolean success {get;set;}
        public decimal days_sober {get;set;} 
        public string app_detail_Id {get;set;}
        public boolean inTake {get;set;}
        public boolean isEditable {get;set;}
        

        public LoginResponseWrapper(boolean aSuccess,decimal daysSober,string appDetailId,boolean aInTake ,boolean aIsEditable){
           
            success = aSuccess;
            days_sober = daysSober;
            app_detail_Id = appDetailId;
            inTake = aInTake;
            isEditable = aIsEditable;
        }
    }
}