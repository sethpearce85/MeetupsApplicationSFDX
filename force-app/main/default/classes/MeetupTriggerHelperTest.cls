@isTest

public class MeetupTriggerHelperTest {

    @isTest 
    private static void testMeetupInsert(){
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =10);

        insert m;
       
        System.assertEquals(8, m.RegistrationCode__c.length());
    }

}
