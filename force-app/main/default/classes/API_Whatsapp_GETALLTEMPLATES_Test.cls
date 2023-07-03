@isTest
private class API_Whatsapp_GETALLTEMPLATES_Test {
    @isTest
    static void testFetchAllWhatsAppTemplates() {
        // Create test data if needed
        // Test data setup
        
        // Set up the mock HTTP response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        Test.startTest();
        API_Whatsapp_GETALLTEMPLATES.fetchAllWhatsAppTemplates();
        Test.stopTest();
        
        
    }
    
    // Helper class to mock the HTTP response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            // Create a mock HTTP response
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            
            // Provide a sample API response with valid Salesforce record Ids
            response.setBody('{"data":[{"id":"001XXXXXXXXXXXXXXX","button_type":"Type1","category":"Category1","creation_time":"1234567890","updation_time":"1234567890","body":"Message1","name":"Template1"}]}');
            
            return response;
        }
    }
}