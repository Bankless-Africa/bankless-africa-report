// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


pragma solidity >=0.7.0 <0.9.0;


contract test is ERC721Enumerable, Ownable {

  using Strings for uint256;
  string baseURI;
  uint256 public cost  = 1000 ether;
  uint256 public maxSupply = 1000;
  uint256 public maxMintAmount = 20;
  bool public paused = false;

IERC20 public bankToken;

  address payable eg = payable(0x88882e661ed8CB398b21F1Cf13651Bd8b47A0588);
  address payable rg = payable(0x3628F8A41eE5112931fBA446610aEaD236Cd2AA3);
  address payable ba = payable(0x7a80F90931DD10CC4697dDb635FCC873f6Ac639d);
  address payable wg = payable(0xe7636c7ef670a3Bcf772D9d57244c9e88aD90437);
  address payable bd = payable(0xf26d1Bb347a59F6C283C53156519cC1B1ABacA51);



  constructor(
    address _bankToken,
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI
  ) ERC721(_name, _symbol) {
    bankToken = IERC20(_bankToken);  
    setBaseURI(_initBaseURI);
  }
  

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }


  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);

    for (uint256 i = 1; i <= _mintAmount; i++) {
        bankToken.transferFrom(msg.sender, address(eg), cost * 10 / 100);
        bankToken.transferFrom(msg.sender, address(bd), cost * 10 / 100);
        bankToken.transferFrom(msg.sender, address(rg), cost * 20 / 100);
        bankToken.transferFrom(msg.sender, address(wg), cost * 20 / 100);
        bankToken.transferFrom(msg.sender, address(ba), cost * 40 / 100);
        _safeMint(msg.sender, supply + i);
    }
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

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI))
        : "";
  }

  //only owner



  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success);
  }
}
