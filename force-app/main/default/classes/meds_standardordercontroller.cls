/*
    controller class for Meds_StandardOrder vf component. 
    @author: Huma Zafar
*/
public class meds_standardordercontroller{
    
    //list of tapers
    public list<Taper__c> lstTapers{get;set;}
    
    //for showing tapers
    public map<string,list<wrapperTaper>> mapWrapperTapers{get;set;}
    public map<string,list<wrapperTaper>> mapWrapperPRNs{get;set;}
    //public map<id,wrapperTaper> lstWrapperOthers{get;set;}
    
    //via picklist on vf page
    public string Via{get;set;}
    
    //id from page parameters
    id clientChartId;
    
    //order by picklist on vfpage
    public id OrderByUserId{get;set;}
    
    //record type paramter value
    string rtParam;
    
    //custom setting record
    Sunshine_Center_Id__c SC;
    
    //if sunshhine center is allowed to send order to pharmacy 
    Boolean SendtoPharmacy ;
    
    //for custom taper
    public Order__c ViewOrderRec{get;set;}
    public list<wrapperOLI> lstWrapperOLI{get;set;}
    
    public meds_standardordercontroller(){
    
        clientChartId = ApexPages.CurrentPage().getParameters().get('id');    
        
        rtParam = ApexPages.CurrentPage().getParameters().get('rt');
        
        SC = Sunshine_Center_Id__c.getValues(rtparam);
        
        if(SC!=null && SC.Required_Pharmacy_Email__c)
            SendtoPharmacy = true;
        else
            SendtoPharmacy = false;
            
        loadTapers();
        
        loadPRNs();
        
        ViewOrderRec = new Order__c();
        ViewOrderRec.Order_Type__c = 'Custom - Taper';
        ViewOrderRec.Status__c = 'Under Review';
        ViewOrderRec.Client_Chart__c = clientChartId ;        
        
        lstWrapperOLI = new list<WrapperOLI>();
    }
    
    //get via picklist values to show on vf
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Requested_via__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //options.add(new SelectOption('--None--', '--None--'));
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    //method for loading users with health practitioner role
     public  List<SelectOption> getUsers(){
         
         set<id> userRoleId = new set<id>();
                 
        list<string> rts = rtParam.split(';');
        for(string sr: rts){
            Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(sr);
            if(sc!=null)
            userRoleId.add(SC.Health_Care_Practitioner_Role_ID__c);
        }
                
        List<SelectOption> options = new List<SelectOption>();
        
        list<User> lstUsers = [select id,Name from  User where UserRoleId=:userRoleId];
        
        for(User u: lstUsers){
            options.add(new SelectOption(u.id,u.Name));
        }
        return options;
    }
    
    //load tapers and categorize them with medicine
    private void loadTapers(){
    
        lstTapers = new  list<Taper__c>();
        mapWrapperTapers = new map<string, list<wrapperTaper>>();
        
        lstTapers = [select id, Name, Protocol__c, Active__c, Warning__c, (select id, Duration_In_Days__c, Amount_to_Use_Per_Dosage_Form__c, 
        Dosage_Form__c, Strength__c, Frequency__c, Medicine__c, Medicine__r.Name, Route__c, Taper__c,No_of_Refills__c,
        Taper__r.Warning__c from Taper_Line_Items__r) from Taper__c 
        where Active__c = true and Dosage_Type__c = 'Taper'];
        
        
        for(Taper__c t : lstTapers){
            if(t.Taper_Line_Items__r.size()>0){
                if(mapWrapperTapers.containsKey(t.Taper_Line_Items__r[0].Medicine__r.Name)){
                    list<wrapperTaper> templst = mapWrapperTapers.get(t.Taper_Line_Items__r[0].Medicine__r.Name);
                    templst.add(new wrapperTaper(t));
                    
                }
                else{
                    mapWrapperTapers.put(t.Taper_Line_Items__r[0].Medicine__r.Name,new list<wrapperTaper>{new wrapperTaper(t)});
                }
            }
        }
        system.debug(mapWrapperTapers.size());
        system.debug(mapWrapperTapers);
    }
    
