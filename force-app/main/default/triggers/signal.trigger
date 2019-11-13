trigger signal on Signal__c(before insert, before update, before delete,
                            after insert, after update, after delete) {

  Trigger_TriggerFactory.createHandler(Signal__c.SObjectType);
}