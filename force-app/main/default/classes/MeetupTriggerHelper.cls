/*
* MeetupTriggerHelp.cls - trigger delegate class, Meetup__c. 
* Class with create a RegistrationCode__c field value and update Meetup record, before insert
*
*/

public with sharing class MeetupTriggerHelper {
    public static void populateRegistrationCode(List<Meetup__c> newTriggerMeetUps){
        DescribeFieldResult registrationCode = Schema.Meetup__c.RegistrationCode__c.getDescribe();
        for(Meetup__c m : newTriggerMeetUps){
            
            if(m.RegistrationCode__c == null || m.RegistrationCode__c == '' ){
              
               m.RegistrationCode__c = generateRegistrationCode(registrationCode.getLength());
            }
        }
    }

    public static String generateRegistrationCode (Integer fieldLength){
        final String chars = '01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String registrationCode = '';
        while(registrationCode .length() < fieldLength){
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            registrationCode += chars.substring(idx, idx+1);
        }
        return registrationCode;
    }


}