    //load prns and categorize them with medicine
    private void loadPRNs(){
        
        mapWrapperPRNs = new map<string, list<wrapperTaper>>();
        
        lstTapers = [select id, Name, Protocol__c, Active__c, Warning__c, (select id, Duration_In_Days__c, Amount_to_Use_Per_Dosage_Form__c, 
        Dosage_Form__c, Strength__c, Frequency__c, Medicine__c,Medicine__r.Name, Route__c, Taper__c,No_of_Refills__c ,
        Taper__r.Warning__c from Taper_Line_Items__r) from Taper__c 
        where Active__c = true and Dosage_Type__c = 'Open Ended'];
        
        
        for(Taper__c t : lstTapers){
            if(t.Taper_Line_Items__r.size()>0){
                if(mapWrapperPRNs.containsKey(t.Taper_Line_Items__r[0].Medicine__r.Name)){
                    list<wrapperTaper> templst = mapWrapperPRNs.get(t.Taper_Line_Items__r[0].Medicine__r.Name);
                    templst.add(new wrapperTaper(t));
                    
                }
                else{
                    mapWrapperPRNs.put(t.Taper_Line_Items__r[0].Medicine__r.Name, new list<wrapperTaper>{new wrapperTaper(t)});
                }
            }
        }
    }
    
    
    //method for creating orders and mars(standard taper)
    private PageReference createOrdersAndMARs( string orderType, list<wrapperTaper > lstwrapper){
        try{
        map<Taper__c,Order__c> mapCreateOrder = new map<Taper__c,Order__c>();
        Order__c ord;
                  
        list<Event> lstCreateMARS = new list<Event>();
        
        
        for(wrapperTaper wt : lstwrapper){
            if(wt.selected){
                ord = new Order__c();
              
                ord = OrderUtil.returnStandardOrder(wt.ord, clientChartId, orderType, OrderByUserId, Via, wt.taper.id);
                if(ord.Send_To_Pharmacy__c == 'No' )
                    ord.Pharmacy_Status__c = 'Order Received';
                mapCreateOrder.put(wt.taper,ord);
            }
        }
        system.debug(mapCreateOrder);
        system.debug(mapCreateOrder.size());
        
        
        map<id,Order_Line_Item__c > mapTLIOLI = new map<id,Order_Line_Item__c >();
        
        if(mapCreateOrder.size()>0){
            insert mapCreateOrder.values();
            
            for(wrapperTaper wt : lstwrapper){
                if(wt.selected ){                
                system.debug(wt.taper.Taper_Line_Items__r.size());
                    for(Taper_Line_Item__c TLI : wt.taper.Taper_Line_Items__r){
                        Order_Line_Item__c oli = OrderUtil.returnOLI(mapCreateOrder.get(wt.taper).id,TLI);
                        
                        if(oli.Day__c== 1 && wt.ord.Send_To_Pharmacy__c == 'No'){
                            oli.Status__c = 'In Progress';
                            lstCreateMARS.Add(OrderUtil.returnStandardMARs(oli,mapCreateOrder.get(wt.taper),wt.taper.Warning__c,clientChartId));                                                                            
                            
                        }
                        mapTLIOLI.put(TLI.id,oli);
                        
                    }
                      
                }
            }
            if(mapTLIOLI.size()>0)
                insert mapTLIOLI.values();
            system.debug(lstCreateMARS.size());
            
            
            if(lstCreateMARS.size()>0){
                for(Event e : lstCreateMARS){
                    e.Order_Line_Item__c = mapTLIOLI.get(e.Taper_Line_Item__c).id;
                }
                insert lstCreateMARS;        
                
                /*
                list<Order_line_item__c> lstUpdateOLI = new list<Order_Line_Item__c>();                        
                //update oli status to Active
                
                for(Event e : lstcreateMARS){
                    lstUpdateOLI.add(new Order_Line_Item__c(id=e.Order_Line_Item__c,Status__c ='In Progress'));
                }
                if(lstUpdateOLI.size()>0)
                    update  lstUpdateOLI;*/
             }   
        }
            PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
            meds.setRedirect(true);
            return meds;
        }
        catch(exception e){
        system.debug(e.getmessage()+e.getlinenumber());
        }
      
        return null;
    }
    
