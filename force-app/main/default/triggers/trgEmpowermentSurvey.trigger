trigger trgEmpowermentSurvey on Empowerment_Packet_Survey__c (after insert) {

    switch on Trigger.operationType{
        when AFTER_INSERT{
            EmpowermentSurveyTrigger_Handler.getGoogleMapLocation(json.serialize(trigger.New));
        }
    }
}