public with sharing class Spirit_v1 extends Spirit {

public override Boolean testBuy() {

    System.debug('test SpiritV1 buy Start!' + algoSetting + current);
    if ((last.EMA30__c < last.EMA10__c) && (last.EMA30__c >= last.EMA20__c)) {
        if (last.EMA20__c > last_bbb)
            if ((last.BB_upper__c > prev.BB_upper__c) &&
                    (last.EMA10__c > prev.EMA10__c))
                if (current.Close__c <= current.BB_upper__c)
                    if (((current.BB_upper__c / current.BB_lower__c) - 1) * 100 >= 2)
                        return true;
    }

    return false;
  }
}