// SPDX-License-Identifier: MIT

// Amended by HashLips
/**
    !Disclaimer!
    These contracts have been used to create tutorials,
    and was created for the purpose to teach people
    how to create smart contracts on the blockchain.
    please review this code on your own before using any of
    the following code for production.
    HashLips will not be liable in any way if for the use 
    of the code. That being said, the code has been tested 
    to the best of the developers' knowledge to work as intended.
*/

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract OnChainNft is ERC721Enumerable, Ownable {
  using Strings for uint256;

  constructor() ERC721("On Chain NFT", "OCN") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 1000);

    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    }
    // supply+1 is the tokenId
    _safeMint(msg.sender, supply + 1);
  }

  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

  function buildImage(uint256 _tokenId) public pure returns(string memory){
      return Base64.encode(bytes(string(abi.encodePacked(
       '<svg height="30" width="200" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><text x="0" y="15" fill="red">',
       uint2str(_tokenId),
       '</text></svg>'
      ))));

  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    string memory _uri = buildImage(tokenId);
    return string(abi.encodePacked(
        'data:application/json;base64,',
        Base64.encode(bytes(abi.encodePacked(
            '{"name":"',
            "REPLACE",
            '", "description":"',
            "My first on chain nft",
            '", "image": "',
            'data:image/svg+xml;base64,',
            _uri,
            '"}'
        )))
    ));
      
  }

 
  function withdraw() public payable onlyOwner {
    
    // This will payout the owner 95% of the contract balance.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}