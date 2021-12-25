public with sharing class clockOpportunity {
    
    String idr = System.currentPageReference().getParameters().get('id');
    string urlr = 'https://c.na37.visual.force.com/resource/1478304806000/dg';
    DateTime tall,timePst;    
    Boolean flag;    
    String temp,tempw,temph,tempm,sDate,ap,s1,s2,m1,m2,h1,h2,dt;
    Map<String,Integer> timeZoneHoursMap = new Map<String,Integer>();
    Map<String,String> stateTimeZoneMap = new Map<String,String>();
    
    public clockOpportunity(ApexPages.StandardController controller) {
    
        for(State_Abbreviation_Mapping__c sam : State_Abbreviation_Mapping__c.getAll().values()){
            stateTimeZoneMap.put(sam.name,sam.Time_Zone__c);
        }
        
        timeZoneHoursMap.put('Atlantic Standard Time',-4);
        timeZoneHoursMap.put('Eastern Standard Time',-5);
        timeZoneHoursMap.put('Central Standard Time',-6);
        timeZoneHoursMap.put('Mountain Standard Time',-7);
        timeZoneHoursMap.put('Pacific Standard Time',-8);
        timeZoneHoursMap.put('Alaskan Standard Time',-9);
        timeZoneHoursMap.put('Hawaii-Aleutian Standard Time',-10);
        timeZoneHoursMap.put('Samoa standard time',-11);
        timeZoneHoursMap.put('Chamorro Standard Time',-10);
        
        
        /*if(!userInfo.getTimeZone().getDisplayName().contains('Standard')){
            
            
            timeZoneHoursMap.put('Atlantic Standard Time',-3);
            timeZoneHoursMap.put('Eastern Standard Time',-4);
            timeZoneHoursMap.put('Central Standard Time',-5);
            timeZoneHoursMap.put('Mountain Standard Time',-6);
            timeZoneHoursMap.put('Pacific Standard Time',-7);
            timeZoneHoursMap.put('Alaskan Standard Time',-8);
            timeZoneHoursMap.put('Hawaii-Aleutian Standard Time',-9);
            timeZoneHoursMap.put('Samoa standard time',-10);
            timeZoneHoursMap.put('Chamorro Standard Time',-9);
        }else{
                
        }*/
    }
    
    Public PageReference UserTime() {
        flag = false;  
        geta(); 
        return null;
    }
    
    Public PageReference ContactTime() {
        flag = true;  
        geta(); 
        return null;
    }
    
    public string geta() {
        //tall = dateTime.newInstanceGmt(Datetime.now().Date(),Datetime.now().Time());
        tall = dateTime.now();
        system.debug('user time zone :::'+userInfo.getTimeZone());
        system.debug('stateTimeZoneMap'+stateTimeZoneMap);
        system.debug('tall :::'+tall);
        system.debug('date time now :::'+dateTime.now());
        Opportunity opp = [select id, State__c from Opportunity where id=:idr];
        if(opp.state__c!= null && opp.state__c!= '(Choose One)'){
            if(flag == true){
                datetime newDatem;
                if(stateTimeZoneMap.containsKey(opp.State__c)){

                    sDate =tall.format('hh:mm:ss a MM-dd-yyyy',stateTimeZoneMap.get(opp.State__c));
                }
                system.debug('sDate ::::'+sDate);
                //sDate = newDatem.formatgmt('hh:mm:ss a MM-dd-yyyy');
            }else{
                //system.debug('sDate :::'+tall.addHours(-8));
                sDate = tall.format('hh:mm:ss a MM-dd-yyyy');//Because the callers would always be in PST and the Current User Context is EST
            }
            s2 = sDate.substring(7,8);
            s1 = sDate.substring(6,7);
            m2 = sDate.substring(4,5);
            m1 = sDate.substring(3,4);
            h2 = sDate.substring(1,2);
            h1 = sDate.substring(0,1);
            ap = sDate.substring(9,11);
            dt = sDate.substring(11);
            return dt;
        }
        return null;
    }   
    
    public string gets1() {  
        return urlr+s1;  
    }   
    
    public string gets2() { 
        return urlr+s2;  
    }  
    
    public string getm1() { 
        return urlr+m1;  
    } 
    
    public string getm2() { 
        return urlr+m2;  
    } 
    
    public string geth1() { 
        return urlr+h1;  
    }  
    
    public string geth2() {  
        return urlr+h2; 
    } 
    
    public string getampm() { 
        return urlr+ap;
    }   
}