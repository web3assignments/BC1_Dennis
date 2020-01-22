pragma solidity >=0.4.0 <0.6.0;
      import "remix_tests.sol"; // this import is automatically injected by Remix.
      import "./Roulette.sol";

      // file name has to end with '_test.sol'
      contract test_1 {
         enum betModes{ByNumber,ByOddEven,ByRedBlack,ByRow,ByCorner}
        Roulette gameTest;
        function beforeAll() public {
          // here should instantiate tested contract
          gameTest = new Roulette();
        }
        //Test to see if number is not below Zero;
        function randomNumberNotBelowZero() public {

          Assert.greaterThan(uint(gameTest.getRandom()), uint(0),"number is not greaterThan 0");
         
        }
        //Test to see if number is not higher than 36
        function randomNumberNotAbove36() public {
          // use 'Assert' to test the contract
          Assert.lesserThan(uint(gameTest.getRandom()), uint(37),"number is not lesserThan 37");
         
        }
        //Tests if bet by number is correct.
        function playerBetByNumber() public{
             Assert.equal(gameTest.betByNumber(uint(1),uint(1)), true, "numbers don't match");
             Assert.equal(gameTest.betByNumber(uint(26),uint(1)), false, "numbers shouldn't match");
        }
        //Tests is bet by odd/even is correct.
        function playerBetByOdd() public{
             Assert.equal(gameTest.betByOdd(uint(1),uint(1)), true, "number was not Odd");
             Assert.equal(gameTest.betByOdd(uint(1),uint(0)), false, "number was not Even");
        }
        //Test if number to Enum works.
        function testEnum() public{
            bool result=gameTest.returnEnum(uint(0));
            Assert.equal(result, true, "Enum wasn't ByNumber");
        }

        
      }
