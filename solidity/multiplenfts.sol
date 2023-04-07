pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 public lastTokenId;

    constructor() ERC721("MyNFT", "NFT") {}

    function mintBatch(address to) public {
        for (uint256 i = 0; i < 3; i++) {
            lastTokenId++;
            _safeMint(to, lastTokenId);
        }
    }
}
In this example, the mintBatch function mints three NFTs with sequential IDs and assigns them to the specified to address. The lastTokenId variable keeps track of the ID of the last NFT minted, so that new NFTs can be assigned unique IDs.

You can then call this function from a web3-enabled client, such as Remix or Truffle, by specifying the address of the contract and the mintBatch function, and passing in the recipient address as a parameter.

Note that if you are minting a large number of NFTs in a single transaction, you may need to increase the gas limit to ensure that the transaction is processed successfully.





