//Test Class MSinsuranceCollectorRoundRobinTest
trigger MSinsuranceCollectorRoundRobin on Opportunity (after update,after insert) {
    
    Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
    List<Opportunity> oppIdList = new List<Opportunity>();
    Set<Opportunity> oppIdList1 = new Set<Opportunity>();
    Map<String,String> smsUserAndText = new Map<String,String>();
    Map<String,String> subjectAndBody = new Map<String,String>();
    Map<String,Map<String,String>> emailUserAndText = new Map<String,Map<String,String>>();
    List<Insurance_Collector_Round_Robin_User__c> insCollUsr = new List<Insurance_Collector_Round_Robin_User__c>();
    List<Insurance_Collector_Round_Robin_User__c> insCollUsr2 = new List<Insurance_Collector_Round_Robin_User__c>();
    Set<Insurance_Collector_Round_Robin_User__c> insCollUsr1 = new Set<Insurance_Collector_Round_Robin_User__c>();
    insCollUsr = Insurance_Collector_Round_Robin_User__c.getall().values();
    List<OpportunityShare> oppShareList = new List<OpportunityShare>();
    
    for(Opportunity opp : Trigger.New){
        Opportunity opp1 = new Opportunity();
         if(opp.recordTypeId == recTypeId){
            If(opp.Insurance_Collector__c == null && opp.StageName == 'Admitted' && trigger.oldMap.get(opp.id).StageName != 'Admitted' && opp.Cash_Client__c == False){
               integer i,j;
               for(i = 0; i<insCollUsr.size();i++){
                   if(insCollUsr[i].Last_Assigned_To__c == true){
                      opp1.Insurance_Collector__c = insCollUsr[i].User_Id__c;
                      opp1.id = opp.id;
                      oppIdList1.add(opp1);
                      
                      //Setting Up Opportunity Share Access
                      OpportunityShare os = new OpportunityShare(OpportunityId=opp.id, OpportunityAccessLevel='Edit', UserOrGroupId=insCollUsr[i].User_Id__c, RowCause='Manual');
                      oppShareList.add(os);  
                      
                      //Sending Email and SMS Notification to Assigned Collector
                      String text = opp.name + 'has been assigned to you for Insurance Collections.';
                      String body = opp.name + 'has been assigned to you for Insurance Collections.';
                      smsUserAndText.put(insCollUsr[i].User_Id__c, text);
                      subjectAndBody.put(text,body);
                      emailUserAndText.put(insCollUsr[i].User_Id__c, subjectAndBody);
                      
                      //Updating the Insurance Round Robin Assignment Custom Setting
                      insCollUsr[i].Last_Assigned_To__c = false;
                      insCollUsr1.add(insCollUsr[i]);
                      j = i + 1;
                      if(j == insCollUsr.size()){
                          j = 0;
                          
                        } 
                  }
              }
              insCollUsr[j].Last_Assigned_To__c = true;
              insCollUsr1.add(insCollUsr[j]);
           }
        }
    }
    
    if(insCollUsr1.size() > 0){
    insCollUsr2.addAll(insCollUsr1);
        update insCollUsr2;
    }
    
    if(oppIdList1.size()>0){     
        oppIdList.addAll(oppIdList1);
        update oppIdList;
        insert oppShareList;
        
        Utilities.sendSMS(smsUserAndText);
        Utilities.sendEmail(emailUserAndText);
    }    
}