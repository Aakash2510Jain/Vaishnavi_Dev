public without sharing class SimilarLeadsHelper {
    
    @AuraEnabled(cacheable=true)
    public static List<Lead__c> getLeads( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead__c> similarLeads = new List<Lead__c>();
        
        try{
            if(recordId != null){
                Lead__c ld= [Select id,Name__c,Phone__c,Email__c,Source_Type__c,Lead_Source_Type__c,Alternate_Phone__c,Alternate_Email__c from Lead__c where id=:recordId];
                system.debug('ld--->'+ld);
                string whereClause = '';  
                if(ld.Phone__c != null){
                    system.debug('if phone not null');
                    whereClause += ' where ( Phone__c =\''+ld.Phone__c +'\' or Alternate_Phone__c =\''+ ld.Phone__c +'\'';
                }
                system.debug('whereClause-->'+whereClause);
                if(ld.Alternate_Phone__c != null){
                    system.debug('if alternate phone not null');
                    if(whereClause.contains('where')){                           
                            whereClause += ' or Phone__c =\''+ld.Alternate_Phone__c +'\' or Alternate_Phone__c =\''+ld.Alternate_Phone__c+'\'';
                    }else{
                        whereClause += ' where ( Phone__c =\''+ ld.Alternate_Phone__c +'\' or Alternate_Phone__c =\''+ ld.Alternate_Phone__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                if(ld.Email__c != null){
                     system.debug('if email not null');
                    if(whereClause.contains('where')){
                        whereClause += ' or Email__c =\''+ld.Email__c +'\' or Alternate_Email__c =\''+ld.Email__c+'\'';
                    }else{
                         whereClause += ' where ( Email__c =\''+ld.Email__c +'\' or Alternate_Email__c =\''+ld.Email__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                if(ld.Alternate_Email__c != null){
                     system.debug('if alternate email not null');
                    if(whereClause.contains('where')){
                        whereClause += ' or Email__c =\''+ ld.Alternate_Email__c +'\' or Alternate_Email__c =\''+ld.Alternate_Email__c +'\'';
                    }else{
                         whereClause += ' where (Email__c =\''+ ld.Alternate_Email__c +'\' or Alternate_Email__c =\''+ ld.Alternate_Email__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                    
                if(!string.isBlank(whereClause)){
                    system.debug('Select Id,Name__c,Email__c,Phone__c,Source_Type__c, Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c From Lead__c  '+whereClause+') AND Id != \''+recordId+'\' AND isConverted__c = false');
                    similarLeads = database.query('Select Id,Name__c,Email__c,Phone__c,Source_Type__c, Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c,CreatedDate From Lead__c '+whereClause+') AND Id != \''+recordId+'\' AND isConverted__c = false');
                }
                system.debug('similarLeads-->'+similarLeads);
                //similarLeads = [Select Id,Name__c,Email__c,Phone__c,Source_Type__c, Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,Project_Interested_In__c From Lead__c 
                                // where (Phone__c =: ld.Phone__c or Alternate_Phone__c =: ld.Phone__c or Phone__c =: ld.Alternate_Phone__c or Alternate_Phone__c =: ld.Alternate_Phone__c 
                                //        or Email__c =: ld.Email__c or Alternate_Email__c =: ld.Email__c or Email__c =: ld.Alternate_Email__c or Alternate_Email__c =: ld.Alternate_Email__c)
                                // AND Id !=:  recordId AND isConverted__c = false];
                /*similarOpportunities = [Select Id,Opportunity_Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c From Opportunity__c 
where (Phone__c =: ld.Phone__c or Alternate_Phone__c =: ld.Phone__c or Phone__c =: ld.Alternate_Phone__c or Alternate_Phone__c =: ld.Alternate_Phone__c 
or Email__c =: ld.Email__c or Alternate_Email__c =: ld.Email__c or Email__c =: ld.Alternate_Email__c or Alternate_Email__c =: ld.Alternate_Email__c)];
system.debug('similarLeads--->'+similarLeads);
similarLeadWrap wrapInstance = new similarLeadWrap(similarLeads, similarOpportunities);*/
                return similarLeads;
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
    /* public class similarLeadWrap{
public List<lead__c> leadListToBeReturned;
public List<opportunity__c> opportunityListToBeReturned;
public similarLeadWrap(List<lead__c> leadListToBeReturned, List<opportunity__c> opportunityListToBeReturned){
this.leadListToBeReturned = leadListToBeReturned;
this.opportunityListToBeReturned = opportunityListToBeReturned;
}
}*/
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
         } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('SimilarLeadsHelper', 'getLeads2', e, null);
        }
        return null;
    }
}