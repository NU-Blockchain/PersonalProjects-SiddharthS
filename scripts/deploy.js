const hre = require("hardhat");

async function main() {
  const DynamicSVG = await hre.ethers.getContractFactory("DynamicSVG");
  const dynamicSVG = await DynamicSVG.deploy();

  await dynamicSVG.deployed();

  console.log(
    `DynamicSVG deployed to ${dynamicSVG.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});