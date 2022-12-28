// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract DynamicSVG is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter; //for token id
    event NFTMinted(address sender, uint256 tokenId); //event for NFT minting
    constructor() ERC721("DynamicSVG", "DSN") {}

    // Array of names
    string[] flowers = ['phalaenopsis','alstroemeria','helianthus','narcissus','dianthus','anemone'];
    string[] weapons = ['kopis','xiphos','gastraphetes','sarissa','ballista'];

    function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
    } 

    event flowercheck(address add, string flower);

    function randomFlowerName(uint256 tokenId) public returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("flower", Strings.toString(tokenId))));

    rand = rand % flowers.length;
    string memory result = flowers[rand];
    emit flowercheck(msg.sender, result);
    return result;
    
    }
    //why does every array need its own function- why can't we pass the arrays to a single function?
    function randomWeaponName(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("weapon", Strings.toString(tokenId))));

    rand = rand % weapons.length;
    return weapons[rand];
    }

    //svg components
    string svgFirstPart = "<svg viewBox='0 0 350 350' xmlns='http://www.w3.org/2000/svg'><defs><linearGradient id='grad' x1='0%' y1='0%' x2='100%' y2='0%'><stop offset='0%' style='stop-color:#E0144C;stop-opacity:1' /><stop offset='100%' style='stop-color:#FF97C1;stop-opacity:1' /></linearGradient></defs><rect width='100%' height='100%' fill='url(#grad)'/><text fill='white' style='font-size: 20px' x='15%' y='10%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgSecondPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='18%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgThirdPart = "</text><text fill='white' style='font-size: 16px' x='90%' y='90%' class='base' dominant-baseline='middle' text-anchor='middle'>Rank: ";
    string svgFourthPart = "</text></svg>";

    //function for generating the dynamic SVG 
    function generateSvg(uint256 tokenId, string memory flower, string memory weapon) public view returns (string memory) {
      return string(abi.encodePacked(svgFirstPart,flower,svgSecondPart, weapon, svgThirdPart, Strings.toString(tokenId),svgFourthPart));
    }

      //actually minting the NFT
	    function mintNFT() public {
			uint256 tokenId = _tokenIdCounter.current();
      string memory random_flower = randomFlowerName(tokenId);
      string memory random_weapon = randomWeaponName(tokenId);
      string memory generated_svg = generateSvg(tokenId, random_flower, random_weapon);

      string memory svgBase64 = string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(bytes(generated_svg))));

       string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name" : "',
                        abi.encodePacked(random_flower, random_weapon),
                        '","description":"My Random Flower Weapon", "image":"',
                            svgBase64,
                            '"}'
                    )
            )
        )
    );

    string memory tokenUriBase64 = string(
        abi.encodePacked("data:application/json;base64,", json)
    );  
      _safeMint(msg.sender, tokenId);
      _setTokenURI(tokenId, tokenUriBase64);
      emit NFTMinted(msg.sender, tokenId);
      _tokenIdCounter.increment();
		}
} 

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/utils/Base64.sol";

// contract DynamicSVG is ERC721URIStorage {
//     using Counters for Counters.Counter;

//     Counters.Counter private _tokenIdCounter;

//     event NFTMinted(address sender, uint256 tokenId);

//     constructor() ERC721("DynamicSVG", "DSN") {}

//     // Array of names
//     string[] onepiece = ['Luffy', 'Zoro', 'Shanks', 'Ace', 'Whitebeard', 'Aokiji', 'Garp', 'Blackbeard', 'Kaido', 'Sanji'];
//     string[] naruto = ['Naruto', 'Sasuke', 'Kakashi', 'Jiraiya', 'Hinata', 'Itachi', 'Orochimaru', 'Tsunade', 'Madara', 'Obito'];
//     string[] aot = ['Eren', 'Mikasa', 'Levi', 'Armin', 'Sasha','Jean', 'Braun', 'Annie', 'Connie', 'Erwin'];
//     string[] mha = ['Midoriya', 'Bakugo', 'Todoroki', 'Uraraka', 'Endeavour', 'Shingaraki', 'Dabi', 'Togata', 'Lida', 'Aizawa'];

