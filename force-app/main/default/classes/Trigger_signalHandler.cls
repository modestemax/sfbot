public with sharing class Trigger_signalHandler implements Trigger_ITrigger {
    public Trigger_signalHandler() {
    }
    public void bulkBefore() {
    }

    public void bulkAfter() {
        if (!Trigger.isDelete) {
            runAllAlgos();
            deleteOldSignals();
            updateTrades();
        }
    }

    public void beforeInsert(SObject so) {
        // Make sure that the related contact exist
    }
    public void beforeUpdate(SObject oldSo, SObject so) {
    }

    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a
     * BEFORE trigger.
     */
    public void beforeDelete(SObject so) {
    }

    public void afterInsert(SObject so) {
    }

    public void afterUpdate(SObject oldSo, SObject so) {
    }

    public void afterDelete(SObject so) {
    }

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger.
     * Use this method to accomplish any final operations such as creation or
     * updates of other records.
     */
    public void andFinally() {
    }


    static void deleteOldSignals() {
        if (Trigger.isInsert) {
            Decimal signalId = ((Signal__c) Trigger.new[0]).signal_Id__c;
            Decimal timeframe = ((Signal__c) Trigger.new[0]).Timeframe__c;
            System.debug('trigger after insert id ' + signalId);
            delete [SELECT Id FROM Signal__c WHERE signal_Id__c <= :signalId - 3 AND Timeframe__c = :timeframe];
        }
    }

    static void runAllAlgos() {
        AllAlgos.runAll();
    }

    static void updateTrades() {
        Trade__c[]trades = [SELECT Id,Symbol__c FROM Trade__c WHERE Status__c = 'open'];

        for (Trade__c trade : trades) {
            Signal__c[] signal = [SELECT Bid__c FROM Signal__c WHERE Symbol__c = :trade.Symbol__c ORDER BY CreatedDate DESC LIMIT 1];
            if (signal.size() != 0) {
                trade.Price__c = signal[0].Bid__c;
            }
        }
        upsert trades;
    }
}