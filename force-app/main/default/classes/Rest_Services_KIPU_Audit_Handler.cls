//Test Class :
public  class Rest_Services_KIPU_Audit_Handler {
    
    public static Object kipuAuditService(String data){
        
        System.debug(data);
        try{
            
            KIPU_Audit_Wrapper requestDataJSON = (KIPU_Audit_Wrapper)JSON.deserializeStrict(data, KIPU_Audit_Wrapper.class);
            updateKIPUChartAuditFields(requestDataJSON);
            
        }catch(exception e){
            System.debug('exception e ::::'+e.getMessage());
        }
        
        return New ResponseClass('success',JSON.deserializeUntyped(data),'Services are working!','Services are working!');
    }
    
    public static void updateKIPUChartAuditFields(KIPU_Audit_Wrapper requestDataJSON){
        string returnString = '';
        if(requestDataJSON.medical_record_number != null){
            
            string medicalRecordNumber = requestDataJSON.medical_record_number;
            
            KIPU_Chart_Audit__c temp_KCA = new KIPU_Chart_Audit__c();
            for(KIPU_Chart_Audit__c kca : [Select id, Intake_Consents_date__c, Intake_Consents_completed_by__c, F2F_Date_Completed__c, 
                                           F2F_completed_by__c, Face_2_Face_2_0_Form__c from KIPU_Chart_Audit__c where Medical_Record_Number__c =: medicalRecordNumber]){
                temp_KCA = kca;                               
            }
            
            if(temp_KCA.id != null){
                if(requestDataJSON.Intake_Consents_date!=null){
                    temp_KCA.Intake_Consents_date__c = getDateValue(requestDataJSON.Intake_Consents_date);
                }
                if(requestDataJSON.Intake_Consents_completed_by!=null){
                    temp_KCA.Intake_Consents_completed_by__c = requestDataJSON.Intake_Consents_completed_by;
                }
                if(requestDataJSON.F2F_Date_Completed!=null){
                    temp_KCA.F2F_Date_Completed__c = getDateValue(requestDataJSON.F2F_Date_Completed);
                }
                if(requestDataJSON.F2F_completed_by!=null){
                    temp_KCA.F2F_completed_by__c = requestDataJSON.F2F_completed_by;
                }
                if(requestDataJSON.two_point_o_form!=null){
                    temp_KCA.Face_2_Face_2_0_Form__c = requestDataJSON.two_point_o_form;
                }
                /*if(requestDataJSON.two_point_o_form == FALSE){
                    temp_KCA.Face_2_Face_2_0_Form__c = 'No';
                }else{
                    temp_KCA.Face_2_Face_2_0_Form__c = 'Yes';
                }*/
                if(requestDataJSON.HP_date_completed!=null){
                    temp_KCA.H_P_date_completed__c = getDateValue(requestDataJSON.HP_date_completed);
                }
                if(requestDataJSON.HP_is_completed_by!=null){
                    temp_KCA.H_P_is_completed_by__c = requestDataJSON.HP_is_completed_by;
                }
                /*for(KIPU_Audit_Wrapper.audit_field_data afd : requestDataJSON.audit_field_data){
                    if(afd.field_name.contains('Intake')){
                        if(afd.date_completed != '')
                            temp_KCA.Intake_Consents_date__c = getDateValue(afd.date_completed);
                        if(afd.completed_by != '')
                            temp_KCA.Intake_Consents_completed_by__c = afd.completed_by;
                    }
                    else if(afd.field_name.contains('F2F')){
                        if(afd.date_completed != '')
                            temp_KCA.F2F_Date_Completed__c = getDateValue(afd.date_completed);
                        if(afd.completed_by != '')
                            temp_KCA.F2F_completed_by__c = afd.completed_by;
                        if(afd.two_point_o_form == FALSE)
                            temp_KCA.Face_2_Face_2_0_Form__c = 'No';
                        else
                            temp_KCA.Face_2_Face_2_0_Form__c = 'Yes';
                    }
                    
                }*/
                
                try{
                    update temp_KCA;
                    returnString = 'KIPU Chart Audit for MRN : '+medicalRecordNumber+', updated successfully!!!';
                    integrationLineItemSetup(requestDataJSON,temp_KCA.id,returnString);
                }Catch(exception e){
                    returnString = 'KIPU Chart Audit for MRN : '+medicalRecordNumber+', Failed due to :::'+e.getMessage();
                    integrationLineItemSetup(requestDataJSON,temp_KCA.id,returnString);
                }        
            }else{
                if(requestDataJSON.audit_field_data.size()==0){
                    returnString = 'KIPU Chart Audit for MRN : '+medicalRecordNumber+', Not Update as No Audit Field Data Found in JSON';
                    integrationLineItemSetup(requestDataJSON,temp_KCA.id,returnString);
                }
            }
        }
        
    }
    
