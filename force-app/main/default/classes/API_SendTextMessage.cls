public class API_SendTextMessage {
    
    private static String SMS_baseURL          		= 'https://pgapi.vispl.in/fe/api/v1/send?';
    private static String SMS_Username           	= 'vaishnavipropg.pro';
    private static String SMS_Password         		= 'Y8BAX';
    final static string SMS_From            		= '246694';
    final static string SMS_dltPrincipalEntityId    = '1101374980000039563';
    final static string SMS_dltContentId 			= '1107168457261453237';
    
    public static void sendMessage(string recipientNumber, string message, string leadId){
        system.debug('message-->'+message);
        //message = EncodingUtil.URLENCODE(message,'UTF-8').replace('+', '%20');
        system.debug('message--->'+message);
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        String queryString = '';
        Map<String, String> requestParams = prepareRequestParams(recipientNumber, message);
        for (String param : requestParams.keySet()) {
            System.debug('requestParams.keySet()==='+requestParams.get(param));
            String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
            System.debug('value--'+value);
            queryString += '&' + param + '=' + value;
        }
        System.debug('queryString--'+queryString);
        httpRequest.setEndpoint(SMS_baseURL + '?' + queryString);
        //httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        System.debug('httpRequest--'+httpRequest);
        Http http = new Http();
        HttpResponse httpResponse = new HttpResponse();
        if(Test.isRunningTest()){
             httpResponse = http.send(httpRequest);
        }
       
        if (httpResponse.getStatusCode() == 200) {
            Messages__c msgRecToInsert = new Messages__c();
            msgRecToInsert.Message_Body__c = message;
            msgRecToInsert.Message_Type__c = 'Sent';
            msgRecToInsert.Lead__c = leadId;
            msgRecToInsert.Type__c = 'Text SMS';
            insert msgRecToInsert;
        } else {
            System.debug('HTTP request failed with status code: ' + httpResponse.getStatusCode());
        }
    }
    
    Public static Map<String, String> prepareRequestParams(String receiptNo, string msg){
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('username', SMS_Username);
        requestParams.put('password', SMS_Password);
        requestParams.put('unicode', 'false');
        requestParams.put('from', SMS_From);
        requestParams.put('to', receiptNo);
        requestParams.put('dltPrincipalEntityId', SMS_dltPrincipalEntityId);
        requestParams.put('text', msg);
        requestParams.put('dltContentId', SMS_dltContentId);
        return requestParams;
    } 
    
}