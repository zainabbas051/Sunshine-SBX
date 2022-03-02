//TestClass : MarketingSupportCaseNotificationTest
trigger MarketingSupportCaseNotification on Case (after insert) {
    
    Map<string,string> smsNotification  = new Map<string,string>();
   
    for (Case smscase: Trigger.new) {    
        if (smscase.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId()){
            smsNotification.put('0054P000009l6o6','A new Case,' + smscase.CaseNumber + ' has been reported by '  + smscase.SuppliedName + ', Please check and reply!!');
            smsNotification.put(Label.Naveen_User_Id,'A new Case,' + smscase.CaseNumber + ' has been reported by '  + smscase.SuppliedName + ', Please check and reply!!');
        }    
    }
    
     if(!smsNotification.KeySet().isEmpty())
        Utilities.sendSMS(smsNotification); 
}