#!/bin/bash

# === Config ===
APP_NAME="supply-chain-dapp"
CONTRACT_ABI="[]" # Placeholder, you can replace later
CONTRACT_ADDRESS="YOUR_CONTRACT_ADDRESS"

# === Step 1: Create React + TypeScript App ===
echo "Creating React TypeScript app..."
npx create-react-app $APP_NAME --template typescript
cd $APP_NAME || exit

# === Step 2: Install Dependencies ===
echo "Installing web3 and react-toastify..."
npm install web3 react-toastify

# === Step 3: Create Components Folder ===
mkdir -p src/components

# === Step 4: Create App.tsx ===
cat <<EOL > src/App.tsx
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

        const contractAddress = "${CONTRACT_ADDRESS}";
        const abi = ${CONTRACT_ABI};
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
EOL

# === Step 5: Create ProductForm.tsx ===
cat <<EOL > src/components/ProductForm.tsx
import React, { useState } from 'react';

interface Props {
  registerProduct: (name: string, manufacturer: string) => void;
}

const ProductForm: React.FC<Props> = ({ registerProduct }) => {
  const [name, setName] = useState('');
  const [manufacturer, setManufacturer] = useState('');

  const handleSubmit = () => {
    if (!name || !manufacturer) return alert('Fill all fields');
    registerProduct(name, manufacturer);
    setName('');
    setManufacturer('');
  };

  return (
    <div className="card">
      <h2>Register Product</h2>
      <input
        type="text"
        placeholder="Product Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <input
        type="text"
        placeholder="Manufacturer"
        value={manufacturer}
        onChange={(e) => setManufacturer(e.target.value)}
      />
      <button onClick={handleSubmit}>Register</button>
    </div>
  );
};

export default ProductForm;
EOL

# === Step 6: Create ProductDetails.tsx ===
cat <<EOL > src/components/ProductDetails.tsx
import React from 'react';
import ProductHistory from './ProductHistory';

interface ProductInfo {
  name: string;
  manufacturer: string;
  status: string;
  currentOwner: string;
  history: string[];
}

interface Props {
  productInfo: ProductInfo;
}

const ProductDetails: React.FC<Props> = ({ productInfo }) => {
  return (
    <div className="product-details">
      <h3>Product Details</h3>
      <p>Name: {productInfo.name}</p>
      <p>Manufacturer: {productInfo.manufacturer}</p>
      <p>Status: {productInfo.status}</p>
      <p>Current Owner: {productInfo.currentOwner}</p>
      <ProductHistory history={productInfo.history} />
    </div>
  );
};

export default ProductDetails;
EOL

# === Step 7: Create ProductHistory.tsx ===
cat <<EOL > src/components/ProductHistory.tsx
import React from 'react';

interface Props {
  history: string[];
}

const ProductHistory: React.FC<Props> = ({ history }) => {
  return (
    <div>
      <h4>History:</h4>
      <ul>
        {history.length > 0 ? (
          history.map((event, index) => <li key={index}>{event}</li>)
        ) : (
          <li>No history available.</li>
        )}
      </ul>
    </div>
  );
};

export default ProductHistory;
EOL

# === Step 8: Create empty App.css ===
touch src/App.css

# === Step 9: Done ===
echo "React + TypeScript blockchain app structure created successfully!"
echo "Next steps: Replace YOUR_CONTRACT_ADDRESS and ABI in App.tsx, then run 'npm start'."
