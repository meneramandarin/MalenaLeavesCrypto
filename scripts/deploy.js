async function main() {
    console.log("Starting deployment...");
    const signers = await ethers.getSigners();
    if (signers.length === 0) {
      console.error("No signers available. Check network configuration.");
      process.exit(1);
    }
    const deployer = signers[0];
    console.log("Deploying contracts with the account:", deployer.address);
  
    try {
      const MalenaLeavesCrypto = await ethers.getContractFactory("MalenaLeavesCrypto");
      const malenaLeavesCrypto = await MalenaLeavesCrypto.deploy();
  
      await malenaLeavesCrypto.deployed();
  
      console.log("MalenaLeavesCrypto deployed to:", malenaLeavesCrypto.address);
  
      await malenaLeavesCrypto.initialize(
        "MalenaLeavesCrypto", 
        "MLC", 
        "0xa521df93f64177b3fbcf1fbc0720f16066061d5357731291b1e17c58e62cc7c0", 
        "0x0DC825282d60cEB87c87A58AB1B1d47384ae9Aa5" 
      );
  
      console.log("MalenaLeavesCrypto initialized successfully");
    } catch (error) {
      console.error("An error occurred during deployment:", error);
      process.exit(1);
    }
  }
  
  main().catch(error => {
    console.error("An error occurred:", error);
    process.exit(1);
  });