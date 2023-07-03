@isTest
private class API_MagicBricks_Test {
    @isTest
    static void testCreateLeadFromMagicBricks_NewLead() {
        // Set up the REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/magicBricks';
        request.httpMethod = 'POST';
        
        // Set the request body for a new lead
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('url', 'http://app.sell.do/api/leads/create?source=Magic%20Bricks&mobile=9791155XXX&email=ashokraj.ok@gXXXX.com&time=145000&isd=Plaza%20Bounty%20Acres&name=Ashok%20Raj&msg=Plaza%20Bounty%20Acres,%20Chennai%20-%20I%20am%20interested%20in%20your%20project.%20Please%20contact%20me.%20Additional%20Details%20-%20Multistorey%20Apartment&project=Plaza%20Bounty%20Acres&dt=20180722&City=Chennai&api_key=aff532af1e2b22588a58XXXXXXXXXXXX');
        requestBody.put('leadstage', 'New Enquiry');
        requestBody.put('leadtype', 'Normal');
        requestBody.put('callrecording', 'recording link');
        requestBody.put('additionalcomments', 'interested and looking for 2bhk');
        requestBody.put('sitevisitdatetime', '2022-07-11T09:11:03.000');
        requestBody.put('leadid', '');
        
        String requestBodyJson = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJson);
        
        // Set up the REST response
        RestResponse response = new RestResponse();
        
        // Call the method to be tested
        Test.startTest();
        RestContext.request = request;
        RestContext.response = response;
        API_MagicBricks.createLeadFromMagicBricks();
        Test.stopTest();
        
    }
    
    @isTest
    static void testCreateLeadFromMagicBricks_UpdateLead() {
        // Set up the REST request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/magicBricks';
        request.httpMethod = 'POST';
        
        // Set the request body for updating a lead
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('url', '');
        requestBody.put('leadstage', 'New Enquiry');
        requestBody.put('leadtype', 'Normal');
        requestBody.put('callrecording', 'recording link');
        requestBody.put('additionalcomments', 'interested and looking for 2bhk');
        requestBody.put('sitevisitdatetime', '2022-07-11T09:11:03.000');
        requestBody.put('leadid', '001XXXXXXXXXXXXXXX'); // Replace with an existing Lead Id
        
        String requestBodyJson = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJson);
        
        // Set up the REST response
        RestResponse response = new RestResponse();
        
        // Call the method to be tested
        Test.startTest();
        RestContext.request = request;
        RestContext.response = response;
        API_MagicBricks.createLeadFromMagicBricks();
        Test.stopTest();
        
        
    }
    
   
}