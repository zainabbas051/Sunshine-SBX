/*    
    this class is used in view order form. to show order and related records.
*/
public class OrderView{
    public Order__c order{get;set;}
    public Taper__c taper{get;set;}
    public list<wrapperTLI> lstTLI{get;set;}
    
    
    public OrderView(Order__c ord, Taper__c tap, list<wrapperTLI> wrapT){
        order = ord;
        taper = tap;
        lstTLI= wrapT;
    }
    
    public class wrapperTLI{
        public string medication{get;set;}
        public string route{get;set;}
        public string dosage{get;set;}
        public string dose{get;set;}
        public string frequency{get;set;}
        public list<string> lstFrequency{get;set;}
        public decimal day{get;set;}
        
        public wrapperTLI(string med, string r, string d, string s, string f,list<string> lst, decimal daynum){
        
            medication = med;
            route = r;
            dosage = d;
            dose = s;
            frequency = f;
            lstFrequency = lst; 
            day = daynum;   
        }
    }
    
    public class MedicationInfo{
        public string medicine{get;set;}
        public string dose{get;set;}
        public string route{get;set;}
        public string dosageForm{get;set;}
        public string frequency{get;set;}
        public decimal dispenseAmt{get;set;}
        public string refills{get;set;}
        
        public MedicationInfo(string medi, string d, string rt, string dform, string freq, decimal damt, string ref){
            medicine = medi;
            dose = d;
            route = rt;
            dosageForm = dform;
            frequency = freq;
            dispenseAmt = damt;
            refills = ref;
        }
        
    }
    
    public class OrderPDF{
        public Order__c order{get;set;}
        public list<MedicationInfo> lstMedications{get;set;}
        
        public OrderPDF (Order__c ord, list<MedicationInfo> lstMedi){
            order = ord;
            lstMedications = lstMedi;
        }
    }
}