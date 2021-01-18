//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.1;

interface ERC721{
    function ownerOf(uint256 _tokenId) external view returns (address);
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external ;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external ;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approved, uint256 _tokenId) external ;
    function setApprovalForAll(address _operator, bool _approved) external;
}