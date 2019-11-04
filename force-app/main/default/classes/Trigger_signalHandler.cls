public with sharing class Trigger_signalHandler implements Trigger_ITrigger {
public Trigger_signalHandler() {}
public void bulkBefore() {}

public void bulkAfter() {
    runAllAlgos();
    deleteOldSignals();
  }

public void beforeInsert(SObject so) {
    // Make sure that the related contact exist
  }
public void beforeUpdate(SObject oldSo, SObject so) {}

  /**
   * beforeDelete
   *
   * This method is called iteratively for each record to be deleted during a
   * BEFORE trigger.
   */
public void beforeDelete(SObject so) {}

public void afterInsert(SObject so) {}

public void afterUpdate(SObject oldSo, SObject so) {}

public void afterDelete(SObject so) {}

  /**
   * andFinally
   *
   * This method is called once all records have been processed by the trigger.
   * Use this method to accomplish any final operations such as creation or
   * updates of other records.
   */
public void andFinally() {}

  void deleteOldSignals() {
    if (Trigger.isInsert) {
      Decimal signalId = ((Signal__c)Trigger.new[0]).signal_Id__c;
      System.debug('trigger after insert id ' + signalId);
      Signal__c[] toDel =
          [SELECT Id FROM Signal__c WHERE signal_Id__c <=:signalId - 3];
      delete toDel;
    }
  }

  void runAllAlgos() { AllAlgos.runAll(); }
}