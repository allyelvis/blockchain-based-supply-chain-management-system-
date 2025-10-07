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
