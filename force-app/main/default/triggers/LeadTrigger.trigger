trigger LeadTrigger on Lead (before insert, before Update) {

    if(Trigger.isInsert){
        if(Trigger.isBefore){
            LeadTriggerHandler.prefixDrtoFirstName(Trigger.new);
            LeadTriggerHandler.throwErrorIfEmailIsExists(Trigger.new, null);
            LeadTriggerHandler.changeLeadRatingAccordingtoLeadSource(Trigger.new);
        } else if(Trigger.isAfter){
            
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            LeadTriggerHandler.prefixDrtoFirstName(Trigger.new);
            LeadTriggerHandler.throwErrorIfEmailIsExists(Trigger.new, Trigger.oldMap);
        } else if(Trigger.isAfter){
            
        }
    }
}