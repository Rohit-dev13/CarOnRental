@isTest
public with sharing class ReviewTriggerTest {

    //data setup
    @TestSetup
    static void makeData(){
        //create contacts
        List<Contact> conList = TestDataFactory.createContacts(1);
        //create cars
        List<Car__c> carList = TestDataFactory.createCars(1);
        //create bookings
        List<Booking__c> bookingList = TestDataFactory.createBookings(1,conList,carList);
    }

    @isTest
    public static void testReviewTriggerHandlerForNegativeRating(){
        List<Contact> conList = [select id from Contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> reviewList = TestDataFactory.createReviews(1,bookingList,conList,2);

        //validate sharing record is created.
        List<Booking__share> bookingShareRec = [select parentId from Booking__share
                                                 where parentId = :bookingList[0].Id];
                                                
        Assert.isTrue(bookingShareRec.size() > 0, 'Negative Review record is not shared successfully.');

        List<Case> caseList = [select id from case where Review_ID__c = :reviewList[0].Id];
        Assert.isTrue(caseList.size() > 0, 'Negative review Case record is not created successfully.');


    }

    @isTest
    public static void testUpdateReviewTriggerHandlerForNegativeRating(){
        List<Contact> conList = [select id from Contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> reviewList = TestDataFactory.createReviews(1,bookingList,conList,5);
        Review__c reviewRec = reviewList[0];
        reviewRec.Rating__c = 2;
        update reviewRec;

         //validate sharing record is created.
        List<Booking__share> bookingShareRec = [select parentId from Booking__share
                                                 where parentId = :bookingList[0].Id];
                                                
        Assert.isTrue(bookingShareRec.size() > 0, 'Negative Review record is not shared successfully.');

        List<Case> caseList = [select id from case where Review_ID__c = :reviewRec.Id];
        Assert.isTrue(caseList.size() > 0, 'Negative review Case record is not created successfully.');

    }

    @isTest
    public static void testInsertForAverageCarRating(){
        List<Contact> conList = [select id from Contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);
        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 5; //(5+5)/2
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated.');
    }

    @isTest
    public static void testUpdateForAverageCarRating(){
        List<Contact> conList = [select id from Contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);

        //update the first review to trigger the update trigger
        firstReviewList[0].Rating__c = 3;
        update firstReviewList;

        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 4; //(5+3)/2
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated.');
    }

    @isTest
    public static void testDeleteForAverageCarRating(){
        List<Contact> conList = [select id from Contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,bookingList,conList,5);

        //delete the first review to trigger the delete trigger
        delete firstReviewList;

        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 5; //(5)/1
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated.');
    }
}