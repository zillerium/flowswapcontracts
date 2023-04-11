// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FlowSwapNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FSNT", "MTK") {
        investmentTypeMap["RealEstate"] = InvestmentType.RealEstate;
        investmentTypeMap["CollectibleCars"] = InvestmentType.CollectibleCars;
        investmentTypeMap["Currency"] = InvestmentType.Currency;
        investmentTypeMap["Stock"] = InvestmentType.Stock;
        investmentTypeMap["Other"] = InvestmentType.Other;
    }

    struct AssetStruct {
        uint256 assetNft;
        uint256 assetValue;
        uint256 assetNumberShares;
        uint256 assetIncome;
        uint256 assetYield;
        uint256 assetRiskRating;
        string currency;
        uint256 assetNumberSharesSold;
        InvestmentType investmentType;
    }

    mapping(address => bool) public walletExists;

        // Mapping of bytes32 to AssetStruct
    mapping(bytes32 => AssetStruct) public assets;

    address[] public wallets;

    // Mapping of address to bytes32
    //mapping(address => bytes32[]) public assetsByOwner;
    mapping(address => bytes32[]) public assetsByOwner;


    enum InvestmentType { RealEstate, CollectibleCars, Currency, Stock, Other }

    mapping(string => InvestmentType) investmentTypeMap;

    function getWallets() public view returns (address[] memory) {
        return wallets;
    }

    function safeMint(
        string memory uri,
        bytes32 _ipfsAddr,
        uint256 _assetValue,
        uint256 _assetNumberShares,
        uint256 _assetIncome,
        uint256 _assetYield,
        uint256 _assetRiskRating,
        string memory _currency,
        uint256 _assetNumberSharesSold,
        string memory _investmentTypeStr
    )
     public  {
        require(
            investmentTypeMap[_investmentTypeStr] != InvestmentType(0),
            "Invalid investment type"
        );

        require(
            assets[_ipfsAddr].assetNft == 0,
            "Asset with this IPFS address already exists"
        );

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
 
 
        InvestmentType investmentType = investmentTypeMap[_investmentTypeStr];

        AssetStruct memory newAsset = AssetStruct({
            assetNft: tokenId,
            assetValue: _assetValue,
            assetNumberShares: _assetNumberShares,
            assetIncome: _assetIncome,
            assetYield: _assetYield,
            assetRiskRating: _assetRiskRating,
            currency: _currency,
            assetNumberSharesSold: _assetNumberSharesSold,
            investmentType: investmentType

        });

        // Store the new asset in the assets mapping
        assets[_ipfsAddr] = newAsset;

        // Store the IPFS address in the assetsByOwner mapping
        if (!WalletHasAsset(msg.sender, _ipfsAddr)) {
            assetsByOwner[msg.sender].push(_ipfsAddr);
        }
        

        if (!walletExists[msg.sender]) {
            wallets.push(msg.sender);
            walletExists[msg.sender] = true;
        }
 
      //  _safeMint(msg.sender, tokenId);
      //  _setTokenURI(tokenId, uri);

        _safeMint(address(this), tokenId);

        // Then, set the token URI
        _setTokenURI(tokenId, uri);

        // Finally, transfer the token to the caller
        safeTransferFrom(address(this), msg.sender, tokenId);

    }

function WalletHasAsset(address wallet, bytes32 _ipfsAddr) private view returns (bool) {
    bytes32[] storage walletAssets = assetsByOwner[wallet];
    for (uint256 i = 0; i < walletAssets.length; i++) {
        if (walletAssets[i] == _ipfsAddr) {
            return true;
        }
    }
    return false;
}

function getAssetsByOwner(address walletAddress) public view returns (bytes32[] memory) {
   
   return assetsByOwner[walletAddress];
     
}
    
    function getAsset(bytes32 _ipfsAddr) public view   returns (
        uint256 assetNft,
        uint256 assetValue,
        uint256 assetNumberShares,
        uint256 assetIncome,
        uint256 assetYield,
        uint256 assetRiskRating,
        string memory currency,
        uint256 assetNumberSharesSold
    ) {
        AssetStruct storage asset = assets[_ipfsAddr];
        return (
            asset.assetNft,
            asset.assetValue,
            asset.assetNumberShares,
            asset.assetIncome,
            asset.assetYield,
            asset.assetRiskRating,
            asset.currency,
            asset.assetNumberSharesSold
        );
    }

 
 
    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
