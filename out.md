slither ../flowcontract.sol  

Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse = (3 * denominator) ^ 2 (@openzeppelin/contracts/utils/math/Math.sol#117)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#121)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#122)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#123)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#124)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#125)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- denominator = denominator / twos (@openzeppelin/contracts/utils/math/Math.sol#102)
	- inverse *= 2 - denominator * inverse (@openzeppelin/contracts/utils/math/Math.sol#126)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) performs a multiplication on the result of a division:
	- prod0 = prod0 / twos (@openzeppelin/contracts/utils/math/Math.sol#105)
	- result = prod0 * inverse (@openzeppelin/contracts/utils/math/Math.sol#132)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply

Reentrancy in FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string) (../flowcontract.sol#54-121):
	External calls:
	- _safeMint(address(this),tokenId) (../flowcontract.sol#113)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
	- safeTransferFrom(address(this),msg.sender,tokenId) (../flowcontract.sol#119)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
	State variables written after the call(s):
	- safeTransferFrom(address(this),msg.sender,tokenId) (../flowcontract.sol#119)
		- _balances[from] -= 1 (@openzeppelin/contracts/token/ERC721/ERC721.sol#377)
		- _balances[to] += 1 (@openzeppelin/contracts/token/ERC721/ERC721.sol#378)
	ERC721._balances (@openzeppelin/contracts/token/ERC721/ERC721.sol#33) can be used in cross function reentrancies:
	- ERC721._mint(address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#286-308)
	- ERC721._transfer(address,address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#355-385)
	- ERC721.balanceOf(address) (@openzeppelin/contracts/token/ERC721/ERC721.sol#62-65)
	- safeTransferFrom(address(this),msg.sender,tokenId) (../flowcontract.sol#119)
		- _owners[tokenId] = to (@openzeppelin/contracts/token/ERC721/ERC721.sol#380)
	ERC721._owners (@openzeppelin/contracts/token/ERC721/ERC721.sol#30) can be used in cross function reentrancies:
	- ERC721._mint(address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#286-308)
	- ERC721._ownerOf(uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#216-218)
	- ERC721._transfer(address,address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#355-385)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1

ERC721._checkOnERC721Received(address,address,uint256,bytes) (@openzeppelin/contracts/token/ERC721/ERC721.sol#429-451) ignores return value by IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return

Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).retval (@openzeppelin/contracts/token/ERC721/ERC721.sol#436)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (@openzeppelin/contracts/token/ERC721/ERC721.sol#429-451) potentially used before declaration: retval == IERC721Receiver.onERC721Received.selector (@openzeppelin/contracts/token/ERC721/ERC721.sol#437)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (@openzeppelin/contracts/token/ERC721/ERC721.sol#438)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (@openzeppelin/contracts/token/ERC721/ERC721.sol#429-451) potentially used before declaration: reason.length == 0 (@openzeppelin/contracts/token/ERC721/ERC721.sol#439)
Variable 'ERC721._checkOnERC721Received(address,address,uint256,bytes).reason (@openzeppelin/contracts/token/ERC721/ERC721.sol#438)' in ERC721._checkOnERC721Received(address,address,uint256,bytes) (@openzeppelin/contracts/token/ERC721/ERC721.sol#429-451) potentially used before declaration: revert(uint256,uint256)(32 + reason,mload(uint256)(reason)) (@openzeppelin/contracts/token/ERC721/ERC721.sol#444)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#pre-declaration-usage-of-local-variables

Reentrancy in FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string) (../flowcontract.sol#54-121):
	External calls:
	- _safeMint(address(this),tokenId) (../flowcontract.sol#113)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
	State variables written after the call(s):
	- _setTokenURI(tokenId,uri) (../flowcontract.sol#116)
		- _tokenURIs[tokenId] = _tokenURI (@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol#47)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

Reentrancy in FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string) (../flowcontract.sol#54-121):
	External calls:
	- _safeMint(address(this),tokenId) (../flowcontract.sol#113)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
	- safeTransferFrom(address(this),msg.sender,tokenId) (../flowcontract.sol#119)
		- IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) (@openzeppelin/contracts/token/ERC721/ERC721.sol#436-447)
	Event emitted after the call(s):
	- Transfer(from,to,tokenId) (@openzeppelin/contracts/token/ERC721/ERC721.sol#382)
		- safeTransferFrom(address(this),msg.sender,tokenId) (../flowcontract.sol#119)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3

ERC721._checkOnERC721Received(address,address,uint256,bytes) (@openzeppelin/contracts/token/ERC721/ERC721.sol#429-451) uses assembly
	- INLINE ASM (@openzeppelin/contracts/token/ERC721/ERC721.sol#443-445)
Address._revert(bytes,string) (@openzeppelin/contracts/utils/Address.sol#231-243) uses assembly
	- INLINE ASM (@openzeppelin/contracts/utils/Address.sol#236-239)
Strings.toString(uint256) (@openzeppelin/contracts/utils/Strings.sol#18-38) uses assembly
	- INLINE ASM (@openzeppelin/contracts/utils/Strings.sol#24-26)
	- INLINE ASM (@openzeppelin/contracts/utils/Strings.sol#30-32)
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) uses assembly
	- INLINE ASM (@openzeppelin/contracts/utils/math/Math.sol#66-70)
	- INLINE ASM (@openzeppelin/contracts/utils/math/Math.sol#86-93)
	- INLINE ASM (@openzeppelin/contracts/utils/math/Math.sol#100-109)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Different versions of Solidity are used:
	- Version used: ['^0.8.0', '^0.8.1', '^0.8.9']
	- ^0.8.0 (@openzeppelin/contracts/access/Ownable.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/token/ERC721/ERC721.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/token/ERC721/IERC721.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/Context.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/Counters.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/Strings.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/introspection/ERC165.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/introspection/IERC165.sol#4)
	- ^0.8.0 (@openzeppelin/contracts/utils/math/Math.sol#4)
	- ^0.8.1 (@openzeppelin/contracts/utils/Address.sol#4)
	- ^0.8.9 (../flowcontract.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used

Address._revert(bytes,string) (@openzeppelin/contracts/utils/Address.sol#231-243) is never used and should be removed
Address.functionCall(address,bytes) (@openzeppelin/contracts/utils/Address.sol#85-87) is never used and should be removed
Address.functionCall(address,bytes,string) (@openzeppelin/contracts/utils/Address.sol#95-101) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256) (@openzeppelin/contracts/utils/Address.sol#114-120) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256,string) (@openzeppelin/contracts/utils/Address.sol#128-137) is never used and should be removed
Address.functionDelegateCall(address,bytes) (@openzeppelin/contracts/utils/Address.sol#170-172) is never used and should be removed
Address.functionDelegateCall(address,bytes,string) (@openzeppelin/contracts/utils/Address.sol#180-187) is never used and should be removed
Address.functionStaticCall(address,bytes) (@openzeppelin/contracts/utils/Address.sol#145-147) is never used and should be removed
Address.functionStaticCall(address,bytes,string) (@openzeppelin/contracts/utils/Address.sol#155-162) is never used and should be removed
Address.sendValue(address,uint256) (@openzeppelin/contracts/utils/Address.sol#60-65) is never used and should be removed
Address.verifyCallResult(bool,bytes,string) (@openzeppelin/contracts/utils/Address.sol#219-229) is never used and should be removed
Address.verifyCallResultFromTarget(address,bool,bytes,string) (@openzeppelin/contracts/utils/Address.sol#195-211) is never used and should be removed
Context._msgData() (@openzeppelin/contracts/utils/Context.sol#21-23) is never used and should be removed
Counters.decrement(Counters.Counter) (@openzeppelin/contracts/utils/Counters.sol#32-38) is never used and should be removed
Counters.reset(Counters.Counter) (@openzeppelin/contracts/utils/Counters.sol#40-42) is never used and should be removed
ERC721.__unsafe_increaseBalance(address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#503-505) is never used and should be removed
ERC721._burn(uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#321-342) is never used and should be removed
ERC721URIStorage._burn(uint256) (@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol#55-61) is never used and should be removed
FlowSwapNFT._burn(uint256) (../flowcontract.sol#166-168) is never used and should be removed
Math.average(uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#34-37) is never used and should be removed
Math.ceilDiv(uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#45-48) is never used and should be removed
Math.log10(uint256,Math.Rounding) (@openzeppelin/contracts/utils/math/Math.sol#296-301) is never used and should be removed
Math.log2(uint256) (@openzeppelin/contracts/utils/math/Math.sol#205-241) is never used and should be removed
Math.log2(uint256,Math.Rounding) (@openzeppelin/contracts/utils/math/Math.sol#247-252) is never used and should be removed
Math.log256(uint256) (@openzeppelin/contracts/utils/math/Math.sol#309-333) is never used and should be removed
Math.log256(uint256,Math.Rounding) (@openzeppelin/contracts/utils/math/Math.sol#339-344) is never used and should be removed
Math.max(uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#19-21) is never used and should be removed
Math.min(uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#26-28) is never used and should be removed
Math.mulDiv(uint256,uint256,uint256) (@openzeppelin/contracts/utils/math/Math.sol#55-135) is never used and should be removed
Math.mulDiv(uint256,uint256,uint256,Math.Rounding) (@openzeppelin/contracts/utils/math/Math.sol#140-151) is never used and should be removed
Math.sqrt(uint256) (@openzeppelin/contracts/utils/math/Math.sol#158-189) is never used and should be removed
Math.sqrt(uint256,Math.Rounding) (@openzeppelin/contracts/utils/math/Math.sol#194-199) is never used and should be removed
Strings.toHexString(address) (@openzeppelin/contracts/utils/Strings.sol#67-69) is never used and should be removed
Strings.toHexString(uint256) (@openzeppelin/contracts/utils/Strings.sol#43-47) is never used and should be removed
Strings.toHexString(uint256,uint256) (@openzeppelin/contracts/utils/Strings.sol#52-62) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

Pragma version^0.8.9 (../flowcontract.sol#2) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/access/Ownable.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/token/ERC721/ERC721.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/token/ERC721/IERC721.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol#4) allows old versions
Pragma version^0.8.1 (@openzeppelin/contracts/utils/Address.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/Context.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/Counters.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/Strings.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/introspection/ERC165.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/introspection/IERC165.sol#4) allows old versions
Pragma version^0.8.0 (@openzeppelin/contracts/utils/math/Math.sol#4) allows old versions
solc-0.8.9 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in Address.sendValue(address,uint256) (@openzeppelin/contracts/utils/Address.sol#60-65):
	- (success) = recipient.call{value: amount}() (@openzeppelin/contracts/utils/Address.sol#63)
Low level call in Address.functionCallWithValue(address,bytes,uint256,string) (@openzeppelin/contracts/utils/Address.sol#128-137):
	- (success,returndata) = target.call{value: value}(data) (@openzeppelin/contracts/utils/Address.sol#135)
Low level call in Address.functionStaticCall(address,bytes,string) (@openzeppelin/contracts/utils/Address.sol#155-162):
	- (success,returndata) = target.staticcall(data) (@openzeppelin/contracts/utils/Address.sol#160)
Low level call in Address.functionDelegateCall(address,bytes,string) (@openzeppelin/contracts/utils/Address.sol#180-187):
	- (success,returndata) = target.delegatecall(data) (@openzeppelin/contracts/utils/Address.sol#185)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._ipfsAddr (../flowcontract.sol#56) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetValue (../flowcontract.sol#57) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetNumberShares (../flowcontract.sol#58) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetIncome (../flowcontract.sol#59) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetYield (../flowcontract.sol#60) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetRiskRating (../flowcontract.sol#61) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._currency (../flowcontract.sol#62) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._assetNumberSharesSold (../flowcontract.sol#63) is not in mixedCase
Parameter FlowSwapNFT.safeMint(string,bytes32,uint256,uint256,uint256,uint256,uint256,string,uint256,string)._investmentTypeStr (../flowcontract.sol#64) is not in mixedCase
Function FlowSwapNFT.WalletHasAsset(address,bytes32) (../flowcontract.sol#123-131) is not in mixedCase
Parameter FlowSwapNFT.WalletHasAsset(address,bytes32)._ipfsAddr (../flowcontract.sol#123) is not in mixedCase
Parameter FlowSwapNFT.getAsset(bytes32)._ipfsAddr (../flowcontract.sol#139) is not in mixedCase
Function ERC721.__unsafe_increaseBalance(address,uint256) (@openzeppelin/contracts/token/ERC721/ERC721.sol#503-505) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
../flowcontract.sol analyzed (14 contracts with 84 detectors), 87 result(s) found

