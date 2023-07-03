@isTest
private class API_WhatsAppDLReventCaptureTest {
    @isTest
    static void testCaptureDLREventResponse() {
        // Create a mock request
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestURI = '/whatsapp_dlr_event_capture/';
        mockRequest.httpMethod = 'POST';
        mockRequest.requestBody = Blob.valueOf('{"key":"value"}');
        
        // Create a mock response
        RestResponse mockResponse = new RestResponse();
        
        // Set up the test context
        RestContext.request = mockRequest;
        RestContext.response = mockResponse;
        
        // Call the method under test
        Test.startTest();
        API_WhatsAppDLReventCapture.captureDLREventResponse();
        Test.stopTest();
        
        /* Verify the email was sent
        Messaging.SingleEmailMessage[] sentEmails = Messaging.sendEmail(new Messaging.SingleEmailMessage());
        System.assertEquals(1, sentEmails.size(), 'Expected 1 email to be sent');
        
        // Verify the email properties
        Messaging.SingleEmailMessage sentEmail = sentEmails[0];
        System.assertEquals(2, sentEmail.getToAddresses().size(), 'Expected 2 recipients');
        System.assertEquals('this is the response from whatsapp for DLR event!', sentEmail.getSubject(), 'Unexpected email subject');
        System.assertEquals('{"key":"value"}', sentEmail.getPlainTextBody(), 'Unexpected email plain text body');
        System.assertEquals('{"key":"value"}', sentEmail.getHtmlBody(), 'Unexpected email HTML body');  */
    }
}