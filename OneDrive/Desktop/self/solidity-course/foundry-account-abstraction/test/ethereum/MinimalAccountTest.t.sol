// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test,console2} from "forge-std/Test.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {DeployMinimal} from "script/DeployMinimal.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {SendPackedUserOp,IEntryPoint} from "script/SendPackedUserOp.s.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract MinimalAccountTest is Test {

using MessageHashUtils for bytes32 ;
uint256 public ANVIL_DEFAULT_KEY =0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
HelperConfig  helperConfig ;
MinimalAccount minimalAccount ;
ERC20Mock usdc ;
SendPackedUserOp sendPackedUserOp ;

address randomuser = makeAddr("randomuser");
uint256 constant AMOUNT = 1e18;
    function setUp() public{
        DeployMinimal deployMinimal = new DeployMinimal();
        (helperConfig ,minimalAccount) =deployMinimal.deployMinimalAccount();
        usdc = new ERC20Mock();
        sendPackedUserOp = new SendPackedUserOp();
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
            
            vm.prank(minimalAccount.owner());
             
            minimalAccount.execute(dest,0,functionData);

            assertEq(usdc.balanceOf(address(minimalAccount)), AMOUNT);
    }
function testNonOwnerCannotExecuteCommands() public  {
        // Arrange
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
        // Act
        vm.prank(randomuser);
        vm.expectRevert(MinimalAccount.MinimalAccount__NotFromEntryPointOrOwner.selector);
        minimalAccount.execute(dest, value, functionData);
    }

      function testRecoverSignedOp() public{
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
        bytes memory excuteData = abi.encodeWithSelector(MinimalAccount.execute.selector,dest,value, functionData);
        PackedUserOperation memory PackedUserOp =sendPackedUserOp.generateSignedUserOperation(
            excuteData,helperConfig.getConfig()
        );
      bytes32 userOperationHash = IEntryPoint(helperConfig.getConfig().entryPoint).getUserOpHash(PackedUserOp);
        
        //  uint8 v;
        // bytes32 r;
        // bytes32 s;
        //  (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, userOperationHash.toEthSignedMessageHash());
        // bytes memory trye= abi.encodePacked(r, s, v);
        // // Act
        // // console2.logBytes(trye);
        // // console2.logBytes(PackedUserOp.signature);
        address actualSigner = ECDSA.recover
        (userOperationHash.toEthSignedMessageHash(), PackedUserOp.signature);
        
        // Assert
        assertEq(actualSigner, minimalAccount.owner());

      }


    // 1. Sign user ops
    // 2. Call validate userops
    // 3. Assert the return is correct

    function testValidationOfUserOps() public  {
        // Arrange
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);
        bytes memory executeCallData =
            abi.encodeWithSelector(MinimalAccount.execute.selector, dest, value, functionData);
        PackedUserOperation memory packedUserOp = sendPackedUserOp.generateSignedUserOperation(
            executeCallData, helperConfig.getConfig()
        );
        
        bytes32 userOperationHash = IEntryPoint(helperConfig.getConfig().entryPoint).getUserOpHash(packedUserOp);
        uint256 missingAccountFunds = 1e18;
        
        vm.prank(helperConfig.getConfig().entryPoint);
        uint256 validationData =minimalAccount.validateUserOp(packedUserOp,userOperationHash,missingAccountFunds);
        vm.startBroadcast();
          assertEq(validationData, 0);
}





}