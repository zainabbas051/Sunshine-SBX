//Test Class : AdmitOrderNewExtTest
public class AdmitOrderNewExt{
    public Medical__c medical {get;set;}
    public string  AdmitOrderRtId;
    public string clientId {get;set;}
    public string taperId {get;set;}
    public string OTCID {get;set;}
    public string PSID {get;set;}
    public string StomachPSID {get;set;}
    public list<Taper__c> AllTaperrecords;
    public Client_Chart__c ClientIns {get;set;}
    public boolean readOnly{get;set;}
    
    public map<string,wrapperMediType> mapPRNTapers {get;set;}
    public map<string,string> mapPRNSelectedTaperID{get;set;}
    
    public list<wrapperOrder> lstOtherMedications{get;set;}
    
    private id medicalId;
    
   
    
     public AdmitOrderNewExt(){
     
        medicalId = ApexPages.CurrentPage().getParameters().get('mcid');
        system.debug(medicalId);
        clientId = ApexPages.CurrentPage().getParameters().get('id');
        AdmitOrderRtId= Schema.SObjectType.Medical__c.getRecordTypeInfosByName().get('Admit Order').getRecordTypeId();
        string readonlyvar=ApexPages.CurrentPage().getParameters().get('editValue');

        readonly=false;
        medical = [select id,Status__c, AO_height__c, AO_Weight_in_lbs__c, MC_Evaluation_Date__c,
        AO_Admit_to__c, Visual_Check_Parameters1__c, Vital_Sign_Parameters__c, COWS_Parameters__c,
        CIWA_Parameters__c, AO_No_Standing_Order__c, AO_Determine_BAC__c, AO_Obtain_TB_Skin_Test__c, 
        AO_Obtain_Initial_Urine_Drug_Screening__c, AO_Obtain_Standard_Blood_DNA_Lab__c, 
        AO_14_Day_Thiamine_Supplement__c, AO_Multivitamin__c, AO_Folic_Acid_Supplement__c, Client_Chart__c 
         from Medical__c where id=:medicalId];
        loadTapers();
        loadOrders();
        
    }
    
    private void loadTapers(){
        
       AllTaperrecords = [select id,name, dosage_type__c,PRN_Medication_Type__c from Taper__C where Active__c = true];


       mapPRNTapers = new map<string,wrapperMediType>();
       
       mapPRNSelectedTaperID = new map<string,string>();
       for(Taper__c t : AllTaperrecords ){
           if(t.Dosage_Type__c == 'Open Ended'){
               if(mapPRNTapers.containsKey(t.PRN_Medication_Type__c)){
                   wrapperMediType wM =  mapPRNTapers.get(t.PRN_Medication_Type__c) ;
                    list<selectOption> lstTemp = wM.lstSO;
                    lstTemp.add(new selectoption(t.id, t.name));
               }
               else{
                   list<selectoption> lstTemp = new list<selectoption>{new selectoption(t.id, t.name)};
                   mapPRNTapers.put(t.PRN_Medication_Type__c,new wrapperMediType (lstTemp ,''));
               }
               //mapPRNSelectedTaperID.put(t.PRN_Medication_Type__c,'');
           }
       }
       
       
    }
    public class wrapperMediType{
        public list<selectOption> lstSO{get;set;}
        public string TaperID{get;set;}
        
        public wrapperMediType(list<selectOption> s, string s2){
            lstSO = s;
            TaperID = s2;
        }
    }
    private void loadOrders(){
        
        if(medicalId !=null){
            list<Order__c> lstOrders = [select id,Medicine__c, Dosage_Form__c, Dose__c, Route__c, Frequency__c,
            Amount_per_Dosage__c, PRN__c, Last_Dose_Before_Admission__c, Justification__c, Brought_in_on_admission__c,
            Continue_on_admission__c, Continue_on_Discharge__c, was_destroyed__c, Notes__c, Medical__c, Duration__c 
             from Order__c where Medical__c =:medicalId and Taper__c = null ];
             
             lstOtherMedications = new list<wrapperOrder>();
             
             wrapperOrder wOrd;
             if(lstOrders!=null){
             for(integer i =0; i<lstOrders.size();i++){
                 wOrd = new wrapperOrder(lstOrders[i],i);
                 lstOtherMedications.add(wOrd);
             }
             }
             
        }
        
    }
    
    public list<selectoption> getTaperLst(){
        list<selectoption> options= new list<selectoption>();
        list<Taper__c> TaperLst= [select id,name from Taper__c where Active__c=true and Dosage_Type__c='Taper'];
        options.add(new selectoption('—-None—-', '—-None—-'));
        for(Taper__c Tins :TaperLst){
            options.add(new selectoption(Tins.id,TIns.name));
        }
        return options;
    }
    
    
    public void editRecord() {
        readOnly= True;
        lstOtherMedications.add(new wrapperOrder(new Order__c(),lstOtherMedications.size()));
    }
    
