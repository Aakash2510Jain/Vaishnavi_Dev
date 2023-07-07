@IsTest
public class UtilityPickListClassTest {
    
    @IsTest
    public static void testGetPicklistValues() {
        // Create a test custom object and custom field
        Schema.SObjectType customObjectType = Schema.getGlobalDescribe().get('Lead__c');
        SObject customObject = customObjectType.newSObject();
        customObject.put('Name__c', 'Test Record');
        insert customObject;
        
        Schema.DescribeSObjectResult describeResult = customObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        Schema.DescribeFieldResult fieldDescribe = fieldMap.get('Lead_Stage__c').getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        
        // Call the method being tested
        List<String> actualPicklistValues = UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Stage__c');
        
        // Assert the expected picklist values
        List<String> expectedPicklistValues = new List<String>();
        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            expectedPicklistValues.add(picklistEntry.getLabel().trim());
        }
        
        System.assertEquals(expectedPicklistValues, actualPicklistValues);
    }
    
    @IsTest
    public static void testGetPicklistValuesWithNone() {
        // Create a test custom object and custom field
        Schema.SObjectType customObjectType = Schema.getGlobalDescribe().get('Lead__c');
        SObject customObject = customObjectType.newSObject();
        customObject.put('Name__c', 'Test Record');
        insert customObject;
        
        Schema.DescribeSObjectResult describeResult = customObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        Schema.DescribeFieldResult fieldDescribe = fieldMap.get('Lead_Stage__c').getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        
        // Call the method being tested
        List<String> actualPicklistValuesWithNone = UtilityPickListClass.getPicklistValuesWithNone('Lead__c', 'Lead_Stage__c');
        
        // Assert the expected picklist values with '--None--' added at the beginning
        List<String> expectedPicklistValuesWithNone = new List<String>{'--None--'};
        for (Schema.PicklistEntry picklistEntry : picklistValues) {
            expectedPicklistValuesWithNone.add(picklistEntry.getLabel().trim());
        }
        
        System.assertEquals(expectedPicklistValuesWithNone, actualPicklistValuesWithNone);
    }
}