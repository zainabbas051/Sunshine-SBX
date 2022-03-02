//Test Class : SEOassignmentTest
trigger SEOassignment on OUTREACH_REQUEST__c (after insert, after update) {
    
      
        List<SEO_Outreacher_Mapping__c> seoOutreachersList = SEO_Outreacher_Mapping__c.getall().values();
        
       // Similarly we weed to update record of object OUTREACH so we collected all records in seprate list to perform operaions  
        
       List<OUTREACH_REQUEST__c> outreachRequestList = new List<OUTREACH_REQUEST__c>();
       List<OUTREACH_REQUEST__c> outreachRequestListUpdate = new List<OUTREACH_REQUEST__c>();
      
        for(OUTREACH_REQUEST__c outreq : Trigger.New) {        
           if(trigger.isInsert){
               if( outreq.Status__c == 'Qualified'){
                  outreachRequestList.add(outreq);
               }
           }
           if(trigger.isUpdate){
               if( outreq.Status__c == 'Qualified' && Trigger.OldMap.Get(outreq.id).Status__c != outreq.Status__c){
                  outreachRequestList.add(outreq);
               }
           }
           
        }
        
   //seo assignment direct mapping to outreachers
        if(!outreachRequestList.isEmpty()){
            for(OUTREACH_REQUEST__c outReq : outreachRequestList){                       
                 //This below change for social media box is checked then it will always be assigned to Alexandrea_Warner_User_id 
                 if (outReq.Social_Media_Accounts__c == True){
                       OUTREACH_REQUEST__c socialOutReq = new OUTREACH_REQUEST__c(id = outReq.id,Prospect_URL__c=outReq.Prospect_URL__c);          
                        socialOutReq.AssignedSEO__c=Label.Alexandrea_Warner_User_id;
                        outreachRequestListUpdate.add(socialOutReq);
                  }// end of changes for social media assignment
                
                else{   
                       OUTREACH_REQUEST__c tempOutReq = new OUTREACH_REQUEST__c(id = outReq.id,Prospect_URL__c=outReq.Prospect_URL__c);
                       for(SEO_Outreacher_Mapping__c seoOutreach : seoOutreachersList ){
                           if (seoOutreach.Name == outReq.Ownerid){                               
                               tempOutReq.AssignedSEO__c = seoOutreach.SEO_ID__c ;
                               outreachRequestListUpdate.add(tempOutReq);  
                            } 
                        }
                }
            }
        }
                     
        
        if(!outreachRequestListUpdate.isEmpty()){  
        
            update outreachRequestListUpdate;
            //update seoRoundRobinList; 
            update  seoOutreachersList ; 
          //  Map<String,String> smsMap = new Map<String,String>();
           // Map<String,Map<String,String>> emailWriter= new Map<String,Map<String,String>>();
            
            for(OUTREACH_REQUEST__c seorrlist : outreachRequestListUpdate){
                if (seorrlist.AssignedSEO__c != null) {                   
                   // smsMap.put(seorrlist.AssignedSEO__c,'Contact has been established with Outreach Request on : '+seorrlist.Prospect_URL__c+', and You have been assigned as the SEO on it');                                        
                   // Map<String,String> emailMap = new Map<String,String>();
                   // emailMap.put('Outreach Request attention!!' ,'Contact has been established with Outreach Request on' +seorrlist.Prospect_URL__c+', and You have been assigned as the SEO on it' );
                 //   emailMap.put('You have been assigned as the SEO ');
                  //  emailWriter.put(seorrlist.AssignedSEO__c,emailMap );
                    
                    }
               }
              // Utilities.sendSMS(smsMap); 
             //  Utilities.sendEmail(emailWriter); 
        }      
        
            
           
}