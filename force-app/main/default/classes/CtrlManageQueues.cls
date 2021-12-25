/**
    @author: HZ
    @modified: 7/24/2016
    @purpose: controller class for VF console, for setting up queues (Working & Non-working hours)    
*/
public class CtrlManageQueues{
    
    //list of non working hour queues
    public list<wrapperNWQueue> lstNonWorkingHourQueues{get;set;}
    
    //list of working hour queues
    public list<wrapperWQueue> lstWorkingHourQueues{get;set;}
    
    //wrapper list for adding new queue to working or non working hour
    public list<wrapperAddQueues> lstwrapperAddQueues{get;set;}
    
    //for showing add queue
    public boolean displayPopUp{get;set;}
    
    private set<string> setExistingQueueNames ;
    
    //param
    public integer indexVal{get;set;}
    /**
        constructor
    */
    public CtrlManageQueues(){
        displayPopUp = false;
        LoadExistingData();
        loadNewRecords();
    
    }//end of constructor
    
    
    public void showAddQueueScreen(){
        displayPopUp = true;    
    }
    
    public void cancel(){
        displayPopUp = false;    
    }
    
    public void EditW(){
        for(wrapperWQueue WQ : lstWorkingHourQueues){
            system.debug(indexVal );
            system.debug(WQ.index);
            if(indexVal == WQ.index){
                WQ.Edit = true;
            }
        }
    }
    
    public void EditNW(){
        for(wrapperNWQueue NWQ : lstNonWorkingHourQueues){
            if(indexVal == NWQ.index){
                NWQ.Edit = true;
            }
        }
    }
    
    public void DelW(){
        try{
            for(wrapperWQueue WQ : lstWorkingHourQueues){
                system.debug(indexVal );
                system.debug(WQ.index);
                if(indexVal == WQ.index){
                    delete WQ.queue;
                }
            }
            LoadExistingData();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Queue deleted successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
    }
    
    public void DelNW(){
        try{
            for(wrapperNWQueue NWQ : lstNonWorkingHourQueues){
                if(indexVal == NWQ.index){
                    delete NWQ.queue;
                }
            }
            LoadExistingData();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Queue deleted successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
    }
    
    public void DisableNW(){
        for(wrapperAddQueues a: lstwrapperAddQueues){
            if(a.WQ){
                a.disableNW = true;
            }
            else
                a.disableNW = false;
        }
    }
    
    public void DisableW(){
        for(wrapperAddQueues a: lstwrapperAddQueues){
            if(a.NWQ){
                a.disableW = true;
            }
            else
                a.disableW = false;
        }
    }
    
    public void SaveW(){
        list<Queues__c> lstWQ = new list<Queues__c>();
        try{
            for(wrapperWQueue WQ : lstWorkingHourQueues){
                lstWQ.add(WQ.queue);
            }
            if(lstWQ.size()>0)
                update lstWQ;
            LoadExistingData();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Queues saved successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
    }
    
    public void SaveNW(){
        list<NW_Queues__c> lstNWQ = new list<NW_Queues__c>();
        try{
            for(wrapperNWQueue NWQ : lstNonWorkingHourQueues){
                lstNWQ.add(NWQ.queue);
            }
            if(lstNWQ.size()>0)
                update lstNWQ;
            LoadExistingData();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Queues saved successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
    }
    
    public void SaveNewQueues(){
        
        list<Queues__c> lstWQ = new list<Queues__c>();
        list<NW_Queues__c> lstNWQ = new list<NW_Queues__c>();
        try{
            for(wrapperAddQueues a : lstwrapperAddQueues){
                if(a.selected){
                    if(a.WQ){
                        lstWQ.add(new Queues__c(Name=a.QueueName, Active__c= true));
                    }
                    else if(a.NWQ){
                        lstNWQ.add(new NW_Queues__c(Name=a.QueueName,Active__c= true));
                    }
                }
            }
            if(lstWQ.size()>0)
                insert lstWQ;
            if(lstNWQ.size()>0)
                insert lstNWQ;
            displayPopUp = false;
            LoadExistingData();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Queues saved successfully.'));
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
    }
    
    //method for loading data
    private void LoadExistingData(){
        setExistingQueueNames = new set<string>();
        //get current queue records
        lstNonWorkingHourQueues = new list<wrapperNWQueue>();
        
        lstWorkingHourQueues = new list<wrapperWQueue>();
        
        list<Queues__c> lstW = Queues__c.getall().values();  
        
        list<NW_Queues__c> lstNW = NW_Queues__c.getall().values();

        wrapperNWQueue NWQ;//wrapper instance
        integer countQ = 1;
        for(NW_Queues__c q: lstNW ){
            NWQ = new wrapperNWQueue(false,countQ ,q);
            lstNonWorkingHourQueues.add(NWQ);
            setExistingQueueNames.add(q.Name);
            countQ ++;
        } 
        wrapperWQueue WQ ;//wrapper instance
        countQ =0;
        for(Queues__c q: lstW  ){
            WQ = new wrapperWQueue(false,countQ ,q);
            lstWorkingHourQueues.add(WQ);
            setExistingQueueNames.add(q.Name);
            countQ ++;
        }              
    }
    
    private void loadNewRecords(){
        
        list<QueueSobject> lstQueueAssociation = [select QueueId, SobjectType, Queue.Name from QueueSobject where 
        Queue.Name not in: setExistingQueueNames and SobjectType = 'Lead'];
        
        lstwrapperAddQueues = new list<wrapperAddQueues>();
        wrapperAddQueues WQ;
        
        for(QueueSobject g : lstQueueAssociation ){
            WQ = new wrapperAddQueues( false, false, g.Queue.Name);            
            lstwrapperAddQueues.add(WQ);
        }        
    }
    
    public class wrapperWQueue{
        public boolean Edit{get;set;}
        public integer index{get;set;}
        public Queues__c queue{get;set;}
        
        public wrapperWQueue(boolean e, integer i, Queues__c q){
            Edit = e;
            index = i;
            queue = q;
        }
    }
    
    public class wrapperNWQueue{
        public boolean Edit{get;set;}
        public integer index{get;set;}
        public NW_Queues__c queue{get;set;}
        
        public wrapperNWQueue(boolean e, integer i, NW_Queues__c q){
            Edit = e;
            index = i;
            queue = q;
        }
    }
    
    public class wrapperAddQueues{
        public boolean NWQ{get;set;}
        public boolean WQ{get;set;}
        public string QueueName{get;set;}
        public boolean selected {get;set;}
        public boolean disableW{get;set;}
        public boolean disableNW{get;set;}
        
        public wrapperAddQueues(boolean n, boolean w, string q){
            NWQ = n;
            WQ = w;
            QueueName = q;
            selected = false;
            disableW = false;
            disableNW = false;
        }
    }
}