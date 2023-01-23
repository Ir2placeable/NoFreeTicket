/* contract ERC721 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './IERC721.sol';
import './IERC721Metadata.sol';

contract ERC721 is IERC721, IERC721Metadata {

	string public override name;
	string public override symbol;
    string public override location;
	
    // _balances : 누가 -> 몇 개의 토큰을 소유했는지
	mapping(address => uint) private _balances;
    // _owners : 토큰ID -> 누구 소유인지
	mapping(uint => address) private _owners;
    // _schedules : 토큰ID -> 예약 시간이 언제인지
    mapping(uint => uint) private _schedules;
    // _tokenApprovals -> 토큰ID -> 대리인이 누구인지
	mapping(uint => address) private _tokenApprovals;

	// mapping(address => mapping(address => bool)) private _operatorApprovals;

	constructor(string memory _name, string memory _symbol, string memory _location) {
		name = _name;
		symbol = _symbol;
        location = _location;
	}

	/* Functions */
	function balanceOf(address _owner) public override view returns (uint) {
		require(_owner != address(0), "ERC721 : balance query for the zero address");
		
		return _balances[_owner];
	}

	function ownerOf(uint _tokenId) public override view returns (address) {
		address owner = _owners[_tokenId];
		require(owner != address(0), "ERC721 : owner query for the nonexistent token");
		
		return _owners[_tokenId];
	}

    // customed function
    function scheduleOf(uint _tokenId) public override view returns (uint) {
        // _schedules 는 uint => uint 이지만, require 조건을 만족하는 문법을 만들 수 없음.
        // 따라서 _owner의 존재 여부로 대신 확인한다.
        address owner = _owners[_tokenId];
        require(owner != address(0), "Error : nonexistent token");

        return _schedules[_tokenId];
    }

	function approve(address _to, uint _tokenId) external override {
		address owner = _owners[_tokenId];
		require(_to != owner, "ERC721 : approval to current owner");
        require(msg.sender == owner);
		// require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
	
		_tokenApprovals[_tokenId] = _to;
		emit Approval(owner, _to, _tokenId);
	}

	function getApproved(uint  _tokenId) public override view returns (address) {
		require(_owners[_tokenId] != address(0));
		
		return _tokenApprovals[_tokenId];
	}

	// function setApprovalForAll(address _operator, bool _approved) external override {
	// 	require(msg.sender != _operator);
	// 	_operatorApprovals[msg.sender][_operator] = _approved;
		
	// 	emit ApprovalForAll(msg.sender, _operator, _approved);
	// }

	// function isApprovedForAll(address _owner, address _operator) public override view returns (bool) {
	// 	return _operatorApprovals[_owner][_operator];
	// }

	function _isApprovedOrOwner(address _spender, uint _tokenId) private view returns (bool) {
		address owner = _owners[_tokenId];
		require(owner != address(0));

        return (_spender == owner || getApproved(_tokenId) == _spender);
		// return (_spender == owner || isApprovedForAll(owner, _spender) || getApproved(_tokenId) == _spender);
	}

	function transferFrom(address _from, address _to, uint _tokenId) external override {
		require(_isApprovedOrOwner(_from, _tokenId));
		require(_from != _to);

		_beforeTokenTransfer(_from, _to, _tokenId);
	
		_balances[_from] -= 1;
		_balances[_to] += 1;
		_owners[_tokenId] = _to;

		emit Transfer(_from, _to, _tokenId);
	}

	// function tokenURI(uint256 _tokenId) external override virtual view returns (string memory) {}

	function _mint(address _to, uint _tokenId, uint _schedule) public {
		require(_to != address(0), "Error : address of _to is null");
		address owner = _owners[_tokenId];
		require(owner == address(0), "Error : address of owner is null");
        require(_schedule > block.timestamp, "Error : schedule should not set in past");

		_beforeTokenTransfer(address(0), _to, _tokenId);

		_balances[_to] += 1;
		_owners[_tokenId] = _to;
        _schedules[_tokenId] = _schedule;

		emit Transfer(address(0), _to, _tokenId);
	}

	function _beforeTokenTransfer(address _from, address _to, uint _token) internal virtual {}

}

