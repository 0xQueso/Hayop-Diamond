// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Modifiers, AppStorage} from "../libraries/LibAppStorage.sol";
import {LibERC721} from "../libraries/LibERC721.sol";
import {LibStrings} from "../libraries/LibStrings.sol";
import {LibBase64} from "../libraries/LibBase64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

contract HayopFactoryFacet is Modifiers {
    using Counters for Counters.Counter;

    string constant baseSvg = '<svg xmlns="http://www.w3.org/2000/svg" width="350" height="350" viewBox="0 0 1348.2 1080">';

    function bgColor(uint256 tokenId) public view virtual returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(LibStrings.strWithUint("BackgroundColor", tokenId))));
        rand = rand % s.hayopBase.bgColor.length;
        string memory bgSvg = '<rect width="100%" height="100%" ';
        string memory bgColorSvg = string(abi.encodePacked('fill="', string (s.hayopBase.bgColor[rand]),'" />'));
        return string (abi.encodePacked(bgSvg , bgColorSvg));
    }

    function eyeColor(uint256 tokenId) public view virtual returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(LibStrings.strWithUint("EyeColor", tokenId))));
        rand = rand % s.hayopBase.eyeColor.length;
        string memory eyeSvg = '<polygon points="1127.6 954.7 896.5 954.7 896.5 1051.8 480 1051.8 480 954.7 220.6 954.7 220.6 561.2 1127.6 561.2 1127.6 954.7" ';
        string memory eyeColorSvg = string(abi.encodePacked('fill="', string (s.hayopBase.eyeColor[rand]),'" />'));
        return string (abi.encodePacked(eyeSvg , eyeColorSvg));
    }

    function faceColor(uint256 tokenId) public view virtual returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(LibStrings.strWithUint("FaceColor", tokenId))));
        rand = rand % s.hayopBase.faceColor.length;
        string memory faceSvg = '<path d="M554.1,810h90V630h-90Zm538.3,180V900H824.1v90Zm270-360h-90V810h90ZM464.1,1080V990h-90V900h-90V450h90V270h45a44.9,44.9,0,0,0,45-45s360-24.9,360,0v45h268.3V180h90V90h90V0h90V90h90V270h90V450h90V900h-90v90h-90v90Z" transform="translate(-284.1 0)" ';
        string memory faceColorSvg = string(abi.encodePacked('fill="', string (s.hayopBase.faceColor[rand]),'" />'));
        return string (abi.encodePacked(faceSvg , faceColorSvg));
    }

    function tokenSVG(uint256 _tokenId) public view virtual returns (string memory) {
        string memory outputSVG;
        outputSVG = string (abi.encodePacked( baseSvg,bgColor(_tokenId), eyeColor(_tokenId), faceColor(_tokenId), '</svg>'));

        return outputSVG;
    }

    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory output = tokenSVG(tokenId);

        string memory json = LibBase64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Hayop #', LibStrings.toString(tokenId),
                        '", "description": "Hayops are on-chain pet, ready to tackle multiverse.", "animation_url" : "', s.baseUrl,  LibStrings.toString(tokenId) , '.html"' , ', "image": "data:image/svg+xml;base64,',
                        LibBase64.encode(bytes(output)),
                        '", "attributes": [{"trait_type": "location", "value": "',
                        'indoor',
                        '"}]}'
                    )
                )
            )
        );
        output = string(abi.encodePacked("data:application/json;base64,", json));
        return output;
    }

    function mintHayop() public {
        uint256 tokenId = s.counter.current();

        _mint(msg.sender, tokenId);
        s.counter.increment();
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        s.hayopBalance[to] += 1;
        s.hayops[tokenId].owner = to;
        s.tokenIds.push(tokenId);

        emit LibERC721.Transfer(address(0), to, tokenId);
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return s.hayops[tokenId].owner != address(0);
    }

    //randomization doesnt matter for now as each base is equal and no rarity.
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function setBaseUrl(string memory _url) public onlyOwner{
        s.baseUrl = _url;
    }
}