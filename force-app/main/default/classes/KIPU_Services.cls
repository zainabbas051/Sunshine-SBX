global class KIPU_Services{
    
    webservice static string CreatePatient( id OpportunityID){
        
        Opportunity opp = [select id,Sunshine_Center_Name__c, Client_DOB__c,
        Marital_Status__c, Address__c, Address_2__c, City__c, Zip_Code__c, State__c, Current_Employer__c, KIPU_MRN__c, Phone__c,
         Race__c, Ethnicity__c, SSN_Last_4__c, Email__c, Date_Time_Lead_Was_Created__c,   Additional_Notes__c, 
        Bed__c, CloseDate,Name, Date_of_Last_Use_Drug_1__c, Sex__c , Opening_Agent__r.name,
        Family_Contact_Name__c, Family_Contact_Phone__c,Family_Contact_Relationship__c, Family_Contact_Email__c, Family_History_Notes__c,
         Family_Contact_Phone_2__c,Family_Contact_Relationship_2__c, Family_Contact_Email_2__c, Family_Contact_Name_2__c,
         Family_Contact_Phone_3__c,Family_Contact_Relationship_3__c, Family_Contact_Email_3__c, Family_Contact_Name_3__c
         from Opportunity where id=: OpportunityID];
        
        Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(opp.Sunshine_Center_Name__c);
        
        /*if(opp.KIPU_Chart_Created__c){
            return 'Chart is already created';
        }*/
        
        
        
        KIPU_APIs_Wrappers.kipudocument doc = new KIPU_APIs_Wrappers.kipudocument();
        doc.recipient_id = SC.KIPU_Access_ID__c;
        doc.sending_app_name = 'salesforce';
        
        KIPU_APIs_Wrappers.CreatePatient  CP = new KIPU_APIs_Wrappers.CreatePatient();
        
        CP.sending_app_patient_id = opp.id;
        list<string> lstOppName = opp.Name.split(' ');
       
        CP.first_name = (lstOppName.size()>1)?lstOppName[0]:'';
        CP.middle_name = '';
        CP.last_name = (lstOppName.size()>1)?lstOppName[1]:lstOppName[0];
        CP.preferred_name = opp.Name;
        //CP.dob = opp.Client_DOB__c==null?null:Date.valueof(opp.Client_DOB__c);
        CP.marital_status = opp.Marital_Status__c;
        //CP.patient_color_id; //blank
        //CP.location_id; blank
        CP.address_street = opp.Address__c;
        CP.address_street2 = opp.Address_2__c;
        CP.address_city = opp.City__c;
        CP.address_zip = opp.Zip_Code__c;
        CP.address_state = opp.State__c;
        //CP.occupation;blank
        CP.employer_name = opp.Current_Employer__c;
        //CP.employer_phone; blank
        CP.mr = '';
        CP.phone = opp.Phone__c;
        CP.alternate_phone = '';
        CP.race = opp.Race__c;
        CP.ethnicity = opp.Ethnicity__c;
        //CP.pre_admission_status;blank
        CP.admission_date = opp.CloseDate;
        CP.discharge_date = opp.CloseDate.addDays(30);
        CP.sobriety_date = opp.Date_of_Last_Use_Drug_1__c;
        CP.ssn = opp.SSN_Last_4__c;
        CP.gender = opp.Sex__c;
        CP.email = opp.Email__c;
        CP.first_contact_date = Date.valueof(opp.Date_Time_Lead_Was_Created__c);
        CP.first_contact_rep_on_call = opp.Opening_Agent__r.name;
        //CP.first_contact_name ;
        CP.first_contact_information = opp.Additional_Notes__c;
        //CP.first_contact_relationship 
        //CP.referrer_id;
        //CP.referrer_name;
        //CP.discharge_to_id;
        //CP.discharge_to_name;
        //CP.payment_method;
        CP.bed_name = string.valueof(opp.Bed__c);
        CP.anticipated_discharge_date = opp.CloseDate.addDays(30);
        
        list<KIPU_APIs_Wrappers.InsuranceAttributes> lstInsuranceAttr = new list<KIPU_APIs_Wrappers.InsuranceAttributes>();
        
        //select insurance info where status is primary
        list<Insurance_Information__c> lstInsuranceInfo = [select id, Insurance_Status__c, Insurance_Policy__c, 
        Insurance_Provider_Phone_Number__c, Insurance_Type__c, Group_Number__c, Subscriber_Name__c, Subscriber_DOB__c, 
        Employer__c, SSN_Last_4__c, Address__c, City__c, Zip_Code__c, State__c, Country__c , Insurance_Providers__c          
        from Insurance_Information__c where Opportunity__c =: opp.id];
        
        Insurance_Information__c InsInfo = new Insurance_Information__c();
        if(lstInsuranceInfo.size()>1){
            for(Insurance_Information__c ii : lstInsuranceInfo){
                if(ii.Insurance_Status__c == 'Primary')
                    InsInfo = ii;
            }
        }
        else
            InsInfo = (lstInsuranceInfo.size()>0)?lstInsuranceInfo[0]:new Insurance_Information__c();
        
        KIPU_APIs_Wrappers.InsuranceAttributes ins = new KIPU_APIs_Wrappers.InsuranceAttributes();
        ins.insurance_company = InsInfo.Insurance_Providers__c;
        ins.policy_no = InsInfo.Insurance_Policy__c;
        ins.insurance_phone = InsInfo.Insurance_Provider_Phone_Number__c;
        ins.insurance_type = InsInfo.Insurance_Type__c;
        //ins.insurance_plan_type;
        //ins.kipu_insurance_id;
        ins.group_ID = InsInfo.Group_Number__c;
        /*
        ins.notes;
        ins.old_deductible;
        ins.old_co_payment;
        ins.migrating;
        ins.payer_synonym;
        ins.deductible;
        ins.exclude_from_scheduling;
        ins.rx_group;
        ins.rx_bin;
        ins.rx_pcn;
        ins.rx_name;
        ins.rx_phone;
        ins.subscriber_relationship;
        */
        list<string> subsName = (InsInfo.Subscriber_Name__c!='' && InsInfo.Subscriber_Name__c!=null)?InsInfo.Subscriber_Name__c.split(' '):new list<string>();
        if(subsName.size()>0){
            ins.subscriber_first_name = (subsName.size()>1)?subsName[0]:'';
            ins.subscriber_last_name = (subsName.size()>1)?subsName[1]:subsName[0];
        }
        //ins.subscriber_DOB = (InsInfo.Subscriber_DOB__c!='' && InsInfo.Subscriber_DOB__c!=null)?Date.valueof(InsInfo.Subscriber_DOB__c):null;
        ins.subscriber_employer = InsInfo.Employer__c;
        //ins.subscriber_gender ;
        ins.subscriber_name = InsInfo.Subscriber_Name__c;
        ins.subscriber_SSN = InsInfo.SSN_Last_4__c;
        ins.subscriber_address_street = InsInfo.Address__c;
        //ins.subscriber_address_street2;
        ins.subscriber_address_city = InsInfo.City__c;
        ins.subscriber_address_zip = InsInfo.Zip_Code__c;
        ins.subscriber_address_state = InsInfo.State__c;
        ins.subscriber_address_country = InsInfo.Country__c;
        
        
        list<KIPU_APIs_Wrappers.PatientContactsAttributes> lstPatientContactAttr = new list<KIPU_APIs_Wrappers.PatientContactsAttributes>();
        KIPU_APIs_Wrappers.PatientContactsAttributes pc;
        // family contact info fields.
        if(opp.Family_Contact_Name__c !=''){
            pc = new KIPU_APIs_Wrappers.PatientContactsAttributes();
            pc.full_name = opp.Family_Contact_Name__c ;
            pc.phone = opp.Family_Contact_Phone__c;
            pc.address = '';
            pc.notes = opp.Family_History_Notes__c;
            pc.email = opp.Family_Contact_Email__c;
            pc.contact_type = '';
            pc.relationship = opp.Family_Contact_Relationship__c;
            lstPatientContactAttr.add(pc);
        }
        if(opp.Family_Contact_Name_2__c!=''){
            pc = new KIPU_APIs_Wrappers.PatientContactsAttributes();
            pc.full_name = opp.Family_Contact_Name_2__c ;
            pc.phone = opp.Family_Contact_Phone_2__c;
            pc.address = '';
            pc.notes = opp.Family_History_Notes__c;
            pc.email = opp.Family_Contact_Email_2__c;
            pc.contact_type = '';
            pc.relationship = opp.Family_Contact_Relationship_2__c;
            lstPatientContactAttr.add(pc);
        }
        if(opp.Family_Contact_Name_3__c!=''){
            pc = new KIPU_APIs_Wrappers.PatientContactsAttributes();
            pc.full_name = opp.Family_Contact_Name_3__c ;
            pc.phone = opp.Family_Contact_Phone_3__c;
            pc.address = '';
            pc.notes = opp.Family_History_Notes__c;
            pc.email = opp.Family_Contact_Email_3__c;
            pc.contact_type = '';
            pc.relationship = opp.Family_Contact_Relationship_3__c;
            lstPatientContactAttr.add(pc);
        }
        
        CP.insurances_attributes = lstInsuranceAttr ;
        CP.patient_contacts_attributes = lstPatientContactAttr ;
        
        doc.data = CP;
        
        KIPU_APIs_Wrappers.createPatientMain CM = new KIPU_APIs_Wrappers.createPatientMain();
        CM.document = doc;
        
        string JSONString = System.JSON.serialize(CM );
        
        //call API
        HttpResponse res = KIPUIntegrationUtil.callKIPUAPI('/api/patients', 'application/json', JSONString, opp.Sunshine_Center_Name__c,'POST');
        if(res !=null){
        System.debug('MYDEBUG: RESPONSE STRING: ' + res.toString());
        System.debug('MYDEBUG: RESPONSE STATUS: '+res.getStatus());
        System.debug('MYDEBUG: STATUS_CODE:'+res.getStatusCode());
        System.debug('MYDEBUG: BODY:'+res.getBody());
       
        if(res.getStatus() == 'Created'){
            
            //opp.KIPU_Chart_Created__c = true;
            //opp.KIPU_Chart_Created_Date_Time__c = datetime.now();
            //opp.KIPU_Case_File_ID__c = '';
            //opp.KIPU_Status__c = 'Review Pending';
            update opp;
            
        }
        return res.getStatus();
        }
        return null;
        
        
    }
    
    
}