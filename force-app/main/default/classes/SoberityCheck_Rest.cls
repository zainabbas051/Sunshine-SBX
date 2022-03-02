/*
Test Class : SoberityCheck_Rest_Test
*/
@RestResource(urlMapping='/sobriety_check/*')
global class SoberityCheck_Rest {

    @HttpPost
    global static void addSoberityCheck(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<string,string> mapOfRequest = new Map<string,string>();

        try{
            string requestBodyStr = req.requestBody.toString();
            system.debug('#requestBodyStr='+requestBodyStr);
            if(string.isEmpty(requestBodyStr) || !RestContext.request.headers.containsKey('id')){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }

            SoberityCheckRequestWrapper soberityWrapper = (SoberityCheckRequestWrapper)JSON.deserialize(requestBodyStr,SoberityCheckRequestWrapper.CLASS);
            soberityWrapper.loginId = RestContext.request.headers.get('id');

            /*
            Update Request
            Jira ticket : PIHRC-33
            Author : Zain Abbas
            Date : 24-01-22
            */

            //Start

           /* Alumni_App_Detail__c appDet = [select id, Longest_Checkin__c, Current_Checkin_Streak__c from Alumni_App_Detail__c where id =:soberityWrapper.loginId];
            if(appDet != null){
                if(appDet.Current_Checkin_Streak__c != null){
                    appDet.Current_Checkin_Streak__c = appDet.Current_Checkin_Streak__c + 1;
                }
                else{
                    appDet.Current_Checkin_Streak__c = 1;
                }
                if(appDet.Longest_Checkin__c != null && appDet.Longest_Checkin__c < (appDet.Current_Checkin_Streak__c + 1)){
                    appDet.Longest_Checkin__c = appDet.Current_Checkin_Streak__c + 1;
                }

                update appDet;
            } */
            
            //End
            
            Alumni_App_Sobriety_Checkin__c allsObj = new Alumni_App_Sobriety_Checkin__c();
            allsObj.Anxiety_Score__c = soberityWrapper.anxious;
            allsObj.Cravings_Score__c = soberityWrapper.craving;
            allsObj.Depression_Score__c = soberityWrapper.depressed;
            allsObj.Feeling_Today__c = soberityWrapper.feeling;
            allsObj.Notes__c = soberityWrapper.note;
            allsObj.Alumni_App_Detail__c = soberityWrapper.loginId;
            allsObj.Sobriety_Checkin_Date__c = Date.Today();

            insert allsObj;
            mapOfRequest = new Map<string,string>();
            mapOfRequest.put('success','true');
            mapOfRequest.put('message','Saved Successfully');
            res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
            res.statusCode = 200;
            return;
            
        }
        catch(Exception ex){
            mapOfRequest = new Map<string,string>();
            mapOfRequest.put('success','false');
            mapOfRequest.put('message',ex.getMessage() + ' ' + ex.getLineNumber());
            res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
            res.statusCode = 500;
        }
    }
    public class SoberityCheckRequestWrapper{
        public String feeling;
        public String anxious;
        public String depressed;
        public String craving;
        public String note;
        public String loginId;
   
    }
    
}