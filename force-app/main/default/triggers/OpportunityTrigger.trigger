trigger OpportunityTrigger on Opportunity (before insert, after insert, before Update, after update) {

    if(Trigger.isInsert){
        if(Trigger.isAfter){
            OpportunityTriggerHandler.updateAccountRating(Trigger.new, null);
            OpportunityTriggerHandler.createRelatedTask(Trigger.new, null);
        }
    }
        
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            OpportunityTriggerHandler.updateAccountRating(Trigger.new, Trigger.oldMap);
            OpportunityTriggerHandler.setCloseDateandTypeOfOpp(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isAfter){
            OpportunityTriggerHandler.updateAccFieldIfOppFieldIsUpdated(Trigger.new, Trigger.oldMap);
            OpportunityTriggerHandler.updaterelatedAccNadConField(Trigger.new, Trigger.oldMap);
            OpportunityTriggerHandler.createRelatedTask(Trigger.new, Trigger.oldMap);
            OpportunityTriggerHandler.updateClientContactonAccandOpp(Trigger.new, Trigger.oldMap);
        }
    }
    
}