trigger campaignTrigger on Campaign (before insert, after insert, before update, after update) {

   if(Trigger.isInsert){
        if(Trigger.isBefore){
           // campaignTriggerHandler.changeStatus(Trigger.new);
        } else if(Trigger.isAfter){
            
        }
    }
   
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            
        } else if(Trigger.isAfter){
            
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            
        } else if(Trigger.isAfter){
            
        }
    }
   
    if(Trigger.isUndelete){
        if(Trigger.isAfter){
            
        }
    }
}