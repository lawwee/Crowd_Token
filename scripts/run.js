async function main() {
    const [ owner, randomUser, another, investor ] = await hre.ethers.getSigners()
    const currentTimestampInSeconds = Math.round(Date.now() / 1000);

    const ONE_MONTH_IN_SECS = 30 * 24 * 60 * 60;
    const TWO_MONTH_IN_SECS = 60 * 24 * 60 * 60;

    const openingTime = currentTimestampInSeconds + ONE_MONTH_IN_SECS;
    const closingTime = currentTimestampInSeconds + TWO_MONTH_IN_SECS;

    const tokenContractFactory = await hre.ethers.getContractFactory("TokenERC20");
    const tokenContract = await tokenContractFactory.deploy("Token", "TOK");
    await tokenContract.deployed();
    console.log("deploy success");

    const crowdContractFactory = await hre.ethers.getContractFactory("Crowd_Token");
    const crowdContract = await crowdContractFactory.deploy(
        1,
        randomUser.address,
        tokenContract.address,
        500,
        openingTime,
        closingTime,
        another.address,
        another.address,
        another.address,
        closingTime
    );
    await crowdContract.deployed();
    console.log("Deployment successful")

    let txn = await crowdContract.getUserContributions(investor.address);

    txn = await crowdContract.getCrowdsaleStage()

    txn = await crowdContract.setCrowdsaleStage(1)
    await txn.wait()

    txn = await crowdContractFactory.token()

}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1
});