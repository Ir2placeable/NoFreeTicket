/* test contract v1.0 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
	
    // allTokens : 몇 번째로 발급된 NFT 인지 저장하는 공간
	uint[] private _allTokens;
    	
    // 어떤 계정이 몇번째 NFT를 
	mapping(address => mapping(uint => uint)) private _ownedTokens;
	mapping(uint => uint) private _ownedTokensIndex;

	constructor(string memory _name, string memory _symbol, string memory _location) ERC721(_name, _symbol, _location) {}

	function mint(address _to, uint _schedule) public {
		_mint(_to, _allTokens.length, _schedule);
	}

	function _beforeTokenTransfer(address _from, address _to, uint _tokenId) internal override {
		if (_from == address(0)) {
			_allTokens.push(_allTokens.length);
		}
		else {
			uint latestTokenIndex = ERC721.balanceOf(_from) - 1;
			uint tokenIndex = _ownedTokensIndex[_tokenId];

			if (tokenIndex != latestTokenIndex) {
				uint latestTokenId = _ownedTokens[_from][latestTokenIndex];
		
				_ownedTokens[_from][tokenIndex] = latestTokenId;
				_ownedTokensIndex[latestTokenId] = tokenIndex;
			}
			
			delete _ownedTokens[_from][latestTokenIndex];
			delete _ownedTokensIndex[_tokenId];
		}

		uint length = ERC721.balanceOf(_to);
		_ownedTokens[_to][length] = _tokenId;
		_ownedTokensIndex[_tokenId] = length;
	}

	function totalSupply() public view returns (uint) {
		return _allTokens.length;
	}

	function tokenByIndex(uint _index) public view returns (uint) {
		require(_index < _allTokens.length);
		
		return _allTokens[_index];
	}

	function tokenOfOwnerByIndex(address _owner, uint _index) public view returns (uint) {
		require(_index < balanceOf(_owner));
		
		return _ownedTokens[_owner][_index];
	}
}
