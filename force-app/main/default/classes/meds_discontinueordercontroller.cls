/*
    controller class for meds_discontinueorder vf component. 
    @author: Huma Zafar
*/
public class meds_discontinueordercontroller{
        
    
    public list<Order__c> lstActiveOrders;
    
    public list<wrapperOrder> lstWrapperActiveOrders{get;set;}
    
   
    public string Via{get;set;}
    
    id clientChartId;
    public id OrderByUserId{get;set;}
    string rtParam;
    
    string errorMessage;
    

    //AWS
    public string accessKeyId {
        get;
        set;
    }
    public string secretAccessKey {
        get;
        set;
    }
    public string OrgName {
        get;
        set;
    }
    final string AWSURL;
    private User userObj;
    
    
    public string SunShineCenterName {get; set;}
    public string ClientName {get; set;}

    
    public meds_discontinueordercontroller(){
        
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;

        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtParam = ApexPages.CurrentPage().getParameters().get('rt');
        
        Client_Chart__c ClientChartObj = [select id, Name, Treatment_Center__r.Name from Client_Chart__c where id = :clientChartId];

        SunShineCenterName = ClientChartObj.Treatment_Center__r.Name;
        ClientName = ClientChartObj.Name;   
        
        userObj = [select id, name, title from user where id = :UserInfo.getUserID()];   
        
        loadActiveOrders();
    }
    
    //method for loading order records
    private void loadActiveOrders(){
        
        lstActiveOrders = new list<Order__c>();
        
        lstWrapperActiveOrders = new list<wrapperOrder>();
        
        lstActiveOrders  = [select id, Name, Status__c, Client_Chart__c, Order_Type__c, Discontinue_Date_Time__c , Medicine__r.name,
        Taper__r.Name,Action__c  from  Order__c 
        where Client_Chart__c=:clientChartId and Status__c <>'Inactive' and Status__c <>'Under Review - Discontinue'];
        
        //add to wrapper list
        for(Order__c o : lstActiveOrders){
            lstWrapperActiveOrders.add(new wrapperOrder(o));
        }
    }
    
    //get via picklist values to show on vf
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Order__c.Via_cancelled_by__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('--None--', '--None--'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
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
    
    private boolean isValid(){
        //return true;
        
        errorMessage = '';
        
        if(via == null){
            errorMessage += 'Please enter Via.\n';
        }
        integer selectedCount = 0;
        for(wrapperOrder wrapO : lstWrapperActiveOrders){
            if(wrapO.selected){
                selectedCount++;
                if(wrapO.ActiveOrder.Discontinue_Date_Time__c ==null){
                    errorMessage += 'Please enter Discontinue Date/Time.\n';
                }              
            }
        }
        if(selectedCount == 0)
            errorMessage = 'Please select atleast one order.\n';
        if(errorMessage !=null && errorMessage!='')
            return false;
        return true;
    }
    
    //cancel order and related MARs
    public PageReference SubmitButton(){
    
        if(isValid()){
        
            list<Order__c> lstUpdateOrders = new list<Order__c>();
            
            map<id,DateTime> mapOrderDiscontinueDateTime = new map<id,DateTime>();
            
            list<Event> lstUpdateMARs = new list<Event>();
            
            for(wrapperOrder wrapO : lstWrapperActiveOrders){
                if(wrapO.selected){
                    lstUpdateOrders.add(new Order__c(id=wrapO.ActiveOrder.id,
                    Status__c = 'Under Review - Discontinue',Order_Cancelled_by__c=OrderByUserId,
                    Via_cancelled_by__c = via, Discontinue_Date_Time__c=wrapO.ActiveOrder.Discontinue_Date_Time__c ));
                    mapOrderDiscontinueDateTime.put(wrapO.ActiveOrder.id,wrapO.ActiveOrder.Discontinue_Date_Time__c);
                }
            }
            try{
                if(lstUpdateOrders.size()>0){
                    update lstUpdateOrders;
                    
                    list<Event> lstMars = new list<Event>();
                    
                    lstUpdateMARs = [select id, Status__c, WhatId, StartDateTime, Discontinued__c from Event where 
                    WhatId in: mapOrderDiscontinueDateTime.keyset() and Status__c = 'Open'];
                    if(lstUpdateMARs.size()>0){
                        for(Event MAR : lstUpdateMARs){
                            DateTime discDT = mapOrderDiscontinueDateTime.get(MAR.WhatId);
                            if( MAR.StartDateTime > discDT || 
                            (DateTime.newinstance(discDT.year(),discDT.month(),discDT.day(),discDT.hour(),discDT.minute(),0) == 
                            DateTime.newinstance(MAR.StartDateTime.year(), MAR.StartDateTime.month(),MAR.StartDateTime.day(),MAR.StartDateTime.hour(),MAR.StartDateTime.minute(),0))
                            ){
                                MAR.Status__c = 'Inactive';
                                lstMars.add(MAR);
                            }
                            else{
                                MAR.Discontinued__c = true;
                                lstMars.add(MAR);
                            }                                            
                        }
                        if(lstMars.size()>0)
                            update lstMars;
                    }
                    PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId+'&rt='+rtparam );
                    meds.setRedirect(true);
                    return meds;
                }
                return null;
            }
            catch(exception e){
                return null;
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage ));
            return null;
        }
    }
    
    //wrapper class
    public class wrapperOrder{
        public boolean selected {get;set;}
        public Order__c ActiveOrder{get;set;}
        
        public wrapperOrder(Order__c  o){
            selected = false;
            ActiveOrder = o;
            
        }
    }
    
}