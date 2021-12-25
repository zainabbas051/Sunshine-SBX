/*
Test Class : HistoryCalendar_Rest_Test
*/
@RestResource(urlMapping='/history_page_calender/*')
global  class HistoryCalendar_Rest {
    
    @HttpGet
    global static void getSobrietyHistroy(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
         Map<string,string> mapOfRequest = new Map<string,string>();

        try{
            
            if(RestContext.request.headers.isEmpty() || RestContext.request.params.isEmpty()){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }
            
            string recordId = RestContext.request.headers.get('id');
            integer numberOfDays = integer.valueOf(RestContext.request.params.get('interval'));
            date checkInDate = Date.valueOf(RestContext.request.params.get('startDate'));
            
           
            List<Alumni_App_Sobriety_Checkin__c> lstSobrietyCheckIn = SoberityCheck_Selector.getSobrietyCheckinHistory(recordId,numberOfDays,checkInDate);
            if(lstSobrietyCheckIn.isEmpty()){
                List<SobrietyCheckIn> lst = new List<SobrietyCheckIn>();
                res.responseBody = Blob.valueOf(System.JSON.serialize(lst));
                res.statusCode = 200;
                return;
            
            }
            
            List<SobrietyCheckIn> lst = new List<SobrietyCheckIn>();
            for(Alumni_App_Sobriety_Checkin__c iApp : lstSobrietyCheckIn){
                lst.add(new SobrietyCheckIn(iApp));
            }
           res.responseBody = Blob.valueOf(System.JSON.serialize(lst));
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
    
    public class SobrietyCheckIn{
        
        public string anxious {get;set;}
        public string craving {get;set;}
        public string depressed {get;set;}
        public string feeling {get;set;}
        public string record_date {get;set;}
        public string notes {get;set;}
        
        public SobrietyCheckIn(Alumni_App_Sobriety_Checkin__c appSobriety){
            
            anxious = appSobriety.Anxiety_Score__c;
            craving = appSobriety.Cravings_Score__c;
            depressed = appSobriety.Depression_Score__c;
            feeling = appSobriety.Feeling_Today__c;
            notes = appSobriety.Notes__c;
            record_date = String.valueOf(appSobriety.Sobriety_Checkin_Date__c);
           
        }
    }
   
   
}