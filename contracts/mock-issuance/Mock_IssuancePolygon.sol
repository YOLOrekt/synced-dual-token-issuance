/**

For unit testing - overwriting FxBaseChildTunnel external functions

**/

pragma solidity 0.8.4;

import {IERC20} from "../tokens-base/IERC20.sol";
import {YoloPolygonUtilityTokens} from "../core/YoloPolygonUtilityTokens.sol";
// import {Mock_FxBaseChildTunnel} from "../mock-fx/Mock_FxBaseChildTunnel.sol";
import {IssuancePolygon} from "../issuance/IssuancePolygon.sol";
import {Mock_IssuanceEthereum} from "./Mock_IssuanceEthereum.sol";

contract Mock_IssuancePolygon is IssuancePolygon {
    Mock_IssuanceEthereum mockIssuanceEthereumContract;

    constructor(
        address yoloPolygonTokenAddress_,
        address mEthTokenContract_,
        address fxChild_
    ) IssuancePolygon(yoloPolygonTokenAddress_, mEthTokenContract_, fxChild_) {}

    function setMockIssuanceEthereumContract(
        address _mockIssuanceEthereumContract
    ) external restricted returns (bool) {
        mockIssuanceEthereumContract = Mock_IssuanceEthereum(
            _mockIssuanceEthereumContract
        );

        return true;
    }

    // TODO: decided if anyone can call
    // This function computes the share of each contributor and sends the token to TimeLock contract
    // function closeContributionWindow()
    //     external
    //     override
    //     restricted
    //     returns (bool)
    // {
    //     hasContributionWindowClosed = true;
    //     emit ContributionWindowClosed(msg.sender, childSum);

    //     // TODO: sendMessageToRoot - on Call.
    //     sendMessageToRoot();

    //     return true;
    // }

    // // TODO: decide if anyone can call
    // function sendMessageToRoot() public override restricted {
    //     require(
    //         hasContributionWindowClosed == true,
    //         "cannot send child contribution sum until contribution window closed"
    //     );
    //     bytes memory message = abi.encode(childSum);
    //     mockIssuanceEthereumContract.receiveMessage(message);
    //     isMessageSentToRoot = true;
    // }

    // function openRedemptionRegime() external override returns (bool) {
    //     // Which will unlock once the product goes live.
    //     require(
    //         hasContributionWindowClosed == true,
    //         "issuance window must be closed"
    //     );
    //     require(isMessageSentToRoot == true, "childSum must be sent to root");
    //     require(
    //         msg.sender == owner ||
    //             block.timestamp > contributionStartTimestamp + 60 days,
    //         "cannot open redemption window unless owner or 60 days since deployment"
    //     );

    //     uint256 tokensAllocated = yoloPolygonTokenContract.balanceOf(
    //         address(this)
    //     );

    //     require(
    //         tokensAllocated > 0,
    //         "child issuance contract must receive tokens first"
    //     );

    //     childIssuanceAllocatedTokens = tokensAllocated;
    //     isRedemptionRegimeOpen = true;
    //     // redemptionWindowTimestamp = block.timestamp;
    //     emit RedemptionWindowOpened(
    //         msg.sender,
    //         childSum,
    //         childIssuanceAllocatedTokens
    //     );

    //     return true;
    // }

    // TODO: either allow them to withdraw or use "make love not war" pattern
    function redeemTokens() external override returns (bool) {
        // Which will unlock once the product goes live.
        require(
            isRedemptionRegimeOpen == true,
            "redemption window is not open yet"
        );
        require(claimsCheck[msg.sender] == false, "prior claim executed");
        claimsCheck[msg.sender] = true;

        uint256 claimAmount = (contributorAmounts[msg.sender] *
            childIssuanceAllocatedTokens) / childSum;

        yoloPolygonTokenContract.transfer(msg.sender, claimAmount);

        // TODO: Set it zero? Replace claimsCheck bools? Any reasons we should or shoudn't set it zero.
        contributorAmounts[msg.sender] = 0;

        emit TokensRedeemed(msg.sender, claimAmount);

        return true;
    }
}
