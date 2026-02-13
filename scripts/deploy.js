const hre = require("hardhat");

async function main() {
  const NFT = await hre.ethers.getContractFactory("MyNFT");
  const nft = await NFT.deploy();
  await nft.waitForDeployment();

  console.log("Contract deployed to:", await nft.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
