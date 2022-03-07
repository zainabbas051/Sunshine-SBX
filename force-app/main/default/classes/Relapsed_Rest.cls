@RestResource(urlMapping='/relapsed/*')
global without sharing class Relapsed_Rest {

    @HttpGet
    global static void checkRelapsed(){
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
            
            list<user> ListOfUsers = new list<user>();
            list<Alumni_App_Sobriety_Checkin__c> listSobCheckins = new list<Alumni_App_Sobriety_Checkin__c>();
            list<Alumni_App_Challenges_Line_Items__c> listChallLines = new list<Alumni_App_Challenges_Line_Items__c>();
            string mentionedUsers = label.Relapsed_API_Chatter_Tagged_Persons;
            list<string> mentionedUsersList = new list<String>();
            
            if(!string.isBlank(mentionedUsers)){
                if(mentionedUsers.contains(',')){
                    for(string usr: mentionedUsers.split(',')){
                        mentionedUsersList.add(usr.trim());
                    }
                }
                else {
                    mentionedUsersList.add(mentionedUsers);
                }
            }
            
            string appDetailId = RestContext.request.headers.get('id');
            Alumni_App_Detail__c appDetail = [select id, Relapsed__c, Date_Time_Relapsed__c,
                                                        Total_Number_of_Sobreity_Checkins__c, Longest_Checkin__c,Number_of_Days_Sober__c,
                                                        Opportunity__c, account__c, (select id, Opportunity__c, Opportunity__r.Name,Opportunity__r.OwnerId,
                                                        Opportunity__r.Email__c, Opportunity__r.Phone__c from App_Detail_Histories__r where 
                                                        active__c = true), (select id, active__c from Alumni_App_Challenges_Line_Items__r where active__c = true), 
                                                        (select id, active__c from Alumni_App_Sobriety_Checkins__r where active__c = true)
                                                        from Alumni_App_Detail__c where id=: appDetailId];
            
            
            
            

            
            if(appDetail != null && appDetail.App_Detail_Histories__r.size() > 0)
            {
                lead l = [select id from lead where App_Detail_History__c =: appDetail.App_Detail_Histories__r[0].id];
                if(l != null && l.Id != null){
                    mapOfRequest = new Map<string,string>();
                    mapOfRequest.put('success','true');
                    mapOfRequest.put('message','Successfully Relapsed Again');
                    res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                    res.statusCode = 200;
                    return;
                }

                App_Detail_History__c appHistory = appDetail.App_Detail_Histories__r[0];
                appHistory.Relapsed__c = true;
                appHistory.Relapsed_Date__c = Datetime.now();
                appHistory.Total_Number_of_Sobreity_Checkins__c = appDetail.Total_Number_of_Sobreity_Checkins__c;
                appHistory.Longest_Checkin__c = appDetail.Longest_Checkin__c;
                appHistory.Number_of_Days_Sober__c = appDetail.Number_of_Days_Sober__c;
                update appHistory;

                if(appDetail.Alumni_App_Challenges_Line_Items__r.size() > 0){
                    for(Alumni_App_Challenges_Line_Items__c chItem : appDetail.Alumni_App_Challenges_Line_Items__r){
                        Alumni_App_Challenges_Line_Items__c chL = new Alumni_App_Challenges_Line_Items__c();
                        chL.id = chItem.id;
                        chL.active__c = false;
                        listChallLines.add(chL);
                    }
                }

                if(appDetail.Alumni_App_Sobriety_Checkins__r.size() > 0){
                    for(Alumni_App_Sobriety_Checkin__c checkin : appDetail.Alumni_App_Sobriety_Checkins__r){
                        Alumni_App_Sobriety_Checkin__c ch = new Alumni_App_Sobriety_Checkin__c();
                        ch.id = checkin.id;
                        ch.active__c = false;
                        listSobCheckins.add(ch);
                    }
                }


                if(!string.isBlank(appDetail.App_Detail_Histories__r[0].Opportunity__c))
                {
                    for(User u : [select id, name from user where isactive = true AND (Name IN: mentionedUsersList OR id=: appDetail.App_Detail_Histories__r[0].Opportunity__r.OwnerId)])
                    {
                        ListOfUsers.add(u);
                    }
                    System.debug('ListOfUsers='+ListOfUsers);
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                    // post body
                    String postBody = label.Relapsed_API_Chatter_Post_Body +'\n\n';

                    textSegmentInput.text = postBody;
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    feedItemInput.body = messageBodyInput;
                    
                    
                    //mention account reviewer from old and new onwer region
                    for(user u: ListOfUsers){
                        System.debug('u='+u.Name);
                        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                        mentionSegmentInput.id = u.Id;
                        messageBodyInput.messageSegments.add(mentionSegmentInput);
                    }
                    
                    
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    //post on Opp record
                    feedItemInput.subjectId = appDetail.App_Detail_Histories__r[0].Opportunity__c;
                    //post the chatter
                    ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput); 
                    
                    Lead newLead = new Lead();
                    newLead.LastName = appDetail.App_Detail_Histories__r[0].Opportunity__r.name;
                    newLead.email = appDetail.App_Detail_Histories__r[0].Opportunity__r.Email__c;
                    newLead.Phone = appDetail.App_Detail_Histories__r[0].Opportunity__r.Phone__c;
                    newLead.LeadSource = 'Alumni App';
                    newLead.Company = 'None';
                    newLead.App_Detail_History__c = appDetail.App_Detail_Histories__r[0].id;
                    
                    insert newLead;
                
                }

            }

            update listChallLines;
            update listSobCheckins;

            list<Alumni_App_Detail__c> lstAppD = AppDetailsUtil.resetNextEligibleChallenges(new list<Alumni_App_Detail__c>{appDetail});
            appDetail.Longest_Checkin__c = 0;
            if(lstAppD.size() > 0)
            {
                appDetail.Next_Eligible_Checkin_Streak__c = lstAppD[0].Next_Eligible_Checkin_Streak__c !=  null? lstAppD[0].Next_Eligible_Checkin_Streak__c : 0;
                appDetail.Next_Eligible_Total_Checkins__c = lstAppD[0].Next_Eligible_Total_Checkins__c !=  null? lstAppD[0].Next_Eligible_Total_Checkins__c : 0;
            }
            update appDetail;

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
}