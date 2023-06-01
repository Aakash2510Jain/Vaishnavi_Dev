@RESTResource(urlMapping = '/ninetynineacres/*')
global class API_ninetynineacres {
    @HttpPost
    global static ResponseClass.ReponseWrapperforNintyNineAcres createLeadFromMagicBricks(){
        ResponseClass.ReponseWrapperforNintyNineAcres responseData = new ResponseClass.ReponseWrapperforNintyNineAcres();
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
            leadRecToInsert.Lead_Source_Type__c = '99 Acres';
            leadRecToInsert.Email__c = (string)requestBodyMap.get('email');
            leadRecToInsert.Project_Interested_In__c = (string)requestBodyMap.get('project_interested_in');
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