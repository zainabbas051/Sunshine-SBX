public class PreAdmission_Ctrl {

    public Pre_Admission_Assessment__c preAdmission {
        get;
        set;
    }
    private ApexPages.StandardController stdController;
    public Boolean shouldRedirect {
        public get;
        private set;
    }
    public Boolean showEditButton {
        public get;
        private set;
    }
    public boolean readOnly {
        get;
        set;
    }



    List
        <
        Pre_Admission_Assessment__c > lstPreAdmission {
            get;
            set;
        }


    id opptyId;
    public PreAdmission_Ctrl(ApexPages.StandardController controller) {
        opptyId = controller.getId();
        getValuesFromFieldSet();


    }

    public PreAdmission_Ctrl() {

    }

    public void getValuesFromFieldSet() {


        List
            <
            Pre_Admission_Assessment__c > lstPreAdmission = getPreAdmission(opptyId);
        if (lstPreAdmission.isEmpty()) {
            this.preAdmission = new Pre_Admission_Assessment__c();
            this.preAdmission.Opportunity__c = opptyId;
            showEditButton = true;
            readOnly = true;
            return;
        }
        this.preAdmission = lstPreAdmission[0];
        readOnly = true;

    }




    private List
        <
        Pre_Admission_Assessment__c > getPreAdmission(String opptyId) {

            String query = 'SELECT ';
            //system.debug('++fieldset'+fieldSetName);
            // fieldSetMemberList =  PreAdmission_Ctrl.readFieldSet(fieldSetName,'Pre_Admission_Assessment__c');
            for (Schema.FieldSetMember f: this.getFields()) {

                query += f.getFieldPath() + ',';
            }
            query += 'Id, Name FROM Pre_Admission_Assessment__c where Opportunity__c = :opptyId order by LastModifiedDate DESC LIMIT 1';
            return Database.query(query);

        }

    public List
        <
        Schema.FieldSetMember > getFields() {
            return SObjectType.Pre_Admission_Assessment__c.FieldSets.SubstanceAbuse.getFields();
        }


    public PageReference saveRecord() {

        upsert preAdmission;

        return cancelRecord();
    }

    public void EditRecord() {

        readOnly = false;
        showEditButton = false;
    }

    public PageReference cancelRecord() {

        readOnly = true;
        showEditButton = true;
        return null;
    }

}