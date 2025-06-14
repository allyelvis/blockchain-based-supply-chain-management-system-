// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Product {
        string name;
        string origin;
        string status;
        address currentHolder;
    }

    mapping(string => Product) public products;

    function registerProduct(string memory id, string memory name, string memory origin) public {
        products[id] = Product(name, origin, "Created", msg.sender);
    }

    function updateStatus(string memory id, string memory status) public {
        require(products[id].currentHolder == msg.sender, "Not authorized");
        products[id].status = status;
    }

    function transferHolder(string memory id, address newHolder) public {
        require(products[id].currentHolder == msg.sender, "Not authorized");
        products[id].currentHolder = newHolder;
    }
}
