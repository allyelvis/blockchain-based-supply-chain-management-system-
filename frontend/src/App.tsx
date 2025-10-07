import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import './App.css';

function App() {
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [productInfo, setProductInfo] = useState(null);

  useEffect(() => {
    const initWeb3 = async () => {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const accounts = await web3.eth.getAccounts();
        setAccount(accounts[0]);
        // Assuming the contract ABI and address are available
        const contractAddress = 'YOUR_CONTRACT_ADDRESS';
        const abi = [/* Contract ABI */];
        const contractInstance = new web3.eth.Contract(abi, contractAddress);
        setContract(contractInstance);
      } else {
        alert('Please install MetaMask!');
      }
    };

    initWeb3();
  }, []);

  const fetchProductInfo = async (productId) => {
    if (contract) {
      try {
        const info = await contract.methods.getProductInfo(productId).call();
        setProductInfo(info);
      } catch (error) {
        console.error('Error fetching product info:', error);
      }
    }
  };

  return (
    <div className="App">
      <h1>Supply Chain Management</h1>
      {account ? (
        <div>
          <p>Connected Account: {account}</p>
          <button onClick={() => fetchProductInfo(1)}>Fetch Product Info</button>
          {productInfo && (
            <div>
              <h2>Product Details</h2>
              <p>Name: {productInfo.name}</p>
              <p>Manufacturer: {productInfo.manufacturer}</p>
              <p>Status: {productInfo.status}</p>
            </div>
          )}
        </div>
      ) : (
        <p>Please connect your wallet to continue.</p>
      )}
    </div>
  );
}

export default App;
