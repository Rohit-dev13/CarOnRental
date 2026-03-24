public with sharing class ContactTriggerHandler extends TriggerHandler {
 
    override public void afterInsert(){
        List<Contact> contacts = (List<Contact>)Trigger.new;
        ContactTriggerHandlerService.processContact(Trigger.new);
    }

    override public void afterUpdate(){
        List<Contact> contacts = (List<Contact>)Trigger.new;
        Map<Id,Contact> oldContactMap = (Map<Id,Contact>)Trigger.oldMap;

        List<Contact> contactsToProcess = new List<Contact>();
        for(Contact con : contacts){
            //change in email
            String newEmail = con.Email;
            String oldEmail = oldContactMap.get(con.Id).Email;
            Contact oldContact = oldContactMap.get(con.Id);
            if(newEmail != oldEmail){
                contactsToProcess.add(con);
            }
        }

        if(contactsToProcess.size()> 0){
            ContactTriggerHandlerService.processContact(contactsToProcess);
        }

    }
}