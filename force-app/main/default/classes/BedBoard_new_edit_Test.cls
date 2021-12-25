@IsTest
private class BedBoard_new_edit_Test {
    public static testmethod void BedBoard_new_edit_Test(){
        Test.startTest();
        PrepareData();
        Test.stopTest();
    }
    public static void PrepareData(){
        
        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;
        
        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Willowsprings Recovery';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.Admit_Date_Time__c = dateTime.NOW();
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Willowsprings Recovery').getRecordTypeId();
        Insert ClientID;
        
        Account sunshine = new Account();
        sunshine.Name = 'Willowsprings Recovery';
        insert sunshine;
        
        Bed_Board_Configuration__c house = new Bed_Board_Configuration__c();
        house.House_Name__c = 'House 1';
        house.Sunshine_Center__c = sunshine.Id;
        insert house;
        
        ApexPages.currentPage().getParameters().put('ID', house.Id);
        ApexPages.currentPage().getParameters().put('edit', 'true');
        
        Bed_Board_Configuration__c room = new Bed_Board_Configuration__c();
        room.House__c = house.Id;
        room.Room_Number__c = 'room 1';
        insert room;
        
        Bed_Board_Configuration__c bed = new Bed_Board_Configuration__c();
        bed.Room__c = room.Id;
        bed.Bed_Number__c = 'bed 1';
        insert bed;
        
        BedBoard_new_edit bbne = new BedBoard_new_edit();
        
        bbne.EditRoomId = room.Id;
        bbne.EditBedId = bed.Id;
        bbne.saveHouse();
        
        bbne.addRooms();
        bbne.saveRoom();
        bbne.editRoom();
        bbne.SaveEditRoom();
        bbne.cancelEditRooms();
        bbne.cancelRooms();
        
        bbne.addBeds();
        bbne.saveBeds();
        bbne.editBed();
        bbne.SaveEditBed();
        bbne.cancelEditBeds();
        bbne.cancelBeds();
        
        bbne.deleteBed();
        bbne.deleteRoom();
        
        bbne.backToAllBed();
        
    }
}