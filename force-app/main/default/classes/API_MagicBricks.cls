/**
 * @author Aakash Jain
 * @email aakash.jain@utilitarianlab.com
 * @create date 19-05-2023 12:07:54
 * @modify date 19-05-2023 12:07:54
 * @desc [description]
 */

 /*
{
    "url": "http://app.sell.do/api/leads/create?source=Magic%20Bricks&mobile=9791155XXX&email=ashokraj.ok@gXXXX.com&time=145000&isd=Plaza%20Bounty%20Acres&name=Ashok%20Raj&msg=Plaza%20Bounty%20Acres,%20Chennai%20-%20I%20am%20interested%20in%20your%20project.%20Please%20contact%20me.%20Additional%20Details%20-%20Multistorey%20Apartment&project=Plaza%20Bounty%20Acres&dt=20180722&City=Chennai&api_key=aff532af1e2b22588a58XXXXXXXXXXXX",
    "leadstage": "New Enquiry",
    "leadtype": "Normal",
    "callrecording": "recording link",
    "additionalcomments": "interested and looking for 2bhk",
    "sitevisitdatetime": "2022-07-11T09:11:03.000",
    "leadid": ""
}

 */
 @RESTResource(urlMapping = '/magicBricks/*')
global class API_MagicBricks {
    @HttpPost
    global static ResponseClass.ReponseWrapperforMB createLeadFromMagicBricks(){
        ResponseClass.ReponseWrapperforMB responseData = new ResponseClass.ReponseWrapperforMB();
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String body = req.requestBody.toString();
            Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(body);
            system.debug('requestBodyMap---->'+requestBodyMap);
			
            system.debug('string.isBlank((string)requestBodyMap.get---->'+string.isBlank((string)requestBodyMap.get('leadid')));
            if(string.isBlank((string)requestBodyMap.get('leadid')) || string.isEmpty((string)requestBodyMap.get('leadid'))){
                //Create New Lead
                String urlValue = (string)requestBodyMap.get('url');
                
                System.PageReference pageReference = new System.PageReference( '/' + urlValue );
                Map<String, String> params = pageReference.getParameters();
                            
                String source = params.get('source');
                String mobile = params.get('mobile');
                String email = params.get('email');
                String registrationTime = params.get('time');
                String isd = params.get('isd');
                String name = params.get('name');
                String msg = params.get('msg');
                String project = params.get('project');
                String dt = params.get('dt');
                String city = params.get('City');
                String apiKey = params.get('api_key');
                
                Lead__c leadRecToInsert = new Lead__c();
                leadRecToInsert.API_Body__c = String.ValueOf(requestBodyMap);
                leadRecToInsert.Name__c = name;
                leadRecToInsert.Phone__C = mobile;
                leadRecToInsert.Lead_Source__c = 'DIGITAL';
                leadRecToInsert.Lead_Sub_Source__c ='Portals';
                leadRecToInsert.Lead_Source_Type__c = 'Magicbricks';
                leadRecToInsert.Email__c = email;
                leadRecToInsert.url__c = (string)requestBodyMap.get('url');
                leadRecToInsert.Additional_Comments__c = (string)requestBodyMap.get('additionalcomments');
                insert leadRecToInsert;

                responseData.success_code = '200';
                responseData.success_message = 'Lead Created Successfully';
                responseData.status = 'Success';
                responseData.lead_id = leadRecToInsert.Id;
            }else{
                //Update Lead
                List<Lead__c> existingLeadList = new List<Lead__c>(); 
                Lead__c leadRecToUpdate = new Lead__c();
                existingLeadList = [Select Id,Additional_Comments__c From Lead__c where id =: (string)requestBodyMap.get('leadid')];
                leadRecToUpdate.Id = (string)requestBodyMap.get('leadid');
                if(!existingLeadList.isEmpty())
                    leadRecToUpdate.Additional_Comments__c = existingLeadList[0].Additional_Comments__c +' ; '+(string)requestBodyMap.get('additionalcomments');
                else
                    leadRecToUpdate.Additional_Comments__c = (string)requestBodyMap.get('additionalcomments');
                update leadRecToUpdate;
                responseData.success_code = '200';
                responseData.success_message = 'Lead Updated Successfully';
                responseData.status = 'Success';
                responseData.lead_id = leadRecToUpdate.Id;  
            }
        }catch(Exception ex){
            system.debug('Error -->'+ex.getMessage());
            responseData.error_code = '400';
            responseData.status = 'Error';
            responseData.error_message = ex.getMessage();
        }
        return responseData;
    }
}