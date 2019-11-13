/**
 * Created by max on 11/4/19.
 */

trigger trade on Trade__c(before insert, before update, before delete,
        after insert, after update, after delete) {
    Trigger_TriggerFactory.createHandler(Trade__c.SObjectType);

}