public with sharing class algoH1Macd extends AlgoBase {

    public override Boolean testBuy() {

        if ((current.MACD_macd__c > current.MACD_signal__c))
            if ((last.MACD_macd__c > last.MACD_signal__c))
                if ((prev.MACD_macd__c < prev.MACD_signal__c))
                    if ((prev.MACD_macd__c - prev.MACD_signal__c < last.MACD_macd__c - last.MACD_signal__c))
                        if ((last.MACD_macd__c - last.MACD_signal__c < current.MACD_macd__c - current.MACD_signal__c))
                            if ((current.MACD_macd__c < 0 && current.MACD_signal__c < 0)
                                    || (last.MACD_macd__c < 0 && last.MACD_signal__c < 0)
                                    || (prev.MACD_macd__c < 0 && prev.MACD_signal__c < 0))

                                return true;
        return false;
    }
}