# ERC Token Briefcase

---

An ERC-721 NFT that can send and receive ERC-20 and ERC-721 tokens, as well as ETH.

Each `Briefcase` has a dedicated smart contract, meaning no special integration from 3rd party code is needed. Just provide the address and the `Briefcase` can receive tokens.

`BreifcaseManager_full` deployed on Kovan testnet at `0x1f9695c836ec9d12391ed46cf4fc50da664f5dc2`

## BriefcaseManager

The primary ERC-721 contract is called `BriefcaseManager`. This is a fully compliant implementation of the NFT standard. 
`BriefcaseManager_basic` just contains the minimum implementation, `BriefcaseManager_full` includes the `Enumerable` and `Metadata` extensions, but these aren't needed for core functionality. Only included for thoroughness.

There is an additional `mint` function in this contract, for creating new tokens.

The `mint` function deploys a `Briefcase` contract, casts the new contract's `address` as a `uint`, and uses that as the `tokenId` of the newly minted token.
The `mint` function will also return the address of the newly minted `Briefcase`.

For thoroughness there is an added function `addressOf(uint _tokenId) public pure returns(address)`, to return the address of any valid token.

## Briefcase

The Briefcase contracts wrap all ERC-20 and ERC-721 transfer and permission functions, as well as the `send` and `transfer` functions on address types. 

The former are all suffixed with `_ERC20` and `_ERC721` respectively, and the latter two are suffixed with `_ETH`. The wrapped token functions all have an added first parameter, `address _tokenAddress`, which specifies which of the Briefcase's token is being dealt with. 

All functions include an `access` modifier, which piggybacks off the ownership and approval functions in the `BriefcaseManager` contract for execution permissions. If `msg.sender` is owner of, or is approved by owner of this Briefcase (as per 721 standard) is assumed to have permission to move underlying assets.

They pass on any returns from the function they're wrapping.

The aforementioned functions are:

### ERC-20 

`transfer_ERC20(address _tokenAddress, address _to, uint256 _value) public access returns (bool success);`

`transferFrom_ERC20(address _tokenAddress, address _from, address _to, uint256 _value) public access returns (bool success);`

`approve_ERC20(address _tokenAddress,address _spender, uint256 _value) public access returns (bool success);`

`allowance_ERC20(address _tokenAddress, address _owner, address _spender) public access view returns (uint256 remaining);`

### ERC-721

`function safeTransferFrom_ERC721(address _tokenAddress, address _from, address _to, uint256 _tokenId, bytes calldata data) access external;`

`function safeTransferFrom_ERC721(address _tokenAddress, address _from, address _to, uint256 _tokenId) access external;`

`function transferFrom_ERC721(address _tokenAddress,address _from, address _to, uint256 _tokenId) access external;`

`function approve_ERC721(address _tokenAddress,address _approved, uint256 _tokenId) access external;`

`function setApprovalForAll_ERC721(address _tokenAddress,address _operator, bool _approved) external;`

The contract also implements the `onERC721Received` function as defined by the 721 standard in order to receive tokens sent with `safeTransferFrom`. 

### ETH

`function transfer_ETH(address payable _to, uint256 _value) public access;`

`function send_ETH(address payable _to, uint256 _value) public access returns (bool);`

The contract also implements a `receive` function in order to be able to receive ETH.

---

Lastly, for thoroughness, there is a `tokenId()` function which just returns the `tokenId` corresponding to this `Briefcase`. 

