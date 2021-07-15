/**

For unit testing - overwriting FxBaseRootTunnel external calls and POS token tfr call

**/

pragma solidity ^0.8.0;

import "../core/YoloEthereumUtilityTokens.sol";
import {IRootChainManager} from "../fx-portal/IRootChainManager.sol";
import {IssuanceCommon} from "../issuance/IssuanceCommon.sol";
import {IssuanceEthereum} from "../issuance/IssuanceEthereum.sol";

// TODO: add FxBaseRootTunnel contract deployed by matic to read to and from matic chain

contract Mock_IssuanceEthereum is IssuanceEthereum {
    constructor(
        address yoloEthereumTokenAddress_,
        address checkpointManager_,
        address fxRoot_,
        address fxChildTunnel_,
        address rootChainManager_,
        address predicateContractAddress_
    )
        IssuanceEthereum(
            yoloEthereumTokenAddress_,
            checkpointManager_,
            fxRoot_,
            fxChildTunnel_,
            rootChainManager_,
            predicateContractAddress_
        )
    {}

    function receiveMessage(bytes memory inputData) public override {
        // critical validation takes place here, mock input directly
        bytes memory message = inputData;
        _processMessageFromChild(message);
    }

    // for reference
    // function _processMessageFromChild(bytes memory data)
    //     internal
    //     override
    // {
    //     childSum = abi.decode(data, (uint256));
    //     hasProcessedMessageFromChild = true;
    // }

    // function depositOnChildIssuanceContract()
    //     external
    //     override
    //     restricted
    //     returns (bool)
    // {
    //     require(
    //         hasProcessedMessageFromChild == true,
    //         "childSum must be processed from child first"
    //     );

    //     require(
    //         hasContributionWindowClosed == true,
    //         "contribution window must be closed"
    //     );
    //     require(
    //         hasRootToChildTransferRequest == false,
    //         "root to child transfer already requested"
    //     );
    //     require(
    //         predicateContractAddress != address(0),
    //         "predicate contract address must be set"
    //     );

    //     // expressions can overflow, assign sum first
    //     uint256 totalCrossChainSum = rootSum + childSum;
    //     uint256 childTokenAmount = (TOTAL_ISSUANCE_CONTRACT_TOKENS * childSum) /
    //         totalCrossChainSum;

    //     rootIssuanceAllocatedTokens =
    //         TOTAL_ISSUANCE_CONTRACT_TOKENS -
    //         childTokenAmount;

    //     yoloEthereumTokenContract.approve(
    //         predicateContractAddress,
    //         childTokenAmount
    //     );

    //     bytes memory encodedChildAmount = abi.encode(childTokenAmount);

    //     rootChainManagerContract.depositFor(
    //         fxChildTunnel,
    //         address(yoloEthereumTokenContract),
    //         encodedChildAmount
    //     );

    //     hasRootToChildTransferRequest = true;

    //     return true;
    // }
}
