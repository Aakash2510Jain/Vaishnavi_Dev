public class channelPartnerTriggerHandler {
    static channelPartnerTriggerHandler cpTriggerHandler;
    public static channelPartnerTriggerHandler getInstance(){
        if(cpTriggerHandler==null)
            cpTriggerHandler = new channelPartnerTriggerHandler();
        return cpTriggerHandler;
    }
    
    
    public void afterInsert(Map<Id,Channel_Partner__c> accMap){
        Explorer_Configuration__c  accDocConfig = Explorer_Configuration__c.getValues('Channel Partner');
        String cpFoldersString = accDocConfig.Folders__c;
        
        List<String> accFolders = cpFoldersString.split(';');
        
        List<Folder__c> folders = new List<Folder__c>();
        
        for(Channel_Partner__c acc : accMap.values()){
            for(String fName : accFolders){
                Folder__c folder = new Folder__c(Name=fName, Channel_Partner__c = acc.Id);
                folders.add(folder);
            }
        }
        
        if(!folders.isEmpty()){
            insert folders; 
        }
    }
}