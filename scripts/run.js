async function main() {
    const [ owner, randomUser, another ] = await hre.ethers.getSigners()
    const tokenContractFactory = await hre.ethers.getContractFactory("TokenERC20");
    const tokenContract = await tokenContractFactory.deploy("Token", "TOK");
    await tokenContract.deployed();
    console.log("deploy success");

    const crowdContractFactory = await hre.ethers.getContractFactory("CrowdSale");
    const crowdContract = await crowdContractFactory.deploy(
        owner.address,
        tokenContract.address
    );
    await crowdContract.deployed();

    let txn = await tokenContract.transfer(crowdContract.address, 500);
    await txn.wait()

    txn = await crowdContract.buyTokens(1, {
        value: hre.ethers.utils.parseEther("0.0001")
    });
    await txn.wait()

}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1
});