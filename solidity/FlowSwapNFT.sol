// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FlowSwapNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FSNT", "MTK") {}

      struct AssetStruct {
        uint256 assetValue;
        uint256 assetNumberShares;
        uint256 assetIncome;
        uint256 assetYield;
        uint256 assetRiskRating;
        string currency;
        uint256 assetNumberSharesSold;
    }

    mapping(bytes32 => AssetStruct) public assets;

    function safeMint(
        address to, 
        string memory uri,
        bytes32 _ipfsAddr,
        uint256 _assetValue,
        uint256 _assetNumberShares,
        uint256 _assetIncome,
        uint256 _assetYield,
        uint256 _assetRiskRating,
        string memory _currency,
        uint256 _assetNumberSharesSold
    )
     public  {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
         assets[_ipfsAddr] = AssetStruct({
            assetValue: _assetValue,
            assetNumberShares: _assetNumberShares,
            assetIncome: _assetIncome,
            assetYield: _assetYield,
            assetRiskRating: _assetRiskRating,
            currency: _currency,
            assetNumberSharesSold: _assetNumberSharesSold
        });
    }

    
    function getAsset(bytes32 _ipfsAddr) public view   returns (
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
            asset.assetValue,
            asset.assetNumberShares,
            asset.assetIncome,
            asset.assetYield,
            asset.assetRiskRating,
            asset.currency,
            asset.assetNumberSharesSold
        );
    }

    function getNumberSharesSold(bytes32 _ipfsAddr) public view   returns (uint256) {
        return assets[_ipfsAddr].assetNumberSharesSold;
    }

    function updateNumberSharesSold(bytes32 _ipfsAddr, uint256 _assetNumberSharesSold) public   {
        require(assets[_ipfsAddr].assetValue > 0, "Asset does not exist");

        assets[_ipfsAddr].assetNumberSharesSold = _assetNumberSharesSold;
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
