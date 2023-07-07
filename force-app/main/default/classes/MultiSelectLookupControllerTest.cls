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
    
    @IsTest
    public static void testAssignCriteriaToGroup() {
        // Create test data
       
            
        Execution_Criteria__c executionCriteria = new Execution_Criteria__c();
        insert executionCriteria;
        Assignment_Group__c testGroup1 = new Assignment_Group__c();
        testGroup1.Lead_Assigning_Criteria__c = executionCriteria.Id;
        
        Assignment_Group__c testGroup2 = new Assignment_Group__c();
        insert new List<Assignment_Group__c>{testGroup1, testGroup2};
        String assCriteriaId = executionCriteria.Id;
        
        // Call the method being tested
        Test.startTest();
        MultiSelectLookupController.assignCriteriaToGroup(new List<String>{testGroup1.Id, testGroup2.Id}, assCriteriaId);
        Test.stopTest();

        
    }
}