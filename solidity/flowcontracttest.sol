// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
 

contract FlowSwap {

    address   usdcAddressAvax = 0x5425890298aed601595a70AB815c96711a31Bc65; // avax testnet
    address payable  usdcAddressPolygon  = payable(0x0FA8781a83E46826621b3BC094Ea2A0212e71B23);
    address payable usdcAddressProxyPolygon = payable(0xfC872E8Dc23fD2fDe20F720077016b9C4B1c8C59);
    address  usdcAddressDERC20 = 0xfe4F5145f6e09952a5ba9e956ED0C25e3Fa4c7F1;
 
    address public usdcAddress;
    uint256 public salesContractNumber;

    struct SalesContract {
        address payable seller;
        address  buyer;
        uint256 price;
        uint256 balance;
        uint usdGbpRate; 
        uint assetNumberSharesSold; 
        bytes32 assetIpfs;

    }

    struct SalesContractConditions {
        uint releaseTime;
        uint disputeRelease;
        address notary;
    }

    struct SalesContractStatus {
        bool dispute;
        bool settled;
        bool sellerConfirmsPayment;
        bool buyerConfirmsPayment;
    }
// sales contract number for investment map to sales 
 
    mapping(uint256 => SalesContract) public salesContracts;
    mapping(uint256 => SalesContractConditions) public salesContractConditions;
    mapping(uint256 => SalesContractStatus) public salesContractStatuses;

// wallet address
    mapping(address => uint256[]) public buyerContractNumbers;
    mapping(address => uint256[]) public sellerContractNumbers;
    mapping(address => uint256[]) public notaryContractNumbers;

 
//map ipfs addr to asset
 
     

    function getNumberSharesSold(uint _contractNumber) public  view   returns (uint256) {
        return salesContracts[_contractNumber].assetNumberSharesSold;
    }
 

function updateNumberSharesSold(uint _contractNumber, uint256 _assetNumberSharesSold) public {
    require(salesContracts[_contractNumber].assetNumberSharesSold > 0, "Asset ID does not exist");
    // possible error - too many shares are sold
    // needs check in the dapp
    uint256 soldShares = _assetNumberSharesSold + salesContracts[_contractNumber].assetNumberSharesSold;
   // require(_assetNumberSharesSold <= availableShares, "Number of shares sold exceeds available shares");

    salesContracts[_contractNumber].assetNumberSharesSold = soldShares;
}

  //  receive() external payable {}

    constructor()  {
        salesContractNumber=0;
    }


     function approveContractTransfer(uint256 _value1) 
        public  {
        uint256 amount = _value1;
       IERC20(usdcAddressPolygon).approve(address(this), amount);
       //  _approve(msg.sender, spender, amount);
      //  IERC20(usdcAddress).approve(msg.sender, amount);
    }

    function checkAllowance() public view returns (uint256, uint256, address, address) {
      //  return IERC20(usdcAddress).allowance(address(this), msg.sender);
      uint256 a = IERC20(usdcAddressPolygon).allowance(msg.sender, address(this));
            uint256 a1 = IERC20(usdcAddressPolygon).allowance(address(this), msg.sender);
    //   uint a2= IERC20(usdcAddressPolygon).allowance(buyer, address(this));
     //    uint a3= IERC20(usdcAddressPolygon).allowance( address(this), seller);
       return (a,a1, msg.sender, address(this) );
    }

    function getBuyerContractsByAddress(address _address) public view returns (uint[] memory) {
        return buyerContractNumbers[_address];
    }

    function getSellerContractsByAddress(address _address) public view returns (uint[] memory) {
        return sellerContractNumbers[_address];
    }

    function getNotaryContractsByAddress(address _address) public view returns (uint[] memory) {
        return notaryContractNumbers[_address];
    }
// this approves and pays into the contract
// the allowance needs to be done for the contract first - this can be done manually using 
// the contract functions at etherscan

 


 function approveAndTransferUSDC(
    address payable seller,
    address buyer,
    address notary,
    uint releaseTime,
    uint disputeRelease,
    uint256 price,
    bytes32 assetIpfs,
    uint256 assetNumberSharesSold,
    uint usdGbpRate
     //SalesContractParams memory params
 
 
 ) public returns(bool) {
    require(msg.sender == buyer, "Only the buyer can call this function");

    salesContractNumber = salesContractNumber+1;
    uint256 amount = price;

    SalesContract memory newSalesContract = SalesContract({
        seller: seller,
        buyer: msg.sender,
        price: price,
        balance: 0,
        usdGbpRate: usdGbpRate,
        assetIpfs: assetIpfs,
        assetNumberSharesSold: assetNumberSharesSold

    });

    SalesContractConditions memory newSalesContractConditions = SalesContractConditions({
        releaseTime: releaseTime,
        disputeRelease: disputeRelease,
        notary: notary
    });

    SalesContractStatus memory newSalesContractStatus = SalesContractStatus({
        dispute: false,
        settled: false,
        sellerConfirmsPayment: false,
        buyerConfirmsPayment: false
    });

    salesContracts[salesContractNumber] = newSalesContract;
    salesContractConditions[salesContractNumber] = newSalesContractConditions;
    salesContractStatuses[salesContractNumber] = newSalesContractStatus;

    buyerContractNumbers[msg.sender].push(salesContractNumber);
    sellerContractNumbers[seller].push(salesContractNumber);
    notaryContractNumbers[notary].push(salesContractNumber);

    require(IERC20(usdcAddressPolygon).approve(address(this), amount) == true, "approval failed");
    require(IERC20(usdcAddressPolygon).transferFrom(msg.sender, address(this), amount) == true, "transfer failed");
    salesContracts[salesContractNumber].balance = amount;

    return true;
}

 

function payContract(uint256 _amount) public returns(bool) {
      require(IERC20(usdcAddressPolygon).approve(address(this), _amount) == true, "approval failed");
        require(IERC20(usdcAddressPolygon).transferFrom(msg.sender, address(this), _amount) == true, "transfer failed");
      return true;
}
    // Buyer disputes the contract payment before the sale release date
    function raiseDispute() public  {
     //   require(tx.origin == buyer);
     //   require(block.timestamp <= saleRelease);
     //   dispute=true;
    }

    // Buyer can settle anytime to the Seller
    function settlement() public  {
     //   require(tx.origin == buyer);
    //    uint256 amount = address(this).balance;
     //   seller.transfer(amount);
         
    }

   function getBuyerUsdcBalance() public pure returns (uint256, uint256, uint256) {
     //   require(tx.origin == buyer);
     //   uint256 amount = IERC20(usdcAddressPolygon).balanceOf(buyer);
     //           uint256 amount1 = IERC20(usdcAddressPolygon).balanceOf(seller);
     //           uint256 amount2 = IERC20(usdcAddressPolygon).balanceOf(msg.sender);
       // return (amount, amount1, amount2);
       return (0,0,0);
         
    }

   function getContractUsdcBalance() public view returns (uint256) {
        //require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
        uint256 amount = IERC20(usdcAddressPolygon).balanceOf(address(this));
        return amount;
         
    }
    function settlementUsdc(uint contractNumber) public returns(bool) {
        require(tx.origin == salesContracts[contractNumber].buyer);
        require(salesContractStatuses[contractNumber].dispute == false, "cannot pay due to dispute");
      //  uint256 amount = IERC20(usdcAddressPolygon).balanceOf(address(this));
        //IERC20(usdcAddressPolygon).transfer(seller, amount);
        require(IERC20(usdcAddressPolygon).transferFrom(
            address(this), 
            salesContracts[contractNumber].seller,
            salesContracts[contractNumber].price)==true, "transfer failed");
            salesContractStatuses[contractNumber].settled = true;
        //    salesContracts[contractNumber].sellerConfirmsPayment = true;
        //    salesContracts[contractNumber].buyerConfirmsPayment = true;
            salesContracts[contractNumber].balance = 0;
            return true;


    }

    function claimUsdc(uint contractNumber) public returns(bool) {
        require(tx.origin == salesContracts[contractNumber].seller);
        require(salesContractStatuses[contractNumber].dispute == false, "cannot claim due to dispute");
        require(block.timestamp >= salesContractConditions[contractNumber].releaseTime, "too early to claim");
      //  uint256 amount = IERC20(usdcAddressPolygon).balanceOf(address(this));
        //IERC20(usdcAddressPolygon).transfer(seller, amount);
        require(IERC20(usdcAddressPolygon).transferFrom(
            address(this), 
            salesContracts[contractNumber].seller,
            salesContracts[contractNumber].price)==true, "transfer failed");
            salesContractStatuses[contractNumber].settled = true;
            salesContracts[contractNumber].balance = 0;
            return true;


    }

    function getSenderBalance() public view returns (uint256) {
        return msg.sender.balance;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // the notary can decide to pay the seller or buyer based on a decision 
    function disputeSettlement(bool paySeller) public  {
   /*     require(tx.origin == notary);
        require(dispute == true);
        require(block.timestamp <= disputeRelease);
        uint256 amount = address(this).balance;
        if (paySeller) {
            seller.transfer(amount);
        } else {
            buyer.transfer(amount);
        }
        */
    }

    // when no dispute is raised, the seller can get the funds after the sale release time
    function saleSettlement() public  {
       /* require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
        require(block.timestamp >= saleRelease && dispute == false);
        uint256 amount = address(this).balance;
        seller.transfer(amount);
        */
    }

    // after the dispute release time (regardless of if a dispute is raised or not),
    // the seller is entitled to the funds
    function defaultDisputeSettlement() public  {
    //    require(tx.origin == notary || tx.origin == seller || tx.origin == buyer);
    //    require((block.timestamp >= disputeRelease));
    //    uint256 amount = address(this).balance;
    //    seller.transfer(amount);
    }

 

 
  //  fallback() external payable {
   //     revert();
  //  }

     
 
}
