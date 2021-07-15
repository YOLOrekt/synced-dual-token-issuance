/**

YOLOrekt Token Issuance - 

YOLOrekt is issuing 5% of the 1 Billion total supply to raise capital to provide in-game liquidity. 
This contracts accepts matic wEth (wEth) token contributions for acquiring early YOLO tokens at a price that 
is determined at contribution close by calculating proportion of funds raised on the polygon child chain 
with respect to the Ethereum root chain and bridging the appropriate share of YOLO tokens to the 
child issuance contract (IssuancePolygon) for redemption by the contributors.

https://yolorekt.com 

Authors :
Garen Vartanian
Yogesh Srihari 

**/

pragma solidity 0.8.4;

import {IERC20} from "../tokens-base/IERC20.sol";
import {YoloPolygonUtilityTokens} from "../core/YoloPolygonUtilityTokens.sol";
import {FxBaseChildTunnel} from "../fx-portal/tunnel/FxBaseChildTunnel.sol";
import {IssuanceCommon} from "./IssuanceCommon.sol";

contract IssuancePolygon is IssuanceCommon, FxBaseChildTunnel {
    // Contribution Sum on Polygon Side
    uint256 public childSum;
    // Proportion of tokens transferred to polygon issuance contract
    uint256 public childIssuanceAllocatedTokens;

    // After ending token issuance, sum is sent to the root and flag to record the state.
    bool public isMessageSentToRoot;

    // YOLOrekt ERC20 contract
    YoloPolygonUtilityTokens public yoloPolygonTokenContract;

    // Contribution is Erc20 mEth
    IERC20 public mEthTokenContract;

    // Data coming from the Root(IssuanceEthereum) To Child (IssuancePolygon) messaging
    // uint256 public latestStateId;
    // address public latestRootMessageSender;
    // bytes public latestData;

    constructor(
        address yoloPolygonTokenAddress_,
        address mEthTokenContractAddress_,
        address fxChild_
    ) FxBaseChildTunnel(fxChild_) {
        require(
            yoloPolygonTokenAddress_ != address(0),
            "YOLO polygon token contract address must be specified"
        );
        require(
            mEthTokenContractAddress_ != address(0),
            "mEth token contract address must be specified"
        );
        require(
            fxChild_ != address(0),
            "fxChild contract address must be specified"
        );

        yoloPolygonTokenContract = YoloPolygonUtilityTokens(
            yoloPolygonTokenAddress_
        );
        mEthTokenContract = IERC20(mEthTokenContractAddress_);
    }

    // just in case
    function setYoloPolygonTokenContract(address _yoloPolygonTokenAddress)
        public
        restricted
    {
        require(
            _yoloPolygonTokenAddress != address(0),
            "YOLO polygon token contract address must be specified"
        );
        yoloPolygonTokenContract = YoloPolygonUtilityTokens(
            _yoloPolygonTokenAddress
        );
    }

    // just in case
    function setMEthTokenContract(address _mEthTokenContractAddress)
        public
        restricted
    {
        require(
            _mEthTokenContractAddress != address(0),
            "mEth token contract address must be specified"
        );
        mEthTokenContract = IERC20(_mEthTokenContractAddress);
    }

    function openContributionWindow()
        external
        override
        restricted
        returns (bool)
    {
        require(
            yoloPolygonTokenContract.balanceOf(address(this)) == 0,
            "No tokens must be transferred to issuance contract before issuance is started"
        );
        require(
            isContributionWindowOpen == false,
            "contribution window already opened"
        );

        isContributionWindowOpen = true;
        contributionStartTimestamp = block.timestamp;
        emit ContributionWindowOpened(msg.sender);

        return true;
    }

    function contribute(uint256 mEthAmount) public returns (bool) {
        require(
            isContributionWindowOpen == true,
            "contribution window has not opened"
        );
        require(
            isContributionWindowClosed == false,
            "contribution window has closed"
        );
        require(mEthAmount >= 0.01 ether, "minimum contribution is 0.01 ether");

        require(
            mEthAmount <=
                mEthTokenContract.allowance(msg.sender, address(this)),
            "contributor must approve issuance contract via mEth token contract in order to contribute tokens"
        );

        uint256 contributorTotal = contributorAmounts[msg.sender] + mEthAmount;

        mEthTokenContract.transferFrom(msg.sender, address(this), mEthAmount);
        contributorAmounts[msg.sender] = contributorTotal;

        // Fixed Here - Check again
        childSum += mEthAmount;

        emit ContributionMade(msg.sender, mEthAmount);

        return true;
    }

    // !!! Added virtual for unit testing !!!
    function closeContributionWindow()
        external
        virtual
        override
        restricted
        returns (bool)
    {
        require(
            isContributionWindowOpen == true,
            "contribution window must be open before closing"
        );

        isContributionWindowClosed = true;
        emit ContributionWindowClosed(msg.sender, childSum);

        bytes memory message = abi.encode(childSum);
        _sendMessageToRoot(message);
        isMessageSentToRoot = true;

        return true;
    }

    // !!! Added virtual for unit testing !!!
    // function sendMessageToRoot() internal virtual {
    //     require(
    //         isContributionWindowClosed == true,
    //         "cannot send child contribution sum until contribution window closed"
    //     );
    //     bytes memory message = abi.encode(childSum);
    //     _sendMessageToRoot(message);
    //     isMessageSentToRoot = true;
    // }

    // !!! Add virtual for unit testing !!!
    function openRedemptionRegime() external virtual override returns (bool) {
        // Which will unlock once the product goes live.
        require(
            isContributionWindowClosed == true,
            "contribution window must be closed"
        );
        require(isMessageSentToRoot == true, "childSum must be sent to root");
        require(
            msg.sender == owner ||
                block.timestamp > contributionStartTimestamp + 60 days,
            "cannot open redemption window unless owner or 60 days since deployment"
        );

        uint256 tokensAllocated = yoloPolygonTokenContract.balanceOf(
            address(this)
        );

        require(
            tokensAllocated > 0,
            "child issuance contract must receive tokens first"
        );
        require(
            isRedemptionRegimeOpen == false,
            "redemption regime already open"
        );

        childIssuanceAllocatedTokens = tokensAllocated;
        isRedemptionRegimeOpen = true;

        emit RedemptionWindowOpened(
            msg.sender,
            childSum,
            childIssuanceAllocatedTokens
        );

        return true;
    }

    // !!! Added virtual for unit testing !!!
    function redeemTokens() external virtual override returns (bool) {
        require(
            isRedemptionRegimeOpen == true,
            "redemption window is not open yet"
        );
        require(claimsCheck[msg.sender] == false, "prior claim executed");

        claimsCheck[msg.sender] = true;

        uint256 claimAmount = (contributorAmounts[msg.sender] *
            childIssuanceAllocatedTokens) / childSum;

        contributorAmounts[msg.sender] = 0;

        yoloPolygonTokenContract.transfer(msg.sender, claimAmount);
        emit TokensRedeemed(msg.sender, claimAmount);

        return true;
    }

    function migrateInvestmentFund(address recipient)
        external
        restricted
        validateRecipient(recipient)
        returns (bool)
    {
        require(
            isContributionWindowClosed == true,
            "contribution window must be closed"
        );

        uint256 contractBalance = mEthTokenContract.balanceOf(address(this));
        mEthTokenContract.transfer(recipient, contractBalance);
        emit InvestmentFundTransferred(recipient, contractBalance);

        return true;
    }

    // !!! should be unused !!!
    // Implemented but should be unused
    function _processMessageFromRoot(
        uint256 stateId,
        address sender,
        bytes memory data
    ) internal override validateSender(sender) {
        // latestStateId = stateId;
        // latestRootMessageSender = sender;
        // latestData = data;
    }
}
