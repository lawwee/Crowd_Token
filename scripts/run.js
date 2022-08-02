async function main() {
    const [ owner, randomUser, another ] = await hre.ethers.getSigners()
    const tokenContractFactory = await hre.ethers.getContractFactory("TokenERC20");
    const tokenContract = await tokenContractFactory.deploy("Token", "TOK");
    await tokenContract.deployed();
    console.log("deploy success");

    // txn = await tokenContract.transfer(owner.address, 300);
    // await txn.wait();

    let txn = await tokenContract.totalSupply();

    txn = await tokenContract.name();
    // await txn.wait()

    txn = await tokenContract.symbol();

    // txn = await tokenContract.decreaseAllowance(randomUser.address, 100);
    // await txn.wait()

    // txn = await tokenContract.allowance(owner.address, randomUser.address);

}

main().catch((error) => {
    console.log(error);
    process.exitCode = 1
});