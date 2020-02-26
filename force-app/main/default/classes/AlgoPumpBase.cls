public virtual with sharing class AlgoPumpBase extends AlgoBase {

    public virtual override Boolean testBuy() {

        if (current.rank__c == 1 && current.Change__c > algoSetting.Enter_Trade_At_Change__c) {
            Long startTime = current.CreatedDate.getTime();
            Long now = Datetime.now().getTime();
            Long someSeconds = Datetime.now().addMinutes(3).getTime() - now;
//            if (now - startTime > someSeconds)
            if (current.Change__c != last.Change__c || (now - startTime > someSeconds))
                if (current.High__c - current.Change__c < 2) {
                    System.debug('top ' + current.Symbol__c);
                    return true;
                }
        }

        return false;
    }

//    public override Boolean testBuy() {
//
//        if ((current.MACD_macd__c > current.MACD_signal__c))
//            if ((last.MACD_macd__c > last.MACD_signal__c))
//                if ((prev.MACD_macd__c < prev.MACD_signal__c))
//                    if ((prev.MACD_macd__c - prev.MACD_signal__c < last.MACD_macd__c - last.MACD_signal__c))
//                        if ((last.MACD_macd__c - last.MACD_signal__c < current.MACD_macd__c - current.MACD_signal__c))
//                            if ((current.MACD_macd__c < 0 && current.MACD_signal__c < 0)
//                                    || (last.MACD_macd__c < 0 && last.MACD_signal__c < 0)
//                                    || (prev.MACD_macd__c < 0 && prev.MACD_signal__c < 0))
//
//                                return true;
//        return false;
//    }
}