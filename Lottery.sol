// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract lottery{

    //entities - manager, players, and winners

address public manager;
address payable[] public players;
address payable public winner;


constructor (){
    manager = msg.sender;
}

//fucntion to participage in the lottery
function participate () public payable{
    require(msg.value == 1 ether, "Please pay 1 ether only");
    players.push(payable(msg.sender));

}

function getBalance() public view returns(uint){
    require(manager == msg.sender, "You are not the manager");
    return address(this).balance;
}


function random() internal view returns(uint){
    //generate a random number, we will use abi.encodedPacked(block.difficulty,though not recommented for getting random number
    //abi.encoded are all global variables
    //best to generate random number is the use of ORACLE such as chainlink oracle
return uint( keccak256( abi.encodePacked(block.prevrandao, block.timestamp, players.length)));

}

//pick winner function

function pickWinner() public{
    require(manager == msg.sender, "You are not the manager");
    require(players.length>=3,"Players are less than 3");

    //we will use the random number generated here by calling the random function;
     uint r = random();

     //Getting the index using the modulus operator which returns a whole number
     //modulus operator always returns values less than the divisor by 1, 
     uint index = r% players.length;
     winner = players[index];
     winner.transfer(getBalance());
     //Now that the balance has been transfered to the winner, we will make the players array to be zero;
     players = new address payable[](0); //this will initialise the players array back to zero;
     

}

}