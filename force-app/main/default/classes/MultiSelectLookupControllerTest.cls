@isTest
public class MultiSelectLookupControllerTest {
	@isTest
    static void testfetchRecords(){
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<String> slist = new List<String>{testAccount.Id};
        
        List<MultiSelectLookupController.RecordsData> recordsDataList = MultiSelectLookupController.fetchRecords('Account', 'Name', 'Test', 'slist');
        
         MultiSelectLookupController.RecordsData recordsData = recordsDataList[0];
    }
    
     @isTest
     static void testAssignCriteriaToGroup() {
        
        Assignment_Group__c testAssignmentGroup = new Assignment_Group__c();
        insert testAssignmentGroup;
        List<String> selectedGroupIds = new List<String>();
        selectedGroupIds.add(testAssignmentGroup.Id);
        
        String result = MultiSelectLookupController.assignCriteriaToGroup(selectedGroupIds, 'a0V1m000004toc7EAA');
             
        Assignment_Group__c updatedAssignmentGroup = [SELECT Lead_Assigning_Criteria__c FROM Assignment_Group__c WHERE Id = :testAssignmentGroup.Id];
        
    }
}