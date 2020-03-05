const AdapterRegistry = artifacts.require('./AdapterRegistry');
const testAddress = '0x42b9dF65B219B3dD36FF330A4dD8f327A6Ada990';

contract('AdapterRegistry deployed', () => {
  let adapterRegistry;

  beforeEach(async () => {
    await AdapterRegistry.deployed()
      .then((result) => {
        adapterRegistry = result.contract;
      });
  });

  it('should be correct protocols names', async () => {
    await adapterRegistry.methods.getProtocolNames()
      .call()
      .then((result) => {
        assert.deepEqual(
          result,
          [
            '0x',
            'Uniswap',
            'Synthetix',
            'PoolTogether',
            'MCD',
            'DSR',
            'iearn3',
            'iearn2',
            'dYdX',
            'Curve',
            'Compound',
            'Aave',
          ],
        );
      });
    await adapterRegistry.methods.getTokenAdapterNames()
      .call()
      .then((result) => {
        assert.deepEqual(
          result,
          [
            'Uniswap pool token',
            'PoolTogether pool',
            'YToken',
            'Curve pool token',
            'CToken',
            'AToken',
            'ERC20',
          ],
        );
      });
    await adapterRegistry.methods['getBalances(address)'](testAddress)
      .call()
      .then((result) => {
        // eslint-disable-next-line no-console
        console.dir(result, { depth: null });
      });
  });
});
