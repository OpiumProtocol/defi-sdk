const { BN } = web3.utils;
const SignatureVerifier = artifacts.require('./SignatureVerifier');

async function signTypedData(account, data) {
  return new Promise((resolve, reject) => {
    web3.currentProvider.send({
      jsonrpc: '2.0',
      method: 'eth_signTypedData',
      params: [account, data],
      id: new Date().getTime(),
    }, (err, response) => {
      if (err) {
        return reject(err);
      }
      resolve(response.result);
    });
  });
}

contract('SignatureVerifier', () => {

  let accounts;
  let signatureVerifier;


  beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    await SignatureVerifier.new({ from: accounts[0] })
      .then((result) => {
        signatureVerifier = result.contract;
      });
  });

  it.only('should be correct signer', async () => {
    // console.log(signatureVerifier.methods);

    let hashApproval;

    await signatureVerifier.methods['hashApproval((address,uint256,uint8,uint256))'](
      ['0x6B175474E89094C44Da98b954EedeAC495271d0F', 1000, 0, 0],
    )
      .call()
      .then((result) => {
        hashApproval = result;
      });
    console.log(`Approval hash to be signed: ${hashApproval}`);

    // sign
    async function signer(asset, amount, amountType, nonce) {
      const typedData = {
        types: {
          EIP712Domain: [
            { type: 'address', name: 'verifyingContract' },
          ],
          Approval: [
            { type: 'address', name: 'asset' },
            { type: 'uint256', name: 'amount' },
            { type: 'uint8', name: 'amountType' },
            { type: 'uint256', name: 'nonce' },
          ],
        },
        domain: {
          verifyingContract: signatureVerifier.options.address,
        },
        primaryType: 'Approval',
        message: {
          asset,
          amount,
          amountType,
          nonce,
        },
      };

      return signTypedData(accounts[0], typedData);
    }

    const signature = await signer(
      '0x6B175474E89094C44Da98b954EedeAC495271d0F',
      1000,
      0,
      0,
    );
    console.log(signature);
    console.log(`0x${signature.slice(2, 66)}`);
    console.log(`0x${signature.slice(66, 130)}`);
    console.log(`0x${signature.slice(130, 132)}`);

    // decode signature
    await signatureVerifier.methods['getUserFromSignature((address,uint256,uint8,uint256),bytes32,bytes32,uint8)'](
      ['0x6B175474E89094C44Da98b954EedeAC495271d0F', 1000, 0, 0],
      `0x${signature.slice(2, 66)}`,
      `0x${signature.slice(66, 130)}`,
      `0x${signature.slice(130, 132)}`,
    )
      .call()
      .then((result) => {
        assert.equal(accounts[0], result);
      });
  });
});