    //method for creating standard taper orders when tapers are selected
    public PageReference submitTaper(){
        
        try{
            list<wrapperTaper> templstTaper = new list<wrapperTaper>();
            for(string medi : mapWrapperTapers.keyset()){
                templstTaper.addAll(mapWrapperTapers.get(medi));
            }
            PageReference pr = createOrdersAndMARs('Standard - Taper',templstTaper);        
            
            return pr; 
        }
        catch(exception e){
            system.debug(e.getmessage()+e.getlinenumber());
            return null;
        }
    }
    
    //method for creating prn orders when prns are selected
    public PageReference submitPRN(){
        
        
        map<Taper__c,Order__c> mapCreateOrder = new map<Taper__c,Order__c>();                
        
        list<Order__c> lstCreateOrder = new list<Order__c>();
        Order__c ord;                
        
        list<Event> lstCreateMARS = new list<Event>();

        list<wrapperTaper> templstTaper = new list<wrapperTaper>();
        for(string medi : mapWrapperPRNs.keyset()){
            templstTaper.addAll(mapWrapperPRNs.get(medi));
        }
        
        for(wrapperTaper wt : templstTaper){
            if(wt.selected){
                ord = new Order__c();
                ord = OrderUtil.returnStandardOrder(wt.ord, clientChartId, 'Standard - PRN', OrderByUserId, Via, wt.taper.id);
                ord.PRN__c = true;
                if(ord.Send_To_Pharmacy__c == 'No' )
                    ord.Pharmacy_Status__c = 'Order Received';
                mapCreateOrder.put(wt.Taper,ord);
            }
        }
        system.debug(mapCreateOrder);
        system.debug(mapCreateOrder.size());
        
        map<id,Order_Line_Item__c > mapTLIOLI = new map<id,Order_Line_Item__c >();
        
        try{
        
            if(mapCreateOrder.size()>0){
                insert mapCreateOrder.values();
                
                for(wrapperTaper wt : templstTaper){
                    if(wt.selected ){                
                    
                        for(Taper_Line_Item__c TLI : wt.taper.Taper_Line_Items__r){
                            //if(TLI.Duration_In_Days__c == 1)
                            Order_Line_Item__c oli = OrderUtil.returnOLI(mapCreateOrder.get(wt.taper).id,TLI);
                            oli.Status__c = 'In Progress' ; // for prn only
                            mapTLIOLI.put(TLI.id,oli);
                            if(wt.ord.Send_To_Pharmacy__c == 'No')
                                lstCreateMARS.add(OrderUtil.returnStandardPRNOTHERMARs(oli,mapCreateOrder.get(wt.taper),wt.taper.Warning__c,true,clientChartId));
                        }
                          
                    }
                }
                if(mapTLIOLI.size()>0)
                    insert mapTLIOLI.values();
                if(lstCreateMARS.size()>0)
                    for(Event e : lstCreateMARS){
                        e.Order_Line_Item__c = mapTLIOLI.get(e.Taper_Line_Item__c).id;
                    }
                    insert lstCreateMARS;
                    
                    
                
            }
            PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
            meds.setRedirect(true);
            return meds;    
        }
        catch(exception e){
            system.debug(e.getmessage()+e.getlinenumber());
            return null;
        }
      
    }
    
