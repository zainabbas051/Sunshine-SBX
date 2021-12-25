public class GoogleMAPAPIWrapper{

    public cls_results[] results;
    public String status;   //OK
    public cls_opening_hours opening_hours;
    
    public class cls_results {
        public String business_status;  //OPERATIONAL
        public String formatted_address;    //1111 Harvard Ave, Seattle, WA 98122, United States
        public String name; //Seattle First Baptist Church
        public String place_id;
        public string formatted_phone_number; 
       
        
        
    
    }
    
    public class cls_opening_hours {
        
        public boolean open_now;
    }
}