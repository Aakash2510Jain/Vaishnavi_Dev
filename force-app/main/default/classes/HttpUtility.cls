/*
* Author: DeaGle
*/

public without sharing class HttpUtility {
    static final String NO_RESPONSE = 'NO_RESPONSE';
    static final String HTTP_ERROR = 'ERROR WHILE MAKING REQUEST';
    static Whatsapp_Cloud_Settings__c wCloudSettings;

    
    static HttpUtility httpUtilityInstance;
    
    private HttpUtility() {}

    public static HttpUtility getInstance() {
        if(httpUtilityInstance == null) {
            httpUtilityInstance = new HttpUtility();
            wCloudSettings = Whatsapp_Cloud_Settings__c.getInstance();
        }
        return httpUtilityInstance;
    }

    public String httpReqHelper(Map<String,String> headerMap, String method, String jsonBody, String endPoint) {
        System.debug('--- body '+ jsonBody);
        System.debug('--- headerMap '+ headerMap);
        System.debug('--- method '+ method);
        System.debug('--- endPoint '+ endPoint);

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpoint);
        httpRequest.setMethod(method);
        httpRequest.setBody(jsonBody);

        if(!headerMap.isEmpty()){
            for(String key : headerMap.keySet()){
                httpRequest.setHeader(key,headerMap.get(key)); 
            }
        }
        try {
            Http http = new Http();
            HTTPResponse response = http.send(httpRequest);
            if(wCloudSettings != null && wCloudSettings.Enable_Integration_Logger__c)
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201)
                return response.getBody();
            return NO_RESPONSE;
        }catch (Exception e) {
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
            //HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
            return HTTP_ERROR;
        }

    }
   
}