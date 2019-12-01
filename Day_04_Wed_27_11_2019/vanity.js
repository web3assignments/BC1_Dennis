Web3 = require('web3');
web3 = new Web3();
var i=0;
var find="00404";
var findlength_plus2=find.length+2;
var prefix;
var startTime = new Date();
do {
    newAddress=web3.eth.accounts.create();
    prefix=newAddress.address.slice(2,findlength_plus2).toLowerCase();
} while (prefix !=find );
var endTime = new Date();
var timeDif=(endTime-startTime)/1000;
console.log(`Found an address with prefix ${prefix} in ${timeDif} seconds`);
console.log(`address=${newAddress.address}`);
console.log(`privatekey=${newAddress.privateKey}`); 