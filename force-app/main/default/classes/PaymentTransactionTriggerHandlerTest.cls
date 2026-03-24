@isTest
public with sharing class PaymentTransactionTriggerHandlerTest {

    //create test data
    @testSetup
    static void makeData(){
        List<Contact> conList =  TestDataFactory.createContacts(2);
        List<Car__c> carList = TestDataFactory.createCars(2);
        List<Booking__c> bookingList = TestDataFactory.createBookings(2,conList,carList);   
    }

    @isTest
    static void testBookingAndPaymentStatus(){

        Booking__c bookingRec = [select id,Status__c,Payment_Status__c from Booking__c limit 1];
        //Create payment transaction record. 
        Payment_Transaction__c payment = new Payment_Transaction__c();
        payment.Booking__c = bookingRec.id;
        payment.Amount__c = 100;
        payment.Status__c = Constants.SUCCESS;
        payment.Type__c = Constants.TYPE_INITIAL_PAYMENT;
        payment.Transaction_Date__c = Datetime.now();
        insert payment;

        String expectedPaymentStatus = Constants.BOOKING_PARTIAL_PAID;
        String expectedBookingStatus = Constants.BOOKING_CONFIRM_STATUS;
         Booking__c updatedBookingRec = [select id,Status__c,Payment_Status__c from Booking__c where id = :bookingRec.id limit 1];
         Assert.areEqual(expectedPaymentStatus, updatedBookingRec.Payment_Status__c, 'Payment status is not updated correctly');
         Assert.areEqual(expectedBookingStatus, updatedBookingRec.Status__c, 'Booking status is not updated correctly');

         
         //Remaining Rental Payment
        Payment_Transaction__c partialPayment = new Payment_Transaction__c();
        partialPayment.Booking__c = bookingRec.id;
        partialPayment.Amount__c = 100;
        partialPayment.Status__c = Constants.SUCCESS;
        partialPayment.Type__c = Constants.TYPE_PARTIAL_PAYMENT;
        partialPayment.Transaction_Date__c = Datetime.now();
       

         //Security Deposit Payment
        Payment_Transaction__c securityDeposit = new Payment_Transaction__c();
        securityDeposit.Booking__c = bookingRec.id;
        securityDeposit.Amount__c = 40;
        securityDeposit.Status__c = Constants.SUCCESS;
        securityDeposit.Type__c = Constants.TYPE_SECURITY_DEPOSIT;
        securityDeposit.Transaction_Date__c = Datetime.now();

         //store the trasactions in collection

         List<Payment_Transaction__c> transactionCollection = new List<Payment_Transaction__c>();
         transactionCollection.add(partialPayment);
         transactionCollection.add(securityDeposit);

         //Dml operation on collection
         insert transactionCollection;

         //validate the result

         Booking__c updatedBookingAfterFullPayment = [select id,status__c,Payment_Status__c from Booking__c where id = :bookingRec.id limit 1];
         expectedPaymentStatus = Constants.BOOKING_PAID;
         Assert.areEqual(expectedPaymentStatus, updatedBookingAfterFullPayment.Payment_Status__c, 'Payment status is not updated correctly');


         List<Payment_Transaction__c> securityTxn = [select id from Payment_Transaction__c where Booking__c = :bookingRec.id and Type__c = :Constants.TYPE_SECURITY_DEPOSIT];
         delete securityTxn;

         expectedPaymentStatus = Constants.BOOKING_PARTIAL_PAID;
         Booking__c updatedBookingAfterDeletion = [select id,status__c,Payment_Status__c from Booking__c where id = :bookingRec.id limit 1];
         Assert.areEqual(expectedPaymentStatus, updatedBookingAfterDeletion.Payment_Status__c, 'Payment status is not updated correctly');
    }
}
