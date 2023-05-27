public without sharing class API_WhatsApp {
    public static void sendWhatsAppMessage(){
        // Create an instance of the HttpRequest class
        HttpRequest httpRequest = new HttpRequest();
        
        // Set the endpoint URL
        String endpointUrl = 'https://media.smsgupshup.com/GatewayAPI/rest';
        httpRequest.setEndpoint(endpointUrl);
        
        // Set the HTTP method to GET
        httpRequest.setMethod('GET');
        
        // Set request parameters
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('userid', '2000212725');
        
        requestParams.put('password', 'BTmHHaeBc');
        requestParams.put('send_to', '7042458620');
        requestParams.put('v', '1.1');
        requestParams.put('format', 'json');
        requestParams.put('msg_type', 'TEXT');
        requestParams.put('method', 'SENDMESSAGE');
        requestParams.put('msg', 'It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.Feel free to reach us on {{1}} regarding any queries that you may have!Here is the link to the brochure - {{2}} Warm Regards, Team Vaishnavi https://www.vaishnavigroup.com/');
        
        // Build the query string with parameters
        String queryString = '';
        for (String param : requestParams.keySet()) {
            String value = EncodingUtil.urlEncode(requestParams.get(param), 'UTF-8');
            queryString += '&' + param + '=' + value;
        }
        if (queryString != null && !String.isBlank(queryString)) {
            // Remove the leading '&' character
            queryString = queryString.substring(1);
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
        if (httpResponse.getStatusCode() == 200) {
            String responseBody = httpResponse.getBody();
            // Process the response body as needed
        } else {
            System.debug('HTTP request failed with status code: ' + httpResponse.getStatusCode());
        }
        
    }
}