import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import ProductForm from './components/ProductForm';
import ProductDetails from './components/ProductDetails';
import './App.css';

interface ProductInfo {
  name: string;
  manufacturer: string;
  status: string;
  currentOwner: string;
  history: string[];
}

const App: React.FC = () => {
  const [account, setAccount] = useState<string | null>(null);
  const [contract, setContract] = useState<any>(null);
  const [role, setRole] = useState<string | null>(null);
  const [productId, setProductId] = useState<string>('');
  const [productInfo, setProductInfo] = useState<ProductInfo | null>(null);
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    const initWeb3 = async () => {
      if ((window as any).ethereum) {
        const web3 = new Web3((window as any).ethereum);
        await (window as any).ethereum.request({ method: 'eth_requestAccounts' });
        const accounts = await web3.eth.getAccounts();
        setAccount(accounts[0]);

        const contractAddress = "YOUR_CONTRACT_ADDRESS";
        const abi = [];
        const contractInstance = new web3.eth.Contract(abi, contractAddress);
        setContract(contractInstance);

        const userRole = await contractInstance.methods.getUserRole(accounts[0]).call();
        setRole(userRole);

        subscribeToEvents(contractInstance);
      } else {
        alert('Please install MetaMask!');
      }
    };

    initWeb3();
  }, []);

  const subscribeToEvents = (contractInstance: any) => {
    contractInstance.events.ProductRegistered({ fromBlock: 'latest' })
      .on('data', (event: any) => {
        console.log('Product Registered:', event.returnValues);
        if (event.returnValues.productId === productId) fetchProductInfo();
      });

    contractInstance.events.ProductTransferred({ fromBlock: 'latest' })
      .on('data', (event: any) => {
        console.log('Product Transferred:', event.returnValues);
        if (event.returnValues.productId === productId) fetchProductInfo();
      });

    contractInstance.events.StatusUpdated({ fromBlock: 'latest' })
      .on('data', (event: any) => {
        console.log('Status Updated:', event.returnValues);
        if (event.returnValues.productId === productId) fetchProductInfo();
      });
  };

  const fetchProductInfo = async () => {
    if (!productId || !contract) return;
    setLoading(true);
    try {
      const info = await contract.methods.getProductInfo(productId).call();
      setProductInfo({
        name: info.name,
        manufacturer: info.manufacturer,
        status: info.status,
        currentOwner: info.currentOwner,
        history: info.history || [],
      });
    } catch (error) {
      console.error(error);
      alert('Failed to fetch product info.');
    }
    setLoading(false);
  };

  const registerProduct = async (name: string, manufacturer: string) => {
    if (!contract || !account) return;
    try {
      await contract.methods.registerProduct(name, manufacturer).send({ from: account });
      alert('Product registered successfully!');
    } catch (error) {
      console.error(error);
      alert('Failed to register product.');
    }
  };

  return (
    <div className="App">
      <h1>Blockchain Supply Chain</h1>
      {account ? (
        <>
          <p>Connected Wallet: {account}</p>
          <p>Role: {role}</p>
          {role === 'manufacturer' && <ProductForm registerProduct={registerProduct} />}
          <div className="card">
            <h2>Track Product</h2>
            <input
              type="text"
              placeholder="Product ID"
              value={productId}
              onChange={(e) => setProductId(e.target.value)}
            />
            <button onClick={fetchProductInfo}>Fetch Info</button>
            {loading && <p>Loading...</p>}
            {productInfo && <ProductDetails productInfo={productInfo} />}
          </div>
        </>
      ) : (
        <p>Please connect your wallet.</p>
      )}
    </div>
  );
};

export default App;
