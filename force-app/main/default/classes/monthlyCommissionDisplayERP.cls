//Test CLass : monthlyCommissionsCalculatorERPTest
public with sharing class monthlyCommissionDisplayERP{
    
    String month='';
    string year='';
    
    public monthlyCommissionDisplayERP(){
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(1,'January');
        monthMap.put(2,'February');
        monthMap.put(3,'March');
        monthMap.put(4,'April');
        monthMap.put(5,'May');
        monthMap.put(6,'June');
        monthMap.put(7,'July');
        monthMap.put(8,'August');
        monthMap.put(9,'September');
        monthMap.put(10,'October');
        monthMap.put(11,'November');
        monthMap.put(12,'December');
        
        setmonth(monthMap.get(date.today().month()));
        setyear(string.valueof(date.today().year()));
        monthlyCommissions();
    }
    
    public List<SelectOption> getMonths() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('January','January'));
        options.add(new SelectOption('February','February'));
        options.add(new SelectOption('March','March'));
        options.add(new SelectOption('April','April'));
        options.add(new SelectOption('May','May'));
        options.add(new SelectOption('June','June'));
        options.add(new SelectOption('July','July'));
        options.add(new SelectOption('August','August'));
        options.add(new SelectOption('September','September'));
        options.add(new SelectOption('October','October'));
        options.add(new SelectOption('November','November'));
        options.add(new SelectOption('December','December'));
        return options;
    }
    public String getmonth() {
       return month;
    }
    public void setmonth(String month) {
        this.month = month;
    }
    
    public List<SelectOption> getYears() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2017','2017'));
        options.add(new SelectOption('2018','2018'));
        options.add(new SelectOption('2019','2019'));
        options.add(new SelectOption('2020','2020'));
        
        return options;
    }
    public String getyear() {
       return year;
    }
    public void setyear(String year) {
        this.year = year;
    }
    
    public static decimal totalSCCommission{
        get{
            decimal total=0;
            if(seniorCounsellorList.size()>0){
                for(Monthly_Commisions__c mc : seniorCounsellorList){
                    total = total+mc.Total_Monthly_Commission__c;
                }
            }
            return total;
        }set;
    }
    
    public static decimal totalCSRCommission{
        get{
            decimal total=0;
            if(csrList.size()>0){
                for(Monthly_Commisions__c mc : csrList){
                    total = total+mc.Total_Monthly_Commission__c;
                }
            }
            return total;
        }set;
    }
    
    public static decimal totalMUCommission{
        get{
            decimal total=0;
            if(muList.size()>0){
                for(Monthly_Commisions__c mc : muList){
                    total = total+mc.Total_Monthly_Commission__c;
                }
            }
            return total;
        }set;
    }
    Public static list<Monthly_Commisions__c> seniorCounsellorList{
        get{
            if(seniorCounsellorList == null)
                seniorCounsellorList = new List<Monthly_Commisions__c>();
            return seniorCounsellorList;
        }set;
    }
    
    Public static list<Monthly_Commisions__c> csrList{
        get{
            if(csrList == null)
                csrList = new List<Monthly_Commisions__c>();
            return csrList;
        }set;
    }
    
    Public static list<Monthly_Commisions__c> muList{
        get{
            if(muList == null)
                muList= new List<Monthly_Commisions__c>();
            return muList;
        }set;
    }
    
    public static boolean displayManagementCommission{
        get{
            if(muList.size()>0){
                return true;
            }
            return false;
        }set;
    }
    
    public void monthlyCommissions(){
         csrList.clear();
         seniorCounsellorList.clear();
         //String queryMonth = month;
         For(Monthly_Commisions__c mc : [Select id, Month__c, Year__c, Total_Number_of_Rescued_Opportunities__c, Tier_1_Personal_Referral__c, Tier_1_Repeat_Business__c, Tier_1_Rescued__c,
                                         Tier_2_Personal_Referral__c, Tier_2_Repeat_Business__c, Tier_2_Rescued__c, Reduced_Commission__c,
                                        Total_Rescued_Commision__c, Type_of_User__c, User__r.Name, Total_Monthly_Commission__c, Total_Number_of_Smile_and_Dial_Opps__c
                                        from Monthly_Commisions__c
                                        Where Month__c =: month AND Year__c =: year]){
            
            if(mc.Type_of_User__c == 'CSR')
                csrList.add(mc);
            else if(mc.Type_of_User__c == 'Senior Counselor')
                seniorCounsellorList.add(mc);
            else
                muList.add(mc);
                                           
        }
        
    }
    
}