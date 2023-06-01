@RESTResource(urlMapping = '/commonfloor/*')
global class API_CommonFloor {
    @HttpPost
    global static ResponseClass.ReponseWrapperforCommonFloor createLeadFromMagicBricks(){
        ResponseClass.ReponseWrapperforCommonFloor responseData = new ResponseClass.ReponseWrapperforCommonFloor();
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String body = req.requestBody.toString();
            Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(body);
            system.debug('requestBodyMap---->'+requestBodyMap);
            
            Lead__c leadRecToInsert = new Lead__c();
            leadRecToInsert.Name__c = (string)requestBodyMap.get('name');
            leadRecToInsert.Phone__C = (string)requestBodyMap.get('phone');
            leadRecToInsert.Lead_Source__c = 'DIGITAL';
            leadRecToInsert.Lead_Sub_Source__c ='Portals';
            leadRecToInsert.Lead_Source_Type__c = '	Commonfloor';
            leadRecToInsert.Email__c = (string)requestBodyMap.get('email');
            insert leadRecToInsert;
            
            responseData.success_code = '200';
            responseData.success_message = 'Lead Created Successfully';
            responseData.status = 'Success';
            responseData.lead_id = leadRecToInsert.Id;
            
        }catch(Exception ex){
            system.debug('Error -->'+ex.getMessage());
            responseData.error_code = '400';
            responseData.status = 'Error';
            responseData.error_message = ex.getMessage();
        }
        return responseData;
    }
}