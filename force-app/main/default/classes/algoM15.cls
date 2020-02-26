public with sharing class algoM15 extends AlgoPumpBase {

    public override Boolean testBuy() {
        if (super.testBuy()) {
            Decimal D1Timeframe = 1440;
            Signal__c d1 = getCurrentSignalBySymbol(current.Symbol__c, D1Timeframe);
            if (d1.Change__c > algoSetting.Enter_Trade_At_Change__c && d1.rank__c <= 3) {
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