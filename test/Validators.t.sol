// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Validators.sol";


contract ValidatorsOneTest is Test {
    Validators validators;

    address acc0;
    address acc1;
    address acc2;
    address val0;
    address val1;
    address val2;

    function setUp() public virtual {
        acc0 = makeAddr("acc0");
        acc1 = makeAddr("acc1");
        acc2 = makeAddr("acc2");
        val0 = makeAddr("val0");
        val1 = makeAddr("val1");
        val2 = makeAddr("val2");

        address[] memory initialAccounts = new address[](1);
        initialAccounts[0] = acc0;
        address[] memory initialValidators = new address[](1);
        initialValidators[0] = val0;
        validators = new Validators(initialAccounts, initialValidators);
    }

    function testNumAllowedAccounts() public {
        assertEq(validators.numAllowedAccounts(), 1, "numAllowedAccounts");
    }

    function testGetValidators() public {
        address[] memory vals = validators.getValidators();
        assertEq(vals.length, 1, "getValidators length");
        assertEq(vals[0], val0, "getValidators[0]");
    }

    function testActivateDeactivateValidators() public {
        
    }




}


contract ValidatorsThreeTest is Test {
    Validators validators;

    address acc0;
    address acc1;
    address acc2;
    address val0;
    address val1;
    address val2;

    function setUp() public virtual {
        acc0 = makeAddr("acc0");
        acc1 = makeAddr("acc1");
        acc2 = makeAddr("acc2");
        val0 = makeAddr("val0");
        val1 = makeAddr("val1");
        val2 = makeAddr("val2");

        address[] memory initialAccounts = new address[](3);
        initialAccounts[0] = acc0;
        initialAccounts[1] = acc1;
        initialAccounts[2] = acc2;

        address[] memory initialValidators = new address[](3);
        initialValidators[0] = val0;
        initialValidators[1] = val1;
        initialValidators[2] = val2;

        validators = new Validators(initialAccounts, initialValidators);
    }

    function testNumAllowedAccounts() public {
        assertEq(validators.numAllowedAccounts(), 3, "numAllowedAccounts");
    }

    function testGetValidators() public {
        address[] memory vals = validators.getValidators();
        assertEq(vals.length, 3, "getValidators length");
        assertEq(vals[0], val0, "getValidators[0]");
        assertEq(vals[1], val1, "getValidators[1]");
        assertEq(vals[2], val2, "getValidators[2]");
    }




}

contract MoreAccountThanValidatorsTest is Test {
    Validators validators;

    address acc0;
    address acc1;
    address acc2;
    address acc3;
    address val0;
    address val1;
    address val2;

    function setUp() public virtual {
        acc0 = makeAddr("acc0");
        acc1 = makeAddr("acc1");
        acc2 = makeAddr("acc2");
        acc3 = makeAddr("acc3");
        val0 = makeAddr("val0");
        val1 = makeAddr("val1");
        val2 = makeAddr("val2");

        address[] memory initialAccounts = new address[](3);
        initialAccounts[0] = acc0;
        initialAccounts[1] = acc1;
        initialAccounts[2] = acc2;
        address[] memory initialValidators = new address[](1);
        initialValidators[0] = val0;
        validators = new Validators(initialAccounts, initialValidators);
    }

    function testNumAllowedAccounts() public {
        assertEq(validators.numAllowedAccounts(), 3, "numAllowedAccounts");
    }

    function testGetValidators() public {
        address[] memory vals = validators.getValidators();
        assertEq(vals.length, 1, "getValidators length");
        assertEq(vals[0], val0, "getValidators[0]");
    }

    function testAddNewAccount() public {
        assertEq(validators.numAllowedAccounts(), 3, "numAllowedAccounts before");
        validators.voteToAddAccountToAllowList(acc3);
        assertEq(validators.numAllowedAccounts(), 4, "numAllowedAccounts after");
    }


}







//     it("can activate different validator and deactivate validator", async () => {
//         await addValidators(1, 1);

//         let currentValidators = await allowListContract.getValidators();
//         assert.lengthOf(currentValidators, 2);
//         assert.equal(currentValidators[0], validators[0]);
//         assert.equal(currentValidators[1], validators[1]);

//         await allowListContract.activate(validators[2], {from: accounts[1]});
//         currentValidators = await allowListContract.getValidators();

//         assert.lengthOf(currentValidators, 2);
//         assert.equal(currentValidators[0], validators[0]);
//         assert.equal(currentValidators[1], validators[2]);

//         await allowListContract.deactivate({from: accounts[0]});
//         currentValidators = await allowListContract.getValidators();

//         assert.lengthOf(currentValidators, 1);
//         assert.equal(currentValidators[0], validators[2]);
//     });

