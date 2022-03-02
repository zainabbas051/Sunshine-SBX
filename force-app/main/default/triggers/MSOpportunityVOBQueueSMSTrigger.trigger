trigger MSOpportunityVOBQueueSMSTrigger on Opportunity ( After insert) {
     set<Id> OppId= new set<Id>();
     list<opportunity> OppList = new list<opportunity>();

     Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
     Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recTypeId = rtMapByName.get('Monarch Shores').getRecordTypeId();//Getting the id of Monarch Shore Opportunity Record Type
     
        //getting MS VOB queue Memeber details
        List<Group> QueueId = [select Id from Group where Name = 'MS VOB Queue' and Type = 'Queue'];
        List<GroupMember > QueueMemIDs  = [Select UserOrGroupId From GroupMember where GroupId =:QueueId ] ;
        set<id> UserIds = new set<id>();
        for(GroupMember GMIns: QueueMemIDs){
            UserIds.add(GMIns.UserOrGroupId );
        } 
        list<user> MSVOBQueueMembers = [select id,name,MobilePhone from user where IsActive = true AND id in :UserIds];
        
          //list for sending VOB sms
         list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();   
    
    
       for(Opportunity o: Trigger.New){
          if(o.recordTypeId == recTypeId){//Making sure only Monarch Shores Opp are being processed.
             for(user VOBQueueMembersIns: MSVOBQueueMembers ){
                 smagicinteract__smsMagic__c smsObjNew = new smagicinteract__smsMagic__c();
                 smsObjNew.smagicinteract__PhoneNumber__c = VOBQueueMembersIns.MobilePhone;//Phone Number to which text is sent
                 smsObjNew.smagicinteract__SMSText__c = 'Please Initiate VOB for New MS Opportunity - '+O.name;
                 smsObjNew.smagicinteract__senderId__c = 'smsMagic';
                 smsObjNew.smagicinteract__Name__c = VOBQueueMembersIns.Name;
                 smsObjNew.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                 lstSendSMS.add(smsObjNew);
          }
          if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                insert lstSendSMS;
            }

          }
     
     }
     
      

}