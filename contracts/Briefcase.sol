//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.1;

import "./interface_ERC721TokenReceiver.sol";
import "./interface_partial_ERC721.sol";
import "./interface_partial_ERC20.sol";

contract Briefcase is ERC721TokenReceiver{
    ERC721 parent;

    modifier access(){
        uint _tokenId = uint(address(this));
        address owner = parent.ownerOf(_tokenId);
        require(
            owner == msg.sender ||
            parent.getApproved(_tokenId) == msg.sender ||
            parent.isApprovedForAll(owner,msg.sender),
            'access'
        );
        _;
    }

    constructor(address _parent){
        parent = ERC721(_parent);
    }

    receive() external payable {}

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) override external pure returns(bytes4){
        _operator;_from;_tokenId;_data;
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }


    function tokenId() public view returns(uint){
        return uint(address(this));
    }

    function transfer_ETH(address payable _to, uint256 _value) public access{
        _to.transfer(_value);
    }
    function send_ETH(address payable _to, uint256 _value) public access returns (bool){
        return _to.send(_value);
    }

    function transfer_ERC20(address _tokenAddress, address _to, uint256 _value) public access returns (bool success){
        return ERC20(_tokenAddress).transfer(_to,_value);
    }
    function transferFrom_ERC20(address _tokenAddress, address _from, address _to, uint256 _value) public access returns (bool success){
        return ERC20(_tokenAddress).transferFrom(_from, _to, _value);
    }
    function approve_ERC20(address _tokenAddress,address _spender, uint256 _value) public access returns (bool success){
        return ERC20(_tokenAddress).approve(_spender, _value);
    }
    function allowance_ERC20(address _tokenAddress, address _owner, address _spender) public access view returns (uint256 remaining){
        return ERC20(_tokenAddress).allowance(_owner, _spender);
    }

    function safeTransferFrom_ERC721(address _tokenAddress, address _from, address _to, uint256 _tokenId, bytes calldata data) access external{
        ERC721(_tokenAddress).safeTransferFrom(_from, _to, _tokenId, data);
    }
    function safeTransferFrom_ERC721(address _tokenAddress, address _from, address _to, uint256 _tokenId) access external{
        ERC721(_tokenAddress).safeTransferFrom(_from, _to, _tokenId);
    }
    function transferFrom_ERC721(address _tokenAddress,address _from, address _to, uint256 _tokenId) access external{
        ERC721(_tokenAddress).transferFrom(_from, _to, _tokenId);
    }
    function approve_ERC721(address _tokenAddress,address _approved, uint256 _tokenId) access external {
        ERC721(_tokenAddress).approve(_approved, _tokenId);
    }
    function setApprovalForAll_ERC721(address _tokenAddress,address _operator, bool _approved) external{
        ERC721(_tokenAddress).setApprovalForAll(_operator, _approved);
    }
}
