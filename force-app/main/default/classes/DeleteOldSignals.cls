public with sharing class DeleteOldSignals //implements ITask, Database.Batchable<Signal__c>
 {
//
//    public static void execute() {
//        Database.executeBatch(new DeleteOldSignals());
//    }
//
//    public Iterable<Signal__c> start(Database.BatchableContext param1) {
//        Date date1 = Datetime.now().date();
//        return (Iterable<Signal__c>) Database.getQueryLocator('SELECT signalId FROM Signal__c  ');
//    }
//
//    public void execute(Database.BatchableContext param1, List<Signal__c> param2) {
//        AggregateResult[] signals = [SELECT MAX(signal_Id__c) FROM Signal__c WHERE Timeframe__c = :param2[0].Timeframe__c];
//       Decimal max_signal_Id__c=(Decimal) signals[0].get('signal_Id__c');
//        Trade__c[] trades=new List<Trade__c>();
//        for (Signal__c signal : param2) {
//          if(signal.signal_Id__c)
//        }
//        update param2;
//    }
//
//    public void finish(Database.BatchableContext param1) {
//    }
}