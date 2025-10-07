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
