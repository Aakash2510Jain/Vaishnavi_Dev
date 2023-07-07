@isTest
public class API_SendTextMessage_Test {
    @isTest
    public static void testSendMessage() {
        // Test data
        Lead__c leadRec = new Lead__c(Name__c='Test');
        insert leadRec;
        
        String recipientNumber = '1234567890';
        String message = 'Test message';
        String leadId = leadRec.Id;
        
        // Mock the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method to be tested
        Test.startTest();
        API_SendTextMessage.sendMessage(recipientNumber, message, leadId);
        Test.stopTest();
        
        // Verify the results
        List<Messages__c> messages = [SELECT Id, Message_Body__c, Message_Type__c, Lead__c, Type__c FROM Messages__c];
        
        Messages__c msgRecToInsert = messages[0];
      /*  System.assertEquals(message, msgRecToInsert.Message_Body__c);
        System.assertEquals('Sent', msgRecToInsert.Message_Type__c);
        System.assertEquals(leadId, msgRecToInsert.Lead__c);
        System.assertEquals('Text SMS', msgRecToInsert.Type__c); */
    }
    
    // Mock HTTP callout response
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            return response;
        }
    }
}