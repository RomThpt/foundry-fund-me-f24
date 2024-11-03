-include .env

build:
	forge build

deploy-sepolia:
	forge script script/FundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account sepolia --broadcast --verify --etherscan-api-key $(ETHERSCAN_API)-vvvvv