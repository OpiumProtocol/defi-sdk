const { BN } = web3.utils;
const AdapterRegistry = artifacts.require('./AdapterRegistry');
const Logic = artifacts.require('./Logic');
const CompoundInteractiveAdapter = artifacts.require('./CompoundInteractiveAdapter');
const ChaiInteractiveAdapter = artifacts.require('./ChaiInteractiveAdapter');
const ERC20 = artifacts.require('./ERC20');

contract('Logic', () => {
  const cDAIAddress = '0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643';
  const DAIAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F';
  const chaiAddress = '0x06AF07097C9Eeb7fD685c692751D5C66dB49c215';
  const testAddress = '0xD8282A355383A6513EccC8a16F990bA0026C2d1a';

  let accounts;
  let adapterRegistry;
  let compoundInteractiveAdapter;
  let chaiInteractiveAdapter;
  let logic;

  beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    await CompoundInteractiveAdapter.new({ from: accounts[0] })
      .then((result) => {
        compoundInteractiveAdapter = result.contract;
      });
    await ChaiInteractiveAdapter.new({ from: accounts[0] })
      .then((result) => {
        chaiInteractiveAdapter = result.contract;
      });
    await AdapterRegistry.new(
      [
        chaiInteractiveAdapter.options.address,
        compoundInteractiveAdapter.options.address,
      ],
      [
        [
          chaiAddress,
        ],
        [
          cDAIAddress,
        ],
      ],
      { from: accounts[0] },
    )
      .then((result) => {
        adapterRegistry = result.contract;
      });
    await Logic.new(
      adapterRegistry.options.address,
      { from: accounts[0] },
    )
      .then((result) => {
        logic = result.contract;
      });
  });

  it('should be correct lend transfer', async () => {
    let base;
    let cDAIAmount;
    let cDAIRate;
    let daiAmount;
    let chaiAmount;
    let chaiRate;
    let daiChaiAmount;
    let chaiAmountNew;
    let chaiRateNew;
    let daiChaiAmountNew;

    await adapterRegistry.methods['getBalancesAndRates(address)'](testAddress)
      .call()
      .then((result) => {
        base = new BN(10).pow(new BN(34));
        cDAIAmount = new BN(result[0].balances[0].amount);
        cDAIRate = new BN(result[0].rates[0].components[0].rate);
        daiAmount = cDAIRate.mul(cDAIAmount).div(base).toNumber() / 100;
        // eslint-disable-next-line no-console
        console.log(`cDAI amount: ${cDAIAmount.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`cDAI rate: ${cDAIRate.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`Means its: ${daiAmount} DAI locked`);
      });
    await adapterRegistry.methods['getBalancesAndRates(address)'](testAddress)
      .call()
      .then((result) => {
        base = new BN(10).pow(new BN(43));
        chaiAmount = new BN(result[1].balances[0].amount);
        chaiRate = new BN(result[1].rates[0].components[0].rate);
        daiChaiAmount = chaiRate.mul(chaiAmount).div(base).toNumber() / 100;
        // eslint-disable-next-line no-console
        console.log(`Deposited chai amount: ${chaiAmount.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`chai-to-DAI rate: ${chaiRate.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`Means its: ${daiChaiAmount} DAI locked initially on chai`);
      });
    // transfer cDAI directly on logic contract
    let cDAI;
    await ERC20.at(cDAIAddress)
      .then((result) => {
        cDAI = result.contract;
      });
    await cDAI.methods['transfer(address,uint256)'](logic.options.address, cDAIAmount.toString())
      .send({
        from: testAddress,
        gas: 1000000,
      });
    // call logic with two actions
    await logic.methods['0x39c31e1a']( // executeActions function call
      [
        [2, compoundInteractiveAdapter.options.address, [cDAIAddress], [1000], [1], '0x'],
        [1, chaiInteractiveAdapter.options.address, [DAIAddress], [1000], [1], '0x'],
      ],
      [
      ],
    )
      .send({
        from: testAddress,
        gas: 1000000,
      });
    await adapterRegistry.methods['getBalancesAndRates(address)'](testAddress)
      .call()
      .then((result) => {
        base = new BN(10).pow(new BN(34));
        chaiAmountNew = new BN(result[1].balances[0].amount);
        chaiRateNew = new BN(result[1].rates[0].components[0].rate);
        daiChaiAmountNew = chaiRateNew.mul(chaiAmountNew).div(base).toNumber() / 100;
        // eslint-disable-next-line no-console
        console.log(`Deposited chai amount: ${chaiAmountNew.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`chai-to-DAI rate: ${chaiRateNew.toString()}`);
        // eslint-disable-next-line no-console
        console.log(`Means its: ${daiChaiAmountNew} DAI locked on chai after the actions`);
      });
  });
});
