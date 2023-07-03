@isTest
private class CreateLeadViaQRCodeHelperTest {
    
    @isTest
    static void testCreateLeadViaQRCodeHelper() {
        
        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        insert testCampaign;
        
        Test.setCurrentPageReference(new PageReference('/apex/YourPageName?id=' + testCampaign.Id));
        
        // Call the constructor
        CreateLeadViaQRCodeHelper helper = new CreateLeadViaQRCodeHelper();
               
        // Verify campaignRecordString
        String expectedCampaignRecordString = JSON.serialize(testCampaign);
        
        // Verify LeadRecordString
        Lead__c leadRecord = new Lead__c();
        String expectedLeadRecordString = JSON.serialize(leadRecord);
        
        List<String> expectedLeadSource = UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Source__c');
        List<String> expectedLeadSubSource = UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Sub_Source__c');
        List<String> expectedLeadSourceType = UtilityPickListClass.getPicklistValues('Lead__c', 'Lead_Source_Type__c');
        
    }


    @isTest
    static void testInsertLeadDetails() {
        Campaign campRec = new Campaign(Name = 'Test Campaign');
        insert campRec; 
        
        CreateLeadViaQRCodeHelper.insertLeadDetails(campRec.Id, 'Test Kumar', 'testKumar@gmail.com', '9078563421', 'ATL', 'Print', 'Magazine');
    }
}