//     string svgFirstPart = "<svg viewBox='0 0 350 350' xmlns='http://www.w3.org/2000/svg'><defs><linearGradient id='grad' x1='0%' y1='0%' x2='100%' y2='0%'><stop offset='0%' style='stop-color:#E0144C;stop-opacity:1' /><stop offset='100%' style='stop-color:#FF97C1;stop-opacity:1' /></linearGradient></defs><rect width='100%' height='100%' fill='url(#grad)'/><text fill='white' style='font-size: 20px' x='15%' y='10%' class='base' dominant-baseline='middle' text-anchor='middle'>";
//     string svgSecondPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='18%' class='base' dominant-baseline='middle' text-anchor='middle'>";
//     string svgThirdPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='26%' class='base' dominant-baseline='middle' text-anchor='middle'>";
//     string svgFourthPart = "</text><text fill='white' style='font-size: 20px' x='15%' y='34%' class='base' dominant-baseline='middle' text-anchor='middle'>";
//     string svgFifthPart = "</text><text fill='white' style='font-size: 16px' x='90%' y='90%' class='base' dominant-baseline='middle' text-anchor='middle'>Rank: ";
//     string svgSixthPart = "</text></svg>";

//     function generateSvg(uint256 tokenId, string memory onepieceName, string memory narutoName, string memory aotName, string memory mhaName) public view returns(string memory) {
//         return string(
//                 abi.encodePacked(
//                     svgFirstPart, 
//                     onepieceName, 
//                     svgSecondPart, 
//                     narutoName, 
//                     svgThirdPart, 
//                     aotName, 
//                     svgFourthPart, 
//                     mhaName, 
//                     svgFifthPart, 
//                     Strings.toString(tokenId), 
//                     svgSixthPart
//                 )
//             );
//     }

//     // Random One piece name
//     function randomOnePieceName(uint256 tokenId) public view returns (string memory) {
//         uint256 rand = random(string(abi.encodePacked("ONE_PIECE", Strings.toString(tokenId))));

//         rand = rand % onepiece.length;
//         return onepiece[rand];
//     }

//     // Random Naruto Name
//     function randomNarutoName(uint256 tokenId) public view returns (string memory) {
//         uint256 rand = random(string(abi.encodePacked("NARUTO", Strings.toString(tokenId))));

//         rand = rand % naruto.length;
//         return naruto[rand];
//     }

//     // Random AOT Name
//     function randomAOTName(uint256 tokenId) public view returns (string memory) {
//         uint256 rand = random(string(abi.encodePacked("AOT", Strings.toString(tokenId))));

//         rand = rand % aot.length;
//         return aot[rand];
//     }

//     // Random MHA Name
//     function randomMHAName(uint256 tokenId) public view returns (string memory) {
//         uint256 rand = random(string(abi.encodePacked("MHA", Strings.toString(tokenId))));

//         rand = rand % mha.length;
//         return mha[rand];
//     }

//     function random(string memory input) internal pure returns (uint256) {
//         return uint256(keccak256(abi.encodePacked(input)));
//     }

//     function mintNFT() public {
//         // Get token Id
//         uint256 tokenId = _tokenIdCounter.current();

//         string memory onepieceName = randomOnePieceName(tokenId);
//         string memory narutoName = randomNarutoName(tokenId);
//         string memory aotName = randomAOTName(tokenId);
//         string memory mhaName = randomMHAName(tokenId);

//         string memory dynamicSvg = generateSvg(tokenId, onepieceName, narutoName, aotName, mhaName);

//         string memory svgBase64 = string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode(bytes(dynamicSvg))));

//         string memory json = Base64.encode(
//             bytes(
//                 string(
//                     abi.encodePacked(
//                         '{"name" : "',
//                             abi.encodePacked(onepieceName, narutoName, aotName, mhaName),
//                             '","description":"My Random Anime Character List", "image":"',
//                             svgBase64,
//                             '"}'
//                     )
//                 )
//             )
//         );

//         string memory tokenUriBase64 = string(
//             abi.encodePacked("data:application/json;base64,", json)
//         );

//         _safeMint(msg.sender, tokenId);
//         _setTokenURI(tokenId, tokenUriBase64);

//         emit NFTMinted(msg.sender, tokenId);

//         _tokenIdCounter.increment();
//     }
// } 