@isTest
public class propertyMgtControllerTest {
    @isTest
    static void testGetAvailableHostelRooms() {
        
        List<Property_Block__c> blocks = new List<Property_Block__c>{
            new Property_Block__c(Name = 'Block 1'),
            new Property_Block__c(Name = 'Block 2')
                };
                    insert blocks;
        
        Test.startTest();
        List<Property_Block__c> result = propertyMgtController.getavailableHostelRooms('RoomType', 'StudentId', 'SharingType', 'No');
        Test.stopTest();
    }
    
    @isTest
    static void testGetAvailableTowers() {
        
        Property_Block__c block = new Property_Block__c(Name = 'Block 1');
        insert block;
        
        List<Property_Tower__c> towers = new List<Property_Tower__c>{
            new Property_Tower__c(Name = 'Tower 1', Property_Block__c = block.Id),
                new Property_Tower__c(Name = 'Tower 2', Property_Block__c = block.Id)
                };
                    insert towers;
        
        Test.startTest();
        List<Property_Tower__c> result = propertyMgtController.getavailableTowers(block.Id);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetAvailableFloors() {
        Property_Block__c block = new Property_Block__c(Name = 'Block 1');
        insert block;  
        Property_Tower__c tower = new Property_Tower__c(Name = 'Tower 1',Property_Block__c = block.Id);
        insert tower;
        
        List<Property_Floor__c> floor = new List<Property_Floor__c>{
            new Property_Floor__c(Name = 'Floor 1', Property_Tower__c = tower.Id),
                new Property_Floor__c(Name = 'Floor 2', Property_Tower__c = tower.Id)
                };
                    insert floor;
        
        Test.startTest();
        List<Property_Floor__c> result = propertyMgtController.getavailableFloors(tower.Id);
        Test.stopTest();
        
    }
    
    @isTest
    static void testGetAvailableRooms() {
        
        Property_Floor__c floor = new Property_Floor__c(Name = 'Floor 1',Property_Tower__c = 'a0F1m000004WBfcEAG');
        insert floor;
        
        List<Property_Room__c> rooms = new List<Property_Room__c>{
            new Property_Room__c(Room_Type__c = '2 BHK', Property_Floor__c = floor.Id),
                new Property_Room__c(Room_Type__c = '3 BHK', Property_Floor__c = floor.Id)
                };
                    insert rooms;
        
        Test.startTest();
        List<Property_Room__c> result = propertyMgtController.getavailableRooms(floor.Id);
        Test.stopTest();
        
    }
    
    @isTest
    static void testBookAvailableRooms(){
        
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        
        Deal__c dealRec = new Deal__c(Name = 'Test Deal',Contact__c = con.Id);
        insert dealRec;
        
        Property_Booking__c pbook = new Property_Booking__c(Deal__c = dealRec.Id);
        insert pbook;
        
        Property_Block__c blkRec = new Property_Block__c(Name = 'Test Block');
        insert blkRec;
        
        Property_Tower__c towerRec = new Property_Tower__c(Name = 'Test Tower',Property_Block__c = blkRec.Id);
        insert towerRec;
        
        Property_Floor__c floorRec = new Property_Floor__c(Name = 'Test Floor',Property_Tower__c = towerRec.Id);
        insert floorRec;
        
        Property_Room__c room = new Property_Room__c(Room_Type__c = '2 BHK',Property_Floor__c = floorRec.Id );
        insert room;
        
        
        Test.startTest();
         propertyMgtController.bookavailableRooms(String.valueOf(dealRec.Id),String.valueOf(room.Id));
        Test.stopTest();
    }
}