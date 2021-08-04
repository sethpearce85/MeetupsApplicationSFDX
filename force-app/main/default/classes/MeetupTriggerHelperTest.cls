@isTest

public class MeetupTriggerHelperTest {

    @isTest 
    private static void testMeetupInsert(){
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =10);

        insert m;
        Meetup__c mu = [Select Id, RegistrationCode__c from Meetup__c where id = :m.Id limit 1];
        System.assertEquals(8, mu.RegistrationCode__c.length());
    }

}