//     it("need more than 50% of votes to add to allow list", async () => {
//         await addValidators(1, 1);

//         let numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 2);

//         await allowListContract.voteToAddAccountToAllowList(accounts[2], {from: accounts[0]});
//         await allowListContract.countVotes(accounts[2]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 2);

//         await allowListContract.voteToAddAccountToAllowList(accounts[2], {from: accounts[1]});
//         await allowListContract.countVotes(accounts[2]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 3);
//     });

//     it("need more than 50% of votes to remove from allow list", async () => {
//         await addValidators(1, 2);

//         let numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 3);

//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[2], {from: accounts[0]});
//         await allowListContract.countVotes(accounts[2]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 3);

//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[2], {from: accounts[1]});
//         await allowListContract.countVotes(accounts[2]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 2);
//     });

//     it("can be removed from allow list, and activated validators are removed", async () => {
//         await addValidators(1, 1);

//         let currentValidators = await allowListContract.getValidators();
//         assert.lengthOf(currentValidators, 2);
//         assert.equal(currentValidators[0], validators[0]);
//         assert.equal(currentValidators[1], validators[1]);

//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[0], {from: accounts[0]});
//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[0], {from: accounts[1]});
//         await allowListContract.countVotes(accounts[0]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 1);

//         currentValidators = await allowListContract.getValidators();
//         assert.lengthOf(currentValidators, 1);
//         assert.equal(currentValidators[0], validators[1]);
//     });

//     it("cannot remove allowed account with last active validator", async () => {
//         await addValidators(1, 1);

//         let currentValidators = await allowListContract.getValidators();
//         assert.lengthOf(currentValidators, 2);
//         assert.equal(currentValidators[0], validators[0]);
//         assert.equal(currentValidators[1], validators[1]);

//         await allowListContract.deactivate({from: accounts[1]});

//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[0], {from: accounts[0]});
//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[0], {from: accounts[1]});
//         try {
//             await allowListContract.countVotes(accounts[0]);
//             assert.fail("no initial validator accounts");
//         } catch (err) {
//             expect(err.reason).to.contain("cannot remove allowed account with last active validator");
//         }

//         currentValidators = await allowListContract.getValidators();
//         assert.lengthOf(currentValidators, 1);
//         assert.equal(currentValidators[0], validators[0]);
//     });

//     it("can remove a vote", async () => {
//         await addValidators(1, 2);

//         let numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 3);

//         await allowListContract.voteToAddAccountToAllowList(accounts[3], {from: accounts[0]});
//         await allowListContract.voteToAddAccountToAllowList(accounts[3], {from: accounts[1]});

//         await allowListContract.removeVoteForAccount(accounts[3], {from: accounts[0]});

//         await allowListContract.countVotes(accounts[3]);
//         numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 3);
//     });

//     it("can call countVotes to get number of votes, required votes and election success for an account", async () => {
//         await addValidators(1, 1);

//         await allowListContract.voteToAddAccountToAllowList(accounts[2], {from: accounts[0]});
//         const web3Contract = new web3.eth.Contract(allowListContractAbi, allowListContract.address);
//         let result = await web3Contract.methods.countVotes(accounts[2]).call({from: accounts[0]});
//         assert.equal(result.numVotes, 1);
//         assert.equal(result.requiredVotes, 2);
//         assert.equal(result.electionSucceeded, false);

//         await allowListContract.voteToAddAccountToAllowList(accounts[2], {from: accounts[1]});
//         result = await web3Contract.methods.countVotes(accounts[2]).call({from: accounts[0]});
//         assert.equal(result.numVotes, 2);
//         assert.equal(result.requiredVotes, 2);
//         assert.equal(result.electionSucceeded, true);
//     });

//     it("can remove allowed account with validator, add account back in without validator", async () => {
//         await addValidators(1, 1);

//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[1], {from: accounts[0]});
//         await allowListContract.voteToRemoveAccountFromAllowList(accounts[1], {from: accounts[1]});
//         await allowListContract.countVotes(accounts[1], {from: accounts[0]});
//         const web3Contract = new web3.eth.Contract(allowListContractAbi, allowListContract.address);
//         let vals = await web3Contract.methods.getValidators().call({from: accounts[0]});

//         assert.equal(vals.length, 1);
//         assert.equal(vals[0], validators[0]);

//         await allowListContract.voteToAddAccountToAllowList(accounts[1], {from: accounts[0]});
//         await allowListContract.countVotes(accounts[1], {from: accounts[0]});
//         vals = await web3Contract.methods.getValidators().call({from: accounts[0]});
//         let numAllowedAccounts = await web3Contract.methods.numAllowedAccounts().call({from: accounts[0]});

