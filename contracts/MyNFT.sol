// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MyNFT is ERC721, Ownable, ERC2981, ReentrancyGuard {

    enum SaleState { Paused, Allowlist, Public }

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 0.01 ether;
    uint256 public totalSupply;
    uint256 public maxPerWallet = 5;

    bytes32 public merkleRoot;

    string private baseURI_;
    string private revealedURI_;
    bool public isRevealed;

    SaleState public saleState = SaleState.Paused;

    mapping(address => uint256) public mintedPerWallet;

    error InvalidSaleState();
    error ExceedsSupply();
    error ExceedsWalletLimit();
    error IncorrectETH();
    error InvalidProof();

    constructor() ERC721("MyNFT", "MNFT") {
        _setDefaultRoyalty(msg.sender, 500);
    }

    function allowlistMint(bytes32[] calldata proof, uint256 quantity) external payable nonReentrant {
        if (saleState != SaleState.Allowlist) revert InvalidSaleState();
        _validateMint(msg.sender, quantity);

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (!MerkleProof.verify(proof, merkleRoot, leaf)) revert InvalidProof();

        _mintTokens(msg.sender, quantity);
    }

    function publicMint(uint256 quantity) external payable nonReentrant {
        if (saleState != SaleState.Public) revert InvalidSaleState();
        _validateMint(msg.sender, quantity);
        _mintTokens(msg.sender, quantity);
    }

    function _validateMint(address minter, uint256 quantity) internal {
        if (totalSupply + quantity > MAX_SUPPLY) revert ExceedsSupply();
        if (mintedPerWallet[minter] + quantity > maxPerWallet) revert ExceedsWalletLimit();
        if (msg.value != price * quantity) revert IncorrectETH();
    }

    function _mintTokens(address to, uint256 quantity) internal {
        mintedPerWallet[to] += quantity;

        for (uint256 i = 0; i < quantity; i++) {
            totalSupply++;
            _safeMint(to, totalSupply);
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Not exist");

        if (!isRevealed) {
            return string(abi.encodePacked(baseURI_, _toString(tokenId), ".json"));
        }

        return string(abi.encodePacked(revealedURI_, _toString(tokenId), ".json"));
    }

    function reveal() external onlyOwner {
        isRevealed = true;
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        price = newPrice;
    }

    function setBaseURI(string calldata uri) external onlyOwner {
        baseURI_ = uri;
    }

    function setRevealedURI(string calldata uri) external onlyOwner {
        revealedURI_ = uri;
    }

    function setMerkleRoot(bytes32 root) external onlyOwner {
        merkleRoot = root;
    }

    function setSaleState(SaleState state) external onlyOwner {
        saleState = state;
    }

    function withdraw() external onlyOwner nonReentrant {
        payable(owner()).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) { digits++; temp /= 10; }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
