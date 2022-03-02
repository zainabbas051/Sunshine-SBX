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
            
            List<Alumni_App_Challenges_Configurations__c> listChallenges = new list<Alumni_App_Challenges_Configurations__c>();
            listChallenges = [select id, Streak_Duration__c, Success_Message__c, Type__c from Alumni_App_Challenges_Configurations__c];
            map<string,Alumni_App_Challenges_Configurations__c> mapOfChallenges = new map<string,Alumni_App_Challenges_Configurations__c>();
            if(listChallenges.size() > 0)
            {
                for(Alumni_App_Challenges_Configurations__c ch : listChallenges)
                {
                    mapOfChallenges.put(ch.Type__c+'|'+integer.valueOf(ch.Streak_Duration__c), ch);
                }
            }
            string checkinMsg1 = '';
            string checkinMsg2 = '';                   
            boolean checkinReward = false;
            
            if(lstAppDetail[0].Next_Eligible_Checkin_Streak__c != null && 
                lstAppDetail[0].Current_Checkin_Streak__c != null &&
                lstAppDetail[0].Current_Checkin_Streak__c + 1 == lstAppDetail[0].Next_Eligible_Checkin_Streak__c)
            {
                checkinReward = true;
                checkinMsg1 = lstAppDetail[0].Next_Eligible_Checkin_Streak__c != null && mapOfChallenges.containsKey('Daily Checkin'+'|'+integer.valueOf(lstAppDetail[0].Next_Eligible_Checkin_Streak__c)) ?
                                mapOfChallenges.get('Daily Checkin'+'|'+integer.valueOf(lstAppDetail[0].Next_Eligible_Checkin_Streak__c)).Success_Message__c : '';
            }

            if(lstAppDetail[0].Next_Eligible_Total_Checkins__c != null && 
                lstAppDetail[0].Total_Number_of_Sobreity_Checkins__c != null &&
                lstAppDetail[0].Total_Number_of_Sobreity_Checkins__c + 1 == lstAppDetail[0].Next_Eligible_Total_Checkins__c)
            {
                checkinReward = true;
                checkinMsg2 = lstAppDetail[0].Next_Eligible_Total_Checkins__c != null && mapOfChallenges.containsKey('Total Checkin'+'|'+integer.valueOf(lstAppDetail[0].Next_Eligible_Total_Checkins__c)) ?
                                mapOfChallenges.get('Total Checkin'+'|'+integer.valueOf(lstAppDetail[0].Next_Eligible_Total_Checkins__c)).Success_Message__c : '';
            }

            
            LoginResponseWrapper loginResponseWrapperObj = new LoginResponseWrapper(
                                                                                    true,
                                                                                    lstAppDetail[0].Number_of_Days_Sober__c,
                                                                                    lstAppDetail[0].Id,
                                                                                    lstAppDetail[0]. Is_Intake__c,
                                                                                    !lstAppDetail[0].Alumni_App_Sobriety_Checkins__r.isEmpty(),
                                                                                    checkinReward,
                                                                                    checkinMsg1,
                                                                                    checkinMsg2);

           
            
            
            res.responseBody = Blob.valueOf(System.JSON.serialize(loginResponseWrapperObj));
            res.statusCode = 200;
            updateDetails(lstAppDetail[0]);
            system.debug('resposeBody='+ res.responseBody);
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
        public boolean checkin_reward_eligible {get; set;}
        public string checkin_reward_message_1 {get; set;}
        public string checkin_reward_message_2 {get; set;}

        public LoginResponseWrapper(boolean aSuccess,decimal daysSober,string appDetailId,boolean aInTake ,boolean aIsEditable, boolean checkinreward, string checkinMsg1, string checkinMsg2){
           
            success = aSuccess;
            days_sober = daysSober;
            app_detail_Id = appDetailId;
            inTake = aInTake;
            isEditable = aIsEditable;
            checkin_reward_eligible = checkinreward;
            checkin_reward_message_1 = checkinMsg1;
            checkin_reward_message_2 = checkinMsg2;
        }
    }
}