//test class : Temp_Lead_ServiceTest
//Test class: tempLeadCreationServiceTest
public class createLeadWrapper{
        
        public string tempString{get;set;}
        public string owner_id;
        public boolean lead_owner_is_queue;
        public string owner_queue_name;
        public string old_sf_id;
        public string first_name;
        public string last_name;
        public string intake_agent_id;
        public string client_dob;
        public string lead_source;
        public boolean monarch_shores_lead;
        public string external_referred_by;
        public string referral_agent_id;
        public boolean smile_and_dial;
        public boolean hmo_lead;
        public string lead_status;
        public string phone;
        public string email;
        public string preferred_contact;
        public string incoming_number;
        public boolean referral_verified;
        public string subscriber_name;
        public string Subscriber_First_Name;
        public string Subscriber_Last_Name;
        public string insurance_providers;
        public string insurance_policy;
        public string group_number;
        public string Insurance_Provider_Phone_Number;
        public string Subscriber_DOB;
        public string SSN_Last_4;
        public string Street_Address;
        public string Address_2;
        public string City;
        public string State;
        public string Zip_Code;
        public string Country;
        public string Employer;
        public string Call_Web;
        public Boolean Cash_Client;
        public Boolean OON_Residential;
        public Boolean In_Network_Residential;
        public Boolean OON_Partial_Hospitalization;
        public Boolean In_Network_Partial_Hospitalization;
        public Boolean JACHO_Required;
        public Boolean State_Licensed;
        public Boolean Free_Standing;
        public string Precertification_Number;
        public string Insurance_Notes;
        public decimal Percentage_Coverage_OON;
        public decimal Percent_Coverage_In_Network;
        public decimal In_Net_Deductible;
        public decimal OON_Deductible;
        public decimal In_Net_Deductible_Met;
        public decimal OON_Deductible_Met;
        public decimal OOP_Max_In_Net;
        public decimal OON_OOP_Max;
        public decimal OOP_Met_In_Net;
        public decimal OON_OOP_Met;
        public string Usual_and_Customary;
        public string Assignment_of_Benefits;
        public string Additional_Notes;
        public DateTime Created_Date_Time;
        public string Create_By_ID;
        public string Lead_Record_Type;
        public string RT_Source;
        public string RT_Channel;
        public string Campaign;
        public string Hubspot_Source;
        public string Hubspot_Source_Data_1;
        public string Hubspot_Source_Data_2;
        public string Company;
        
        public list<feedItems> feedItemsList;
        
        public class feedItems{
            public string parentId{get;set;}
            public string insertedById{get;set;}
            public string type{get;set;}
            public string title{get;set;}
            public string body{get;set;}
            public string status{get;set;}
            
            public feedItems(string parentId, string insertedById, string type, string title, string body, string status){
                this.parentId = parentId;
                this.insertedById = insertedById;
                this.type = type;
                this.title = title;
                this.body = body;
                this.status = status;
            }
        }
    
    
}