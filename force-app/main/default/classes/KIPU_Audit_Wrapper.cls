public class KIPU_Audit_Wrapper {

    public String medical_record_number;
    public string Intake_Consents_date;
    public string Intake_Consents_completed_by;
    public string F2F_Date_Completed;
    public string F2F_completed_by;
    public string two_point_o_form;
    public string HP_date_completed;
    public string HP_is_completed_by;
    public List<audit_field_data> audit_field_data;
    
    public class audit_field_data {
        public String field_name;
        public String date_completed;
        public String completed_by;
        public Boolean two_point_o_form;
    }

    public static KIPU_Audit_Wrapper parse(String json) {
        return (KIPU_Audit_Wrapper) System.JSON.deserialize(json, KIPU_Audit_Wrapper.class);
    }
}