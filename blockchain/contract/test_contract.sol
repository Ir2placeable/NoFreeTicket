// SPDX-License-Identifier: UNLICENSED
//
pragma solidity ^0.8.13;

contract test {
    uint number;

    constructor() {
        number = 0;
    }

    function addNumber(uint _add) public {
        number = number + _add;
    }

    function getNumber() public view returns (uint) {
        return number;
    }
}
