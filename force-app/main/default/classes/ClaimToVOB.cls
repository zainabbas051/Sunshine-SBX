//Test Class : ClaimToVOBTest
global class ClaimToVOB{
    webservice static String ClaimToVOB(String oppId){
    system.debug('oppID'+oppID);
    Boolean IsQueueMember=false;
    string result;
    string userid;
     userid =String.valueOf(UserInfo.getUserId()).substring(0, 15);
     set<id> UserConcerned = new set<id>();
     //UserConcerned.add(System.Label.Tahil_User_Id);
     //UserConcerned.add(System.Label.Lynelle_Smith_Id); 
     UserConcerned.add(System.Label.Ashley_User_Id);
     UserConcerned.add(System.Label.Andy_User_Id); 
     list<user> LstConcernedUsers = [select id,name,MobilePhone from user where IsActive=true and id in :UserConcerned ];
     opportunity oppIns = [select id,ownerid,name,VOB_Status__c, Latest_VOB_Request__c from opportunity where id=:oppID];
   
     
      //getting MS VOB queue Memeber details
        List<Group> QueueId = [select Id from Group where Name = 'MS VOB Queue' and Type = 'Queue'];
        List<GroupMember > QueueMemIDs  = [Select UserOrGroupId From GroupMember where GroupId =:QueueId ] ;
        set<id> UserIds = new set<id>();
        for(GroupMember GMIns: QueueMemIDs){
            UserIds.add(GMIns.UserOrGroupId );
        } 
        list<user> MSVOBQueueMembers = [select id,name,MobilePhone from user where IsActive=true and id in :UserIds];
        
        for(user VOBQueueMembersIns: MSVOBQueueMembers ){
            if(VOBQueueMembersIns.id==userid ){
                IsQueueMember=true;
                break;
            }
            else
                IsQueueMember=false;
        
        }
    
                 
       if(oppIns.VOB_Status__c=='In Progress')
                     result = 'VOB is already claimed';   
     
                           
      
       else if(IsQueueMember ==True && oppIns.VOB_Status__c!='In Progress')
          {
          oppIns.VOB_Status__c = 'In Progress';
          oppIns.VOB_Agent__c= userid;
          OppIns.VOB_Claimed__c=datetime.now();
          update oppIns;
          
          if(oppIns.Latest_VOB_Request__c != null){
              VOB_Request__c vr = new VOB_Request__c(id=oppIns.Latest_VOB_Request__c, VOB_Agent__c = userid, VOB_Claimed__c=datetime.now(), VOB_Request_Status__c = 'In-Progress');
              update vr;
              
          }
          sendSMS (userid,oppIns.name,LstConcernedUsers );
          result = 'VOB is sucessfully claimed';

          }
      
  
       else if(IsQueueMember==False) 
                     result = 'You cannot claim VOB, Only VOB Members can claim';   

          
       
      
      system.debug('result:'+ result);
     
    return result;
    }
    
    public static void sendSMS (string idval,string name,list<user>LstConcernedUsers ){
           //list for sending VOB sms
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>(); 
         system.debug('idval'+ idval);
         user userIns=[SELECT name,mobilephone from user where IsActive=true and id=:idval];
         smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
         smsObj.smagicinteract__PhoneNumber__c = userIns.MobilePhone;//Phone Number to which text is sent
         smsObj.smagicinteract__SMSText__c = 'VOB is sucessfully claimed for '+ name+ ' by '+userIns.name ;
       //  smsObj.smagicinteract__senderId__c = 'smsMagic';
         smsObj.smagicinteract__senderId__c = '13173155065';
         smsObj.smagicinteract__Name__c = userIns.Name;
         if(!Test.isRunningTest()){
             smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
             lstSendSMS.add(smsObj);
             //insert smsObj;
         }
         for(user ConcernedUsers: LstConcernedUsers ){
                 if(ConcernedUsers.id != idval){
                     smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
                     smsObjNew.smagicinteract__PhoneNumber__c = ConcernedUsers.MobilePhone;//Phone Number to which text is sent
                     smsObjNew.smagicinteract__SMSText__c = 'VOB is sucessfully claimed for '+ name+ ' by '+userIns.name ;
                     //smsObjNew.smagicinteract__senderId__c = 'smsMagic';
                     smsObjNew.smagicinteract__senderId__c = '13173155065';
                     smsObjNew.smagicinteract__Name__c = ConcernedUsers.Name;
                     smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                     lstSendSMS.add(smsObjNew);
                 }
          }
          if(lstSendSMS.size()>0){
            if(!Test.isRunningTest())
                insert lstSendSMS;
          }
                 
         
   }

}