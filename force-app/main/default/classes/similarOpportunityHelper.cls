public with sharing class similarOpportunityHelper {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity__c> getOpportunitiesData( string recordId){
        system.debug('recordId==>'+recordId);
        List<Opportunity__c> similarOpportunities= new List<Opportunity__c>();
        
        try{
            if(recordId != null){
                Opportunity__c opportunityRec= [Select id,Opportunity_Name__c,Phone__c,Email__c,Lead_Source_Type__c,Alternate_Phone__c,Alternate_Email__c from Opportunity__c where id=:recordId];
                system.debug('opportunityRec--->'+opportunityRec);
                string whereClause = '';  
                if(opportunityRec.Phone__c != null){
                    system.debug('if phone not null');
                    whereClause += ' where ( Phone__c =\''+opportunityRec.Phone__c +'\' or Alternate_Phone__c =\''+ opportunityRec.Phone__c +'\'';
                }
                system.debug('whereClause-->'+whereClause);
                if(opportunityRec.Alternate_Phone__c != null){
                    system.debug('if alternate phone not null');
                    if(whereClause.contains('where')){                           
                        whereClause += ' or Phone__c =\''+opportunityRec.Alternate_Phone__c +'\' or Alternate_Phone__c =\''+opportunityRec.Alternate_Phone__c+'\'';
                    }else{
                        whereClause += ' where ( Phone__c =\''+ opportunityRec.Alternate_Phone__c +'\' or Alternate_Phone__c =\''+ opportunityRec.Alternate_Phone__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                if(opportunityRec.Email__c != null){
                    system.debug('if email not null');
                    if(whereClause.contains('where')){
                        whereClause += ' or Email__c =\''+opportunityRec.Email__c +'\' or Alternate_Email__c =\''+opportunityRec.Email__c+'\'';
                    }else{
                        whereClause += ' where ( Email__c =\''+opportunityRec.Email__c +'\' or Alternate_Email__c =\''+opportunityRec.Email__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                if(opportunityRec.Alternate_Email__c != null){
                    system.debug('if alternate email not null');
                    if(whereClause.contains('where')){
                        whereClause += ' or Email__c =\''+ opportunityRec.Alternate_Email__c +'\' or Alternate_Email__c =\''+opportunityRec.Alternate_Email__c +'\'';
                    }else{
                        whereClause += ' where (Email__c =\''+ opportunityRec.Alternate_Email__c +'\' or Alternate_Email__c =\''+ opportunityRec.Alternate_Email__c+'\'';
                    }
                }
                system.debug('whereClause-->'+whereClause);
                
                if(!string.isBlank(whereClause)){
                    system.debug('Select Id,Opportunity_Name__c,Email__c,Phone__c,Source_Type__c,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c From Opportunity__C  '+whereClause+') AND Id != \''+recordId);
                    similarOpportunities = database.query('Select Id,Opportunity_Name__c,Email__c,Phone__c,Source_Type__c, Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c,CreatedDate From Opportunity__C '+whereClause+') AND Id != \''+recordId+'\'');
                }
                system.debug('similarOpportunities-->'+similarOpportunities);
                
                return similarOpportunities;
            }                
            else{
                return null;
            }
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
}