    public static void integrationLineItemSetup(KIPU_Audit_Wrapper requestDataJSON,Id auditId, String integrationMessage){
        KIPU_Integration_Support_Object__c kiso = new KIPU_Integration_Support_Object__c();
        kiso.Created_Date_Time__c = dateTime.Now();
        kiso.Inbound_JSON__c = string.valueOf(requestDataJSON);
        kiso.Integration_Outcome_Message__c = integrationMessage;
        kiso.KIPU_Chart_Audit__c = auditId;
        insert kiso;
    }
    
    public static DateTime getDateTimeValue(String dateTimeString){
        
        if(dateTimeString!=''){
            
            String[] dateTimeBreakdown = dateTimeString.trim().split(' ');//Breaking the field on the basis of Date and Time
            if(dateTimeBreakdown.size()>0){
                if(dateTimeBreakdown[0].contains('/')){
                    String[] dateBreakDown = dateTimeBreakdown[0].split('/');//Breakte the Date into Month, Day and Year
                    String[] timeBreakDown = dateTimeBreakdown[1].split(':');//Breaking the Time in Hour and Minutes
                    system.debug('dateBreakdown :::'+dateBreakdown);
                    system.debug('date month :::'+dateBreakdown[0]);
                    system.debug('date day :::'+dateBreakdown[1]);
                    system.debug('date year :::'+dateBreakdown[2]);
                    
                    system.debug('timeBreakdown :::'+timeBreakDown);
                    system.debug('time hour :::'+timeBreakDown[0]);
                    system.debug('time minute :::'+timeBreakDown[1]);
                    
                    dateTime dateTimeFieldValue = DateTime.newInstance(integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()),integer.valueOf(timeBreakDown[0].trim()),integer.valueOf(timeBreakDown[1].trim()),0);
                    system.debug('dateTimeFieldValue ::::'+dateTimeFieldValue);
                    
                    return dateTimeFieldValue;
                }
                else if(dateTimeBreakdown[0].contains('-')){
                    String[] dateBreakDown = dateTimeBreakdown[0].split('-');//Breakte the Date into Month, Day and Year
                    String[] timeBreakDown = dateTimeBreakdown[1].split(':');//Breaking the Time in Hour and Minutes
                    system.debug('dateBreakdown :::'+dateBreakdown);
                    system.debug('date year :::'+dateBreakdown[0]);
                    system.debug('date month :::'+dateBreakdown[1]);
                    system.debug('date day :::'+dateBreakdown[2]);
                    
                    system.debug('timeBreakdown :::'+timeBreakDown);
                    system.debug('time hour :::'+timeBreakDown[0]);
                    system.debug('time minute :::'+timeBreakDown[1]);
                    
                    dateTime dateTimeFieldValue = DateTime.newInstance(integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()),integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(timeBreakDown[0].trim()),integer.valueOf(timeBreakDown[1].trim()),0);
                    system.debug('dateTimeFieldValue ::::'+dateTimeFieldValue);
                    
                    return dateTimeFieldValue;
                }
            }
        }
        
        return null;
    }
    
    public static Date getDateValue(String dateString){
        
        if(dateString!=''){
            
            String[] dateBreakdown = dateString.split('/');//Breakte the Date into Month, Day and Year
            if(dateBreakdown.size()>0){
                system.debug('dateBreakdown :::'+dateBreakdown);
                system.debug('date month :::'+dateBreakdown[0]);
                system.debug('date day :::'+dateBreakdown[1]);
                system.debug('date year :::'+dateBreakdown[2]);
                
                Date dateFieldValue = Date.newInstance(integer.valueOf(dateBreakdown[2].trim()),integer.valueOf(dateBreakdown[0].trim()),integer.valueOf(dateBreakdown[1].trim()));
                system.debug('dateFieldValue ::::'+dateFieldValue);
                return dateFieldValue;
            }
        }
        
        return null;
    }
    
    
    
    /*public static String getFormatedJSONValue(String data){
        
        if(data!=''){
            
            String modified_data = data.replace('1_case_manager', 'case_manager').replace('1_primary_therapist','primary_therapist');
            Map<String,String> requestData = (Map<String,String>)JSON.deserialize(modified_data,Type.forName('Map<String,String>'));
            String careTeamData_temp = requestData.get('Care_Team_Data').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':current_ur_loc=>','"current_ur_loc":').replace(':discharge_date=>','"discharge_date":').replace(':"case_manager"=>','"case_manager":').replace(':"primary_therapist"=>','"primary_therapist":').replace(':bed=>','"bed":').replace(':program=>','"program":').replace(':current_clinical_loc=>','"current_clinical_loc":').replace('[[{','[{').replace('}]]','}]');
            String careTeamData = '';
            if(requestData.get('Sunshine_Center') == 'Chapters Capistrano')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "discharge_date":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil}','');
            if(requestData.get('Sunshine_Center') == 'Willow Springs')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "discharge_date":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil}','');
            if(requestData.get('Sunshine_Center') == 'Monarch Shores')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil, "current_ur_loc":nil}','').replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil}','');
            if(requestData.get('Sunshine_Center') == 'Mountain Springs Recovery')
                careTeamData = careTeamData_temp.replace(', {"full_name":nil, "mr":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil, "current_ur_loc":nil}','').replace(', {"full_name":nil, "mr":nil, "current_ur_loc":nil, "case_manager":nil, "primary_therapist":nil, "bed":nil, "discharge_date":nil}','');
            
            if(careTeamData.containsOnly('nil'))
                careTeamData = careTeamData.replace('nil','""');
            
            String billingItemsLab = '';
            if(requestData.get('Billable_Items_Labs').contains('[[]]')){
                billingItemsLab = requestData.get('Billable_Items_Labs').replace('[[]]','[]');
            }else{
                billingItemsLab = requestData.get('Billable_Items_Labs').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':specimen_id=>','"specimen_id":').replace(':vendor=>','"vendor":').replace(':specimen_source=>','"specimen_source":').replace(':collected=>','"collected":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsLab.containsOnly('nil'))
                billingItemsLab = billingItemsLab.replace('nil','""');
            
            String billingItemsEvaluations = '';
            if(requestData.get('Billable_Items_Evaluations').contains('[[]]')){
                billingItemsEvaluations = requestData.get('Billable_Items_Evaluations').replace('[[]]','[]');
            }else{
                billingItemsEvaluations = requestData.get('Billable_Items_Evaluations').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':evaluation=>','"evaluation":').replace(':signed_by=>','"signed_by":').replace(':started=>','"started":').replace(':ended=>','"ended":').replace(':duration=>','"duration":').replace(':authorizations=>','"authorizations":').replace(':status=>','"status":').replace(':completed_at=>','"completed_at":').replace(':evaluation_id=>','"evaluation_id":').replace(':template_id=>','"template_id":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsEvaluations.containsOnly('nil'))
                billingItemsEvaluations = billingItemsEvaluations.replace('nil','""');
            
            string billingItemsSessions = '';
            if(requestData.get('Billable_Items_Sessions').contains('[[]]')){
                billingItemsSessions = requestData.get('Billable_Items_Sessions').replace('[[]]','[]');
            }else{
                billingItemsSessions = requestData.get('Billable_Items_Sessions').replace(':full_name=>','"full_name":').replace(':mr=>','"mr":').replace(':session=>','"session":').replace(':topic=>','"topic":').replace(':provider=>','"provider":').replace(':started=>','"started":').replace(':ended=>','"ended":').replace(':duration=>','"duration":').replace(':attended=>','"attended":').replace(':absent=>','"absent":').replace(':authorizations=>','"authorizations":').replace(':status=>','"status":').replace(':completed_at=>','"completed_at":').replace(':session_id=>','"session_id":').replace(':template_id=>','"template_id":').replace(':current_ur_loc=>','"current_ur_loc":').replace('[[{','[{').replace('}]]','}]');
            }
            if(billingItemsSessions.containsOnly('nil'))
                billingItemsSessions = billingItemsSessions.replace('nil','""');
            
            String tempJSON = '{"Sunshine_Center":"'+requestData.get('Sunshine_Center')+'","Snapshot_Date":"'+requestData.get('Snapshot_Date')+'","Care_Team_Data":'+careTeamData+',"Billable_Items_Labs":'+billingItemsLab+',"Billable_Items_Evaluations":'+billingItemsEvaluations+',"Billable_Items_Sessions":'+billingItemsSessions+'}';
            
            return tempJSON;
        }
        
        return null;
    }
    */
    
}