/**
 * Created by max on 11/4/19.
 */

public with sharing class Trigger_tradeHandler implements Trigger_ITrigger {


    public void bulkBefore() {
    }

    public void bulkAfter() {
    }

    public void beforeInsert(SObject so) {
        Trade__c trade = (Trade__c) so;
        trade.Max__c = trade.Change__c;
        trade.Min__c = trade.Change__c;
    }


    public void beforeUpdate(SObject oldSo, SObject so) {
        Trade__c trade = (Trade__c) so;
        Trade__c oldTrade = (Trade__c) oldSo;
        trade.Max__c = Math.max(trade.Max__c, oldTrade.Change__c);
        trade.Min__c = Math.min(trade.Min__c, oldTrade.Change__c);
        trade.Note__c = Utils.HourFromNow(trade.CreatedDate) + ' Hours\n';
        if (trade.Change__c >= trade.Take_Profit__c || trade.Change__c <= trade.Stop_Loss__c
                || (trade.Close_position_based_on_age__c && trade.Max_age_In_Minutes__c <= Utils.minutesFromNow(trade.CreatedDate))) {

//            if (!trade.Is_Test__c) {
////                stopTrade(trade);
//                trade.Status__c = 'closed';
//            }
            if (trade.Change__c >= trade.Take_Profit__c) {
                if (trade.Trailing_Stop_Loss__c) {
                    trade.Take_Profit__c += trade.Trailing_Stop_Loss_Value__c;
                    trade.Stop_Loss__c += trade.Trailing_Stop_Loss_Value__c;
                }else{
                    trade.Status__c = 'closed';
                }
                trade.Note__c += ' -> take profit';
            } else if (trade.Change__c <= trade.Stop_Loss__c) {
                trade.Note__c += trade.Change__c <= 0 ? ' -> stop loss' : ' -> stop loss win';
                trade.Status__c = 'closed';
            } else if (trade.Close_position_based_on_age__c && trade.Max_age_In_Minutes__c <= Utils.minutesFromNow(trade.CreatedDate)) {
                trade.Note__c += trade.Change__c <= 0 ? '-> aged trade loss' : '-> aged trade win';
                trade.Status__c = 'closed';
            }

        }
    }

    public void beforeDelete(SObject so) {
    }

    public void afterInsert(SObject so) {

    }

    public void afterUpdate(SObject oldSo, SObject so) {

    }

    public void afterDelete(SObject so) {
    }

    public void andFinally() {
    }


}