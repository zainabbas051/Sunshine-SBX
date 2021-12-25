public class KIPU_APIs_Wrappers{
    
    public class createPatientMain{
        public kipudocument document;
    }
    public class kipudocument{
    
        public string recipient_id;
        public string sending_app_name;
        public CreatePatient data;
    }
    
    public class CreatePatient{
    
        public string sending_app_patient_id;
        public string first_name ;
        public string middle_name;
        public string last_name ;
        public string preferred_name;
        public Date dob;
        public string marital_status ;
        public string patient_color_id;
        public string location_id;
        public string address_street;
        public string address_street2;
        public string address_city;
        public string address_zip;
        public string address_state ;
        public string occupation;
        public string employer_name;
        public string employer_phone;
        public string mr;
        public string phone;
        public string alternate_phone;
        public string race;
        public string ethnicity;
        public string pre_admission_status;
        public Date admission_date;
        public Date discharge_date;
        public Date sobriety_date;
        public string ssn;
        public string gender;
        public string email;
        public Date first_contact_date;
        public string first_contact_rep_on_call;
        public string first_contact_name;
        public string first_contact_information;
        public string first_contact_relationship;
        public string referrer_id;
        public string referrer_name;
        public string discharge_to_id;
        public string discharge_to_name;
        public string payment_method;
        public string bed_name;
        public Date anticipated_discharge_date;
        public list<InsuranceAttributes> insurances_attributes;
        public list<PatientContactsAttributes> patient_contacts_attributes;
        
        /*
        public CreatePatient(string sending_app_patient_id,string first_name ,string middle_name,string last_name ,
        string preferred_name,Date dob,string marital_status ,string patient_color_id,string location_id,string address_street,
        string address_street2,string address_city,string address_zip,string address_state ,string occupation,string employer_name,
        //string employer_phone,string mr,string phone,string alternate_phone,string race,string ethnicity,string pre_admission_status,
        //Date admission_date,Date discharge_date,Date sobriety_date,string ssn,string gender,string email,Date first_contact_date,
        string first_contact_rep_on_call,string first_contact_name,string first_contact_information,string first_contact_relationship,
        string referrer_id,string referrer_name,string discharge_to_id,string discharge_to_name,string payment_method,string bed_name,
        Date anticipated_discharge_date,list<InsuranceAttributes> insurances_attributes,
        list<PatientContactsAttributes> patient_contacts_attributes){
        
            
        }*/
    }
    
    public class InsuranceAttributes {
        
        public string insurance_company;
        public string policy_no;
        public string insurance_phone;
        public string insurance_type;
        public string insurance_plan_type;
        public string kipu_insurance_id;
        public string group_ID;
        public string notes;
        public string old_deductible;
        public string old_co_payment;
        public boolean migrating;
        public string payer_synonym;
        public string deductible;
        public boolean exclude_from_scheduling;
        public string rx_group;
        public string rx_bin;
        public string rx_pcn;
        public string rx_name;
        public string rx_phone;
        public string subscriber_relationship;
        public string subscriber_first_name;
        public string subscriber_last_name;
        public Date subscriber_DOB;
        public string subscriber_employer;
        public string subscriber_gender;
        public string subscriber_name;
        public string subscriber_SSN;
        public string subscriber_address_street;
        public string subscriber_address_street2;
        public string subscriber_address_city;
        public string subscriber_address_zip;
        public string subscriber_address_state;
        public string subscriber_address_country;
    }
    
    public class PatientContactsAttributes{
        public string full_name;
        public string phone;
        public string address;
        public string notes;
        public string email;
        public string contact_type;
        public string relationship;
    }
    /*
    public static KIPU_APIs_Wrappers parse(String json) {
        return (KIPU_APIs_Wrappers) System.JSON.deserialize(json, KIPU_APIs_Wrappers.class);
    }*/
    
    public class PatientsData{
        public list<PatientData> patients;
    }
    
    public class PatientData{
        public string casefile_id;
        public string first_name;
        public string middle_name;
        public string last_name;
        public string dob;
        public string admission_date;
        public string discharge_date;
        public string mr_number;
        public string payment_method_category;
        public string created_at;
        public string last_updated_at;
        public string diagnosis_codes;
        public string insurance_company;
        public string phone;
        public string level_of_care;
        public string program;
        public string bed_name;
        public string room_name;
        public string building_name;
        public string location_id;
        public string location_name;
        public list<apps> external_apps;                 
    }
    
    public class apps{
        public string external_app_name;
        public string external_app_patient_id;
    }
}