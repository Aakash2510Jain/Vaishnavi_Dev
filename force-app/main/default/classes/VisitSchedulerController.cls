public class VisitSchedulerController {
     
    @RemoteAction
    public static Map<String,Object> fetchPageData() {
        try {
            Map<String, Object> pageData = new Map<String,Object>();
            pageData.put('salesRepList', [SELECT Id, FirstName, LastName, UserName FROM User]);
            system.debug('--- pageData '+ pageData);
            return pageData;
        } catch (Exception e) {
            printError(e);
        }
        return null;
    }
    
    // SELECT Id,Name,Assignment_Group__r.Name,Group_Member__r.Name FROM Assignment_Group_Member__c
    @RemoteAction
    public Static List<User> fetchGroupmemeber(String AssignementGropLocation){
        System.debug('AssignementGropLocation :'+AssignementGropLocation);
        try{
            List<User> getUserList = new List<User>();
            Set<String> gorupNameSet = new Set<String>();

             List<Assignment_Group_Member__c> getGMemList = [SELECT Id,Name,Assignment_Group__r.Name,Group_Member__r.Name FROM Assignment_Group_Member__c WHERE Assignment_Group__r.Name =: AssignementGropLocation];
             for(Assignment_Group_Member__c agm : getGMemList){
                 gorupNameSet.add(agm.Group_Member__r.Name);
             }
            System.debug('gorupNameSet ->>>>>'+gorupNameSet);
            List<User> userList = [SELECT Id, FirstName, LastName, UserName FROM User WHERE Name IN: gorupNameSet];
            for(User use : userList){
                getUserList.add(use);
            }
            System.debug('getUserList ::'+getUserList);
            return getUserList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            System.debug('Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    // Showing Lead__c & Account in dropdown
    @RemoteAction
    public Static List<String> getAccountleadList(){
        try{
            List<String> recordList = new List<String>{'Opportunity','Lead'};
                System.debug('recordList :'+recordList);
            return recordList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() + ' && Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    // Show Selected Location Record
    @RemoteAction
    public Static list<Location__c> getAllLocationRecords(){
        List<Location__c> getLocationList = [SELECT Id,Name FROM Location__c];
        System.debug('Location Record :'+getLocationList);
        return getLocationList;
    }
    
    // Show Record of Lead__c Based on Object & Location
    @RemoteAction
    public Static List<Lead__c> getSelectedObjectRecord(String objectName, String location){
        List<Lead__c> ledList = new List<Lead__c>();
        if(objectName == 'Lead__c'){
            ledList =[ SELECT Id,Name,Location__c  FROM Lead__c  Where   Location__c =: location];
        }
        System.debug('ledList Size ::'+ledList.Size()); 
        System.debug('ledList Record ::'+ledList);
        
        // if(objectName == 'Account'){
        //     System.debug('Account Method called');
        //     VisitSchedulerController.getSelectedAccountRecords(objectName,location); 
        // }
        return ledList;
    }
    
    // Show Record of Account Based on Object & Location
    @RemoteAction
    public Static List<Opportunity__c> getSelectedAccountRecords(String objectName, string location){
        System.debug('location ::'+location);
        List<Opportunity__c> accList = new List<Opportunity__c>();
        if(objectName == 'Opportunity__c'){
            accList= [SELECT Id,Name,Location__r.Name FROM Opportunity__c WHERE Location__r.Name =:  location];
            System.debug('Account size :'+accList.size());
            System.debug('Account Record :'+accList);
        }
        return accList;
    }
    
    @RemoteAction
    public static String createVisits(List<Visit__c> visitList) {
        try{
            System.debug('--- visitList '+visitList);
            upsert visitList;
            return 'visits created successfully.';
        }catch(Exception e){
            printError(e);
        }
        return 'something went wrong.';
    }
    
    @RemoteAction
    public static Map<String,Object> getUserVisits(String userId) {
        System.debug('userId===='+userId);
        Map<String, Object> pageData = new Map<String,Object>();
        if(!String.isBlank(userId)) {
            pageData.put('accountList', [SELECT Id,Name FROM Lead__c WHERE OwnerId = :userId LIMIT 15]);//Parent_Visit__c
            pageData.put('visitList', [Select Id, Name, Lead__c, Lead__r.Name, Planned_visit_date__c, CheckIn__c, Check_Out__c FROM Visit__c WHERE Lead__c != null AND /*Assigned_User__c = :userId AND*/ Actual_Visit_Date__c = null]);
        }
        System.debug('User Data ::'+pageData);
        return pageData;
    }
    
    @RemoteAction
    public static void deleteEvent(String eventID) {
        if(!String.isBlank(eventID))
            delete new Visit__c(Id = eventID);
    }
    
    // Get Search Result as Account
    @RemoteAction
    public static List<Opportunity__c> getRepAccounts(String repId, String location) {
        List<Opportunity__c> accList = new List<Opportunity__c>();
        System.debug('repId ::'+repId);
        //System.debug('searchString ::'+searchString);
        //  String searchPattern = '%'+String.escapeSingleQuotes(searchString)+'%';
        accList = [SELECT Id, Name,Location__r.Name,owner.name FROM Opportunity__c WHERE owner.name = :repId AND  Location__r.Name =: location LIMIT 15];
        System.debug('accList ::'+accList);
        return accList;
    }
    
    // Get Search Result as Lead
    @RemoteAction
    public Static List<Lead__c> getRepLeads(String repId,  String location){
        System.debug('repId ::'+repId);
        //  System.debug('searchString ::'+searchString);
        System.debug('location ::'+location);
        List<Lead__c> ledList = new List<Lead__c>();
        //  String searchPattern = '%'+String.escapeSingleQuotes(searchString)+'%';
        ledList = [SELECT Id,Name,Location__c,owner.Name FROM Lead__c WHERE ownerId =: repId AND Location__r.Name =:location LIMIT 10];
        System.debug('Lead__cList ::'+ledList);
        return ledList;
    }
    
    
    // Creare Visit Record on Account & Lead__c Drag
    @RemoteAction
    public Static String createVisitObjectType(Id SobjectId, String AssignedUserId, string datestring, String geolatitude, String geolongitude){
        
        System.debug('datestring =====> ' + datestring);
        System.debug('SobjectId :'+SobjectId);
        String sObjName = SobjectId.getSObjectType().getDescribe().getName();
        System.debug('Object Name ::'+sObjName);
        if(sObjName == 'Lead__c'){
            Visit__c vs = new Visit__c();
            vs.Lead__c = SobjectId;
            vs.Assigned_User__c = AssignedUserId;
            vs.Planned_visit_date__c = Date.valueOf(datestring);
            vs.Geo_Location__Latitude__s = Decimal.valueOf(geolatitude);
            vs.Geo_Location__Longitude__s =  Decimal.valueOf(geolongitude);
            insert vs;
            System.debug('Visit Record  for Lead__c ::'+vs);
            
        }else if(sObjName == 'Opportunity__c'){
            Visit__c vs = new Visit__c();
            vs.Opportunity__c = SobjectId;
            vs.Assigned_User__c = AssignedUserId;
            vs.Planned_visit_date__c = Date.valueOf(datestring);
            vs.Geo_Location__Latitude__s = Decimal.valueOf(geolatitude);
            vs.Geo_Location__Longitude__s =  Decimal.valueOf(geolongitude);
            insert vs;
            System.debug('Visit Record  for Account ::'+vs);
        }       
        return 'SUCCESS';
    }

    @RemoteAction
    Public static string updateVisit(string visitId, string startDate){
        if(!string.isBlank(visitId) && !string.isBlank(startDate)){
            dateTime plannedDateTime = DateTime.newinstance(long.valueOf(startDate));
            update New Visit__c(Id=visitId,Planned_visit_date__c= plannedDateTime.date());
            return 'success';
        }else{
            return 'error';
        }
    }
    
    
    static void printError(Exception e) {
        System.debug('--- ErrorMsg :'+e.getMessage());
        System.debug('--- ErrorLineNo :'+e.getMessage());
    }
    
    @RemoteAction
    public static Lead__c getTestRecord(string recordId){
        if(!String.isBlank(recordId)){
            Lead__c led = [SELECT Id,Name,Geolocation__Latitude__s,Geolocation__Longitude__s FROM Lead__c WHERE Id =: recordId];
            System.debug('Lead__c Record :::'+led);
            return led;
        }
        return null;
    }
    
    @RemoteAction
    public static Sobject getLeadGeolocationTest(String recordId ){
        if(!String.isBlank(recordId)){
            Id myId = Id.valueOf(recordId);
            String sObjName = myId.getSObjectType().getDescribe().getName();
            if(sObjName == 'Lead__c'){
                System.debug('Lead__c Found');
                Lead__c led = [SELECT Id,Name,Geolocation__Latitude__s,Geolocation__Longitude__s FROM Lead__c WHERE Id =: recordId];
                System.debug('Lead__c Record :::'+led);
                return led;
            }else if(sObjName == 'Opportunity__c'){
                System.debug('Account Found'); 
                Opportunity__c acc = [SELECT Id,Name,Geo_Location__Latitude__s,Geo_Location__Longitude__s FROM Opportunity__c WHERE Id =: recordId];
                System.debug('Account Record :::'+acc);
                return acc;
            }
            return null;
            
        }else{
            return null;
        }
    }

    @future (callout= true)
    public static void updateLeadGeoLocation(Set<Id> ledIdSet){
        System.debug('ledIdSet :::'+ledIdSet);
        List<Lead__c> ledListToUpdate = [SELECT Id,Name,Street__c,City__c,State_Province__c,Postal_Code__c,Country__c FROM Lead__c WHERE ID IN:ledIdSet];
        
        for(Lead__c led : ledListToUpdate){
            if(!String.isBlank(led.Street__c) && !String.isBlank(led.City__c) && !String.isBlank(led.State_Province__c) && !String.isBlank(led.Postal_Code__c) && !String.isBlank(led.Country__c)){
                String address = led.Street__c + ', '+led.City__c+ ', '+led.State_Province__c+ ', '+ led.Postal_Code__c + ', '+led.Country__c;
                System.debug('Lead__c Address :: '+address);
                Map<String,String> geoResponseMap = VisitSchedulerController.getLongandLat(address);
                Double lat = Double.valueOf(geoResponseMap.get('lat'));
                Double lang = Double.valueOf(geoResponseMap.get('lang'));
                led.Geolocation__Latitude__s = lat;
                led.Geolocation__Longitude__s = lang;
            }
        }
      
       update ledListToUpdate;
       System.debug('Updated GeoLocation '+ledListToUpdate);
      //  return ledLIst;
    }

  // 
    public Static Map<String,String> getLongandLat(String Addresss){
        System.debug('Addresss :::'+Addresss);
        if(!String.isBlank(Addresss)){
            Map<String,String> responseMap = new Map<String,String>();
            String apikey = Label.GoogleApiKey;	 
            String baseURL = Label.GooglemapBaseURL; 
            
            String encodedAddresss = EncodingUtil.urlEncode(Addresss, 'UTF-8');
            String url = baseURL+encodedAddresss+'&key='+apikey;
            System.debug('encoded url ::'+url);
            Http ht =new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader('Content-Length', '0');
            HttpResponse res = ht.send(req);
            String response = (res.getBody());
            System.debug('response ::'+response);
            
            LocationParser parsedJson = LocationParser.parse(res.getBody());
            system.debug('parsedJson ====> ' + parsedJson);
            system.debug('parsedJson results ====> ' + parsedJson.results);
            
            LocationParser.Results parserResult = parsedJson.results[0];
            LocationParser.Geometry parserGeometry = parserResult.geometry;
            LocationParser.Location parserLocation = parserGeometry.location;
            Double lat = parserLocation.lat;
            Double lang = parserLocation.lng;
            
            responseMap.put('lat',String.valueOf(lat));
            responseMap.put('lang',String.valueOf(lang));
            
            System.debug('responseMap---'+String.valueOf(responseMap));
            
            return responseMap;
        }
        return null; 
    }
    
    

}