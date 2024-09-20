trigger AccountTrigger on Account (before insert, after Insert, Before Update, after update, before Delete) {
    
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccounttriggerHandler.assignOwnerAsSmriti(Trigger.new);
        }else if(Trigger.isAfter){
          AccounttriggerHandler.createRelatedConadndOpp(Trigger.new);   
            AccounttriggerHandler.addContactnameasSmriti(Trigger.new);
            AccounttriggerHandler.addConNamePhoneAsAccNamePhone(Trigger.new);
            AccounttriggerHandler.createConEqualsNoOfLocation(Trigger.new);
            AccounttriggerHandler.divideBalanceOnContact(Trigger.new, null);
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccounttriggerHandler.updateAccNameWithNameAndPhone(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isAfter){
            AccounttriggerHandler.updateContactHomePhoneandOtherPhone(Trigger.new, Trigger.oldMap);
            AccounttriggerHandler.divideBalanceOnContact(Trigger.new, Trigger.oldMap);
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            AccounttriggerHandler.prevetAccountDletion(Trigger.old);
            AccounttriggerHandler.preventDeletionAcc(Trigger.old);
        }
    }
}