//         assert.equal(numAllowedAccounts, 2);
//         assert.equal(vals.length, 1);
//         assert.equal(vals[0], validators[0]);
//     });

//     it("account not on the allow list cannot call voteToAddAccountToAllowList", async () => {
//         try {
//             await allowListContract.voteToAddAccountToAllowList(accounts[0], {from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call add");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("account not on the allow list cannot call voteToRemoveAccountFromAllowList", async () => {
//         try {
//             await allowListContract.voteToRemoveAccountFromAllowList(accounts[0], {from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call remove");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("account not on the allow list cannot call countVotes", async () => {
//         try {
//             await allowListContract.countVotes(accounts[0], {from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call countVotes");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("account not on the allow list cannot call activate", async () => {
//         try {
//             await allowListContract.activate(accounts[0], {from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call activate");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("account not on the allow list cannot call deactivate", async () => {
//         try {
//             await allowListContract.deactivate({from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call countVotes");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("account not on the allow list cannot call removeVoteForAccount", async () => {
//         try {
//             await allowListContract.removeVoteForAccount(accounts[0], {from: accounts[3]});
//             assert.fail("Should not allow account not on the allow list to call removeVoteForAccount");
//         } catch (err) {
//             expect(err.reason).to.contain("sender is not on the allowlist");
//         }
//     });

//     it("can add multiple accounts to allow list, each activating a validator", async () => {
//         await addValidators(1, 9);
//         let web3Contract = new web3.eth.Contract(allowListContractAbi, allowListContract.address);
//         let validators = await web3Contract.methods.getValidators().call();
//         assert.equal(validators.length, 10);
//     });

//     it("constructor cannot be called without initial account", async () => {
//         try {
//             allowListContract = await AllowListContract.new([], [validators[0]], {from: accounts[0]});
//             assert.fail("no initial allowed accounts");
//         } catch (err) {
//             expect(err.reason).to.contain("no initial allowed accounts");
//         }
//     });

//     it("constructor cannot be called without initial validator", async () => {
//         try {
//             allowListContract = await AllowListContract.new([accounts[0]], [], {from: accounts[0]});
//             assert.fail("no initial validator accounts\"");
//         } catch (err) {
//             expect(err.reason).to.contain("no initial validator accounts");
//         }
//     });

//     it("constructor cannot be called with initial accounts smaller than initial validators", async () => {
//         try {
//             allowListContract = await AllowListContract.new([accounts[0]], [validators[0], validators[1]], {from: accounts[0]});
//             assert.fail("number of initial accounts smaller than number of initial validators");
//         } catch (err) {
//             expect(err.reason).to.contain("number of initial accounts smaller than number of initial validators");
//         }
//     });

//     it("constructor cannot be called with initial accounts of 0", async () => {
//         try {
//             allowListContract = await AllowListContract.new(['0x0000000000000000000000000000000000000000'], [validators[0]], {from: accounts[0]});
//             assert.fail("initial accounts cannot be zero");
//         } catch (err) {
//             expect(err.reason).to.contain("initial accounts cannot be zero");
//         }
//     });

//     it("constructor cannot be called with initial validators of 0", async () => {
//         try {
//             allowListContract = await AllowListContract.new([accounts[0]], ['0x0000000000000000000000000000000000000000'], {from: accounts[0]});
//             assert.fail("initial validators cannot be zero");
//         } catch (err) {
//             expect(err.reason).to.contain("initial validators cannot be zero");
//         }
//     });

//     it("allowedAccounts mappings validator index is updated correctly", async () => {
//         await addValidators(1, 1);

//         let numAllowedAccounts = await allowListContract.numAllowedAccounts();
//         assert.equal(numAllowedAccounts, 2);

//         await allowListContract.deactivate({from: accounts[0]});

//         const web3Contract = new web3.eth.Contract(allowListContractAbi, allowListContract.address);
//         let vals = await web3Contract.methods.getValidators().call({from: accounts[0]});
//         assert.equal(vals.length, 1);

//         await allowListContract.activate(validators[0], {from: accounts[1]});
//         vals = await web3Contract.methods.getValidators().call({from: accounts[0]});
//         assert.equal(vals.length, 1);
//         assert.equal(vals[0], validators[0]);
//     });

//     // assumes that accounts 0 to start-1 are allowed
//     // adds accounts [start] to [end] with activated validators [start] to [end]
//     async function addValidators(start, end) {
//         for (let i = start; i <= end; i++) {
//             for (let j = 0; j <= i/2; j++) {
//                 await allowListContract.voteToAddAccountToAllowList(accounts[i], {from: accounts[j]});
//             }
//             await allowListContract.countVotes(accounts[i]);
//             await allowListContract.activate(validators[i], {from: accounts[i]});
//         }
//     }
// });

