trigger signal on signal__c(after insert) {

  if (trigger.isAfter && trigger.isInsert) {
    Decimal signalId = trigger.new[0].signal_id__c;
    System.debug('trigger after insert id ' + signalId);
    signal__c[] toDel =
        [select id from signal__c where signal_id__c <=:signalId - 3];
    delete toDel;
  }
}