trigger CaseTrigger on Case (before insert, after insert) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            CaseTriggerHandler.setStatusandPriorityOfCase(Trigger.new);
        }else if(Trigger.isAfter){
            CaseTriggerHandler.mannualShareCase(Trigger.new);
        }
    }
}