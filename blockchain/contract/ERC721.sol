/* contract ERC721 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './IERC721.sol';
import './IERC721Metadata.sol';

contract ERC721 is IERC721, IERC721Metadata {

	string public override name;
	string public override symbol;
	
	mapping(address => uint) private _balances;
	mapping(uint => address) private _owners;
	mapping(uint => address) private _tokenApprovals;
	mapping(address => mapping(address => bool)) private _opertorApprovals;

	constructor(string memory _name, string memory _symbol) {
		name = _name;
		symbol = _symbol;
	}

	/* Functions */
	function balanceOf(address _owner) public override view returns (uint) {
		require(_owner != address(0), "ERC721 : balance query for the zero address");
		
		return _balances[_owner];
	}

	function ownerOf(uint _tokenId) public override view returns (address) {
		address owner = _owners[tokenId];
		require(owner != address(0), "ERC721 : owner query for the nonexistent token");
		
		return _owners[_tokenId];
	}

	function approve(address _to, uint _tokenId) external override {
		address owner = _owners[_tokenId];
		require(_to != owner, "ERC721 : approval to current owner");
		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
	
		_tokenApprovals[_tokenId] = _to;
		emit Approval(owner, _to, _tokenId);
	}

	function getApproved(uint  _tokenId) public override view returns (address) {
		require(_owners[_tokenId] != address(0));
		
		return _tokenApprovals[_tokenId];
	}

	function setApprovalForAll(address _operator, bool _approved) external override {
		require(msg.sender != _operator);
		_operatorApprovals[msg.sender][_operator] = _approved;
		
		emit ApprovalForAll(msg.sender, _operator, _approved);
	}

	function isApprovedForAll(address _owner, address _operator) public override view returns (bool) {
		return _operatorApprovals[_owner][_opertor];
	}

	function _isApprovedOrOwner(address _spender, uint _tokenId) private view returns (bool) {
		address owner = _owners[_tokenId];
		require(owner != address(0));

		return (_spender == owner || isApprovedForAll(owner, _spender) || getApproved(_tokenId) == _spender);
	}

	function transferFrom(address _from, address _to, uint _tokenId) external override {
		require(_isApprovedOrOwner(_from, _tokenId));
		require(_from != _to)

		_beforeTokenTransfer(_from, _to, _tokenId);
	
		_balances[_from] -= 1;
		_balances[_to] += 1;
		_owners[_tokenId] = _to;

		emit Transfer(_from, _to, _tokenId);
	}

	function tokenURI(uint256 _tokenId) external override virtual view returns (string memory) {}

	function _mint(address _to, uint _tokenId) public {
		require(_to != address(0));
		address owner = _owners[_tokenId];
		require(owner == address(0));

		_beforeTokenTransfer(address(0), _to, _tokenId);

		_balances[_to] += 1;
		_owners[_tokenId] = _to;

		emit Transfer(address(0), _to, _tokenId);
	}

	function _beforeTokenTransfer(address _from, address _to, uint _token) internal virtual {}

}
