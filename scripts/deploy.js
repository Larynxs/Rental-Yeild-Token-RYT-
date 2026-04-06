const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Rental Yield Token...");
  const [deployer] = await ethers.getSigners();
  console.log("Deploying from wallet:", deployer.address);
  const RentalYieldToken = await ethers.getContractFactory("RentalYieldToken");
  const token = await RentalYieldToken.deploy();
  await token.waitForDeployment();
  console.log("RentalYieldToken deployed to:", await token.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });