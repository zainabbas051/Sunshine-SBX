/*
    controller class for txdc_detoxtreatmentplan vf component. Detox Treatment Plan is a record type of 
    tx and dc plans object.
    @author: Huma Zafar
    TestClass: txdc_detoxtreatmentplanTest
*/
public class txdc_detoxtreatmentplan {

    public Tx_and_D_C_Plans__c txdc {
        get;
        set;
    }

    public list < wrapperObjective > lstWrapperObjectives {
        get;
        set;
    }

    public boolean EditPage {
        get;
        set;
    }
    
    public boolean IsClosed {
        
        get;
        set;
    }

    public Map < ID, List < taskWrapper >> MapOfTargetAgainstObject {
        get;
        set;
    }

    public list < SelectOption > listAllCodes {
        get;
        set;
    }

    public list < string > Codes {
        get;
        set;
    }


    //hidden field
    public string SelectedSignedOption {
        get;
        set;
    }
    public string ImageUrlAddress {
        get;
        set;
    }
    
    
     public boolean callJS{
        
        get;
        set;
    }

    Set < ID > setOfObjective;

    public ID objectiveIDToAddTask{
        
        get;
        set;
    
    }

    id txdcId;
    integer counter = 0;

    public User userObj{
        
        get;
        set;
    
    }

    public string RecordType {
        get;
        set;
    }
    
    public ID TargetID{
        
        get;
        set;
    }
    
    public Integer TargetIndex{
        
        get;
        set;
    }
    
    public ID ObjID{
        
        get;
        set;
    }
    
    public Integer ObjectiveIndex{
        
        get;
        set;
    }
    
    

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
    
    public Client_Chart__c clientRecord {get; set;}
    
    public txdc_detoxtreatmentplan() {

        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;
        
        callJS = false;

        string clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        MapOfTargetAgainstObject = new Map < ID, List < taskWrapper >> ();

        txdc = [select id, AS_EVIDENCED_BY__c, Client_Chart__c, Client_Chart__r.Name, Client_Needs_to_Be_Detoxed_from__c, RecordType.Name,
            Client_Image_Url__c, Client_Signed_User__c, Client_Closed_Date__c, SignedBy__c, Staff_Signature_URL__c, Staff_Signed_User__c, Staff_Closed_Date__c,
            Client_Chart__r.Treatment_Center__r.Name, Presenting_Problem__c, Status__c, Date_Time__c,Client_Image_Url_Closed__c ,Staff_Signature_URL_Closed__c,
            Staff_Active_Date__c,Client_Active_Date__c,Client_Signed_User_Closed__c,Staff_Signed_User_Closed__c,Intern_Signature_URL__c ,Intern_Closed_Date__c ,
            Intern_Signed_User__c 
            from Tx_and_D_C_Plans__c where Client_Chart__c =: clientChartId and RecordType.Name = 'Detox Treatment Plan' limit 1
        ];

        clientRecord = [select id,  Diagnosis_Code__c, RecordType.Name from Client_Chart__c where id =: clientChartId];
        
        RecordType = txdc.RecordType.Name;

        userObj = [Select id, name, title, User_Role__c from user where id =: userinfo.getUserID()];

        txdcId = txdc.id;

        if (txdc.Status__c == '' || txdc.Status__c == 'Open') {

            txdc.Status__c = 'Open';
            txdc.SignedBy__c = 'None';
        }

        EditPage = false;
        loadDetoxObjectives();
        fillDiagnosisCodes();
        checkExistingCode();
        
        IsClosed = checkTargetClosed();
    }

