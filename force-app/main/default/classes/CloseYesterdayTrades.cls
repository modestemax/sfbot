public with sharing class CloseYesterdayTrades implements ITask, Database.Batchable<Trade__c> {

    public static void execute() {
        Database.executeBatch(new CloseYesterdayTrades());
    }

    public Iterable<Trade__c> start(Database.BatchableContext param1) {
        Date date1 = Datetime.now().dateGmt();
        return (Iterable<Trade__c>)Database.getQueryLocator('select id from Trade__c where CreatedDate<:date1 ');
    }

    public void execute(Database.BatchableContext param1, List<Trade__c> param2) {
        for (Trade__c t : param2) {
            t.Status__c = 'closed';
        }
        update param2;
    }

    public void finish(Database.BatchableContext param1) {
    }
}