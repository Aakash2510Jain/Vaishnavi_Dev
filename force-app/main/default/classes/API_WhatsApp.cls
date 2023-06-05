public without sharing class API_WhatsApp {

    private static String whatsapp_baseURL          = 'https://media.smsgupshup.com/GatewayAPI/rest';
    private static String whatsapp_userid           = '2000212725';
    private static String whatsapp_password         = 'BTmHHaeBc';
    final static string success_response            = 'success';
    final static string error_response              = 'failure';

    // To mark a user as Opt-in
    Public static String whatsappOptIn(string phoneNoToOpt){
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        String queryString = '';
        Map<String, String> requestParams = prepareRequestParams(phoneNoToOpt);
        for (String param : requestParams.keySet()) {
            System.debug('requestParams.keySet()==='+requestParams.get(param));
            String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
            System.debug('value--'+value);
            queryString += '&' + param + '=' + value;
        }
        System.debug('queryString--'+queryString);
        httpRequest.setEndpoint(whatsapp_baseURL + '?' + queryString);
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        System.debug('httpRequest--'+httpRequest);
        Http http = new Http();
        HttpResponse httpResponse = http.send(httpRequest);
        if (httpResponse.getStatusCode() == 200) {
            String responseBody = httpResponse.getBody();
            System.debug('responseBody: ' + responseBody);

            return success_response;
        } else {
            System.debug('HTTP request failed with status code: ' + httpResponse.getStatusCode());
            return error_response;
        }
    }

    Public static Map<String, String> prepareRequestParams(String phone_num){
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('userid', whatsapp_userid);
        requestParams.put('password', whatsapp_password);
        requestParams.put('phone_number', phone_num);
        requestParams.put('method', 'OPT_IN');
        requestParams.put('auth_scheme', 'plain');
        requestParams.put('v', '1.1');
        requestParams.put('channel', 'WHATSAPP');
        requestParams.put('format', 'json');
        return requestParams;
    } 

    public static void sendWhatsAppMessage(string phoneNo, string message){
        // Create an instance of the HttpRequest class
        HttpRequest httpRequest = new HttpRequest();
        System.debug('message----'+message);
        System.debug('phoneNo----'+phoneNo);
        // Set the endpoint URL
        String endpointUrl = 'https://media.smsgupshup.com/GatewayAPI/rest';
        httpRequest.setEndpoint(endpointUrl);
        
        // Set the HTTP method to GET
        httpRequest.setMethod('GET');
        
        // Set request parameters
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('userid', '2000212725');
        
        requestParams.put('password', 'BTmHHaeBc');
        requestParams.put('send_to', phoneNo);
        //requestParams.put('send_to', '7042458620');
        requestParams.put('v', '1.1');
        requestParams.put('format', 'json');
        requestParams.put('msg_type', 'TEXT');
        requestParams.put('method', 'SENDMESSAGE');
        requestParams.put('msg',message);
        //requestParams.put('msg', 'It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.\nFeel free to reach us on {{1}} regarding any queries that you may have!\nHere is the link to the brochure - {{2}}\n\nWarm Regards,\nTeam Vaishnavi\nhttps://www.vaishnavigroup.com/');
        
        // Build the query string with parameters
        String queryString = '';
        for (String param : requestParams.keySet()) {
            String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
            queryString += '&' + param + '=' + value;
        }
        System.debug('queryString----'+queryString);
        if (queryString != null && !String.isBlank(queryString)) {
            // Remove the leading '&' character
            queryString = queryString.substring(1);
            System.debug('queryString----'+queryString);
            httpRequest.setEndpoint(endpointUrl + '?' + queryString);
        }
        
        // Set the request header
        String headerKey = 'Content-Type';
        String headerValue = 'application/x-www-form-urlencoded';
        httpRequest.setHeader(headerKey, headerValue);
        
        // Create an instance of the Http class
        Http http = new Http();
        
        // Send the request and get the response
        HttpResponse httpResponse = http.send(httpRequest);
        
        // Process the response
        System.debug('httpResponse.getStatusCode()-----'+httpResponse.getStatusCode());
        System.debug('httpResponse.getBody()-----'+httpResponse.getBody());
        if (httpResponse.getStatusCode() == 200) {
            String responseBody = httpResponse.getBody();
            System.debug('responseBody----'+responseBody);
            // Process the response body as needed
        } else {
            System.debug('HTTP request failed with status code: ' + httpResponse.getStatusCode());
        }
        
    }

    public static Boolean sendSingleMessage(string phoneNo, string message){

        HttpRequest httpRequest = new HttpRequest();
          System.debug('message----'+message);
          System.debug('phoneNo----'+phoneNo);
          String endpointUrl = 'https://media.smsgupshup.com/GatewayAPI/rest';
          httpRequest.setEndpoint(endpointUrl);
          httpRequest.setMethod('GET');
          Map<String, String> requestParams = new Map<String, String>();
          requestParams.put('userid', '2000212725');
          requestParams.put('password', 'BTmHHaeBc');
          requestParams.put('method', 'SendMessage');
          requestParams.put('auth_scheme', 'plain');
          requestParams.put('v', '1.1');
          requestParams.put('send_to', phoneNo);
          requestParams.put('msg',message);
          requestParams.put('format', 'json');
          requestParams.put('msg_type', 'DATA_TEXT');

          String queryString = '';
          for (String param : requestParams.keySet()) {
              String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
              queryString += '&' + param + '=' + value;
          }
          System.debug('queryString----'+queryString);
          if (queryString != null && !String.isBlank(queryString)) {
              queryString = queryString.substring(1);
              System.debug('queryString----'+queryString);
              httpRequest.setEndpoint(endpointUrl + '?' + queryString);
          }
          String headerKey = 'Content-Type';
          String headerValue = 'application/x-www-form-urlencoded';
          httpRequest.setHeader(headerKey, headerValue);
          
          Http http = new Http();
          HttpResponse httpResponse = http.send(httpRequest);
          System.debug('httpResponse.getStatusCode()-----'+httpResponse.getStatusCode());
          System.debug('httpResponse.getBody()-----'+httpResponse.getBody());
          if (httpResponse.getStatusCode() == 200) {
              String responseBody = httpResponse.getBody();
              System.debug('responseBody----'+responseBody);
              return true;
          } else {
              System.debug('HTTP request failed with status code: ' + httpResponse.getStatusCode());
              return false;
          }
    }
}