trigger SobrietyCheckinTrigger on Alumni_App_Sobriety_Checkin__c (after insert) {

    if(trigger.isAfter){
        SobrietyChallengeTriggerHandler.createAlumniChalleng(trigger.new);
    }


}