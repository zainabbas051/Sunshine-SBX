// test class SFSupportCaseNotificationTest
trigger SFSupportCaseNotification on Case (after insert) {
    
    Map<string,string> smsNveenZoobeez  = new Map<string,string>();
   
    for (Case smscase: Trigger.new) {    
        if (smscase.RecordTypeId == Constants.sfSupportCaseRecordTypeId){
            smsNveenZoobeez.put(Label.Naveen_User_Id ,'A new Case,' + smscase.CaseNumber + ' has been reported by '  + smscase.Case_Reported_Name__c + ', Please check and reply!!');
            smsNveenZoobeez.put(Label.Zoobeez_Fatima_User_Id,'A new Case,' + smscase.CaseNumber + ' has been reported by '  + smscase.Case_Reported_Name__c + ', Please check and reply!!');
            // String feedBody = 'A new Case,' + smscase.CaseNumber + ' has been reported by '  + smscase.Case_Reported_Name__c + '. Please check.';
            
                /*    FeedItem fi = new FeedItem();
                    fi.Body = feedBody;
                    fi.Type = 'AdvancedTextPost';
                    fi.ParentId = Label.Zoobeez_Fatima_User_Id;
                    insert fi;*/
                    
             
            String sText = label.FeedMention_Name +' Please check this new SFDC case :' + smscase.CaseNumber + ' reported by {'  + smscase.SFDC_Support_Case_Reported_By__c+ '}.';
            ConnectApiHelper.postFeedItemWithMentions(null, smscase.Id, sText);
        }    
    }
    
     if(!smsNveenZoobeez.KeySet().isEmpty())
        Utilities.sendSMS(smsNveenZoobeez); 
}