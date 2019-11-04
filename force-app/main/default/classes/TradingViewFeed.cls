public with sharing class TradingViewFeed implements ITask {
  static String exchangeId = 'binance';
  static String filter = 'btc$';
  static Integer[] timeframes = new Integer[]{/*15,*/
                                                60
                                              //  ,60 * 4,
                                              //5
                                              };

  static String getRequestBody(Integer timeframe) {
    String timeframeFilter;
    if (timeframe == null || timeframe == 60 * 24) {
      timeframeFilter = '';
    } else if (timeframe == 60 * 24 * 7) {
      timeframeFilter = '|1W';
    } else {
      timeframeFilter = '|' + timeframe;
    }
    String body =
        '{' + '"filter": [' + '{ "left": "change' + timeframeFilter +
        '", "operation": "nempty" },' +
        '{ "left": "exchange", "operation": "equal", "right":"' +
        exchangeId.toUpperCase() + '" },' +
        '{ "left": "name,description", "operation": "match", "right":"' +
        filter + '" }' + '],' + '"symbols": { "query": { "types": [] } },' +
        '"columns":' + getColumnsAsJSON(timeframeFilter) + ',' +
        '"sort": { "sortBy": "change' + timeframeFilter +
        '", "sortOrder": "desc" },' + '"options": { "lang": "en" },' +
        '"range": [0, 160]' + '}';
    // System.debug('body in ' + body);
    return body;
  }

  static String[] getTimeframeDependendColumns() {
    return new String[]{
        'close', 'change', 'high', 'low', 'ADX', 'ADX-DI', 'ADX+DI', 'RSI',
        'EMA10', 'EMA20', 'MACD.macd', 'MACD.signal', 'open',
        'change_from_open', 'Mom',
        // 'Aroon.Up', 'Aroon.Down',  'Recommend.All','volume', 'VWMA',
        //'Stoch.K', 'Stoch.D', 'Stoch.RSI.K', 'Stoch.RSI.D',
        'BB.lower', 'BB.upper', 'EMA200', 'EMA50', 'EMA100', 'EMA30'};
  }

  static String[] getStaticColumns() {
    return new String[]{
        'name', 'bid', 'ask' //,  'exchange', 'description', 'Volatility.D'
    };
  }

  static String getColumnsAsJSON(String timeframeFilter) {
    String[] columns = getStaticColumns();

    for (String col : getTimeframeDependendColumns()) {
      columns.add(col + timeframeFilter);
    }
    // System.debug('comlums ' + columns);
    return JSON.serialize(columns);
  }

  @Future(Callout = true) static void callOut(Integer timeframe) {
    // System.debug('tv feed');
    if (timeframe == null) {
      timeframe = 60 * 24;
    }

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://scanner.tradingview.com/crypto/scan');
    request.setMethod('POST');

    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Set the body as a JSON object
    request.setBody(getRequestBody(timeframe));
    HttpResponse response = http.send(request);
    // System.debug('The status code returned was : ' + response.getStatusCode()
    // + ' ' + response.getStatus());

    if (response.getStatusCode() == 200) {
      updateSignals(timeframe, response.getBody());
    } else {
      System.debug('trading view error ' + response.getBody());
    }
  }
  static Long timeframeDuration(Integer timeframe) {
    return timeframe * 60 * 1000L;
  }

  static Long getSignalId(Integer timeframe) {
    Datetime dt = Datetime.now();
    Long ctime = dt.getTime();
    return ctime / timeframeDuration(timeframe);
  }
  static Datetime getSignalTime(Long id, Integer timeframe) {
    return Datetime.newInstance(id * timeframeDuration(timeframe));
  }

  static void updateSignals(Integer timeframe, String json) {
    TradingViewResult result = TradingViewResult.parse(json);
    Signal__c[] signals = new Signal__c[]{};
    Long signalId = getSignalId(timeframe);
    Datetime signalTime = getSignalTime(signalId, timeframe);
    for (TradingViewResult.Data data : result.data) {

      String[] cols = getStaticColumns();
      cols.addAll(getTimeframeDependendColumns());
      Integer i = 0;
      String name = data.s + ':' + signalId;
      Signal__c s = new Signal__c(Name = name, Time__c = signalTime,
                                  Timeframe__c = timeframe);
      for (String col : cols) {
        // System.debug('result ' + col + ' = ' + data.d[i]);
        String colApi = col;
        switch
          on col {
            when 'name' { s.put('symbol__c', (String)data.d[i]); }
            when else {
              switch
                on col {
                  when 'ADX-DI' { colApi = 'ADX_MINUS_DI'; }
                  when 'ADX+DI' { colApi = 'ADX_PLUS_DI'; }
                  when else {
                    colApi = col.replaceAll('[-+.]', '_');
                  }
                }
              if (data.d[i] != null)
                s.put(colApi + '__c', Decimal.valueOf((String)data.d[i]));
            }
          }
        i++;
      }
      signals.add(s);
    }
    // insert signals;
    insertOrUpdate(signals);
  }

  static void insertOrUpdate(Signal__c[] signals) {
    Map<String, Signal__c> newMap = new Map<String, Signal__c>();
    for (Signal__c signal : signals) {
      newMap.put(signal.Name, signal);
    }

    for (Signal__c old :
         [SELECT Name FROM Signal__c WHERE Name IN:newMap.keySet()]) {
      Signal__c signal = newMap.get(old.Name);
      if (signal != null) {
        signal.Id = old.Id;
      }
    }
    upsert newMap.values();
  }

public static void execute() {
    for (Integer timeframe : timeframes) {
      callOut(timeframe);
    }
  }
public static void execute(Integer timeframe) { callOut(timeframe); }
}