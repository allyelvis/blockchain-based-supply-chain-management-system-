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
