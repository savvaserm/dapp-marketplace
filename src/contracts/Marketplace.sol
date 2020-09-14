pragma solidity ^0.5.0;

contract Marketplace {
	string public name;
	uint public productCount = 0;
	mapping(uint => Product) public products;

	struct Product {
		uint id;
		string name;
		uint price;
		address payable owner;
		bool purchased;
	}

	event ProductCreated(
		uint id,
		string name,
		uint price,
		address payable owner,
		bool purchased
	);

	event ProductPurchased(
		uint id,
		string name,
		uint price,
		address payable owner,
		bool purchased
	);

	constructor() public {
		name = "Marketplace";
	}

	function createProduct(string memory _name, uint _price) public {

		// Will write tests to check the below things:

		// Make sure parameters are correct

		// Require a valid name
		// To bytes(name) dhlwnei oti to string name periexei dedomena
		require(bytes(_name).length > 0);

		// Require a valid price
		require(_price > 0);

		// Increment product count
		productCount ++;

		// Create the product
		products[productCount] = Product(productCount, _name, _price, msg.sender, false);

		// Trigger an event
		emit ProductCreated(productCount, _name, _price, msg.sender, false);
	}

	function purchaseProduct(uint _id) public payable{

		// Fetch the product
		// Dhmiourgoume ena antikeimeno Product apo to struct
		// Me to _memory dhmiourgoume ousiastika ena copy tou antikeimenou kai 
		// oxi auto pou yparxei sto blockchain
		// to katoxhronoume sthn local variable _product
		// apo thn domh products pairnoume to antikeimeno me orisma _id
		Product memory _product = products[_id];

		// Fetch the owner
		address payable _seller = _product.owner;

		// Make sure the product has valid id
		require(_product.id > 0 && _product.id <= productCount);

		// Require that there is enough Ether in the account
		require(msg.value >= _product.price);

		// Require that the product has not been purchased already
		require(!_product.purchased);

		// Require that the buyer is not the seller
		require(_seller != msg.sender);


		// Transfer ownership to the buyer
		// o agorasths einai autos pou kalei thn function purchaseProduct 
		// dhladh o msg.sender
		_product.owner = msg.sender;

		// Mark as purchased
		_product.purchased = true;

		// Update the product in the market
		products[_id] = _product;

		// Pay the seller by sending them Ether
		address(_seller).transfer(msg.value);

		// Trigger an event
		emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
	}
}