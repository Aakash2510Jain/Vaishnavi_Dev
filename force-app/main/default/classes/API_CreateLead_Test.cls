@IsTest
private class API_CreateLead_Test {

    @IsTest
    static void testDoPostWithValidLead() {
       
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/CreateLead/';
        req.httpMethod = 'POST';
        
        Lead newLead = new Lead();
        newLead.FirstName = 'Tushar';
        newLead.LastName = 'Kumar';
        
        String leadJson = JSON.serialize(newLead);
        req.requestBody = Blob.valueOf(leadJson);
        RestContext.request = req;
         
        API_CreateLead.doPost();
        
    }
    
    @IsTest
    static void testDoPostWithEmptyRequest() {
        
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/CreateLead/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        RestContext.request = req;
        
        API_CreateLead.doPost();
        
        RestResponse res = RestContext.response;      
        
        IntegrationWrapper.APIResponseWrapper responseWrapper = (IntegrationWrapper.APIResponseWrapper)JSON.deserialize(
            res.responseBody.toString(),
            IntegrationWrapper.APIResponseWrapper.class
        );
       
    }
    
}