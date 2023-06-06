public without sharing class CreateLeadAndShowExistingOnVisiteForm {
    @AuraEnabled
    public Static Lead__c showExistingLead(string searchkey){
        try{
            if(searchkey != null){
                string phonestring = '%' +searchkey;
                Lead__c leadRec = [select id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Sub_Source__c,Lead_Source_Type__c From Lead__c where Email__c =:searchkey OR Phone__c LIKE :phonestring limit 1  ];
                system.debug('leadRec===>>'+leadRec);
                return leadRec; 
            }
            
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
        return null;
        
    }
    @AuraEnabled
    public Static void updateExistinglead(string recid,Lead__c leadRec){
        try{
            update leadRec;
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
    }
    @AuraEnabled
    public Static void createNewLead(string recid,Lead__c createleadRec){
        try{
            
            insert createleadRec;  
            system.debug('createleadRec'+createleadRec);
            
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
    }
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    @AuraEnabled
    public Static void createVisitUnderCurrentLead(string recid,Visit__c newVisitRec, Date changedate ){
        try{
            newVisitRec.Lead__c = recid;
            newVisitRec.Actual_visit_date__c = changedate;
            insert newVisitRec;  
            system.debug('newVisitRec===>>>'+newVisitRec);
            
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
    }
    @AuraEnabled
    public Static List<Visit__c> fetchvisitRecord(string leadid ){
        try{
            
            List<Visit__c> visitList = [Select Name,Actual_visit_date__c,Interested_In__c from Visit__c where Lead__c=:leadid]  ;  
            system.debug('visitList===='+visitList);
            return visitList;
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
        return null;
    }
    
}