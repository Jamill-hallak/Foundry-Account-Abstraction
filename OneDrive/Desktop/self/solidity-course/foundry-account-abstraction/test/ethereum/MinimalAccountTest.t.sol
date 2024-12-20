// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test,console} from "forge-std/Test.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {DeployMinimal} from "script/DeployMinimal.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract MinimalAccountTest is Test {
HelperConfig  helperConfig ;
MinimalAccount minimalAccount ;
ERC20Mock usdc ;
uint256 constant AMOUNT = 1e18;
    function setUp() public{
        DeployMinimal deployMinimal = new DeployMinimal();
        (helperConfig ,minimalAccount) =deployMinimal.deployMinimalAccount();
        usdc = new ERC20Mock();

    }


    // USDC Mint
    // msg.sender -> MinimalAccount
    // approve some amount
    // USDC contract
    // come from the entrypoint
    function testOwnerCanExecuteCommands() public{
            assert(usdc.balanceOf(address(minimalAccount))==0);
           
            address dest = address(usdc);
            bytes memory functionData = abi.encodeWithSelector(usdc.mint.selector,address(minimalAccount),AMOUNT );
            console.log(minimalAccount.owner());
            vm.prank(minimalAccount.owner());
             
            minimalAccount.execute(dest,0,functionData);

            assertEq(usdc.balanceOf(address(minimalAccount)), AMOUNT);
    }


}