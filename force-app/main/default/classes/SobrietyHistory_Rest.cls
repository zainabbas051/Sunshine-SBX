/*
Test Class : SobrietyHistory_Rest_Test
*/
@RestResource(urlMapping='/history_page/*')
global class SobrietyHistory_Rest {
   
    @HttpGet
    global static void showHistory(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<string,string> mapOfRequest = new Map<string,string>();

        try{

            if(!RestContext.request.headers.containsKey('id')){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }
            
            sObretyHistoryResp sobretyHistoryObj = new sObretyHistoryResp(RestContext.request.headers.get('id'));

            Alumni_App_Detail__c alumniObj = SoberityCheck_Selector.getsOberityDetails(sobretyHistoryObj.recordId);
            List<daily_sobriety> lstDailySobriety = new List<daily_sobriety>();
            List<badges> lstBadges = new List<badges>();
            streak streakResp = new streak();
            streakResp.current_checkin = alumniObj.Current_Checkin_Streak__c;
            streakResp.longest_checkin = alumniObj.Longest_Checkin__c;


            HistroyResponseWrapper history = new HistroyResponseWrapper();
            history.streak = streakResp;
            history.daily_sobriety = lstDailySobriety;
            history.badges = lstBadges;

            for(Alumni_App_Sobriety_Checkin__c iApp : alumniObj.Alumni_App_Sobriety_Checkins__r){

                daily_sobriety dailySobrietyObj = new daily_sobriety();
                    dailySobrietyObj.record_date = iApp.Sobriety_Checkin_Date__c;
                    dailySobrietyObj.feeling = iApp.Feeling_Today__c;
                    dailySobrietyObj.anxious = iApp.Anxiety_Score__c;
                    dailySobrietyObj.depressed = iApp.Depression_Score__c;
                    dailySobrietyObj.craving = iApp.Cravings_Score__c;
                    lstDailySobriety.add(dailySobrietyObj);
            }
            
            for(Alumni_App_Challenges_Line_Items__c bdgs : alumniObj.Alumni_App_Challenges_Line_Items__r){

                badges badgesObj = new badges();
                badgesObj.challengeId = bdgs.Alumni_App_Challenges_Configuration__r.Id;
                badgesObj.resourceUrl = bdgs.Alumni_App_Challenges_Configuration__r.Challenge_Medal_Image__c;
                lstBadges.add(badgesObj);
            }
           
            res.responseBody = Blob.valueOf(System.JSON.serialize(history));
            res.statusCode = 200;
            return;
            
        }
        catch(Exception ex){
        
            mapOfRequest = new Map<string,string>();
            mapOfRequest.put('success','false');
            mapOfRequest.put('message','In Valid Request');
            res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
            res.statusCode = 500;
           
        }
    }

    public class sObretyHistoryResp{
        public string recordId;

        public sObretyHistoryResp(string Id ){
            recordId = Id;
        }
    }
    
    public class HistroyResponseWrapper{

        public streak streak;
        public List<daily_sobriety> daily_sobriety;
        public List<badges> badges;
        

    }
    public class streak{

        public decimal current_checkin;
        public decimal longest_checkin;
      
    }

    public class daily_sobriety{
      
        public date record_date;
        public string feeling;
        public string anxious;
        public string depressed;
        public string craving;
    }
    
    public class badges{
      
        public string challengeId;
        public string resourceUrl;
    }
}