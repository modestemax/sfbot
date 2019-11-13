public
with sharing abstract class AlgoBase implements IAlgo {
    protected
    Algo_Setting__mdt algoSetting;
    public Signal__c current;
    public Signal__c last;
    public Signal__c prev;
    public static Signal__c[] signals;

    static AlgoBase[] algos = new AlgoBase[]{
    };

    public static void newSignals(Signal__c[] newSignals) {
        System.debug('new signals = ' + newSignals);
        signals = newSignals;
    }

    public static void prepareAndTest() {
        System.debug('algos = ' + algos);
        Set<String> symbols = AlgoBase.getSymbols();
        for (AlgoBase algo : algos) {
            System.debug('##test Start! ' + algo.algoSetting.Name__c + '(' + algo.algoSetting.Timeframe__c + ')');
            for (String symbol : symbols) {
                List<Signal__c >signals = AlgoBase.getSignalsForSymbol(symbol);
                if (signals.size() > 2) {

                    algo.current = signals[2];
                    algo.last = signals[1];
                    algo.prev = signals[0];
                    if (algo.algoSetting.Timeframe__c == algo.current.Timeframe__c) {
                        algo.test();
                    }
                }
            }
        }
    }
    public static Set<String> getSymbols() {
        Set<String> symbols = new Set<String>();
        for (Signal__c signal : signals) {
            symbols.add(signal.Symbol__c);
        }
        return symbols;
    }

    public static Signal__c getCurrentSignalForSymbol(String symbol) {
        Signal__c[]signals = getSignalsForSymbol(symbol);
        return signals.size() > 2 ? signals [2]
                : signals.size() > 1 ? signals [1]
                        : signals.size() > 0 ? signals [0]
                                : null;
    }
    public static Signal__c[] getSignalsForSymbol(String symbol) {
        Signal__c[] signals = new List< Signal__c>();
        for (Signal__c signal : AlgoBase.signals) {
            if (signal.Symbol__c == symbol) {
                signals.add(signal);
            }
        }
        signals.sort();
        return signals;
    }

    public AlgoBase init(Algo_Setting__mdt algoSetting) {
        this.algoSetting = algoSetting;
        algos.add(this);
        return this;
    }

    public Boolean isTest() {
        return algoSetting.Is_Test__c;
    }

    public virtual void test() {
        System.debug('new test starting');
        if (last != null && current != null && prev != null) {
            System.debug('#test buy Start! ' + algoSetting.Name__c + '( ' + algoSetting.Timeframe__c + ')' + current.Symbol__c);
            if (testBuy()) {
                System.debug('new test succeed');
                if ([
                        SELECT Id
                        FROM Trade__c
                        WHERE Status__c = 'open'
                        AND Algo__c = :algoSetting.Name__c
                ].size() < algoSetting.Trade_Count__c) {
                    if ([
                            SELECT Id
                            FROM Trade__c
                            WHERE Symbol__c = :current.Symbol__c AND Status__c = 'open'
                            AND Algo__c = :algoSetting.Name__c
                    ].size() == 0) {

                        insert new Trade__c(Side__c = 'buy', Status__c = 'open',
                                Symbol__c = current.Symbol__c, Type__c = 'market',
                                Signal_Id__c = current.signal_Id__c,
                                Algo__c = algoSetting.Name__c,
                                Take_Profit__c = algoSetting.Take_Profit__c,
                                Stop_Loss__c = algoSetting.Stop_Loss__c,
                                System_Stop_Loss__c = algoSetting.Stop_Loss__c,
                                System_Take_Profit__c = algoSetting.Take_Profit__c,
                                Close_position_based_on_age__c = algoSetting.Close_position_based_on_age__c,
                                Max_age_In_Minutes__c = algoSetting.Max_age_In_Minutes__c,
                                Is_Test__c = algoSetting.Is_Test__c,
                                Bid__c = current.Bid__c,
                                Price__c = current.Bid__c,
                                Trailing_Stop_Loss__c = algoSetting.Trailing_Stop_Loss__c,
                                Trailing_Stop_Loss_Value__c = algoSetting.Trailing_Stop_Loss_Value__c,
                                Quantity__c = 1
                        );
                    }
                }
            }
        }
    }

    public abstract Boolean testBuy();

    public virtual Boolean testSell() {
        return false;
    }
}