// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;
    address USER = makeAddr("user") ;
    uint256 constant Ether_Give = 10 ether ;
    uint256 constant Ether_Spend = 0.1 ether ;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        deal(USER,Ether_Give );
    }

    function testMinimumlDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        //  fail : cause msg.sender call fundmetest contract then the fundme contract deploy the FundMe contract
        //  so the onwer is the address of the fundmetest
        // assertEq(fundme.i_owner(), msg.sender);

        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }


    function testFundFailsWIthoutEnoughETH() public {
   vm.expectRevert();// <- The next line after this one should revert! If not test fails.
    fundMe.fund();
    //fundMe.fund();     // <- We send 0 value

}
  function testFundUpdatesFundedDataStructure() public{
    vm.prank(USER);
    fundMe.fund{value :Ether_Spend}();
    uint256 amountFunded =fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, Ether_Spend);
  }

 function testAddsFunderToArrayOfFunders() public {
    vm.prank(USER);
    fundMe.fund{value:Ether_Spend}();
    address funder=fundMe.getFunder(0);
    assertEq(funder, USER);

 }

modifier funded(){
  vm.prank(USER);
  fundMe.fund{value:Ether_Spend}();
  _;
}

 function testOnlyOwnerCanWithdraw () public funded {
  
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw();
 }

 function testWithdrawWithSingleFunder()public funded {
    //arrange 
    uint256 stratingOnwerBalance= fundMe.getOwner().balance;
    uint256 stratingFundmeBalance=address(fundMe).balance;

    //Act 
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();


    //assert
    uint256 endingFundmeBlanace = address(fundMe).balance;
    uint256 endingOnwerBalance = fundMe.getOwner().balance;
    assertEq(endingFundmeBlanace, 0);
    assertEq(endingOnwerBalance, stratingOnwerBalance+stratingFundmeBalance);

    
 }

  function testWithdrawFromMulitpleFunders() public funded(){
   
   uint160 numberOfFunders=10 ;
   uint160 stratingNumberIndes=1;

   for (uint160 i =stratingNumberIndes;i<numberOfFunders;i++){
    hoax(address(i),Ether_Spend);
    fundMe.fund{value:Ether_Spend}();
   }
    uint256 stratingOnwerBalance= fundMe.getOwner().balance;
    uint256 stratingFundmeBalance=address(fundMe).balance;
    
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();
    
   assert(address(fundMe).balance==0);
   assert(stratingOnwerBalance + stratingFundmeBalance==fundMe.getOwner().balance);
  }


  function testWithdrawFromMulitpleFunderscheaper() public funded(){
   
   uint160 numberOfFunders=10 ;
   uint160 stratingNumberIndes=1;

   for (uint160 i =stratingNumberIndes;i<numberOfFunders;i++){
    hoax(address(i),Ether_Spend);
    fundMe.fund{value:Ether_Spend}();
   }
    uint256 stratingOnwerBalance= fundMe.getOwner().balance;
    uint256 stratingFundmeBalance=address(fundMe).balance;
    
    vm.startPrank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();
    
   assert(address(fundMe).balance==0);
   assert(stratingOnwerBalance + stratingFundmeBalance==fundMe.getOwner().balance);
  }

}
