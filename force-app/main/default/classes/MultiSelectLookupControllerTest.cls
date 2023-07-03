@isTest
public class MultiSelectLookupControllerTest {
    @isTest
    static void testFetchRecords() {
        
        Account testAccount1 = new Account(Name = 'Test Account 1');
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{testAccount1, testAccount2};
            
        String objectName = 'Account';
        String filterField = 'Name';
        String searchString = 'Test';
        List<String> selectedValues = new List<String>{testAccount1.Id};
        String values = JSON.serialize(selectedValues);
        
        Test.startTest();
        List<MultiSelectLookupController.RecordsData> result = MultiSelectLookupController.fetchRecords(objectName, filterField, searchString, values);
       // List<MultiSelectLookupController.RecordsData> result1 = MultiSelectLookupController.fetchRecords(null, null, null, null);
        
        Test.stopTest(); 
        
    }
    
    @isTest
    static void testAssignCriteriaToGroup() {
        
        List<String> selectedGroupIds = new List<String>{'groupId1', 'groupId2'};
        String assCriteriaId = 'criteriaId';
        
        List<Assignment_Group__c> assGroupList = new List<Assignment_Group__c>{
            new Assignment_Group__c(Name = 'groupId1'),
            new Assignment_Group__c(Name = 'groupId2')
        };
        insert assGroupList;
        
        Test.startTest();
        MultiSelectLookupController.assignCriteriaToGroup(selectedGroupIds, assCriteriaId);
        Test.stopTest();
    }
    
    /*
    @isTest
    static void testAssignCriteriaToGroup() {
        
        Assignment_Group__c testAssignmentGroup = new Assignment_Group__c(Name = 'test Assignment');
        insert testAssignmentGroup;
        
        List<String> selectedGroupIds = new List<String>();
        selectedGroupIds.add(testAssignmentGroup.Id);
        
        MultiSelectLookupController.assignCriteriaToGroup(selectedGroupIds, 'a0V1m000004toc7EAA');
        
        
    }  */
}