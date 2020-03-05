const displayToken = (token) => {
  const { BN } = web3.utils;
  const base = new BN(10).pow(new BN(token.info.decimals - 5));
  const weiBalance = new BN(token.value);
  const balance = weiBalance.divRound(base).toNumber() / 100000;
  // eslint-disable-next-line no-console
  console.log(`${token.info.name} balance: ${balance.toString()}`);
};

export default displayToken;
