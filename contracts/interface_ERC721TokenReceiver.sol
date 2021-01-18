//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.1;

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}