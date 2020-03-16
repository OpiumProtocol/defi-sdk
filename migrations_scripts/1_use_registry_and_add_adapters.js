const AaveAssetAdapter = artifacts.require('AaveAssetAdapter');
const AaveDebtAdapter = artifacts.require('AaveDebtAdapter');
const CompoundAssetAdapter = artifacts.require('CompoundAssetAdapter');
const CompoundDebtAdapter = artifacts.require('CompoundDebtAdapter');
const CurveAdapter = artifacts.require('CurveAdapter');
const DyDxAssetAdapter = artifacts.require('DyDxAssetAdapter');
const DyDxDebtAdapter = artifacts.require('DyDxDebtAdapter');
const IearnAdapter = artifacts.require('IearnAdapter');
const DSRAdapter = artifacts.require('DSRAdapter');
const MCDAssetAdapter = artifacts.require('MCDAssetAdapter');
const MCDDebtAdapter = artifacts.require('MCDDebtAdapter');
const PoolTogetherAdapter = artifacts.require('PoolTogetherAdapter');
const SynthetixAssetAdapter = artifacts.require('SynthetixAssetAdapter');
const SynthetixDebtAdapter = artifacts.require('SynthetixDebtAdapter');
const UniswapAdapter = artifacts.require('UniswapAdapter');
const ZrxAdapter = artifacts.require('ZrxAdapter');
const ERC20TokenAdapter = artifacts.require('ERC20TokenAdapter');
const AaveTokenAdapter = artifacts.require('ERC20TokenAdapter');
const CompoundTokenAdapter = artifacts.require('ERC20TokenAdapter');
const CurveTokenAdapter = artifacts.require('ERC20TokenAdapter');
const IearnTokenAdapter = artifacts.require('ERC20TokenAdapter');
const PoolTogetherTokenAdapter = artifacts.require('ERC20TokenAdapter');
const UniswapTokenAdapter = artifacts.require('ERC20TokenAdapter');
const AdapterRegistry = artifacts.require('AdapterRegistry');

const daiAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F';
const tusdAddress = '0x0000000000085d4780B73119b644AE5ecd22b376';
const usdcAddress = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
const usdtAddress = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
const susdAddress = '0x57Ab1ec28D129707052df4dF418D58a2D46d5f51';
const lendAddress = '0x80fB784B7eD66730e8b1DBd9820aFD29931aab03';
const batAddress = '0x0D8775F648430679A709E98d2b0Cb6250d2887EF';
const ethAddress = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
const linkAddress = '0x514910771AF9Ca656af840dff83E8264EcF986CA';
const kncAddress = '0xdd974D5C2e2928deA5F71b9825b8b646686BD200';
const repAddress = '0x1985365e9f78359a9B6AD760e32412f4a445E862';
const mkrAddress = '0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2';
const manaAddress = '0x0F5D2fB29fb7d3CFeE444a200298f468908cC942';
const zrxAddress = '0xE41d2489571d322189246DaFA5ebDe1F4699F498';
const snxAddress = '0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F';
const wbtcAddress = '0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599';

const cDAIAddress = '0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643';
const cBATAddress = '0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E';
const cETHAddress = '0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5';
const cREPAddress = '0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1';
const cSAIAddress = '0xF5DCe57282A584D2746FaF1593d3121Fcac444dC';
const cZRXAddress = '0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407';
const cUSDCAddress = '0x39AA39c021dfbaE8faC545936693aC917d5E7563';
const cWBTCAddress = '0xC11b1268C1A384e55C48c2391d8d480264A3A7F4';

const saiAddress = '0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359';

const yDAIv2 = '0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01';
const yUSDCv2 = '0xd6aD7a6750A7593E092a9B218d66C0A814a3436e';
const yUSDTv2 = '0x83f798e925BcD4017Eb265844FDDAbb448f1707D';
const ySUSDv2 = '0xF61718057901F84C4eEC4339EF8f0D86D2B45600';
const yTUSDv2 = '0x73a052500105205d34Daf004eAb301916DA8190f';
const yWBTCv2 = '0x04Aa51bbcB46541455cCF1B8bef2ebc5d3787EC9';

