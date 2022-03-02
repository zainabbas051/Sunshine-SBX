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
                                                        Opportunity__c, Opportunity__r.Name,Opportunity__r.OwnerId,
                                                        Opportunity__r.Email__c, Opportunity__r.Phone__c
                                                        from Alumni_App_Detail__c where id=: appDetailId];
            
            
            
            

            appDetail.Relapsed__c = true;
            appDetail.Date_Time_Relapsed__c = Datetime.now();
            update appDetail;

            if(!string.isBlank(appDetail.Opportunity__c))
            {
                for(User u : [select id, name from user where isactive = true AND (Name IN: mentionedUsersList OR id=: appDetail.Opportunity__r.OwnerId)])
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
                feedItemInput.subjectId = appDetail.Opportunity__c;
                //post the chatter
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput); 
                
                Lead newLead = new Lead();
                newLead.LastName = appDetail.Opportunity__r.name;
                newLead.email = appDetail.Opportunity__r.Email__c;
                newLead.Phone = appDetail.Opportunity__r.Phone__c;
                newLead.LeadSource = 'Alumni App';
                newLead.Company = 'None';
                insert newLead;
            
            }

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