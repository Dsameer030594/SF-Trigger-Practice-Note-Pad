public class CaseTriggerHandler {

    //13.Whenever case is created with origin as email then set status as new and priority as Normal
      public static void setStatusandPriorityOfCase(List<Case> caseList){
          for(Case cs : caseList){
              if(cs.Origin == 'Email'){
                  cs.Status = 'New';
                  cs.Priority = 'Normal';
              }
          }
    }
    // When a case is created then add case in 'case Queue';
    public static void mannualShareCase(List<Case> caseList){
       
        Group caseQueue = [SELECT Id, DeveloperName, Type FROM Group where Type = 'QUEUE' AND DeveloperName = 'Case_Queue'];
        Set<Id> cId = new Set<Id>();
        
        for(Case cs : caseList){
            if(cs.Origin == 'WEB'){
                cId.add(cs.Id);
            }
        }
        
        for(Case cs : [Select Id from Case where Id IN: cId]){
            Caseshare css = new Caseshare();
            css.RowCause = 'manual';
            css.CaseAccessLevel = 'Edit';
            css.UserOrGroupId = caseQueue.Id;
            css.CaseId = cs.Id;
            insert css;
        }
    }
}