    void checkExistingCode() {

        Codes = new List < string > ();
        if( txdc.Presenting_Problem__c != NULL &&  txdc.Presenting_Problem__c != '' && txdc.Status__c == 'Closed'){
            for (string exstCode: txdc.Presenting_Problem__c.split(';')) {
                Codes.add(exstCode);
            }
        }
		else if(clientRecord != null && clientRecord.Diagnosis_Code__c != null)
        {
            txdc.Presenting_Problem__c  = clientRecord.Diagnosis_Code__c;
            for(string exstCode: clientRecord.Diagnosis_Code__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
    }
    
    
    private void loadDetoxObjectives() {

        lstWrapperObjectives = new list < wrapperObjective > ();
        setOfObjective = new set < ID > ();
     

        list < Detox_Objectives__c > lstDetoxObjectives = [select ID, Objective_Description_Long__c, Intervention__c,
            Staff_Responsible__c, Date_Comment__c, Tx_and_D_C_Plans__c, Objective__c,
            Status__c, Target_Date__c from Detox_Objectives__c where Tx_and_D_C_Plans__c =: txdcId order by Objective__c
        ];

        set < string > setObjectiveNames = new set < string > ();

        wrapperObjective obj;

        for (Detox_Objectives__c Dobj: lstDetoxObjectives) {
            if (!setObjectiveNames.contains(Dobj.Objective__c)) {
                /* if(Dobj.Tx_and_D_C_Plans__c ==null)
                    Dobj.id = null;*/
                obj = new wrapperObjective(Dobj, counter, false);
                lstWrapperObjectives.add(obj);
                counter++;
                setObjectiveNames.add(Dobj.Objective__c);
                setOfObjective.add(Dobj.ID);
            }
        }

        LoadObjectivesTasks();

    }

    void LoadObjectivesTasks() {

        List < Task > lstTskObj;

        //add objectives in map 
        for (string key: setOfObjective) MapOfTargetAgainstObject.put(key, new List < taskWrapper > ());

        List < Task > lastTasks = [Select Id, ActivityDate, Description, Status, whatId, End_Date__c, Created_By_Alias__c,
            CreatedDate, Closed_By__c From Task WHERE whatId in: setOfObjective];

        for (Task t: lastTasks) {

            if (MapOfTargetAgainstObject.containsKey(t.WhatId)) {
                MapOfTargetAgainstObject.get(t.WhatId).add(new taskWrapper(t,false));
            }

        }
    }

    public void EditFullPage() {
        EditPage = true;
    }

    public void CancelPage() {
        EditPage = false;
    }

    public Pagereference submit() {
        System.debug('submit button method');

        string strCode = '';
        for (string newcode: Codes)
            strCode += newcode + ';';

        //txdc.Presenting_Problem__c = strCode;
        upsert txdc;
        
        clientRecord.Diagnosis_Code__c = txdc.Presenting_Problem__c;
        update clientRecord;

        list < Detox_Objectives__c > lstObjectives = new list < Detox_Objectives__c > ();
        for (wrapperObjective obj: lstWrapperObjectives) {
            // obj.DObj.Tx_and_D_C_Plans__c  = txdc.id;
            lstObjectives.add(obj.DObj);
            obj.isEdit = false;

        }
        if (!lstObjectives.isEmpty())
            upsert lstObjectives;

        if (!MapOfTargetAgainstObject.isEmpty()) {
            List < Task > lstOfTaskToUpdate = new List < Task > ();
            for (List < taskWrapper > lstTask: MapOfTargetAgainstObject.values()) {
                
                for(TaskWrapper tk : lstTask){
                    
                    lstOfTaskToUpdate.add(tk.tskObj);
                    tk.isEdit = false;
                
                }
            }

            upsert lstOfTaskToUpdate;
        }


        EditPage = false;

        return null;
    }
    //objective Function
    
    public void SaveObjective(){
        
     
         WrapperObjective obj = lstWrapperObjectives.get(ObjectiveIndex);
         
         obj.IsEdit = false;
         upsert obj.DObj;
        
    }
    
    
    public void Edit() {
      
         WrapperObjective obj = lstWrapperObjectives.get(ObjectiveIndex);         
         obj.IsEdit = true;

    }

    
    
    boolean checkTargetClosed(){
        
        
        for(string key : MapOfTargetAgainstObject.keySet()){
            
            for(taskWrapper iTk : MapOfTargetAgainstObject.get(key)){
                
                if(iTk.tskObj.Status == 'Open')
                    return false;
            }
        }
        
        return true;
        
    }


    public void RemoveObjectiveFromList() {

        
        delete[Select ID from Detox_Objectives__c where ID =: ObjID];
        lstWrapperObjectives.remove(ObjectiveIndex);
    }
    //target functions
    
     public void AddTargets() {
        
        Task objTask = new Task();
        objTask.RecordTypeId = Constants.TaskTxDcPlansRecordTypeId;
        objTask.whatId = objectiveIDToAddTask;
        objTask.Status = 'Open';
        insert objTask;
        
        objTask = [Select ID, whatId,ActivityDate ,Status,Description ,Closed_By__c, End_Date__c  , CreatedDate , Created_By_Alias__c from task where ID =: objTask.ID];
        // add task in map
        if (MapOfTargetAgainstObject.containsKey(objTask.WhatId))
            MapOfTargetAgainstObject.get(objTask.WhatId).add( new taskWrapper(objTask , true));
        else
            MapOfTargetAgainstObject.put(objTask.WhatId, new List <taskWrapper> {
                new taskWrapper(objTask ,true)
            });
    }
    
    public void SaveTargets() {

        ID objID = system.CurrentPageReference().getParameters().get('TargetObjID');
        integer Index = Integer.valueof(system.CurrentPageReference().getParameters().get('targetIndex'));
        taskWrapper tr = MapOfTargetAgainstObject.get(ObjID).get(Index);

        if (tr.tskObj.Status != 'Open') {
            tr.tskObj.Closed_By__c = userObj.name.substring(0, 1) + userObj.name.split(' ')[1].substring(0, 1).touppercase();
            tr.tskObj.End_Date__c = Date.Today();
            
            
        }
        tr.isEdit = false;
        upsert tr.tskObj;
        IsClosed = checkTargetClosed();
    }
    
    public void RemoveTarget() {
        
        string TargetId = system.CurrentPageReference().getParameters().get('TargetId');
        ID objID = system.CurrentPageReference().getParameters().get('TargetObjID');
        integer Index = Integer.valueof(system.CurrentPageReference().getParameters().get('targetIndex'));

       /* if (TargetId != '')
            delete[Select id from task where id =: TargetId];*/
        delete MapOfTargetAgainstObject.get(objID)[index].tskObj;
        MapOfTargetAgainstObject.get(objID).remove(Index);
        IsClosed = checkTargetClosed();
    }
    
    public void EditTarget() {
    
        system.debug('sdfsafsd'  +MapOfTargetAgainstObject);
           system.debug('sdfsafsd'  +TargetID +' sdfsdfsdf '+TargetIndex);
        taskWrapper tk = MapOfTargetAgainstObject.get(TargetID).get(TargetIndex);
        tk.isEdit = true;
    } 

    public void AddMore() {

        wrapperObjective obj = new wrapperObjective(new Detox_Objectives__c(), lstWrapperObjectives.size(), true);
        obj.DObj.Objective__c = 'Objective ' + (lstWrapperObjectives.size() + 1);
        obj.DObj.Tx_and_D_C_Plans__c = txdc.id;
        insert obj.DObj;
      
        MapOfTargetAgainstObject.put(obj.DObj.ID, new List < taskWrapper > {
            new taskWrapper( new Task (Status = 'Open'),false)
        });
        lstWrapperObjectives.add(obj);

    }

    public PageReference ActiveTXDxPlans() {
    
        callJs = false;
        //if active then it will go for close after complete signature
        
        if(txdc.Client_Closed_Date__c != null &&   txdc.Status__c == 'Review Pending') txdc.Status__c = 'In Use';
        if (txdc.Status__c == 'In Use') {

            if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null) {

                txdc.Staff_Signature_URL_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Staff_Signed_User_Closed__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Staff_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Staff';
                
            } else if (SelectedSignedOption == 'Patient') {

                txdc.Client_Image_Url_Closed__c = AWSURL + ImageUrlAddress;
                txdc.Client_Signed_User_Closed__c = '(Patient) ' + txdc.Client_Chart__r.Name;
                txdc.Client_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
                
            } else if (userObj.User_Role__c != null) {

                txdc.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
                txdc.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
                txdc.Intern_Closed_Date__c = DateTime.Now();
                txdc.SignedBy__c = 'Client';
                txdc.Status__c = 'Review Pending';
            }

             /*if ((txdc.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdc.Staff_Signed_User_Closed__c )) && (txdc.Client_Signed_User_Closed__c != null || String.isNotBlank(txdc.Client_Signed_User_Closed__c ))) {
                txdc.Status__c = 'Closed';
                txdc.SignedBy__c = 'All'; // signing is complete
              

            }*/
            // just statff signature required by ticket number # 301
            if ((txdc.Staff_Signed_User_Closed__c != null || String.isNotBlank(txdc.Staff_Signed_User_Closed__c ))) {
                txdc.Status__c = 'Closed';
                txdc.SignedBy__c = 'All'; // signing is complete
              

            }
            
            if(txdc.Status__c == 'In Use' ){
             callJS = true;
            }
         
           update txdc;
           return null;
         

        }

        if (SelectedSignedOption == 'Staff' && userObj.User_Role__c == null) {


            txdc.Staff_Signature_URL__c = AWSURL + ImageUrlAddress;
            txdc.Staff_Signed_User__c = 'Staff present: ' + userObj.Name + ',' + userObj.Title;
            txdc.Staff_Active_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Staff';
        } else if (SelectedSignedOption == 'Patient') {

            txdc.Client_Image_Url__c = AWSURL + ImageUrlAddress;
            txdc.Client_Signed_User__c = '(Patient) ' + txdc.Client_Chart__r.Name;
            txdc.Client_Active_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Client';
        } else if (userObj.User_Role__c != null) {

            txdc.Intern_Signature_URL__c = AWSURL + ImageUrlAddress;
            txdc.Intern_Signed_User__c = userObj.User_Role__c+' present: ' + userObj.Name + ',' + userObj.Title;
            txdc.Intern_Closed_Date__c = DateTime.Now();
            txdc.SignedBy__c = 'Client';
            txdc.Status__c = 'Review Pending';
        }

        if ((txdc.Staff_Signed_User__c != null || String.isNotBlank(txdc.Staff_Signed_User__c)) && (txdc.Client_Signed_User__c != null || String.isNotBlank(txdc.Client_Signed_User__c))) {
            txdc.Status__c = 'In Use';
            txdc.SignedBy__c = 'Client'; // to sign in again or just client by ticket number # 301
            

        }
     
        if(txdc.Status__c == 'Open'){
             callJS = true;
        }
         
           update txdc;
           return null;
    }

   

    private void fillDiagnosisCodes() {
        listAllCodes = new list < SelectOption > ();
        List < DiagnosisCode__c > myCs = DiagnosisCode__c.getall().values();
        for (DiagnosisCode__c m: myCs) {
            listAllCodes.add(new SelectOption((m.Name + ' ' + m.Description__c), (m.Name + ' ' + m.Description__c)));
        }
    }

    public class wrapperObjective {
        public Detox_Objectives__c DObj {
            get;
            set;
        }
        public integer index {
            get;
            set;
        }
        public boolean isEdit {
            get;
            set;
        }
        public wrapperObjective(Detox_Objectives__c d, integer i, boolean e) {
            DObj = d;
            index = i;
            isEdit = e;

        }
    }
    
     public class taskWrapper {
         
        public Task tskObj {
            get;
            set;
        }
        public boolean isEdit {
            get;
            set;
        }
        public taskWrapper(Task t,  boolean e) {
            tskObj = t;
            isEdit = e;

        }
    }    
}