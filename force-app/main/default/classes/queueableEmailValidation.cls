public with sharing class queueableEmailValidation implements Queueable, Database.AllowsCallouts{
   private set<Id> contactIds;
    
   public queueableEmailValidation(Set<Id> contactIds){    
        this.contactIds = contactIds;
    }

    public void execute(QueueableContext qc){
        List<Contact> contactToUpdate = new List<Contact>();
        for(Contact con : [Select Id, Email from Contact where Id in :contactIds]){
            Boolean isEmailValid = validateEmail(con.Email);
            Contact updateCon = new Contact(
                Id = con.Id,
                Email_Verified__c = isEmailValid
            );
            ContactToUpdate.add(updateCon);
       }

        if(!ContactToUpdate.isEmpty()){
            
            try{
                update ContactToUpdate;
            }catch(Exception ex){
                //log error to the apex logs
                system.debug(ex.getMessage());
                Log logger = Log.get();
                logger.publish(ex.getMessage());
        }
            
    }
}
    private Boolean validateEmail(String email){
        //get the api form the syste threshold custom metadata
        System_Threshold__mdt systemThreshold = System_Threshold__mdt.getInstance('Email_Reputation');
        String apiKey = systemThreshold.Value__c;

        //Make an api call to validate email
        Http http = new Http();
        HttpRequest request = new HttpRequest();
//      https://emailreputation.abstractapi.com/v1/?api_key=YOUR_UNIQUE_API_KEY&email=johnsmith@gmail.com
        request.setEndpoint('callout:EmailReputation/?api_key='+apiKey+'&email='+email);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        request.setTimeout(120000);
        Log logger = Log.get();
        try {
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            Map<String,Object> delivarability = (Map<String,Object>)responseMap.get('email_deliverability');
                String status = (String) delivarability.get('status');
                String status_detail = (String) delivarability.get('status_detail');
                if(Status == Constants.STATUS_EMAIL && Status_detail == Constants.STATUS_DETAIL_EMAIL){
                    return true;
                }else{
                    return false;
                }
        }else{
            logger.publish('API Email Validation Failed'+response.getStatusCode()+' ' + response.getBody());
            return false;
        }
        } catch (Exception ex) {
            System.debug('Exception occured while validating email'+ex.getMessage()); 
           logger.publish('API Email Validation Failed ' + ex.getMessage());
            return false;
            
            
        }
    
    }
}
    
