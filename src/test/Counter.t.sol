// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "../Counter.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

contract CounterTest is DSTest {
    Counter public counter;
    uint256 public staticTime;
    uint256 public INTERVAL;
    Vm internal constant vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

    function setUp() public {
        staticTime = block.timestamp;
        counter = new Counter(INTERVAL);
        vm.warp(staticTime);
    }

    function test_checkup_returns_false_before_time() public {
        (bool upkeepNeeded, ) = counter.checkUpkeep("0x");
        assertTrue(!upkeepNeeded);
    }

    function test_checkup_returns_true_after_time() public {
        vm.warp(staticTime + INTERVAL + 1); // Needs to be more than the interval
        (bool upkeepNeeded, ) = counter.checkUpkeep("0x");
        assertTrue(upkeepNeeded);
    }

    function test_performUpkeep_updates_time() public {
        // Arrange
        uint256 currentCounter = counter.counter();

        // Act
        counter.performUpkeep("0x");

        // Assert
        assertTrue(counter.lastTimeStamp() == block.timestamp);
        assertTrue(currentCounter + 1 == counter.counter());
    }
}
