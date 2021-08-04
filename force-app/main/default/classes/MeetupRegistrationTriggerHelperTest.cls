@IsTest

public  class MeetupRegistrationTriggerHelperTest {
    @isTest 
    private static void testMeetupRegistrationInsert(){
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =10);
        insert m;

       MeetupRegistration__c mr = new MeetupRegistration__c(FirstName__c = 'test', LastName__c='test', Email__c='test@test.com', Meetup__c = m.Id);
       insert mr;

       MeetupRegistration__c mr2 = new MeetupRegistration__c(FirstName__c = 'test', LastName__c='test', Email__c='test@test.com', Meetup__c = m.Id);

       Test.startTest();
       try{
        insert mr2;
       }
       catch(Exception ex){
        Boolean expectedExceptionThrown =  ex.getMessage().contains('This Email Address is already in use for this Meetup!') ? true : false;
        System.assertEquals(expectedExceptionThrown, true);
       }
       Test.stopTest();
    
       

    }

    @isTest 
    private static void testMeetupRegistrationAfterInsert(){
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Closed', RegistrationLimit__c =10);
        insert m;

       MeetupRegistration__c mr = new MeetupRegistration__c(FirstName__c = 'test', LastName__c='test', Email__c='test@test.com', Meetup__c = m.Id);
        Test.startTest();
       try{
        insert mr;
       }
       catch(Exception ex){
        Boolean expectedExceptionThrown =  ex.getMessage().contains('Cannot Register for a closed meetup!') ? true : false;
        System.assertEquals(expectedExceptionThrown, true);
       }
       Test.stopTest();
    
       

    }
}
