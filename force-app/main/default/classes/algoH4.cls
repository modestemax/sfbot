public with sharing class algoH4 extends AlgoPumpBase {
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
}