/**
* @author Isha Raaz
* @email isha.raj@utilitarianlab.com
* @create date 14-07-2023 11:06:03
* @modify date 14-07-2023 11:06:03
*/

@RESTResource(urlMapping = '/websiteleadcreation/*')

global class API_websiteLeadCreation {
    @HttpPost
    global static ResponseClass.ReponseWrapperforWebsiteLeadCreation createLeadFromWebsite(){
        ResponseClass.ReponseWrapperforWebsiteLeadCreation responseData = new ResponseClass.ReponseWrapperforWebsiteLeadCreation();

        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String body = req.requestBody.toString();
            Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(body);
            system.debug('requestBodyMap---->'+requestBodyMap);

            Lead__c leadRecToInsert = new Lead__c();
            leadRecToInsert.API_Body__c = String.ValueOf(requestBodyMap);
            if(!String.isBlank((string)requestBodyMap.get('name'))){
                leadRecToInsert.Name__c = (string)requestBodyMap.get('name');
            }
            if(!String.isBlank((string)requestBodyMap.get('email'))){
                leadRecToInsert.Email__c = (string)requestBodyMap.get('email');
            }
            if(!String.isBlank((string)requestBodyMap.get('phone'))){
                leadRecToInsert.Phone__c = (string)requestBodyMap.get('phone');
            }
            if(!String.isBlank((string)requestBodyMap.get('alternatephone'))){
                leadRecToInsert.Alternate_Phone__c = (string)requestBodyMap.get('alternatephone');
            }
            if(!String.isBlank((string)requestBodyMap.get('project'))){
                leadRecToInsert.Project_Name__c = (string)requestBodyMap.get('project');
            }
            if(!String.isBlank((string)requestBodyMap.get('comments'))){
                leadRecToInsert.Additional_Comments__c = (string)requestBodyMap.get('comments');
            }
            if(!String.isBlank((string)requestBodyMap.get('UTM_Source'))){
                leadRecToInsert.UTM_Source__c = (string)requestBodyMap.get('UTM_Source');
            }
            if(!String.isBlank((string)requestBodyMap.get('UTM_Medium'))){
                leadRecToInsert.UTM_Medium__c = (string)requestBodyMap.get('UTM_Medium');
            }
            if(!String.isBlank((string)requestBodyMap.get('UTM_Campaign'))){
                leadRecToInsert.UTM_Campaign__c = (string)requestBodyMap.get('UTM_Campaign');
            }
            if(!String.isBlank((string)requestBodyMap.get('UTM_Term'))){
                leadRecToInsert.UTM_Term__c = (string)requestBodyMap.get('UTM_Term');
            }
            if(!String.isBlank((string)requestBodyMap.get('unit_details'))){
                leadRecToInsert.Unit_Details__c = (string)requestBodyMap.get('unit_details');
            }
            if(!String.isBlank((string)requestBodyMap.get('unit_details'))){
                leadRecToInsert.Unit_Details__c = (string)requestBodyMap.get('unit_details');
            }
            if(!String.isBlank((string)requestBodyMap.get('source_type'))){
                leadRecToInsert.Lead_Source_Type__c = (string)requestBodyMap.get('source_type');
            }
            leadRecToInsert.Lead_Sub_Source__c = 'Website';
            leadRecToInsert.Lead_Source__c = 'Digital';
            insert leadRecToInsert;

            responseData.success_code = '200';
            responseData.success_message = 'Lead Created Successfully';
            responseData.status = 'Success';
            responseData.lead_id = leadRecToInsert.Id;

        }catch(Exception e){
            system.debug('Error -->'+e.getMessage());
            responseData.error_code = '400';
            responseData.status = 'Error';
            responseData.error_message = e.getMessage();
        }
        return responseData;
    }
}