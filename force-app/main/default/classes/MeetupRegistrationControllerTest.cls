@isTest
public class MeetupRegistrationControllerTest {

    @IsTest
    static void testMeetupRecordsList(){
        
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =10, RegistrationCode__c ='');
        insert m; 

        String charString = m.RegistrationCode__c;

        system.assertEquals(m.Id, MeetupRegistrationController.getMeetupRecordList(charString)[0].Id);
        
    }

    @IsTest
    static void testMeetupRecordsListNull(){
        
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =10, RegistrationCode__c ='');
        insert m; 

        String charString = m.RegistrationCode__c;

        system.assertEquals(null, MeetupRegistrationController.getMeetupRecordList('test'));
        
    }

    @IsTest
    static void testMeetupRegistrationCountSuccess(){
        
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =2, RegistrationCode__c ='');
        insert m; 

        MeetupRegistration__c meetReg = new MeetupRegistration__c(FirstName__c='Tester', LastName__c='Test', Email__c='Tester@test.com', Meetup__c = m.Id);
        insert meetReg;

        String charString = m.RegistrationCode__c;
        system.debug(charString);

        system.assertEquals('success', MeetupRegistrationController.getMeetupRegCount(m.Id));
        
    }

    @IsTest
    static void testMeetupRegistrationCountError(){
        
        Meetup__c m =  new Meetup__c( Name = 'Test Meetup', Status__c = 'Open', RegistrationLimit__c =1, RegistrationCode__c ='');
        insert m; 

        MeetupRegistration__c meetReg = new MeetupRegistration__c(FirstName__c='Tester', LastName__c='Test', Email__c='Tester@test.com', Meetup__c = m.Id);
        insert meetReg;

        String charString = m.RegistrationCode__c;
        system.debug(charString);

        system.assertEquals('Error', MeetupRegistrationController.getMeetupRegCount(m.Id));
        
    }

    
}
