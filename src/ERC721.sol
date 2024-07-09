// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";

abstract contract ERC721 is IERC721 {
    mapping(address owner => uint[] tokenIds) _ownerShips;
    mapping(address owner => mapping(address spender => uint[] tokenIds)) _allowances;

    function name() public pure returns (string memory) {
        return "Danger Kids";
    }

    function symbol() public pure returns (string memory) {
        return "DANGERKIDS";
    }

    function totalSupply() public pure returns (uint) {
        return 30;
    }

    function approve(address to, uint256 tokenId) external {}
}
