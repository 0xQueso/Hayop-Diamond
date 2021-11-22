// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import { LibDiamond } from "./LibDiamond.sol";

struct Hayop {
    address owner;
}

struct HayopSvg {
    string head;
    string[] eyeColor;
    string[] faceColor;
    string[] bgColor;
}

struct AppStorage {
    bytes32 domainSeparator;
    mapping(address => uint256) hayopBalance;
    mapping(uint256 => Hayop) hayops;
    mapping(address => mapping(address => bool)) operators;
    mapping(uint256 => address) approved;
    Counters.Counter counter;
    uint256[] tokenIds;
    mapping(uint256 => uint256) tokenIdIndexes;
    mapping(uint256 => HayopSvg) hayopSvg;
    HayopSvg hayopBase;
    string baseUrl;
}


contract Modifiers {
    AppStorage internal s;

    modifier onlyOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }
}