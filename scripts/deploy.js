async function main() {
  const [deployer] = await ethers.getSigners();
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);

  const ONE_DAY_IN_SECS = 24 * 60 * 60;
  const TWO_MONTHS_IN_SECS = 60 * 24 * 60 * 60;

  const openingTime = currentTimestampInSeconds + ONE_DAY_IN_SECS;
  const closingTime = currentTimestampInSeconds + TWO_MONTHS_IN_SECS;

  const tokenContractFactory = await hre.ethers.getContractFactory("TokenERC20");
  const tokenContract = await tokenContractFactory.deploy("Token", "TOK");
  await tokenContract.deployed();
  console.log("Token deployment successful to address: ", tokenContract.address);

  const crowdContractFactory = await hre.ethers.getContractFactory("Crowd_Token");
  const crowdContract = await crowdContractFactory.deploy(
      1,
      deployer.address,
      tokenContract.address,
      500,
      openingTime,
      closingTime,
      deployer.address,
      deployer.address,
      deployer.address,
      closingTime
  );
  await crowdContract.deployed();

  console.log("Deployment successful to address: ", crowdContract.address)

}

main().catch((error) => {
  console.log(error);
  process.exitCode = 1
});