//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] public players; 
    address public manager;
    uint public stake;

    constructor(){
        manager = msg.sender;
    }

    receive() payable external{
        require(msg.sender != manager, "Manager cannot enter lottery");
        require(msg.value == stake, "You must send the exact stake to enter the lottery");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(manager == msg.sender, "only manager can see balance");

        return address(this).balance;
    }

    function setStake(uint _stake) public {
        require(manager == msg.sender, "only manager can set stake");

        require(players.length == 0, "you can't set stake while a lottery round is ongoing");

        stake = _stake;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public{
        require(msg.sender == manager, "only manager can pick winner");
        require(players.length >= 3, "there must be at least 3 players before you can pick a winner");
        
        uint winnerIndex = random() % players.length;
        address payable winner = players[winnerIndex];
        // transfer contract balance to the winner
        winner.transfer(getBalance());
        // reset the lottery for anothe around of play
        players = new address payable[](0); // 0 sets the size of the new dynamic array
    }
}