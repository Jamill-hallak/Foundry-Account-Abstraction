// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Test,console} from "forge-std/Test.sol";
contract DeployMinimal is Script {
    function run() public {
    }

    function deployMinimalAccount() public returns (HelperConfig, MinimalAccount) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast(config.account);
        MinimalAccount minimalAccount = new MinimalAccount(config.entryPoint);
        // console.log(minimalAccount.owner());
        //minimalAccount.transferOwnership(config.account);
        vm.stopBroadcast();
        return (helperConfig, minimalAccount);
    }
}