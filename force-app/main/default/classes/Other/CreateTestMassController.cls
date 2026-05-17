public with sharing class CreateTestMassController {

    @AuraEnabled
    public static String createRecords(integer total){
        ObjectA__c a = new ObjectA__c();
        insert a;

        List<ObjectB__c> lstInsertObjB =  new  List<ObjectB__c>();
        List<ObjectC__c> lstInsertObjC =  new  List<ObjectC__c>();

        for(Integer i = 0; i<total; i++){
            ObjectB__c  obj = new ObjectB__c();
            obj.ObjectA__c = a.Id;
            lstInsertObjB.add(obj);
        }
        
        Database.insert(lstInsertObjB);

        for(Integer i = 0; i<total; i++){
            ObjectC__c  obj = new ObjectC__c(); 
            Obj.ObjectB__c = lstInsertObjB[i].Id;
            lstInsertObjC.add(obj);
        }
        
        Database.insert(lstInsertObjC);

        return 'Success on Create ! ';
    }
}