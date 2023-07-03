@isTest
private class API_CommonFloor_Test {
    @isTest
    static void testCreateLeadFromMagicBricks() {
       
        String requestBody = '{"name":"Test Lead","phone":"9805672134","email":"testLead@gmail.com"}';
        
        // Set up the REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/commonfloor';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(requestBody);
        
        // Set up the REST context
        RestContext.request = request;
        RestContext.response = new RestResponse();
        
        // Call the method to be tested
        Test.startTest();
        ResponseClass.ReponseWrapperforCommonFloor response = API_CommonFloor.createLeadFromMagicBricks();
        Test.stopTest();
        
        
        
    }
}