    public void SaveRecord(){
        Id RAConfig = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
        Savepoint sp = Database.setSavepoint();
       try{
            system.debug(medical.MC_Evaluation_Date__c);
            system.debug(medical);
            medical.id = medicalId ;
            update medical;
            
            Recurring_Assessment__c RA;
           try{
                RA = [select id, Vital_SIgns_Recurring_Time__c,COWS_Assessment_Recurring_Time__c, 
                CIWA_Assessment_Recurring_Time__c  from Recurring_Assessment__c where Medical__c =:medical.id and Status__c = 'Open' 
                and RecordTypeId =:RAConfig ];
           }
            catch(Exception e){
                RA = new Recurring_Assessment__c();
                RA.Medical__c = medical.id;
                RA.Status__c = 'Open';
                RA.RecordTypeId = RAConfig ;
            }
              
            if(medical.Visual_Check_Parameters1__c!='None')
                RA.Vital_SIgns_Recurring_Time__c = medical.Visual_Check_Parameters1__c ;
            if(medical.Vital_Sign_Parameters__c !='None')
                RA.Vital_SIgns_Recurring_Time__c = medical.Vital_Sign_Parameters__c ;
            if(medical.COWS_Parameters__c!='None')
                RA.COWS_Assessment_Recurring_Time__c= medical.COWS_Parameters__c;
            if(medical.CIWA_Parameters__c!='None')
                RA.CIWA_Assessment_Recurring_Time__c= medical.CIWA_Parameters__c;
        
            upsert RA;   
            
            createAllOrders(medical.id);
                         
            readonly=false;
       }
        catch(Exception ex){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,+ex.getMessage()+ex.getLineNumber()));           

        }
    }
    
    //create orders for tapers and prns
    private void createAllOrders(id medicalId){
        set<id> setTaperIDs = new set<id>();
        for(wrapperMediType wm : mapPRNTapers.values()){
            if(wm.TaperID != null && wm.TaperID != '')
                setTaperIDs.add(wm.TaperID);
        }
        
        system.debug(medical.MC_Evaluation_Date__c);
        //list for creating mars
        list<Event> lstMARS = new list<Event>();
        
        list<Order_Line_Item__c> lstOLIs = new list<Order_Line_Item__c>();
        
        list<Taper__c> lstTaper = [select id, (select id, Duration_In_Days__c, Amount_to_Use_Per_Dosage_Form__c, Dosage_Form__c, Strength__c, Frequency__c, 
        Medicine__c, Route__c, Taper__c from Taper_Line_Items__r) from Taper__c where id=: setTaperIDs or id=: taperID];
        
        if(taperID!= '—-None—-' && taperID!=null){
            Order__c ord = new Order__c();
            ord.Client_Chart__c = clientId;
            ord.Medical__c = medicalId;
            ord.Taper__c = taperID;
            ord.Start_Date__c = medical.MC_Evaluation_Date__c;
            ord.Order_By__c = Userinfo.getUserId();
            ord.Status__c = 'Active';
            ord.Order_Type__c = 'Standard - Taper';
            insert ord;                        
            for(Taper__c t: lstTaper){
                for(Taper_Line_Item__c TLI :  t.Taper_Line_Items__r){
                    if(TLI.Duration_In_Days__c == 1 && t.id == taperID){
                        Order_Line_Item__c oli = OrderUtil.returnOLI(ord.ID,TLI);
                        lstOLIs.add(oli);
                        
                        
                    }
                }
            }
            if(lstOLIs.size()>0){
                insert lstOLIs;
                for(Order_Line_Item__c  oli :lstOLIs){
                    lstMARS.add(OrderUtil.returnStandardMARs(oli, ord, '',clientId));
                }
                if(lstMARS.size()>0)
                    insert lstMARS;
            }
        }
        if(mapPRNTapers.size()>0){
        
            map<id,Order__c> mapTaperOrder = new map<id,Order__c>();
            for(string MT : mapPRNTapers.keyset()){
                system.debug(mapPRNTapers.get(MT).taperID);
            //for(string tid : mapPRNTapers.get()){
                if(mapPRNTapers.get(MT).taperID!='' && mapPRNTapers.get(MT).taperID!=null){
                    Order__c ord = new Order__c();
                    ord.Client_Chart__c = clientId;
                    ord.Medical__c = medicalId;
                    ord.Taper__c = mapPRNTapers.get(MT).taperID;
                    ord.Start_Date__c = medical.MC_Evaluation_Date__c;
                    ord.Order_By__c = Userinfo.getUserId();
                    ord.Status__c = 'Active';
                    ord.Order_Type__c = 'Standard - PRN';
                    ord.PRN__c = true;
                    mapTaperOrder.put(mapPRNTapers.get(MT).taperID,ord);
                }
            //}
            
            }
            if(mapTaperOrder.size()>0)
                insert mapTaperOrder.values();
                
            for(Taper__c t: lstTaper){
                system.debug(t.Taper_Line_Items__r.size());
                for(Taper_Line_Item__c TLI :  t.Taper_Line_Items__r){
                    system.debug(t.id);
                    system.debug(taperID);
                    if(TLI.Duration_In_Days__c == 1 && t.id != taperID){
                        system.debug('inside if');
                         Order_Line_Item__c oli = OrderUtil.returnOLI(mapTaperOrder.get(t.id).ID,TLI);
                        lstMARS.add(OrderUtil.returnStandardPRNOTHERMARs(oli , mapTaperOrder.get(t.id), '',true,clientId));
                        //break;
                    }
                }
            }
            
        }
        
        if(lstOtherMedications.size()>0){

            map<integer,Order__c> mapIndexOrder = new map<integer,Order__c>();
            
            for(wrapperOrder wo : lstOtherMedications){
                if(wo.ord.Medicine__c != null && wo.ord.id==null){
                    wo.ord.Client_Chart__c = clientId;
                    wo.ord.Medical__c = medicalId;
                    
                    wo.ord.Start_Date__c = medical.MC_Evaluation_Date__c;
                    wo.ord.Order_By__c = Userinfo.getUserId();
                    wo.ord.Status__c = 'Active';
                    if(wo.ord.Continue_on_admission__c){                                                
                        wo.ord.Order_Type__c = 'Manual';       
                        
                    }
                    else{
                        wo.ord.Order_Type__c = 'Action'; 
                    }
                    
                    mapIndexOrder.put(wo.index,wo.ord);
                }
            }
            if(mapIndexOrder.size()>0)
                insert mapIndexOrder.values();
                
            for(Order__c o : mapIndexOrder.values()){
                if(o.Order_Type__c !='Action')
                    lstMARS.add(OrderUtil.returnManualMARs(o,clientId));
            }
        }
        
        if(lstMARS.size()>0)
            insert lstMARS;
        
    }
    
    
    public PageReference SaveMedical(){
        Savepoint sp = Database.setSavepoint();
        try{
            medical.recordtypeid=AdmitOrderRtId;
            medical.Client_Chart__c = clientId;
            insert medical;
             return new PageReference('/apex/MedicalHomeEditPage?ID='+clientId +'&mcid='+medical.id+'&rtId='+AdmitOrderRtId);
            
        }
        catch(Exception ex){
            Database.rollback(sp);
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid username'+ex+ex.getLineNumber()));           

            return null;
        }
    }
    
    public List<SelectOption> getVisual(){
        Schema.sObjectType sobject_type = Recurring_Assessment__c.getSObjectType();

        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
      
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Vital_SIgns_Recurring_Time__c').getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None', 'None'));
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getVital(){
        Schema.sObjectType sobject_type = Recurring_Assessment__c.getSObjectType();

        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
      
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Vital_SIgns_Recurring_Time__c').getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None', 'None'));
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getCOWS(){
        Schema.sObjectType sobject_type = Recurring_Assessment__c.getSObjectType();

        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
      
        List<Schema.PicklistEntry> pick_list_values = field_map.get('COWS_Assessment_Recurring_Time__c').getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None', 'None'));
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getCIWA(){
        Schema.sObjectType sobject_type = Recurring_Assessment__c.getSObjectType();

        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
      
        List<Schema.PicklistEntry> pick_list_values = field_map.get('CIWA_Assessment_Recurring_Time__c').getDescribe().getPickListValues();

        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None', 'None'));
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    public class wrapperOrder{
        public Order__c ord{get;set;}
        public integer index{get;set;}
        
        public wrapperOrder(Order__c o, integer i){
            ord = o;
            index = i;
        }
    }
    
    public void addmedi(){
        lstOtherMedications.add(new wrapperOrder(new Order__c(),lstOtherMedications.size()));
    }
    
    public void deletemedi(){
    
        id orderid = system.CurrentPageReference().getParameters().get('orderId');
        system.debug(orderid );
        string ind = system.CurrentPageReference().getParameters().get('index');
        system.debug(ind);
        integer index = integer.valueof(ind);
        
        system.debug(index);
        delete[Select ID from order__c where ID =: orderid ];
        lstOtherMedications.remove(index);
    }

}