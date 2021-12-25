/*
    author: Huma Zafar
    this class is for creating standard and manual orders and their related MARs
*/
public class OrderUtil{
    
    
    ///////CREATE MANUAL ORDER///////////////////////
    public static Order__c returnManualOrder(Order__c order, id clientChartId){
        order.Client_Chart__c = clientChartId;
        order.Status__c = 'Under Review';
        order.Pharmacy_Status__c = 'Not Sent';
        order.Order_Type__c = 'Manual';
        order.End_Date__c = order.Start_Date__c.addDays(Integer.valueof(order.Duration__c-1));
        //order.Order_By__c= order.Order_By__c;  
        return order;
    }
    
    public static Order_Line_Item__c returnOLI(Id OrderId, Taper_Line_Item__c TLI){
        
        Order_Line_Item__c OLI = new Order_Line_Item__c();
        OLI.Day__c = TLI.Duration_In_Days__c;
        OLI.Dosage_Form__c = TLI.Dosage_Form__c;
        OLI.Dose__c = TLI.Strength__c;
        OLI.Frequency__c = TLI.Frequency__c ;
        OLI.Medicine__c = TLI.Medicine__c;
        OLI.No_of_Refills__c = TLI.No_of_Refills__c;
        OLI.Order__c = OrderId;
        OLI.Route__c = TLI.Route__c;
        OLI.Status__c = 'Open';
        OLI.Taper_Line_Item__c = TLI.Id;
        OLI.Warning__c = TLI.Taper__r.Warning__c;
        //OLI.MARS_ID__c = MARSId;
        return OLI;
    }
    /*
    public static Order_Line_Item__c returnOLI(Event a){
        
        Order_Line_Item__c OLI = new Order_Line_Item__c();
        OLI.Day__c = a.Day__c;
        //OLI.Dosage_Form__c = a.Dosage_Form__c;
        OLI.Dose__c = a.Strength__c;
        OLI.Frequency__c = a.Frequency__c ;
        OLI.Medicine__c = a.Medicine__c;
        //OLI.No_of_Refills__c = a.No_of_Refills__c;
        OLI.Order__c = a.whatid;
        OLI.Route__c = a.Route_of_Delivery__c ;
        OLI.Status__c = 'Open';
        OLI.Taper_Line_Item__c = a.Taper_Line_Item__c;
        //OLI.MARS_ID__c = a.id;
        //OLI.Due_Date_Time__c = a.StartDateTime;
        return OLI;
    }*/
    
    ///////CREATE MARS FOR MANUAL ORDERS///////////
    public static Event returnManualMARs(Order__c order, Id ccId){
        
        TimeZone tz = UserInfo.getTimeZone();
        
        list<string> freq = order.Frequency__c.split(' : ');
        system.debug(freq );
        system.debug(freq[0] );
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);
        
         system.debug('creating event');
            
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;
        
