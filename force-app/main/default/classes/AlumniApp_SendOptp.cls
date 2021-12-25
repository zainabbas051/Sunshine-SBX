@RestResource(urlMapping='/sendOtpOnEmail/*')
global without sharing class AlumniApp_SendOptp {
    
    @HttpPost
    global static void sendOptpOnEmailAddress(){

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
            appDetail.Optp_Token_s__c = generateRandomNumber();
            appDetail.User_Email__c = appDetail.Username__c;
            update appDetail;
            sendValidResponse(res,'Email Sent','true');

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

    private static void sendValidResponse(RestResponse res,string message,string OptSend){
        Map<string,string> mapOfRequest = new Map<string,string>();
        mapOfRequest.put('OtpSend',OptSend);
        mapOfRequest.put('message',message);
        res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
        res.statusCode = 200;
    }

    private static string generateRandomNumber(){
        Integer optp = integer.valueof((Math.random() * 999999));
        return string.valueof(optp);
    }

    public class EmaiWrapper{
        public string email {get;set;}

    }
}