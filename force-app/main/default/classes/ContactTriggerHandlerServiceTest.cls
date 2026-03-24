@isTest
public with sharing class ContactTriggerHandlerServiceTest {
 
    @TestSetup
    static void makeData(){
        List<Contact> conList =  TestDataFactory.createContacts(2);

    }

    @isTest
    static void testContactForInsertOrUpdate(){
        Test.setMock(HttpCalloutMock.class, new EmailValidationHttpMock());
        List<Contact> conList = [select id,Email,Email_Verified__c from Contact];
        for(Contact con : conList){
            con.Email = 'test@test.com';
        }
        Test.startTest();
        update conList;
        Test.stopTest();
        List<Contact> updatedConList = [select id,Email,Email_Verified__c from Contact];
        for(Contact con : updatedConList){
            System.Assert.areEqual(true,con.Email_Verified__c, 'Email Verification is failed.');
        }
    
        
    }
}