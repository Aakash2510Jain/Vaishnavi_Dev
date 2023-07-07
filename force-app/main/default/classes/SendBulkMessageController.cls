public withOut sharing class SendBulkMessageController {
    public List<Lead__c> selLeads;
    public String LeadIds;
    
    // Constructor
    public SendBulkMessageController(ApexPages.StandardSetController cntlr){
        selLeads = cntlr.getSelected(); //get selected records from account list view
        LeadIds = '';  
        for(Lead__c lead : selLeads){
            LeadIds += lead.Id + '-'; //build list of ids string concatenated with comma                         
        }
        LeadIds = LeadIds.removeEnd('-'); 
    } 
    
    public PageReference redirectToLC(){
        //'/lightning/cmp/c__LightningComponentName?c__listofAcounts=parameters'

        //lightning/n/WireCurrentPageReference?c__recordId=123
        //c/MyApp.app?recordId=ABCD)
        String returnUrl = '/c/SendBulkMessageApp.app?listofLeads='+LeadIds;
        system.debug('returnUrl---'+returnUrl);
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
    
     @AuraEnabled
    public static List<Lead__c> getLeads(string sleadIds){   
           system.debug('sleadIds--'+sleadIds);
        List<String> urlList =sleadIds.split('listofLeads=');    
        system.debug('urlList---'+urlList);
        if(urlList.size() < 2){
            return null;
        }
        List<String> leadIds=urlList[1].split('-');    
        string lastId = leadIds.get(leadIds.size() - 1);    
        system.debug('lastId----'+lastId); 
        leadIds.remove(leadIds.size() - 1);

        List<String> lastLeadIds=sleadIds.split('&'); 
        if(!lastLeadIds.isEmpty())
            leadIds.add(lastLeadIds[0]);

        system.debug('leadIds--'+leadIds);
        
        Set<String> SobjectFields = Schema.getGlobalDescribe().get('Lead__c').getDescribe().fields.getMap().keySet();
        String queryString='SELECT ' + String.join(new List<String>(SobjectFields), ',') + ' FROM Lead__c WHERE Id IN (\''+String.join(leadIds,'\',\'')+'\') Order by Name asc';
        return Database.query(queryString);
    }

    @AuraEnabled(cacheable = true)
    public static List<Lead__c> searchLeadList(String sleadIds){
        system.debug('sleadIds--'+sleadIds);
        List<String> urlList =sleadIds.split('listofLeads=');    
        system.debug('urlList---'+urlList);
        list<string> splitByAnd = urlList[1].split('&');
        string leadId = splitByAnd[0];
        List<String> leadIds=leadId.split('-');    
        system.debug('leadIds----'+leadIds); 
      
        Set<String> SobjectFields = Schema.getGlobalDescribe().get('Lead__c').getDescribe().fields.getMap().keySet();
        String queryString='SELECT ' + String.join(new List<String>(SobjectFields), ',') + ' FROM Lead__c WHERE Id IN (\''+String.join(leadIds,'\',\'')+'\') Order by Name asc';
        return Database.query(queryString);
    }

    @AuraEnabled(cacheable = true)
    public static list<SMS_Template__c> smsTemplates(){
        return [select name,id,Template_Name__c,Message__c,Message_for_FrontEnd__c,Category__c from SMS_Template__c];
    }

    @AuraEnabled
    public static boolean sendMessage(String temId, string IdList) {
        system.debug('temId----'+temId+'-----IdList------'+IdList);
        system.debug('IdList--'+IdList);
        List<String> urlList =IdList.split('listofLeads=');    
        system.debug('urlList---'+urlList);
        list<string> splitByAnd = urlList[1].split('&');
        string leadId = splitByAnd[0];
        List<String> leadIds=leadId.split('-');    
        system.debug('leadIds----'+leadIds); 
        List<Lead__c> leadList = [select name,id,phone__c from Lead__c where Id IN:leadIds];
        list<string> phoneNosList = New list<string>();
        for(lead__c lead:leadList){
            if(!string.isBlank(lead.phone__c)){
                phoneNosList.add(lead.phone__c);
            }
        }
        system.debug('phoneNosList---'+phoneNosList);
        SMS_Template__c template = [select name,id,message__c from SMS_Template__c where id =:temId];
          list<string> messageList = string.valueOf(template.message__c).split(' needlineBreak ');
            string stringToPass = '';
            system.debug('messageList---'+messageList.size());
            for(string msg:messageList){
                system.debug('msg--'+msg);
                stringToPass += msg+'\n';
            }
            system.debug('stringToPass--'+stringToPass);
            stringToPass = stringToPass.Substring(0,stringToPass.length()-1);
            system.debug('stringToPass--'+stringToPass);
            
        return API_WhatsApp.sendWhatsappTemplate(string.join(phoneNosList,','),stringToPass);
      }
}