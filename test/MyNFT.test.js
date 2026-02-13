const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyNFT", function () {
  let nft, owner, addr1;

  beforeEach(async () => {
    [owner, addr1] = await ethers.getSigners();
    const NFT = await ethers.getContractFactory("MyNFT");
    nft = await NFT.deploy();
  });

  it("Deploys correctly", async () => {
    expect(await nft.name()).to.equal("MyNFT");
  });

  it("Public mint works", async () => {
    await nft.setSaleState(2);
    await nft.connect(addr1).publicMint(1, { value: ethers.parseEther("0.01") });
    expect(await nft.totalSupply()).to.equal(1);
  });
});
