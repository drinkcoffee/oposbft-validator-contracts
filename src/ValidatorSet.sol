// Implementation of a contract to select validators using an allowlist

pragma solidity 0.8.19;

import "./IValidatorSet.sol";


/**
 * @dev This contract is not upgradeable. The approach to upgrade would be to deploy another 
 *      contract, set-up the stakes on that contract, and have the validator blockchain and the prover
 *      hard fork at a particular block to use the new contract address.
 */
contract ValidatorSet is IValidatorSet {
    struct ValidatorInfo {
        // Used for operating the consensus protocol.
        // Note that this address is used for signature verification of the signatures in the block header.
        // To make it easier for the prover to locate this storage location, it should be first in the data structure.
        address nodeAccount;
        // Used for adding and removing stake.
        address stakingAccount;
        // The amount of stake this validator has.
        uint256 stake;
        // Block number of last block produced by this validator.
        uint256 lastTimeBlockProducer;
    }


    error ValidatorNodeAlreadyAdded(uint256 _validatorIdOfNodeAccount);
    error StakerForOtherValidator(uint256 _validatorIdOfStakingAccount);
    error ValidatorNotConfigured(uint256 _stakerId);
    error BlockRewardAlreadyPaid(uint256 _blockNumber);
    error UnknownSlashingReason(address _validatorIdToSlash, uint256 _reason);



    uint256 public constant BLOCK_REWARD = 100;

    uint256 private constant SLASH_NO_BLOCKS_PRODUCED = 1;
    // SLashable inactivity time: one day of 2 second blocks.
    uint256 private constant BLOCK_PRODUCER_INACTIVITY = 43200; 
    // Slashable percentage: 10% per day for block producers not producing blocks.
    uint256 private constant BLOCK_PRODUCER_INACTIVITY_SPERCENT = 10; 


    // Mapping validator id => Validator Info.
    mapping (uint256 => ValidatorInfo) public validatorSet;

    // Mapping node account => validator id.
    mapping (address => uint256) public validatorSetByNodeAccount;

    // Mapping staking account => validator id.
    mapping (address => uint256) public validatorSetByStakingAccount;

    // Highest index of any validator that has ever existed.
    uint256 public nextNewValidatorId;

    // Total stake across all validators.
    uint256 public totalStake;

    // Block rewards yet to be paid out.
    mapping (address => uint256) pendingBlockRewards;


    // The latest block that the block reward has been paid up to.
    // Used to stop block rewards being claimed twice for the same block.
    uint256 public blockNumberBlockRewardPaidUpTo;


    // TODO only validator controller
    function addValidator(address _nodeAccount, address _stakingAccount, uint256 stake) external returns (uint256) {
        uint256 validatorIdOfNodeAccount = validatorSetByNodeAccount[_initialInfo.nodeAccount];
        if (validatorIdOfNodeAccount != 0) {
            revert ValidatorNodeAlreadyAdded(validatorIdOfNodeAccount);
        }
        uint256 validatorIdOfStakingAccount = validatorSetByStakingAccount[_initialInfo.stakingAccount];
        if (validatorIdOfStakingAccount != 0) {
            revert StakerForOtherValidator(validatorIdOfStakingAccount);
        }

        uint256 oldNextNewValidatorId = nextNewValidatorId++;
        ValidatorInfo storage valInfo = validatorSet[oldNextNewValidatorId];
        valInfo.nodeAccount = _nodeAccount;
        valInfo.stakingAccount = _stakingAccount;
        valInfo.stake = _stake;
        valInfo.lastTimeBlockProducer = block.number;
        validatorSetByNodeAccount[_initialInfo.nodeAccount] = oldNextNewValidatorId;
        validatorSetByStakingAccount[_initialInfo.stakingAccount] = oldNextNewValidatorId;
        totalStake += _initialInfo.stake;
    }


    // TODO only validator controller
    function stake(uint256 _stakerId, uint256 _newStake) external {
        if (validatorSet[_stakerId].stakerAccount == address(0)) {
            revert ValidatorNotConfigured(_stakerId);
        }
        validatorSet[_stakerId].stake += _newStake;
        totalStake += _newStake;
    }

    // TODO only staker account
    function requestUnstake() external {
        // TODO allow up to the amount currently staked and not in the withdrawal queue to be unstaked.
        // TODO stake can still be slashed at this point. Validator still needs to operate node.

    }

    // TODO how does this work when withdrawal period has passed. Don't want to allow instant unstake.

    function withdrawalStake() external {
        // Allow unstaked stake that has been in the withdrawal queue to be withdrawn.
    }


    function slash(address _validatorIdToSlash, uint256 _reason) external {
        if (_reason == SLASH_NO_BLOCKS_PRODUCED) {
            if (validatorSet[_validatorIdToSlash].lastTimeBlockProducer + BLOCK_PRODUCER_INACTIVITY < block.number) {
                uint256 amount = validatorSet[_validatorIdToSlash].stake * BLOCK_PRODUCER_INACTIVITY_SPERCENT / 100;
                _slash(_validatorIdToSlash, amount);
                // Update when the validator produced its more recent block so it can't be slashed twice in one day.
                validatorSet[_validatorIdToSlash].lastTimeBlockProducer = block.number;
            }
        }
        else {
            revert UnknownSlashingReason(_validatorIdToSlash, _reason);
        }

    }

    function payBlockReward() external {
        if (blockNumberBlockRewardPaidUpTo == block.number) {
            revert BlockRewardAlreadyPaid(block.number);
        }
        // Indicate the block reward has been paid.
        blockNumberBlockRewardPaidUpTo = block.number;

        // Determine the staker account associated with the validator node account.
        uint256 validatorId = validatorSetByNodeAccount[block.coinbase];
        address staker = validatorSet[validatorId].stakerAccount;

        // Pay the block reward.
        uint256 amount = BLOCK_REWARD;
        pendingBlockRewards[staker] += amount;

        // Update when this validator produced its more recent block.
        validatorSet[validatorId].lastTimeBlockProducer = block.number;
    }

    function withdrawBlockRewards() external {
        uint256 amount = pendingBlockRewards[msg.sender];
        // Zero before sending to prevent re-entrancy attacks.
        pendingBlockRewards[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }



    function getValidators() override external view returns (Validator[] memory) {
        uint256 numActiveValidators = 
        return validators;
    }

    function getWithdrawableStake(address _staker) external view returns (uint256) {

    }


    function _slash(uint256 _validatorId, uint256 _amount) private {
        // TODO communicate with controller

    }

    function _decreaseStake(uint256 _validatorId, uint256 _amount) private {
        // TODO communicate with controller
    }

}
