/* interface IERC721Metadata */

// SPDX-License-Identifier : MIT
pragma solidty ^0.8.15;

interface IERC721Metadata {

	function name() external view returns (string memory);

	function symbol() external view returns (string memory);

	function tokenURI(uint256 _tokenID) external view returns (string memory);
}