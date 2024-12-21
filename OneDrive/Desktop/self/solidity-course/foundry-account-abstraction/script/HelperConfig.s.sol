// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";


contract HelperConfig is Script{
 
 error HelperConfig__InvalidChainId();

    uint256 constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 constant LOCAL_CHAIN_ID = 31337;
    address constant ANVIL_DEFAULT_ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant BURNER_WALLET = 0x643315C9Be056cDEA171F4e7b2222a4ddaB9F88D;

struct NetworkConfig {
        address entryPoint;
        address account;
    }

    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor(){
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] =getEthSepoliaConfig();
        networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] =getZkSyncSepoliaConfig();
        

    }

    function getConfig()public   returns(NetworkConfig memory) {

       return getConfigByChainId(block.chainid);
    }

    function getConfigByChainId(uint256 chainId) public  returns(NetworkConfig memory){
       if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else if (networkConfigs[chainId].account != address(0)) {
            return networkConfigs[chainId];
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }
    
      function getEthSepoliaConfig() public pure returns(NetworkConfig memory){
        return NetworkConfig ({
        entryPoint : 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789,
        account : BURNER_WALLET
        });

    }
      function getZkSyncSepoliaConfig()  public pure returns(NetworkConfig memory){
        return NetworkConfig({
        entryPoint : address(0),
        account : BURNER_WALLET
        });

    }
    function getOrCreateAnvilEthConfig() public  returns(NetworkConfig memory){
        if (networkConfigs[LOCAL_CHAIN_ID].account != address(0)){
            return networkConfigs[LOCAL_CHAIN_ID];
        }
        
        console2.log("Deploying EntryPoint mock......");
        vm.prank(ANVIL_DEFAULT_ACCOUNT);
        EntryPoint entrypoint = new EntryPoint();
        networkConfigs[LOCAL_CHAIN_ID]=NetworkConfig({entryPoint:address(entrypoint), account : ANVIL_DEFAULT_ACCOUNT});

        return networkConfigs[LOCAL_CHAIN_ID] ;
        // return NetworkConfig({  entryPoint : address(entryPoint),
        // account : ANVIL_DEFAULT_ACCOUNT});
        
    }
}