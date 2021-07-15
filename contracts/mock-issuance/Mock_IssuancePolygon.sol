/**

For unit testing

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
}
