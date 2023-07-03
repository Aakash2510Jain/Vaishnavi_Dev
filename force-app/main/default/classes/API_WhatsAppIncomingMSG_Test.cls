@isTest
private class API_WhatsAppIncomingMSG_Test {
    @isTest
    static void testCaptureIncomingWhatsAppMSG() {
        Lead__c leadRec = new Lead__c(Name__c ='test Incoming Msg',Phone__c= '7042458620');
        insert leadRec;
        
        Opportunity__c oppRec = new Opportunity__c(Opportunity_Name__c='Test opportunity',Phone__c='7042458620');
        insert oppRec;
        
        Messages__c messageRecToInsert = new Messages__c();
        messageRecToInsert.Message_Body__c = 'Hello';
        messageRecToInsert.Lead__c = leadRec.Id;
        messageRecToInsert.Type__c = 'Received';
        insert messageRecToInsert;
        
        Messages__c messageRecToInsert1 = new Messages__c();
        messageRecToInsert1.Message_Body__c = 'Hello';
        messageRecToInsert1.Opportunity__c = oppRec.Id;   
        messageRecToInsert1.Type__c = 'Received';
        insert messageRecToInsert1; 
        
        // Create a mock REST request
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestURI = '/services/apexrest/whatsapp_incoming_msg';
        mockRequest.httpMethod = 'POST';
        mockRequest.requestBody = Blob.valueOf('{"mobile":"7042458620","text":"Hello"}');
      
        // Set the mock request and response contexts
        RestContext.request = mockRequest;
        RestContext.response = new RestResponse();

        // Call the method under test
        Test.startTest();
        API_WhatsAppIncomingMSG.captureIncomingWhatsAppMSG();
        Test.stopTest();

        
    
    }
}