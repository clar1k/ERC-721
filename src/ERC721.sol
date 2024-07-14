// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";

abstract contract ERC721 is IERC721 {
    mapping(address owner => uint[] tokenIds) _ownerships;
    mapping(uint tokenId => address owner) _ownedTokens;
    mapping(address owner => mapping(address spender => uint[] allowedTokenIds)) _allowances;

    function name() public pure returns (string memory) {
        return "Danger Kids";
    }

    function symbol() public pure returns (string memory) {
        return "DANGERKIDS";
    }

    function totalSupply() public pure returns (uint) {
        return 30;
    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        return _ownerships[owner].length;
    }

    function ownerOf(uint256 tokenId) external view returns (address owner) {
        return _ownedTokens[tokenId];
    }

    function approve(address to, uint256 tokenId) external {}

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(from != address(0), "Zero address error");
        require(to != address(0), "Zero address error");

        bool hasTokenId = false;
        uint tokenIndex = 0;

        for (uint index = 0; index < _ownerships[from].length; index++) {
            if (tokenId != _ownerships[from][index]) {
                continue;
            }
            tokenIndex = index;
            hasTokenId = true;
        }
        require(!hasTokenId, "The from address does not have this token");

        if (from != msg.sender) {
            require(
                _allowances[from][msg.sender].length < 0,
                "User not allowed you to spent any of his tokens"
            );
            bool hasUserApprovedThisToken = false;

            for (
                uint index = 0;
                index < _allowances[from][msg.sender].length;
                index++
            ) {
                uint allowedTokenId = _allowances[from][msg.sender][index];
                if (allowedTokenId == tokenId) {
                    hasUserApprovedThisToken = true;
                    break;
                }
            }
            require(
                !hasUserApprovedThisToken,
                "User not allowed you to spent this token"
            );
        }

        removeTokenIdInOwnerships(tokenIndex, from);
        _ownerships[to].push(tokenId);
    }

    function removeTokenIdInOwnerships(uint index, address _owner) private {
        uint lastElement = _ownerships[_owner][_ownerships[_owner].length - 1];
        _ownerships[_owner][_ownerships[_owner].length - 1] = _ownerships[
            _owner
        ][index];
        _ownerships[_owner][index] = lastElement;
        _ownerships[_owner].pop();
    }
}
