public class KIPU_Snapshot_Wrapper {

    public String Sunshine_Center;
    public String Snapshot_Date;
    public List<Care_Team_Data> Care_Team_Data;
    public List<Billable_Items_Labs> Billable_Items_Labs;
    public List<Billable_Items_Evaluations> Billable_Items_Evaluations;
    public List<Billable_Items_Sessions> Billable_Items_Sessions;

    public class Care_Team_Data {
        public String full_name;
        public String mr;
        public String current_ur_loc;
        public String discharge_date;
        public String case_manager;
        public String primary_therapist;
        public String bed;
    }

    public class Billable_Items_Sessions {
        public String full_name;
        public String mr;
        public String session;
        public String topic;
        public String provider;
        public String started;
        public String ended;
        public Double duration;
        public Integer attended;
        public Integer absent;
        public String authorizations;
        public String status;
        public String completed_at;
        public Integer session_id;
        public String template_id;
    }

    public class Billable_Items_Labs {
        public String full_name;
        public String mr;
        public String specimen_id;
        public String vendor;
        public String specimen_source;
        public String collected;
    }

    public class Billable_Items_Evaluations {
        public String full_name;
        public String mr;
        public String evaluation;
        public String signed_by;
        public String started;
        public String ended;
        public Double duration;
        public String authorizations;
        public String status;
        public String completed_at;
        public Integer evaluation_id;
        public Integer template_id;
    }

    
    public static KIPU_Snapshot_Wrapper parse(String json) {
        return (KIPU_Snapshot_Wrapper) System.JSON.deserialize(json, KIPU_Snapshot_Wrapper.class);
    }
}