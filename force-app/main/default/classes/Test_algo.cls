public
with sharing class Test_algo extends AlgoBase {
public
  test_algo() {}

public
  override Boolean testBuy() {
    System.debug('test buy ' + algo + current);
    return false;
  }

public
  override Boolean testSell() { return false; }
}