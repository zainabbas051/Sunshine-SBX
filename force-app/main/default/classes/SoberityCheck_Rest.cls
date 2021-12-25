@RestResource(urlMapping='/sobriety_check/*')
global class SoberityCheck_Rest {

    @HttpPost
    global static void addSoberityCheck(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<string,string> mapOfRequest = new Map<string,string>();

        try{
            string requestBodyStr = req.requestBody.toString();
            if(string.isEmpty(requestBodyStr) || !RestContext.request.headers.containsKey('id')){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }

            SoberityCheckRequestWrapper soberityWrapper = (SoberityCheckRequestWrapper)JSON.deserialize(requestBodyStr,SoberityCheckRequestWrapper.CLASS);
            soberityWrapper.loginId = RestContext.request.headers.get('id');

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