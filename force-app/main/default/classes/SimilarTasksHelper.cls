public without sharing class SimilarTasksHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks( string recordId){
        system.debug('recordId==>'+recordId);
        List<Task> similarTasks = new List<Task>();
        
        try{
            if(recordId != null){
                string whereClause = '';  
                system.debug('if subject not null');
                whereClause += ' where ( Subject Like \''+ ConstantClass.TaskSubjectForDuplicateLead +'%\'';
                system.debug('whereClause-->'+whereClause);
                
                if(!string.isBlank(whereClause)){
                    system.debug('Select id,WhoId,Priority, Lead_Source__c, Lead_Source_Type__c, Lead_Sub_Source__c, CreatedDate, WhatId,ActivityDate,Owner.Name, Status,Subject,Type from Task  '+whereClause+') AND WhatId = \''+recordId);
                    similarTasks = database.query('Select id,WhoId,Priority, Lead_Source__c, Lead_Source_Type__c, Lead_Sub_Source__c, CreatedDate,Modified_Created_Date__c, WhatId,ActivityDate,Owner.Name, Status,Subject,Type from Task  '+whereClause+') AND WhatId = \''+recordId+'\'');
                }
                system.debug('similarTasks-->'+similarTasks);
                return similarTasks;
            }                
            else{
                return null;
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('SimilarLeadsHelper', 'getLeads', e, null);
        }
        return null;
    } 
    @AuraEnabled
    Public Static List<String> getLeadSourceTypePickList(String ObjectApi_name,String FietskRec_name){
        try{
            if(!String.isBlank(ObjectApi_name) && !String.isBlank(FietskRec_name)){
                List<String> lstPickvals = new List<String>();
                Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
                Sobject Object_name = targetType.newSObject();
                Schema.sObjectType sobject_type = Object_name.getSObjectType();
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
                Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
                List<Schema.PicklistEntry> pick_list_values = field_map.get(FietskRec_name).getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : pick_list_values){
                    lstPickvals.add(String.ValueOf(a.getLabel()).trim());
                }
                System.debug('lstPickvals Values  === :'+lstPickvals);
                return lstPickvals;
            }            
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('SimilarLeadsHelper', 'getLeadSourceTypePickList', e, null);
        }
        return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Lead__c>  getLeads2( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead__c> leadListWithSimEmail = new List<Lead__c>();
        try{
            if(recordId != null){
                Lead__c tskRec= [Select id,Name__c,Phone__c,Email__c from Lead__c where id=:recordId];
                system.debug('tskRec--->'+tskRec);
                string existingLeadPhone = tskRec.Phone__c;
                string existingLeadEmail = (tskRec.Email__c).split('@')[0]+'%';
                
                if(tskRec.Name__c !=null){                       
                    leadListWithSimEmail = [Select Id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c From Lead__c where (Name__c like: tskRec.Name__c or Phone__c like : existingLeadPhone or Email__c like : existingLeadEmail)AND Id !=:  recordId];
                    system.debug('leadListWithSimEmail--->'+leadListWithSimEmail);
                    return leadListWithSimEmail;
                }                
                else{
                    return null;
                }
            }   
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('SimilarLeadsHelper', 'getLeads2', e, null);
        }
        return null;
    }
}