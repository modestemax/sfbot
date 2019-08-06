trigger signal on signal__c(before insert, before update, before delete,
                            after insert, after update, after delete) {

  Trigger_TriggerFactory.createHandler(signal__c.sObjectType);
}