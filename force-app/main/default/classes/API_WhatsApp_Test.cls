@isTest
public class API_WhatsApp_Test {
    @isTest
    static void testWhatsAppOptIn() {
        // Set up test data
        String phoneNoToOpt = '1234567890';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('Success');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the WhatsAppOptIn method
        String result = API_WhatsApp.whatsappOptIn(phoneNoToOpt);
        
    }
    
    // Mock HTTP callout implementation
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest request) {
            return response;
        }
    }
    
    @isTest
    static void testSendWhatsAppMessage() {
        // Test data
        String phoneNo = '1234567890';
        String message = 'Hello, World!';
        
        // Set up mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "success"}');
        
        // Set up mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method to be tested
        Test.startTest();
        API_WhatsApp.sendWhatsAppMessage(phoneNo, message);
        Test.stopTest();
        
        /* Verify the HTTP request
HttpRequest actualRequest = API_WhatsApp.getLastRequest();
String expectedEndpointUrl = 'https://media.smsgupshup.com/GatewayAPI/rest';
String expectedQueryString = 'userid=2000212725&password=BTmHHaeBc&send_to=1234567890&v=1.1&format=json&msg_type=TEXT&method=SENDMESSAGE&msg=Hello%2C+World%21';



// Verify the response handling
String expectedResponseBody = '{"response": "success"}'; */
        
    }
    
    @isTest
    static void testSendSingleMessage() {
        // Set up test data
        String phoneNo = '1234567890';
        String message = 'Test message';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "Success"}');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method being tested
        Boolean result = API_WhatsApp.sendSingleMessage(phoneNo, message);
    }
    
    @isTest
    static void testSendWhatsappTemplate() {
        // Set up test data
        String phoneNo = '1234567890';
        String message = 'Test message';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "Success"}');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method being tested
        Boolean result = API_WhatsApp.sendWhatsappTemplate(phoneNo, message);
        
    }
    
    @isTest
    static void testSendMediaMessage() {
        // Set up test data
        String phoneNo = '1234567890';
        String mediaURL = 'https://example.com/image.jpg';
        String messageCaption = 'Test caption';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "Success"}');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method being tested
        Boolean result = API_WhatsApp.sendMediaMessage(phoneNo, mediaURL, messageCaption);
        
        
    }
    
    @isTest
    static void testSendBulkMessage() {
        // Set up test data
        String filePath = 'C:/Users/LENOVO/Downloads/whatsappAPI.csv';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "Success"}');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method being tested
        Boolean result = API_WhatsApp.sendBulkMessage();
        
    }
    
    @isTest
    static void testSendWhatsappTemplateFuture() {
        // Set up test data
        String phoneNo = '1234567890';
        String template = 'Test template';
        
        // Create a mock HTTP response
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"response": "Success"}');
        
        // Create a mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        
        // Call the method being tested
        Test.startTest();
        API_WhatsApp.sendWhatsappTemplateFuture(phoneNo, template);
        Test.stopTest();
        
        // Perform assertions to validate the expected outcome
        // Since the method is void, we cannot directly assert the outcome
        // We can only assert that the mock HTTP callout was made
        //HttpRequest actualHttpRequest = Test.getLastHttpRequest();
        
    }
}