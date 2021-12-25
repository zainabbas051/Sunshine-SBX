public class Ctrl_CGDashboard {

public string UnscheduledDischarge_CC {
        get;
        set;
    }
public string UnscheduledDischarge_MS {
        get;
        set;
    }
public string UnscheduledDischarge_WS {
        get;
        set;
    }
public string UnscheduledDischarge_MSR {
        get;
        set;
    }
public string UnscheduledDischarge_Total {
        get;
        set;
    }
    
public string Discharge_Buckets_CC {
        get;
        set;
    }
    
public string Discharge_Buckets_MS {
        get;
        set;
    }
public string Discharge_Buckets_WS {
        get;
        set;
    }
public string Discharge_Buckets_MSR {
        get;
        set;
    }
public string Discharge_Buckets_Total {
        get;
        set;
    }
    
public Ctrl_CGDashboard(){


 Dashboard_Data__c d = [select id , Dashboard_Numbers__c from  Dashboard_Data__c limit 1];
 list<string> lstNumber = d.Dashboard_Numbers__c.split(';');
UnscheduledDischarge_CC = lstNumber[0];
UnscheduledDischarge_MS = lstNumber[1];
UnscheduledDischarge_WS = lstNumber[2];
UnscheduledDischarge_MSR = lstNumber[3];
UnscheduledDischarge_Total = lstNumber[4];
Discharge_Buckets_CC = lstNumber[5];
Discharge_Buckets_MS = lstNumber[6];
Discharge_Buckets_WS = lstNumber[7];
Discharge_Buckets_MSR = lstNumber[8];
Discharge_Buckets_Total = lstNumber[9];



}


}