const yDAIv3 = '0xC2cB1040220768554cf699b0d863A3cd4324ce32';
const yUSDCv3 = '0x26EA744E5B887E5205727f55dFBE8685e3b21951';
const yUSDTv3 = '0xE6354ed5bC4b393a5Aad09f21c46E101e692d447';
const yBUSDv3 = '0x04bC0Ab673d88aE9dbC9DA2380cB6B79C4BCa9aE';


const ssCompoundTokenAddress = '0x845838DF265Dcd2c412A1Dc9e959c7d08537f8a2';
const ssYTokenAddress = '0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8';
const ssBusdTokenAddress = '0x3B3Ac5386837Dc563660FB6a0937DFAa5924333B';

const wethAddress = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';

const saiPoolAddress = '0xb7896fce748396EcFC240F5a0d3Cc92ca42D7d84';
const daiPoolAddress = '0x29fe7D60DdF151E5b52e5FAB4f1325da6b2bD958';
const usdcPoolAddress = '0x0034Ea9808E620A0EF79261c51AF20614B742B24';

const uniDaiAddress = '0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667';

const aaveAdapterTokens = [
  daiAddress,
  tusdAddress,
  usdcAddress,
  usdtAddress,
  susdAddress,
  lendAddress,
  batAddress,
  ethAddress,
  linkAddress,
  kncAddress,
  repAddress,
  mkrAddress,
  manaAddress,
  zrxAddress,
  snxAddress,
  wbtcAddress,
];
const compoundAssetAdapterTokens = [
  cDAIAddress,
  cBATAddress,
  cETHAddress,
  cREPAddress,
  cSAIAddress,
  cZRXAddress,
  cUSDCAddress,
  cWBTCAddress,
];
const compoundDebtAdapterTokens = [
  daiAddress,
  batAddress,
  ethAddress,
  repAddress,
  saiAddress,
  zrxAddress,
  usdcAddress,
  wbtcAddress,
];
const curveAdapterTokens = [
  ssCompoundTokenAddress,
  ssYTokenAddress,
  ssBusdTokenAddress,
];
const dydxAdapterTokens = [
  wethAddress,
  saiAddress,
  usdcAddress,
  daiAddress,
];
const iearn2AdapterTokens = [
  yDAIv2,
  yUSDCv2,
  yUSDTv2,
  ySUSDv2,
  yTUSDv2,
  yWBTCv2,
];
const iearn3AdapterTokens = [
  yDAIv3,
  yUSDCv3,
  yUSDTv3,
  yBUSDv3,
];
const dsrAdapterTokens = [
  daiAddress,
];
const mcdAssetAdapterTokens = [
  wethAddress,
  batAddress,
];
const mcdDebtAdapterTokens = [
  daiAddress,
];
const poolTogetherAdapterTokens = [
  saiPoolAddress,
  daiPoolAddress,
  usdcPoolAddress,
];
const synthetixAssetAdapterTokens = [
  snxAddress,
];
const synthetixDebtAdapterTokens = [
  susdAddress,
];
const uniswapAdapterTokens = [
  uniDaiAddress,
];
const zrxAdapterTokens = [
  zrxAddress,
];

