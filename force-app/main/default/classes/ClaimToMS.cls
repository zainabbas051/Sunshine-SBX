//Test Class : ClaimToMSTest
global class ClaimToMS {

  webservice static String ClaimToMS(String oppId){
     system.debug('oppID'+oppID);
     string result;
     string userid;
     userid =String.valueOf(UserInfo.getUserId()).substring(0, 15);
     opportunity oppIns = [select id,ownerid,name,is_Claimed__c from opportunity where id=:oppID];
    
                 
       if(oppIns.is_Claimed__c ==true)
                     result = 'Opportunity is already claimed';          
      
       else if(oppIns.ownerid ==System.Label.Tahil_User_Id && oppIns.is_Claimed__c ==false)
          {
          oppIns.is_Claimed__c = true;
          oppIns.ownerId = userid;
          oppIns.Closing_Agent__c  = userid;
          update oppIns;
          sendSMS (userid,oppIns.name);
          result = 'Opportunity is sucessfully claimed';

          }
      

          
       
      
      system.debug('result:'+ result);
      return result;
  }
  
  public static void sendSMS (string idval,string name){
         
         system.debug('idval'+ idval);
         user userIns=[SELECT name,mobilephone from user where id=:idval];
         smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
         smsObj.smagicinteract__PhoneNumber__c = userIns.MobilePhone;//Phone Number to which text is sent
         smsObj.smagicinteract__SMSText__c = name+', '+label.MS_Opportunity_Owner_Text;
        // smsObj.smagicinteract__senderId__c = 'smsMagic';
         smsObj.smagicinteract__senderId__c = '13173155065';
         smsObj.smagicinteract__Name__c = userIns.Name;
         if(!Test.isRunningTest()){
             smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
             insert smsObj;
         }
         
   }
  
}