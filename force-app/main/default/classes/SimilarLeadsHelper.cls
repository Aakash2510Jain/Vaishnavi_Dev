public without sharing class SimilarLeadsHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Lead__c>  getLeads( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead__c> leadListWithSimEmail = new List<Lead__c>();
        try{
            if(recordId != null){
                Lead__c ld= [Select id,Name__c,Phone__c,Email__c,Source_Type__c,Lead_Source_Type__c	from Lead__c where id=:recordId];
                system.debug('ld--->'+ld);
                string existingLeadPhone = ld.Phone__c;
                string existingLeadEmail = (ld.Email__c).split('@')[0]+'%';
                
                if(ld.Name__c !=null){                       
                    leadListWithSimEmail = [Select Id,Name__c,Email__c,Phone__c,Source_Type__c, Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c From Lead__c where (Name__c like: ld.Name__c or Phone__c like : existingLeadPhone or Email__c like : existingLeadEmail)AND Id !=:  recordId];
                    system.debug('leadListWithSimEmail--->'+leadListWithSimEmail);
                    return leadListWithSimEmail;
                }                
                else{
                    return null;
                }
            }   
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
    
    @AuraEnabled
    Public Static List<String> getLeadSourceTypePickList(String ObjectApi_name,String Field_name){
        try{
            if(!String.isBlank(ObjectApi_name) && !String.isBlank(Field_name)){
                List<String> lstPickvals = new List<String>();
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
                Sobject Object_name = targetType.newSObject();
                Schema.sObjectType sobject_type = Object_name.getSObjectType();
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
                Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
                List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values){
                    lstPickvals.add(String.ValueOf(a.getLabel()).trim());
                }
                System.debug('lstPickvals Values  === :'+lstPickvals);
                return lstPickvals;
            }            
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Lead__c>  getLeads2( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead__c> leadListWithSimEmail = new List<Lead__c>();
        try{
            if(recordId != null){
                Lead__c ld= [Select id,Name__c,Phone__c,Email__c from Lead__c where id=:recordId];
                system.debug('ld--->'+ld);
                string existingLeadPhone = ld.Phone__c;
                string existingLeadEmail = (ld.Email__c).split('@')[0]+'%';
                
                if(ld.Name__c !=null){                       
                    leadListWithSimEmail = [Select Id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c From Lead__c where (Name__c like: ld.Name__c or Phone__c like : existingLeadPhone or Email__c like : existingLeadEmail)AND Id !=:  recordId];
                    system.debug('leadListWithSimEmail--->'+leadListWithSimEmail);
                    return leadListWithSimEmail;
                }                
                else{
                    return null;
                }
            }   
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
}