        t.Medicine__c = order.Medicine__c;
        t.PRN__c = order.PRN__c;
        t.Strength__c = order.Dose__c;
        t.Route_of_Delivery__c = order.Route__c;
        t.Frequency__c = order.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = ccId;
        t.Day__c = 1;
        t.Warning__c = order.Warnings__c;
        if(FM.Time__c ==null){
            //creating Q MARs  
            if(order.Send_To_Pharmacy__c == 'Yes' ){                     
                t.StartDateTime =Datetime.now();
                
                t.EndDateTime =Datetime.now();
            }
            else{
                t.StartDateTime = order.Start_Date__c;
                
                t.EndDateTime = order.Start_Date__c;                
            }
            list<string> FMobj = FM.Name.split(' ');
            system.debug(FMobj );
            system.debug(FMobj[0]);
            if(FMobj.size()>0){
                integer rem =  integer.valueof(order.Duration__c) * (24/(integer.valueof(FMobj[0].replace('Q',''))));
                system.debug(rem );
                t.Remaining__c = rem- 1;
            }
            //return t;
        }
        else{
            //creating X MARs
            string timeFM = FM.Time__c;
            list<string> lstTimeOld = FM.Time__c.split(',');
            
            DateTime dt =  (order.Send_To_Pharmacy__c == 'Yes' )?Datetime.now():order.Start_Date__c;
            system.debug(dt);
            dt = dt.addSeconds((tz.getOffset(dt)/1000));
            system.debug(dt);
            integer currentHour = dt.hourGMT();
            integer currentMin = dt.minuteGMT();

            system.debug('*******'+currentHour );
            integer missedhour = (integer)(double.valueof(FM.Missed__c)*(60))/60;
            if(order.Frequency__c.startswith('QDaily')){
                timeFM = QDailyFM(lstTimeOld, missedhour, currentHour,timeFM);
            }
            else{
                for(integer i=0; i<lstTimeOld .size();i++){
                    
                    system.debug(lstTimeOld[i]  );
                    system.debug(missedhour);
                    if(lstTimeOld.size()>1 && (((integer.valueof(lstTimeOld[i])*60) + (missedhour*60) )< ((currentHour*60)+currentMin) )
                    ){                    
                        timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                        timeFM += ','+lstTimeOld[i];
                        
                    }
                    else{
                        break;
                    }
                }
            }
            system.debug(timeFM );
            list<string> lstTime = timeFM.split(',');
            
            integer minutes = integer.valueof(double.valueof(FM.Missed__c)*(60));
            system.debug(minutes );
           
            
            Date taskDate =  Date.valueof(dt);
            Time taskTime = Time.newInstance(integer.valueof(lstTime[0]), 0, 0, 0);

            DateTime taskDateTime = DateTime.newinstance(taskDate ,taskTime );
            //taskDateTime = taskDateTime.addSeconds((tz.getOffset(taskDateTime )/1000));
            
            DateTime CurrentDatetime = Datetime.now();
            CurrentDatetime = CurrentDatetime.addSeconds((tz.getOffset(CurrentDatetime)/1000));
            
            system.debug(taskDateTime);
            system.debug(CurrentDatetime );

            if(taskDateTime < CurrentDatetime ){
               taskDateTime = taskDateTime.addDays(1);
            }
            t.StartDateTime = taskDateTime ;
            
            t.EndDateTime = taskDateTime ;
            string RemainingTimeStr = timeFM.replaceFirst(lstTime[0]+',','');
            for(integer i=1; i<order.Duration__c; i++){
                RemainingTimeStr += ','+timeFM ;
            }
            
            //t.Remaining_Time__c = RemainingTimeStr ;
            
            //update remaining time in order
            Order__c o = new Order__c();
            o.Remaining_Time__c  = RemainingTimeStr ;
            o.id = order.id;
            update o;
            
            t.Remaining__c = integer.valueof(order.Duration__c) * FM.Count__c - 1;
        //    return t;
            
            t.Missed_Time__c = t.StartDateTime.addMinutes(minutes );
        }
        double hourVal = FM.Hide_Button__c;
        t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0))));
        
            return t;
    }
    
    public static string QDailyFM(list<string> lstTimeOld , integer missedhour, integer currentHour,string timeFM){
        missedhour =0;
        for(integer i=0; i<lstTimeOld .size();i++){
            
            system.debug(lstTimeOld[i]  );
            system.debug(missedhour);
            if(lstTimeOld.size()>1 && ((integer.valueof(lstTimeOld[i]  ) + missedhour )<= currentHour )
            ){                    
                timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                timeFM += ','+lstTimeOld[i];
                
            }
            else{
                break;
            }
        }
        return timeFM.split(',')[0];
    }
    
    //////////CREATE STANDARD ORDER/////////////
    ///////// FOR TAPER, PRN  & OTHER///////////////
    public static Order__c returnStandardOrder(Order__c ord, id clientChartId, string orderType, Id OrderedBy, string Via, Id TaperId){
        
        ord.Client_Chart__c = clientChartId;
        ord.Status__c = 'Under Review';
        ord.Pharmacy_Status__c = 'Not Sent';
        ord.Order_Type__c = orderType;
        //ord.Start_Date__c = ord.Start_Date__c;
        system.debug(OrderedBy);
        //ord.End_Date__c = Date.valueof(wt.ord.Start_Date__c).addDays(Integer.valueof(wt.taper.Number_of_Days__c-1));
        ord.Order_By__c= OrderedBy;//OrderedBy;
        ord.Requested_via__c =  Via;
        ord.Taper__c =TaperId;
        return ord;
    }
    
    
    
    ////////CREATE MARS FOR STANDARD ORDERS//////
    ///////// FOR TAPER  ///////////////
    public static Event returnStandardMARs(Order_Line_Item__c TLI, Order__c order,string warning,id ccId){
        
        TimeZone tz = UserInfo.getTimeZone();
        
        list<string> freq = TLI.Frequency__c.split(' : ');
  
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);                                
          
        system.debug('creating event');
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;
        t.Day__c = 1;
        t.Warning__c = warning;//taper.Warning__c;
        t.Medicine__c = TLI.Medicine__c;
        t.PRN__c = order.PRN__c;
        t.Taper_Line_Item__c = TLI.Taper_Line_Item__c ;
        t.Strength__c = TLI.Dose__c;
        t.Route_of_Delivery__c = TLI.Route__c;
        t.Frequency__c = TLI.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = ccId; 
        t.Order_Line_item__c = TLI.id;
        if(FM.Time__c ==null){
            //creating Q MARs                       
            if(order.Send_To_Pharmacy__c == 'Yes' ){                     
                t.StartDateTime =Datetime.now();
                
                t.EndDateTime =Datetime.now();
            }
            else{
                t.StartDateTime = order.Start_Date__c;
                
                t.EndDateTime = order.Start_Date__c;                
            }
            list<string> FMobj = FM.Name.split(' ');
            system.debug(FMobj );
            system.debug(FMobj[0]);
            if(FMobj.size()>0){
                integer rem = (24/(integer.valueof(FMobj[0].replace('Q',''))));
                system.debug(rem );
                t.Remaining__c = rem- 1;
            }
            //return t;
        }
        else{
            string timeFM = FM.Time__c;
            //creating X MARs
            list<string> lstTimeOld = FM.Time__c.split(',');
            system.debug(Datetime.now());
            system.debug(order.id);
            
            DateTime dt = (order.Send_To_Pharmacy__c == 'Yes' )?Datetime.now():order.Start_Date__c;
            dt = dt.addSeconds((tz.getOffset(dt)/1000));
            system.debug(dt+' :order date dt offset');
            
            integer currentHour = dt.hourGMT();
            integer currentMin = dt.minuteGMT();
            
            system.debug('******'+currentHour);
            
             integer missedhour = (integer)(double.valueof(FM.Missed__c)*(60))/60;
             if(TLI.Frequency__c.startswith('QDaily')){
                timeFM = QDailyFM(lstTimeOld, missedhour, currentHour,timeFM);
            }
            else{
                for(integer i=0; i<lstTimeOld .size();i++){
                    system.debug(lstTimeOld[i]  );
                    system.debug(missedhour);
                    if(lstTimeOld.size()>1 && (((integer.valueof(lstTimeOld[i])*60) + (missedhour*60) )< ((currentHour*60)+currentMin) )
                    ){                    
                        timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                        timeFM += ','+lstTimeOld[i];
                        
                    }
                    else{
                        break;
                    }
                }
            }
            integer minutes = integer.valueof(double.valueof(FM.Missed__c)*(60));
            
            
            system.debug(timeFM);
            list<string> lstTime = timeFM.split(',');
            
            Date taskDate =  Date.valueof(dt);
            Time taskTime = Time.newInstance(integer.valueof(lstTime[0]), 0, 0, 0);

            DateTime taskDateTime = DateTime.newinstance(taskDate ,taskTime );
            
            DateTime CurrentDatetime = Datetime.now();
            CurrentDatetime = CurrentDatetime.addSeconds((tz.getOffset(CurrentDatetime)/1000));
            
            system.debug(taskDateTime);
            system.debug(CurrentDatetime );

            if(taskDateTime < CurrentDatetime ){
               taskDateTime = taskDateTime.addDays(1);
            }
            
            t.StartDateTime = taskDateTime ;
           
            t.EndDateTime = taskDateTime ;
            t.Remaining_Time__c = timeFM.replaceFirst(lstTime[0]+',','');
            t.Remaining__c = FM.Count__c - 1;
            //return t;
            
            t.Missed_Time__c = t.StartDateTime.addMinutes(minutes );
        }
        double hourVal = FM.Hide_Button__c;
        t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0))));
        
        return t;
    }
    
    ////////CREATE MARS FOR STANDARD ORDERS//////
    ///////// FOR PRN & OTHER///////////////
    public static Event returnStandardPRNOTHERMARs(Order_Line_Item__c TLI, Order__c order, string warning,boolean PRN,id ccId){
        
        TimeZone tz = UserInfo.getTimeZone();
        
        list<Event> lstCreateMARS = new list<Event>();
        
        list<string> freq = TLI.Frequency__c.split(' : ');
                      
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);                        

        system.debug('creating event');
        Event t = new Event();
        t.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MARs').getRecordTypeId();
        t.WhatId = order.id;
        
        t.Warning__c =warning;
        t.Medicine__c = TLI.Medicine__c;
        t.PRN__c = PRN;
        t.Taper_Line_Item__c = TLI.Taper_Line_Item__c ;
        t.Strength__c = TLI.Dose__c;
        t.Route_of_Delivery__c = TLI.Route__c;
        t.Frequency__c = TLI.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = ccId;
        t.Order_Line_item__c = TLI.id;
        //t.Day__c = 1;
        if(FM.Time__c ==null){
            //creating Q MARs                       
            if(order.Send_To_Pharmacy__c == 'Yes' ){                     
                t.StartDateTime =Datetime.now();
                
                t.EndDateTime =Datetime.now();
            }
            else{
                t.StartDateTime = order.Start_Date__c;
                
                t.EndDateTime = order.Start_Date__c;                
            }
            
            list<string> FMobj = FM.Name.split(' ');
            system.debug(FMobj );
            system.debug(FMobj[0]);
            /*if(FMobj.size()>0){
                integer rem =  (24/(integer.valueof(FMobj[0].replace('Q',''))));
                system.debug(rem );
                t.Remaining__c = rem- 1;
            }*/
            //return t;
        }
        else{
            string timeFM = FM.Time__c;
            //creating X MARs
            list<string> lstTimeOld = FM.Time__c.split(',');
            
            DateTime dt =  (order.Send_To_Pharmacy__c == 'Yes' )?Datetime.now():order.Start_Date__c;
            dt = dt.addSeconds((tz.getOffset(dt)/1000));
            
            integer currentHour = dt.hourGMT();
            integer currentMin = dt.minuteGMT();
            system.debug('******'+currentHour); 
            
            integer missedhour = (integer)(double.valueof(FM.Missed__c)*(60))/60;
            if(TLI.Frequency__c.startswith('QDaily')){
                timeFM = QDailyFM(lstTimeOld, missedhour, currentHour,timeFM);
            }
            else{
                for(integer i=0; i<lstTimeOld .size();i++){
                     system.debug(lstTimeOld[i]  );
                    system.debug(missedhour);
                    if(lstTimeOld.size()>1 && (((integer.valueof(lstTimeOld[i])*60) + (missedhour*60) )< ((currentHour*60)+currentMin) )
                    ){                    
                        timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                        timeFM += ','+lstTimeOld[i];
                        
                    }
                    else{
                        break;
                    }
                }
            }
            system.debug(timeFM);
            list<string> lstTime = timeFM.split(',');
            
            integer minutes = integer.valueof(double.valueof(FM.Missed__c)*(60));
                        
            
            Date taskDate =  Date.valueof(dt);
            Time taskTime = Time.newInstance(integer.valueof(lstTime[0]), 0, 0, 0);
            
                        
            DateTime taskDateTime = DateTime.newinstance(taskDate ,taskTime );
            
            DateTime CurrentDatetime = Datetime.now();
            CurrentDatetime = CurrentDatetime.addSeconds((tz.getOffset(CurrentDatetime)/1000));
            
            system.debug(taskDateTime);
            system.debug(CurrentDatetime );

            if(taskDateTime < CurrentDatetime ){
               taskDateTime = taskDateTime.addDays(1);
            }
            
            t.StartDateTime = taskDateTime ;
            
            t.EndDateTime = taskDateTime ;
            timeFM = timeFM.replaceFirst(lstTime[0]+',','');
            timeFM += ','+lstTime[0];
            t.Remaining_Time__c = timeFM;
            //t.Remaining__c = FM.Count__c - 1;
            //return t;
            
        t.Missed_Time__c = t.StartDateTime.addMinutes(minutes );
        }
        double hourVal = FM.Hide_Button__c;
        t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0))));
        
        return t;  

    }
    
    public static Event getMARs(Event m,boolean prn ){
        
        TimeZone tz = UserInfo.getTimeZone();
        string timeFM = '';
        
        Event t = new Event();
        t.RecordTypeId = m.RecordTypeId;
        t.WhatId = m.WhatId;
        
        t.Medicine__c = m.Medicine__c;
        t.PRN__c = m.PRN__c;
        t.Strength__c = m.Strength__c ;
        t.Route_of_Delivery__c = m.Route_of_Delivery__c ;
        t.Frequency__c = m.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = m.Client_Chart__c ;
        t.Day__c = m.Day__c;
        t.Taper_Line_Item__c = m.Taper_Line_Item__c;
        t.Order_Line_item__c = m.Order_Line_Item__c;
        if(m.Remaining__c!=null)
            t.Remaining__c = m.Remaining__c - 1;
        t.Warning__c = m.Warning__c;
        list<string> freq = m.Frequency__c.split(' : ');
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);                     
        
        //q orderline
        if(m.Frequency__c.contains('Hours')){
            list<string> FMobj = m.Frequency__c.split(' ');
            if(FMobj.size()>0){
                integer interval = integer.valueof(FMobj[0].replace('Q',''));
                                            
                DateTime taskDT;
                if(m.Status__c == 'Administered')
                    taskDT = m.MARs_Administered__c.addHours(interval );
                else if(m.Status__c == 'Refused')
                    taskDT = m.MARs_Refused__c.addHours(interval );
                else
                    taskDT = m.StartDateTime.addHours(interval);
                system.debug(taskDT );
                t.StartDateTime = taskDT;                            
                t.EndDateTime = taskDT; 
                t.ActivityDateTime= taskDT;                          
            }
        }
        else{//x orderline
            string remainingTime ='';

            remainingTime = m.Remaining_Time__c;
                system.debug(remainingTime );
            timeFM = remainingTime ;
            system.debug(timeFM );
            
            list<string> lstTimeOld = timeFM.split(',');
            DateTime current ;
            current = m.StartDateTime;
            system.debug(current );
            
            current  = current.addSeconds((tz.getOffset(current)/1000));
            system.debug(current );
            
            integer currentHour = current.hourGMT();
            integer currentMin  = current.minuteGMT();
            
            system.debug('*****'+currentHour );    
            system.debug(m.StartDateTime.hour());
            
            if(prn){
                for(integer i=0; i<lstTimeOld .size();i++){
                    if(lstTimeOld.size()>1 && (integer.valueof(lstTimeOld[i])*60) <= ((currentHour*60)+currentMin) 
                    ){
                        timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                        timeFM += ','+lstTimeOld[i];                               
                    }
                    else{break;}
                }
            }
            system.debug(timeFM);
            
            list<string> lstTime = timeFM.split(',');
           
            Time taskTime = Time.newInstance(integer.valueof(lstTime[0]), 0, 0, 0);
            
            system.debug(lstTime[0]);
            System.debug(m.StartDateTime);
            System.debug(m.StartDateTime.hour());
            
            integer nextDay = 0;
            if(integer.valueof(lstTime[0]) <= current.hourGMT() || m.Frequency__c.startswith('QDaily'))
                nextDay =1;
                                  
            system.debug(nextDay );
            DateTime taskDateTime = DateTime.newinstance( Date.valueof(current).addDays(nextDay),taskTime );
            t.StartDateTime = taskDateTime ;
            system.debug(taskDateTime );
            t.EndDateTime = taskDateTime ;
            timeFM = timeFM.replaceFirst(lstTime[0]+',','');

            t.Remaining_Time__c = timeFM;
                
            t.ActivityDateTime = taskDateTime ;
            integer minutes = integer.valueof(double.valueof(FM.Missed__c)*(60));
           
            t.Missed_Time__c = t.StartDateTime.addMinutes(minutes );
            
        }
        double hourVal = FM.Hide_Button__c;
        t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0))));
        
        return t;
    }
    
    public static Event getNextEvent(Order_Line_Item__c  TLI, Event m){
    
        TimeZone tz = UserInfo.getTimeZone();
        list<string> freq = TLI.Frequency__c.split(' : ');
              
        FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);    
        
        system.debug('creating event');
        Event t = new Event();
        t.RecordTypeId = m.RecordTypeId ;
        t.WhatId = m.WhatId;
        t.Day__c = TLI.Day__c;
        t.Warning__c = TLI.Warning__c;
        t.Medicine__c = TLI.Medicine__c;
        //t.PRN__c = order.PRN__c;
        t.Taper_Line_Item__c = TLI.id;
        t.Strength__c = TLI.Dose__c;
        t.Route_of_Delivery__c = TLI.Route__c;
        t.Frequency__c = TLI.Frequency__c;
        t.Status__c = 'Open';
        t.Client_Chart__c = m.Client_Chart__c ; 
        t.Taper_Line_Item__c = TLI.Taper_Line_Item__c ;
        t.Order_Line_item__c = TLI.id;
        if(FM.Time__c ==null){
        //updated
            string freqVal;
            if(m.Frequency__c.contains('Hours')){
                freqVal= m.Frequency__c;
            }
            else
                freqVal= TLI.Frequency__c;
            list<string> FMobj = freqVal.split(' ');
            if(FMobj.size()>0){
                integer interval = integer.valueof(FMobj[0].replace('Q',''));
                                            
                DateTime taskDT;
                if(m.Status__c == 'Administered')
                    taskDT = m.MARs_Administered__c.addHours(interval );
                else if(m.Status__c == 'Refused')
                    taskDT = m.MARs_Refused__c.addHours(interval );
                else 
                    taskDT = m.StartDateTime.addHours(interval);
                t.StartDateTime = taskDT;                            
                t.EndDateTime = taskDT; 
                t.ActivityDateTime= taskDT;  
                
                string newfreqVal = TLI.Frequency__c;
                list<string> newFMobj = newfreqVal.split(' ');
            
                integer rem =  24/integer.valueof((newFMobj[0].replace('Q','')));
                system.debug(rem );
                t.Remaining__c = rem- 1;  
                
            
                double hourVal = FM.Hide_Button__c;
                t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0)))); 
                    
            }
            
        }
        else{
            string timeFM = FM.Time__c;
            //creating X MARs
            list<string> lstTimeOld = FM.Time__c.split(',');
            
            DateTime dt;                    
            dt= m.StartDateTime;
                
            dt= dt.addSeconds((tz.getOffset(dt)/1000));
            
            system.debug(dt);
            if(m.Frequency__c.contains('Hours')){
                list<string> FMobj = m.Frequency__c.split(' ');
                integer interval = integer.valueof(FMobj[0].replace('Q',''));
                system.debug(interval);
                dt = dt.addHours(interval);
            }
            system.debug(dt);
            //dt = dt.addSeconds((tz.getOffset(dt)/1000));
            system.debug(dt);
            integer currentHour = dt.hourGMT() ;
            integer currentMin = dt.minuteGMT();
                        system.debug('*****'+currentHour );
            if(TLI.Frequency__c.startswith('QDaily')){
                timeFM = m.Remaining_Time__c;
            }
            else{
                for(integer i=0; i<lstTimeOld .size();i++){
                    if(lstTimeOld.size()>1 &&  (integer.valueof(lstTimeOld[i])*60) <= ((currentHour*60)+currentMin) 
                    ){
                        timeFM = timeFM.replaceFirst(lstTimeOld [i]+',','');
                        timeFM += ','+lstTimeOld[i];
                       
                    }
                    else{
                        break;
                    }
                }
            }
            system.debug(timeFM );
            list<string> lstTime = timeFM.split(',');
            
            Date taskDate =  Date.valueof(date.valueof(dt));
            Time taskTime = Time.newInstance(integer.valueof(lstTime[0]), 0, 0, 0);
            
            integer nextDay = 0;
                if(integer.valueof(lstTime[0]) <= dt.hourGMT() || TLI.Frequency__c.startswith('QAM') 
                || TLI.Frequency__c.startsWith('QDaily'))
                    nextDay =1;
            
            system.debug(nextDay);
            
            DateTime taskDateTime = DateTime.newinstance(taskDate.addDays(nextDay) ,taskTime );
            t.StartDateTime = taskDateTime ;
            
            t.EndDateTime = taskDateTime ;
            t.Remaining_Time__c = timeFM.replaceFirst(lstTime[0]+',','');
                
            t.Remaining__c = FM.Count__c - 1;
            
            double hourVal = FM.Hide_Button__c;
            t.Hide_Button_Date_Time__c = t.StartDateTime.addMinutes(-(integer.valueof((hourVal * 60.0))));
    
            integer minutes = integer.valueof(double.valueof(FM.Missed__c)*(60));
            t.Missed_Time__c = t.StartDateTime.addMinutes(minutes );
        } 
        return t;                   
    }
    
   
}