let protocols = [];
let tokenAdapters = [];
let aaveAdapters = [];
let compoundAdapters = [];
let curveAdapters = [];
let dydxAdapters = [];
let iearn2Adapters = [];
let iearn3Adapters = [];
let dsrAdapters = [];
let mcdAdapters = [];
let poolTogetherAdapters = [];
let synthetixAdapters = [];
let uniswapAdapters = [];
let zrxAdapters = [];

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(AaveAssetAdapter, { from: accounts[0] })
    .then(() => {
      aaveAdapters.push([
        AaveAssetAdapter.address,
        aaveAdapterTokens,
      ]);
    });
  await deployer.deploy(AaveDebtAdapter, { from: accounts[0] })
    .then(() => {
      aaveAdapters.push([
        AaveDebtAdapter.address,
        aaveAdapterTokens,
      ]);
    });
  protocols.push([
    'Aave',
    'Decentralized Lending & Borrowing Protocol',
    'aave.com',
    'protocol-icons.s3.amazonaws.com/aave.png',
    '0',
    aaveAdapters,
  ]);
  await deployer.deploy(CompoundAssetAdapter, { from: accounts[0] })
    .then(() => {
      compoundAdapters.push([
        CompoundAssetAdapter.address,
        compoundAssetAdapterTokens,
      ]);
    });
  await deployer.deploy(CompoundDebtAdapter, { from: accounts[0] })
    .then(() => {
      compoundAdapters.push([
        CompoundDebtAdapter.address,
        compoundDebtAdapterTokens,
      ]);
    });
  protocols.push([
    'Compound',
    'Decentralized Lending & Borrowing Protocol',
    'compound.finance',
    'protocol-icons.s3.amazonaws.com/compound.png',
    '0',
    compoundAdapters,
  ]);
  await deployer.deploy(CurveAdapter, { from: accounts[0] })
    .then(() => {
      curveAdapters.push([
        CurveAdapter.address,
        curveAdapterTokens,
      ]);
    });
  protocols.push([
    'Curve',
    'Exchange liquidity pool for stablecoin trading',
    'curve.fi',
    'protocol-icons.s3.amazonaws.com/curve.fi.png',
    '0',
    curveAdapters,
  ]);
  await deployer.deploy(DyDxAssetAdapter, { from: accounts[0] })
    .then(() => {
      dydxAdapters.push([
        DyDxAssetAdapter.address,
        dydxAdapterTokens,
      ]);
    });
  await deployer.deploy(DyDxDebtAdapter, { from: accounts[0] })
    .then(() => {
      dydxAdapters.push([
        DyDxDebtAdapter.address,
        dydxAdapterTokens,
      ]);
    });
  protocols.push([
    'dYdX',
    '',
    'dydx.exchange',
    'protocol-icons.s3.amazonaws.com/dydx.png',
    '0',
    dydxAdapters,
  ]);
  await deployer.deploy(IearnAdapter, { from: accounts[0] })
    .then(() => {
      iearn2Adapters.push([
        IearnAdapter.address,
        iearn2AdapterTokens,
      ]);
    });
  protocols.push([
    'iearn.finance (v2)',
    '',
    'iearn.finance',
    '',
    '0',
    iearn2Adapters,
  ]);
  await deployer.deploy(IearnAdapter, { from: accounts[0] })
    .then(() => {
      iearn3Adapters.push([
        IearnAdapter.address,
        iearn3AdapterTokens,
      ]);
    });
  protocols.push([
    'iearn.finance (v3)',
    '',
    'iearn.finance',
    '',
    '0',
    iearn3Adapters,
  ]);
  await deployer.deploy(DSRAdapter, { from: accounts[0] })
    .then(() => {
      dsrAdapters.push([
        DSRAdapter.address,
        dsrAdapterTokens,
      ]);
    });
  protocols.push([
    'Dai Savings Rate',
    'Decentralized Lending Protocol',
    'makerdao.com',
    'protocol-icons.s3.amazonaws.com/dai.png',
    '0',
    dsrAdapters,
  ]);
  await deployer.deploy(MCDAssetAdapter, { from: accounts[0] })
    .then(() => {
      mcdAdapters.push([
        MCDAssetAdapter.address,
        mcdAssetAdapterTokens,
      ]);
    });
  await deployer.deploy(MCDDebtAdapter, { from: accounts[0] })
    .then(() => {
      mcdAdapters.push([
        MCDDebtAdapter.address,
        mcdDebtAdapterTokens,
      ]);
    });
  protocols.push([
    'Multi-Collateral Dai',
    'Collateralized loans on Maker',
    'makerdao.com',
    'protocol-icons.s3.amazonaws.com/maker.png',
    '0',
    dydxAdapters,
  ]);
  await deployer.deploy(PoolTogetherAdapter, { from: accounts[0] })
    .then(() => {
      poolTogetherAdapters.push([
        PoolTogetherAdapter.address,
        poolTogetherAdapterTokens,
      ]);
    });
  protocols.push([
    'PoolTogether',
    'Decentralized no-loss lottery',
    'pooltogether.com',
    'protocol-icons.s3.amazonaws.com/pooltogether.png',
    '0',
    poolTogetherAdapters,
  ]);
  await deployer.deploy(SynthetixAssetAdapter, { from: accounts[0] })
    .then(() => {
      synthetixAdapters.push([
        SynthetixAssetAdapter.address,
        synthetixAssetAdapterTokens,
      ]);
    });
  await deployer.deploy(SynthetixDebtAdapter, { from: accounts[0] })
    .then(() => {
      synthetixAdapters.push([
        SynthetixDebtAdapter.address,
        synthetixDebtAdapterTokens,
      ]);
    });
  protocols.push([
    'Synthetix',
    'Synthetic Assets Protocol',
    'synthetix.io',
    'protocol-icons.s3.amazonaws.com/synthetix.png',
    '0',
    synthetixAdapters,
  ]);
  await deployer.deploy(UniswapAdapter, { from: accounts[0] })
    .then(() => {
      uniswapAdapters.push([
        UniswapAdapter.address,
        uniswapAdapterTokens,
      ]);
    });
  protocols.push([
    'Uniswap',
    '',
    'uniswap.io',
    '',
    '0',
    uniswapAdapters,
  ]);
  await deployer.deploy(ZrxAdapter, { from: accounts[0] })
    .then(() => {
      zrxAdapters.push([
        ZrxAdapter.address,
        zrxAdapterTokens,
      ]);
    });
  protocols.push([
    '0x Staking',
    'Liquidity rewards with ZRX',
    '0x.org/zrx/staking',
    'protocol-icons.s3.amazonaws.com/0x-staking.png',
    '0',
    zrxAdapters,
  ]);
  await deployer.deploy(ERC20TokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        ERC20TokenAdapter.address,
      );
    });
  await deployer.deploy(AaveTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        AaveTokenAdapter.address,
      );
    });
  await deployer.deploy(CompoundTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        CompoundTokenAdapter.address,
      );
    });
  await deployer.deploy(CurveTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        CurveTokenAdapter.address,
      );
    });
  await deployer.deploy(IearnTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        IearnTokenAdapter.address,
      );
    });
  await deployer.deploy(PoolTogetherTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        PoolTogetherTokenAdapter.address,
      );
    });
  await deployer.deploy(UniswapTokenAdapter, { from: accounts[0] })
    .then(() => {
      tokenAdapters.push(
        UniswapTokenAdapter.address,
      );
    });

  // eslint-disable-next-line no-console
  console.dir(`The ready protocols array:\n${protocols}`, { depth: null });
  await AdapterRegistry.at('0x9A2FB998c6bd001B8D4f235a260640136159e496') // kovan
    .then(async (registry) => {
      await registry.contract.methods.addProtocols(
        [
          'Aave',
          'Compound',
          'Curve',
          'dYdX',
          'iearn2',
          'iearn3',
          'DSR',
          'MCD',
          'PoolTogether',
          'Synthetix',
          'Uniswap',
          '0x',
        ],
        protocols,
      )
        .send({
          from: accounts[0],
          gasLimit: '5000000',
        });
      await registry.contract.methods.addTokenAdapters(
        [
          'ERC20',
          'AToken',
          'CToken',
          'Curve pool token',
          'YToken',
          'PoolTogether pool',
          'Uniswap pool token',
        ],
        tokenAdapters,
      )
        .send({
          from: accounts[0],
          gasLimit: '5000000',
        });
    });
};
