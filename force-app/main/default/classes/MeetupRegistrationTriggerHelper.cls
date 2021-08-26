public with sharing class MeetupRegistrationTriggerHelper {
  public static void verifyEmailDuplicates (List<MeetupRegistration__c> meetUpRegs){
      Map<String, MeetupRegistration__c> meetupRegEmailMap = new Map<String, MeetupRegistration__c>();
      for(MeetupRegistration__c mReg : meetUpRegs){
          if(mReg.Email__c != null && !meetupRegEmailMap.keyset().contains(mReg.Email__c)){
             meetupRegEmailMap.put(mReg.Email__c, mReg);
          }
          else{
              mReg.Email__c.addError('This Email Address is already in use for this Meetup!');
          }
      }
      //update : Seth P - Need to filter query by the Meetup__c to avoid error when creating meetup registrations 
      for(MeetupRegistration__c mReg : [Select Email__c from MeetupRegistration__c where Email__c in :meetupRegEmailMap.keySet()]){
          MeetupRegistration__c newMeetupReg = meetupRegEmailMap.get(mReg.Email__c);
          newMeetupReg.Email__c.addError('This Email Address is already in use for this Meetup!');
      }
      
  }

  public static void verifyMeetupStatus(List<MeetupRegistration__c> meetupRegs){

    Set<Id> mregIds = (new Map<Id, MeetupRegistration__c>(meetupRegs)).keyset();
    
    List<MeetupRegistration__c> mRegs = [SELECT Id, FirstName__c, Meetup__c, Meetup__r.Status__c FROM MeetupRegistration__c WHERE Id IN :mregIds];
      for(MeetupRegistration__c mReg : mRegs){
          if(mReg.Meetup__r.Status__c == 'Closed'){
              system.debug(mReg.Meetup__r.Status__C);
              MeetupRegistration__c mur = (MeetupRegistration__c)Trigger.Newmap.get(mReg.Id);
              mur.addError('Cannot Register for a closed meetup!');
          }
      }
  }


}
