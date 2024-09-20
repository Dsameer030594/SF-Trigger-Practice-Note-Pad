public class campaignTriggerHandler {

    public Static void changeStatus(List<Campaign> campList){   // 1.Static method 2. Instance/ non-static Method
         List<Campaign> newCmpList = new List<Campaign>();
        for(Campaign cmp : campList){
            cmp.Name ='Sameer';
            cmp.Status = 'In Progres';
            newCmpList.add(cmp);
        }
        
        insert newCmpList;
    }
}