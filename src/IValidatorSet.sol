// Interface for contracts used to select validators 
  
pragma solidity 0.8.19;
  
interface IValidatorSet {
    struct Validator {
        // Validator node account used for consensus.
        address nodeAccount;
        // Relative stake of this validator node.
        uint256 stake;
    }

    function getValidators() external view returns (Validator[] memory);

}
