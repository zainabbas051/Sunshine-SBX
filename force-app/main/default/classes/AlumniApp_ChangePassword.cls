@RestResource(urlMapping='/changePassword/*')
global without sharing class AlumniApp_ChangePassword {
    
    @HttpPost
    global static void changePassword(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{

            string requestBodyStr = req.requestBody.toString();
            if(string.isEmpty(requestBodyStr)){
                sendInvalidResponse(res,'In Valid Request');
                return;
            }
            EmaiWrapper emailObj = (EmaiWrapper)JSON.deserialize(requestBodyStr,EmaiWrapper.CLASS);
            List<Alumni_App_Detail__c> lstAppDetail = AlumniAppDetail_Selector.getUserDetailByUserName(emailObj.email);
            
            if(lstAppDetail.isEmpty()){
                sendValidResponse(res,'User does not exist','false');
                return;
            }
            Alumni_App_Detail__c appDetail = lstAppDetail[0];
            appDetail.password__c = emailObj.newPassword;
            update appDetail;
            sendValidResponse(res,'Password changed Successfully','true');
            return;
        }
        catch(Exception ex){
            sendInvalidResponse(res,ex.getMessage());
        }

    }

    private static void sendInvalidResponse(RestResponse res,string message){
        Map<string,string> mapOfRequest = new Map<string,string>();
        mapOfRequest.put('success','false');
        mapOfRequest.put('message',message);
        res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
        res.statusCode = 500;//comments
    }

    private static void sendValidResponse(RestResponse res,string message,string isPasswordChanged){
        Map<string,string> mapOfRequest = new Map<string,string>();
        mapOfRequest.put('isPasswordChanged',isPasswordChanged);
        mapOfRequest.put('message',message);
        res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
        res.statusCode = 200;
    }
    public class EmaiWrapper{
        public string email {get;set;}
        public string newPassword {get;set;}

    }
}