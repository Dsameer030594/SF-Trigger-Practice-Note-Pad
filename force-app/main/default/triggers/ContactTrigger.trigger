trigger ContactTrigger on Contact (before insert, after update) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            ContactTriggerHandler.setConPhoneasAccPhone(Trigger.new);
        }else if(Trigger.isAfter){    
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            ContactTriggerHandler.updateRelatedOppAndAccount(Trigger.new, Trigger.oldMap);
        }
    }
}