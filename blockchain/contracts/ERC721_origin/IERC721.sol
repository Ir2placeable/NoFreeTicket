/* interface IERC721 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IERC721 {

	/* Events */
	event Transfer(address indexed _from, address indexed _to, uint indexed _tokenId);
	event Approval(address indexed _from ,address indexed _approved, uint indexed _tokenId);
	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
	
	/* Functions */
	function balanceOf(address _owner) external view returns (uint);
	function ownerOf(uint _tokenId) external view returns (address);
	function transferFrom(address _from, address _to, uint _tokenId) external;
	function approve(address _to, uint _tokenId) external;
	function getApproved(uint _tokenId) external view returns (address);
	function setApprovalForAll(address _operator, bool _approved) external;
	function isApprovedForAll(address _owner, address _operator) external view returns (bool);

}
