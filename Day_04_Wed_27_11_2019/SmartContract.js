const Web3 = require('web3');
const web3 = new Web3('https://ropsten.infura.io' );
const contractAddress="0xF229e85d1f09af9ABBa1f81967c05E05d6FB5e19"
const getBankBalanceABI=[ {
    "constant": true,
    "inputs": [],
    "name": "getBankBalance",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }];
const getRandomABI=[{
    "constant": true,
    "inputs": [],
    "name": "getRandom",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }];

const PlayerBetABI=[{
    "constant": false,
    "inputs": [
      {
        "internalType": "uint256",
        "name": "number",
        "type": "uint256"
      }
    ],
    "name": "PlayerBet",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "payable": true,
    "stateMutability": "payable",
    "type": "function"
  }];
const eventRollResultABI=[{
    "inputs": [],
    "payable": true,
    "stateMutability": "payable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "player",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "table",
        "type": "uint256"
      }
    ],
    "name": "rollResult",
    "type": "event"
  }];
async function checkBankBalance() {      
    const ContractTestPay   = new web3.eth.Contract(getBankBalanceABI, contractAddress );
    var result = await ContractTestPay.methods.getBankBalance().call();
    console.log(`calling the contract method getBankBalance shows ${Web3.utils.fromWei(result)} ether`);
    var x=Web3.utils.fromWei(await web3.eth.getBalance(contractAddress),'ether');
    console.log(`using web3.eth.getBalance shows ${contractAddress} has ${x} ether`);
    console.log(`bewteen the two methods is a differance of ${x-Web3.utils.fromWei(result)}`);
}
async function getRandom(){
    const ContractgetRandom = new web3.eth.Contract(getRandomABI, contractAddress);
    let result= await ContractgetRandom.methods.getRandom().call();
    console.log(`random number was ${result}`);
}
async function newPlayerBet(){
    let PlayerAccount="0x0faacdDD2346AEd3ED3059828210731e154b1313";
    let AmountToBed= web3.utils.toWei("0.05",'ether');
    let PlayerNumber=30;
    const playerBetContact = new web3.eth.Contract(PlayerBetABI,contractAddress);
    await playerBetContact.methods.PlayerBet(PlayerNumber).send({from:PlayerAccount,value:AmountToBed}).then(console.log);

}
async function getLastRollEvent(){
    const eventContract= new web3.eth.Contract(eventRollResultABI,contractAddress);
    await eventContract.getPastEvents('rollResult', { 
        fromBlock: 0,
        toBlock: 'latest'
    }, (error, events) => { 
  
        if (!error){
          var obj=JSON.parse(JSON.stringify(events));
          var array = Object.keys(obj);
          var returnValues=obj[array[array.length-1]].returnValues;
          console.log(`last player bet on ${returnValues[0]} and the table rolled a ${returnValues[1]}`);
        }
        else {
          console.log(error)
        }})
    
}
getRandom();
checkBankBalance();
newPlayerBet();
getLastRollEvent();