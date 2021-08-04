trigger MeetupRegistrationTrigger on MeetupRegistration__c (before insert, after insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        MeetupRegistrationTriggerHelper.verifyEmailDuplicates(Trigger.new);
        
    }
    else if(Trigger.isAfter && Trigger.isInsert){
        MeetupRegistrationTriggerHelper.verifyMeetupStatus(Trigger.new);
    }
}
