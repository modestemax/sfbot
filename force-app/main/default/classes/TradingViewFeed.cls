public
with sharing class TradingViewFeed implements ITask {
  static string exchangeId = 'binance';
  static string filter = 'btc$';
  static Integer[] timeframes = new Integer[]{15, 60, 60 * 4};

  static string getRequestBody(integer timeframe) {
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
        '"range": [0, 150]' + '}';
    System.debug('body in ' + body);
    return body;
  }

  static string[] getTimeframeDependendColumns() {
    return new String[]{
        'close', 'change', 'high', 'low', 'ADX', 'ADX-DI', 'ADX+DI', 'RSI',
        'EMA10', 'EMA20', 'MACD.macd', 'MACD.signal', 'open',
        'change_from_open', 'Mom',
        // 'Aroon.Up', 'Aroon.Down',  'Recommend.All','volume', 'VWMA',
        //'Stoch.K', 'Stoch.D', 'Stoch.RSI.K', 'Stoch.RSI.D',
        'BB.lower', 'BB.upper', 'EMA200', 'EMA50', 'EMA100', 'EMA30'};
  }

  static string[] getStaticColumns() {
    return new String[]{
        'name', 'bid', 'ask' //,  'exchange', 'description', 'Volatility.D'
    };
  }

  static string getColumnsAsJSON(String timeframeFilter) {
    String[] columns = getStaticColumns();

    for (string col : getTimeframeDependendColumns()) {
      columns.add(col + timeframeFilter);
    }
    System.debug('comlums ' + columns);
    return JSON.serialize(columns);
  }

@future(callout=true)
  static void callOut(integer timeframe) {
    System.debug('tv feed');
    if (timeframe == null)
      timeframe = 60 * 24;

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://scanner.tradingview.com/crypto/scan');
    request.setMethod('POST');

    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Set the body as a JSON object
    request.setBody(getRequestBody(timeframe));
    HttpResponse response = http.send(request);
    System.debug('The status code returned was : ' + response.getStatusCode() +
                 ' ' + response.getStatus());

    if (response.getStatusCode() == 200) {
      updateSignals(timeframe, response.getBody());
    } else {
      System.debug('trading view error ' + response.getBody());
    }
  }

  static void updateSignals(integer timeframe, String json) {
    TradingViewResult result = TradingViewResult.parse(json);
    signal__c[] signals = new signal__c[]{};
    for (TradingViewResult.Data data : result.data) {

      String[] cols = getStaticColumns();
      cols.addAll(getTimeframeDependendColumns());
      Integer i = 0;
      signal__c s = new signal__c(Timeframe__c = timeframe);
      for (String col : cols) {
        System.debug('result ' + col + ' = ' + data.d[i]);
        string colApi = col;
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
    insert signals;
  }

public
  static void execute() {
    for (integer timeframe : timeframes) {
      callOut(timeframe);
    }
  }
}
