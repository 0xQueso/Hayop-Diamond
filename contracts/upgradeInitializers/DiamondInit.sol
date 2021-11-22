// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibDiamond} from "../libraries/LibDiamond.sol";
import { IDiamondLoupe } from "../interfaces/IDiamondLoupe.sol";
import { IDiamondCut } from "../interfaces/IDiamondCut.sol";
import { IERC173 } from "../interfaces/IERC173.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { AppStorage} from "../libraries/LibAppStorage.sol";
import {LibMeta} from "..//libraries/LibMeta.sol";

// It is exapected that this contract is customized if you want to deploy your diamond
// with data from a deployment script. Use the init function to initialize state variables
// of your diamond. Add parameters to the init funciton if you need to.

contract DiamondInit {
    AppStorage internal s;
    // You can add parameters to this function in order to pass in
    // data to set your own state variables
    function init() external {
        s.domainSeparator = LibMeta.domainSeparator("HayopDiamond", "V1");
        s.baseUrl = 'https://gateway.pinata.cloud/ipfs/QmUDu47GBYfbb1F8Q2WG7XkQ8w4rcvHbcA4oeALoKVrCtw/';
        s.hayopBase.eyeColor = [
        '#FBF46D',
        '#B4FE98',
        '#77E4D4',
        '#998CEB',
        '#FF5403',
        '#DDDDDD'
        ];

        s.hayopBase.faceColor = [
        '#52006A',
        '#EEB76B',
        '#301B3F',
        '#864000',
        '#272121',
        '#3D0000'
        ];

        s.hayopBase.bgColor = [
        '#E5DCC3',
        '#6D9886',
        '#FBF4E9',
        '#FF616D',
        '#CA8A8B',
        '#289672'
        ];

        // adding ERC165 data
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;

        // add your own state variables 
        // EIP-2535 specifies that the `diamondCut` function takes two optional 
        // arguments: address _init and bytes calldata _calldata
        // These arguments are used to execute an arbitrary function using delegatecall
        // in order to set state variables in the diamond during deployment or an upgrade
        // More info here: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface 
    }


}