    //main method for creating orders
    public PageReference SubmitAll(){
        
        boolean taper=false,prn = false, other = false;
        
        for(string medi : mapWrapperTapers.keyset()){
            for( wrapperTaper wt : mapWrapperTapers.get(medi)){
                if(wt.selected){
                    taper = true;
                }
            }
        }
        
        for(string medi : mapWrapperPRNs.keyset()){
            for( wrapperTaper wt : mapWrapperPRNs.get(medi)){
                if(wt.selected){
                    prn= true;
                }
            }
        }        
           
        if(taper){
            PageReference meds = submitTaper();
            return meds;
        }
        else if(prn){
            PageReference meds = submitPRN();
            return meds;
        }    
        else if(!taper && !prn){
            ViewOrderRec.Order_By__c =  OrderByUserId;
            ViewOrderRec.Requested_Via__c =  Via;
            if(ViewOrderRec.Send_To_Pharmacy__c == 'No' )
                    ViewOrderRec.Pharmacy_Status__c = 'Order Received';
            insert ViewOrderRec;
            
            list<Order_Line_Item__c> lstCreateOLI = new list<Order_Line_Item__c>();
            
            for(wrapperOLI o : lstwrapperOLI){
                if(o.oli.Day__c== 1 && ViewOrderRec.Send_To_Pharmacy__c == 'No')
                    o.OLI.Status__c = 'In Progress';
                o.OLi.Order__c = ViewOrderRec.id;
                o.OLI.Warning__c = ViewOrderRec.Warnings__c;
                lstCreateOLI.add(o.OLI);
            }
            if(lstCreateOLI.size()>0)
                insert lstCreateOLI ;
                
            list<Event> lstCreateMARS = new list<Event>();
            
            for(Order_Line_Item__c ol : lstCreateOLI){
                if(ol.Day__c== 1 && ViewOrderRec.Send_To_Pharmacy__c == 'No'){
                    lstCreateMARS.Add(OrderUtil.returnStandardMARs(ol,ViewOrderRec,ViewOrderRec.Warnings__c,clientChartId));   
                }                                                                             
            }  
            if(lstCreateMARS.size()>0)
                insert lstCreateMARS;                          
            PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
            meds.setRedirect(true);
            return meds;
        }    
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one record.'));
            return null;
        }
        return null;
    }
        

    public void RemoveOLI() {

        string objIndex = system.CurrentPageReference().getParameters().get('IndexNumber');
            
        lstwrapperOLI.remove(integer.valueof(objIndex));

    }
    
    public void AddOLI(){
        
        Order_Line_Item__c oNew = new Order_Line_Item__c();
        oNew.Order__c = ViewOrderRec.id;
        oNew.Status__c = 'Open';
        oNew.Warning__c = ViewOrderRec.Warnings__c;
        if(lstwrapperOLI.size()==0)
            lstwrapperOLI.add(new wrapperOLI(true, lstwrapperOLI.size(),oNew, true));
        else{
            id medicineId;
            for(wrapperOLI oo :lstwrapperOLI){
                medicineId = oo.OLI.Medicine__c;
                break;
            }
            oNew.Medicine__c = medicineId;
            lstwrapperOLI.add(new wrapperOLI(true, lstwrapperOLI.size(),oNew,false));
        }   
        
    }
    
    public  List<SelectOption> getFrequencies(){
    
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Frequency__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            if(f.getValue()!='3 day (m,w,f)' && f.getValue()!='daily' && f.getValue()!='sessions' && f.getValue()!='weekdays only'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        } 
        return options; 
    }
    
    public class wrapperTaper{
        public boolean selected{get;set;}
        public Taper__c taper{get;set;}
        //public DateTime StartDate{get;set;}
        public Order__c ord{get;set;}
        
        public wrapperTaper(Taper__c t){
            selected = false;
            taper = t;
            //StartDate = null;
            ord = new Order__c();
        }
    }
     public class wrapperOLI{
        
        public Order_Line_Item__c OLI{get;set;}
        public integer index {get; set;}
        public boolean isEdit {get; set;}
        public boolean isEditMedi{get;set;}
        
        public wrapperOLI(boolean e, integer i, Order_line_item__c o, boolean m){
            isEdit = e;
            index = i;
            OLI  = o;
            isEditMedi = m;
        }
    }    
}