// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
 

contract FlowSwap {

    address   usdcAddressAvax = 0x5425890298aed601595a70AB815c96711a31Bc65; // avax testnet
    address payable  usdcAddressPolygon  = payable(0x0FA8781a83E46826621b3BC094Ea2A0212e71B23);
    address payable usdcAddressProxyPolygon = payable(0xfC872E8Dc23fD2fDe20F720077016b9C4B1c8C59);
    address  usdcAddressDERC20 = 0xfe4F5145f6e09952a5ba9e956ED0C25e3Fa4c7F1;
 
    address usdcAddress;

    struct SalesContract {
        address payable seller;
        address  buyer;
        uint256 price;
        uint256 balance;
        uint usdGbpRate; 
    }

    struct SalesContractConditions {
        uint releaseTime;
        uint disputeRelease;
        address notary;
    }

    struct SalesContractAsset {
        uint assetId;
        uint assetNumberSharesSold; 
    }

    struct SalesContractStatus {
        bool dispute;
        bool settled;
        bool sellerConfirmsPayment;
        bool buyerConfirmsPayment;
    }

    mapping(uint => SalesContract) public salesContracts;
    mapping(address => uint[]) public buyerContractNumbers;
    mapping(address => uint[]) public sellerContractNumbers;
    mapping(address => uint[]) public notaryContractNumbers;

    mapping(uint => SalesContractConditions) public salesContractConditions;
    mapping(uint => SalesContractAsset) public salesContractAssets;
    mapping(uint => SalesContractStatus) public salesContractStatuses;


    struct AssetStruct {
        uint256 assetId;
        uint256 assetValue;
        uint256 assetNumberShares;
        uint256 assetIncome;
        uint256 assetYield;
        uint256 assetRiskRating;
        string currency;
        uint256 assetNumberSharesSold;
    }

    mapping(uint256 => AssetStruct) public assets;

    function addAsset(
        uint256 _assetId,
        uint256 _assetValue,
        uint256 _assetNumberShares,
        uint256 _assetIncome,
        uint256 _assetYield,
        uint256 _assetRiskRating,
        string memory _currency,
        uint256 _assetNumberSharesSold
    )   public  returns (bool) {
        require(assets[_assetId].assetId == 0, "Asset ID already exists");

        assets[_assetId] = AssetStruct({
            assetId: _assetId,
            assetValue: _assetValue,
            assetNumberShares: _assetNumberShares,
            assetIncome: _assetIncome,
            assetYield: _assetYield,
            assetRiskRating: _assetRiskRating,
            currency: _currency,
            assetNumberSharesSold: _assetNumberSharesSold
        });
        return true;
    }

    function getAsset(uint256 _assetId)   view public  returns (
        uint256 assetId,
        uint256 assetValue,
        uint256 assetNumberShares,
        uint256 assetIncome,
        uint256 assetYield,
        uint256 assetRiskRating,
        string memory currency,
        uint256 assetNumberSharesSold
    ) {
        AssetStruct storage asset = assets[_assetId];
        return (
            asset.assetId,
            asset.assetValue,
            asset.assetNumberShares,
            asset.assetIncome,
            asset.assetYield,
            asset.assetRiskRating,
            asset.currency,
            asset.assetNumberSharesSold
        );
    }

    function getNumberSharesSold(uint256 _assetId) public  view   returns (uint256) {
        return assets[_assetId].assetNumberSharesSold;
    }
 

function updateNumberSharesSold(uint256 _assetId, uint256 _assetNumberSharesSold) public {
    require(assets[_assetId].assetId > 0, "Asset ID does not exist");
    
    uint256 availableShares = assets[_assetId].assetNumberShares - assets[_assetId].assetNumberSharesSold;
    require(_assetNumberSharesSold <= availableShares, "Number of shares sold exceeds available shares");

    assets[_assetId].assetNumberSharesSold = _assetNumberSharesSold;
}

  //  receive() external payable {}

    constructor()  {
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

struct SalesContractParams {
    uint contractNumber;
    address payable seller;
    address buyer;
    address notary;
    uint releaseTime;
    uint disputeRelease;
    uint256 price;
    uint256 assetId;
    uint256 assetNumberSharesSold;
    uint usdGbpRate;
}


 function approveAndTransferUSDC(SalesContractParams memory params) public returns(bool) {
    uint256 amount = params.price;

    SalesContract memory newSalesContract = SalesContract({
        seller: params.seller,
        buyer: msg.sender,
        price: params.price,
        balance: 0,
        usdGbpRate: params.usdGbpRate
    });

    SalesContractConditions memory newSalesContractConditions = SalesContractConditions({
        releaseTime: params.releaseTime,
        disputeRelease: params.disputeRelease,
        notary: params.notary
    });

    SalesContractAsset memory newSalesContractAsset = SalesContractAsset({
        assetId: params.assetId,
        assetNumberSharesSold: params.assetNumberSharesSold
    });

    SalesContractStatus memory newSalesContractStatus = SalesContractStatus({
        dispute: false,
        settled: false,
        sellerConfirmsPayment: false,
        buyerConfirmsPayment: false
    });

    salesContracts[params.contractNumber] = newSalesContract;
    salesContractConditions[params.contractNumber] = newSalesContractConditions;
    salesContractAssets[params.contractNumber] = newSalesContractAsset;
    salesContractStatuses[params.contractNumber] = newSalesContractStatus;

    buyerContractNumbers[msg.sender].push(params.contractNumber);
    sellerContractNumbers[params.seller].push(params.contractNumber);
    notaryContractNumbers[params.notary].push(params.contractNumber);

    require(IERC20(usdcAddressPolygon).approve(address(this), amount) == true, "approval failed");
    require(IERC20(usdcAddressPolygon).transferFrom(msg.sender, address(this), amount) == true, "transfer failed");
    salesContracts[params.contractNumber].balance = amount;

    return true;
}


/*
    function approveAndTransferUSDC1(      
        uint _contractNumber,
        address payable _seller,
        address _notary,
        uint _releaseTime,
        uint _disputeRelease,
        uint256 _price,
        uint256 _assetId,
        uint256 _assetNumberSharesSold,
        uint256 _usdGbpRate
        ) 
        public returns(bool)  {

        uint256 amount = _price;

        SalesContract memory newSalesContract = SalesContract({
            seller: _seller,
            buyer: msg.sender,
            notary: _notary,
            releaseTime: _releaseTime,
            disputeRelease: _disputeRelease,
            price: _price,
            balance: 0,
            dispute: false,
            settled: false,
            assetId: _assetId,
            assetNumberSharesSold: _assetNumberSharesSold,
            usdGbpRate: _usdGbpRate,
            sellerConfirmsPayment: false,
            buyerConfirmsPayment: false
        });

        salesContracts[_contractNumber] = newSalesContract;
        buyerContractNumbers[msg.sender].push(_contractNumber);
        sellerContractNumbers[_seller].push(_contractNumber);
        notaryContractNumbers[_notary].push(_contractNumber);


     //  IERC20(usdcAddress).approve(address(this), amount);
       // require(IERC20(usdcAddress).allowance(buyer, address(this)) >= amount, "Allowance insufficient");
         
//IERC20(usdcAddress).transfer(address(this), amount);
        //IERC20(usdcAddress).transfer(address(this), amount);
//IERC20(usdcAddress).transfer(seller, 1);
          //  require(IERC20(usdcAddress).approve(address(this), amount) == true, "Approval failed");
        //    require(IERC20(usdcAddress).approve(msg.sender, amount), "Approval failed");
        require(IERC20(usdcAddressPolygon).approve(address(this), amount) == true, "approval failed");
        require(IERC20(usdcAddressPolygon).transferFrom(msg.sender, address(this), amount) == true, "transfer failed");
        salesContracts[_contractNumber].balance = amount;

        return true;
    
    }
    */

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
