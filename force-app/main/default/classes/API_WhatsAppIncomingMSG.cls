@RESTResource(urlMapping = '/whatsapp_incoming_msg/*')
global class API_WhatsAppIncomingMSG {
    @HttpPost
    global static void captureIncomingWhatsAppMSG(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String body = req.requestBody.toString();
        List<String> recipientEmailList = new List<String>();
        recipientEmailList.add('aakash.jain@utilitarianlab.com');
        recipientEmailList.add('vignesh.naik@utilitarianlab.com');
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses( recipientEmailList );
        email.setSubject('this is the response from whatsapp for incoming message!');
        email.setPlainTextBody(body);
        email.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}