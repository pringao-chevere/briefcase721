//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.1;

import "Briefcase.sol";

contract BriefcaseManager {


    constructor(){
        supportedInterfaces[0x80ac58cd] = true;
        supportedInterfaces[0x5b5e139f] = true;
        supportedInterfaces[0x01ffc9a7] = true;
    }


    //////===721 Standard
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    //////===721 Implementation
    mapping(address => uint256) internal BALANCES;
    mapping (uint256 => address) internal ALLOWANCE;
    mapping (address => mapping (address => bool)) internal AUTHORISED;

    mapping(uint256 => address) OWNERS;  //Mapping of token owners


    function isValidToken(uint256 _tokenId) internal view returns(bool){
        return OWNERS[_tokenId] != address(0);
    }

    function balanceOf(address _owner) external view returns (uint256){
        return BALANCES[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns(address){
        require(isValidToken(_tokenId),"invalid");
        return OWNERS[_tokenId];
    }



    function mint() external returns(address) {
        Briefcase briefcase = new Briefcase(address(this));


        uint tokenId = uint(address(briefcase));


        OWNERS[tokenId] = msg.sender;
        BALANCES[msg.sender]++;

        emit Transfer(address(0),msg.sender,tokenId);
        return address(briefcase);
    }
    function addressOf(uint _tokenId) public view returns(address){
        require(isValidToken(_tokenId),"invalid");
        return address(_tokenId);
    }

    function approve(address _approved, uint256 _tokenId)  external{
        address owner = ownerOf(_tokenId);
        require( owner == msg.sender                    //Require Sender Owns Token
            || AUTHORISED[owner][msg.sender]                //  or is approved for all.
        ,"permission");
        emit Approval(owner, _approved, _tokenId);
        ALLOWANCE[_tokenId] = _approved;
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(isValidToken(_tokenId),"invalid");
        return ALLOWANCE[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return AUTHORISED[_owner][_operator];
    }


    function setApprovalForAll(address _operator, bool _approved) external {
        emit ApprovalForAll(msg.sender,_operator, _approved);
        AUTHORISED[msg.sender][_operator] = _approved;
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) public {

        //Check Transferable
        //There is a token validity check in ownerOf
        address owner = ownerOf(_tokenId);

        require ( owner == msg.sender             //Require sender owns token
        //Doing the two below manually instead of referring to the external methods saves gas
        || ALLOWANCE[_tokenId] == msg.sender      //or is approved for this token
            || AUTHORISED[owner][msg.sender]          //or is approved for all
        ,"permission");
        require(owner == _from,"owner");
        require(_to != address(0),"zero");
        //require(isValidToken(_tokenId)); <-- done by ownerOf

        emit Transfer(_from, _to, _tokenId);


        OWNERS[_tokenId] =_to;

        BALANCES[_from]--;
        BALANCES[_to]++;

        //Reset approved if there is one
        if(ALLOWANCE[_tokenId] != address(0)){
            delete ALLOWANCE[_tokenId];
        }

    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
        transferFrom(_from, _to, _tokenId);

        //Get size of "_to" address, if 0 it's a wallet
        uint32 size;
        assembly {
            size := extcodesize(_to)
        }
        if(size > 0){
            ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
            require(receiver.onERC721Received(msg.sender,_from,_tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),"receiver");
        }

    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
        safeTransferFrom(_from,_to,_tokenId,"");
    }

    // End 721 Implementation

    ///////===165 Implementation
    mapping (bytes4 => bool) internal supportedInterfaces;
    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return supportedInterfaces[interfaceID];
    }
    ///==End 165
}