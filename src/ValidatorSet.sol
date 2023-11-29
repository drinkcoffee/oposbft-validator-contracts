// Implementation of a contract to select validators using an allowlist

pragma solidity 0.8.19;

import "./IValidatorSet.sol";


// TODO needs to be upgradeable
contract ValidatorSet is IValidatorSet {
    struct ValidatorInfo {
        // The amount of stake this validator has.
        uint256 stake;
        // Used for operating the consensus protocol.
        address nodeAccount;
        // Used for adding and removing stake.
        address stakingAccount;
        // Block number of last block produced by this validator.
        uint256 lastTimeBlockProducer;
    }


    error ValidatorNodeAlreadyAdded(uint256 _validatorIdOfNodeAccount);
    error StakerForOtherValidator(uint256 _validatorIdOfStakingAccount);
    error StakerNotConfigured(uint256 _stakerId);
    error BlockRewardAlreadyPaid(uint256 _blockNumber);


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
    function addValidator(ValidatorInfo calldata _initialInfo) external returns (uint256) {
        uint256 validatorIdOfNodeAccount = validatorSetByNodeAccount[_initialInfo.nodeAccount];
        if (validatorIdOfNodeAccount != 0) {
            revert ValidatorNodeAlreadyAdded(validatorIdOfNodeAccount);
        }
        uint256 validatorIdOfStakingAccount = validatorSetByStakingAccount[_initialInfo.stakingAccount];
        if (validatorIdOfStakingAccount != 0) {
            revert StakerForOtherValidator(validatorIdOfStakingAccount);
        }

        uint256 oldNextNewValidatorId = nextNewValidatorId++;
        validatorSet[oldNextNewValidatorId] = _initialInfo;
        validatorSetByNodeAccount[_initialInfo.nodeAccount] = oldNextNewValidatorId;
        validatorSetByStakingAccount[_initialInfo.stakingAccount] = oldNextNewValidatorId;
        totalStake += _initialInfo.stake;
    }


    // TODO only validator controller
    function depositStake(uint256 _stakerId, uint256 _newStake) external {
        if (validatorSet[_stakerId].stakerAccount == address(0)) {
            revert StakerNotConfigured(_stakerId);
        }
        validatorSet[_stakerId].stake += _newStake;
        totalStake += _newStake;
    }

    // TODO only staker account
    function withdrawStake() external {
        // if (validators[_stakerId].staking == 0) {
        //     revert StakerNotConfigured(_stakerId);
        // }

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



    function getValidators() override external view returns (address[] memory) {
        return validators;
    }


    function _slash(uint256 _validatorId, uint256 _amount) private {

    }

    function _decreaseStake(uint256 _validatorId, uint256 _amount) private {

    }

}
