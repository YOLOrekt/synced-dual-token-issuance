
const fs = require('fs')

const configs = {
    Main: {
    NetworkName: "Goerli",
    ChainId: 5,
    DaggerEndpoint: "wss://goerli.dagger.matic.network",
    WatcherAPI: "https://mumbai-watcher.api.matic.today/api/v1",
    StakingAPI: "https://mumbai-watcher.api.matic.today/api/v1",
    Explorer: "https://goerli.etherscan.io",
    Contracts: {
    BytesLib: "0xde5807d201788dB32C38a6CE0F11d31b1aeB822a",
    Common: "0x84Dc17F28658Bc74125C7E82299992429ED34c12",
    ECVerify: "0xccd1d8d16F462f9d281024CBD3eF52BADB10131C",
    Merkle: "0xCD87Be2Df3de01EA23666c97104613ec252300E8",
    MerklePatriciaProof: "0x3a0Db8fa2805DEcd49cCAa839DaC15455498EDE2",
    PriorityQueue: "0xD26361204b8e4a4bb16668bfE7A1b9106AD17140",
    RLPEncode: "0xDE0D18799a20f29d9618f8DDbf4c2b029FAdc491",
    RLPReader: "0xA5e463c187E53da5b193E2beBca702e9fEeA3738",
    SafeMath: "0x1bEb355BE0577E61870C4c57DAaa6e2129dd0604",
    Governance: "0x03Ac67D03A06571A059F20425FFD1BEa300d98C2",
    GovernanceProxy: "0xAcdEADEE4c054A86F5b1e8705126b30Ec999899B",
    Registry: "0xeE11713Fe713b2BfF2942452517483654078154D",
    RootChain: "0xCe29AEdCdBeef0b05066316013253beACa7A6268",
    RootChainProxy: "0x2890bA17EfE978480615e330ecB65333b880928e",
    ValidatorShareFactory: "0x5737AD9095AB4d55FeE7F972ea7F86734695E3c1",
    StakingInfo: "0x29C40836C17f22d16a7fE953Fb25DA670C96d69E",
    StakingNFT: "0x532c7020E0F3666f9440B8B9d899A9763BCc5dB7",
    StakeManager: "0x63FE73ceAf99878225510563247cb97701ae4710",
    StakeManagerProxy: "0x00200eA4Ee292E253E6Ca07dBA5EdC07c8Aa37A3",
    SlashingManager: "0xDD17DE137c7Cc288E022fE95a3B398C94BDd5b83",
    ValidatorShare: "0xb6d4B5893729601759be67ed98896EF928e5EC88",
    StateSender: "0xEAa852323826C71cd7920C3b4c007184234c3945",
    DepositManager: "0x20339c5Ea91D680E681B9374Fc0a558D5b96a026",
    DepositManagerProxy: "0x7850ec290A2e2F40B82Ed962eaf30591bb5f5C96",
    WithdrawManager: "0x82A0Aafac8D34645f2c681a88b2874aeC8ac5d61",
    ExitNFT: "0xE2Ab047326B38e4DDb6791551e8d593D30E02724",
    WithdrawManagerProxy: "0x2923C8dD6Cdf6b2507ef91de74F1d5E0F11Eac53",
    ERC20Predicate: "0x033a0A06dc6e78a518003C81B64f9CA80A55cb06",
    ERC721Predicate: "0xDbBffd69Ef9F34bA8Fb8722157A51a4733992B35",
    Tokens: {
    MaticToken: "0x499d11E0b6eAC7c0593d8Fb292DCBbF815Fb29Ae",
    TestToken: "0x3f152B63Ec5CA5831061B2DccFb29a874C317502",
    RootERC721: "0xfA08B72137eF907dEB3F202a60EfBc610D2f224b",
    MaticWeth: "0x60D4dB9b534EF9260a88b0BED6c486fe13E604Fc"
    }
    },
    POSContracts: {
    Merkle: "0x0ef207185e0c1631beb5514eb76501dd16ff9258",
    MerklePatriciaProof: "0xfa76e5b10a0131573176bd2802535b4a9e76fecb",
    RLPReader: "0x383b6b577298a35fd8ee18536d3915db6039468f",
    SafeERC20: "0xcf0902e21c85ba20633c89523c9a0bfa04de3ec5",
    RootChainManager: "0x8829EC24A1BcaCdcF4a3CBDE3A4498172e9FCDcE",
    RootChainManagerProxy: "0xBbD7cBFA79faee899Eaf900F13C9065bF03B1A74",
    DummyStateSender: "0x4Ad6FFD6D9b49E832e5ac56f5aEcaB137F9F91C6",
    ERC20Predicate: "0x07f76e8EfaEAe05cb093AC79740e3546dC03FA93",
    ERC20PredicateProxy: "0xdD6596F2029e6233DEFfaCa316e6A95217d4Dc34",
    ERC721Predicate: "0xb9B40c5a9614A40148cd11A494b00EE8E6f486E3",
    ERC721PredicateProxy: "0x74D83801586E9D3C4dc45FfCD30B54eA9C88cf9b",
    ERC1155Predicate: "0xe57f31d0E1320E5C69bC000044BD155Df3fe4FeE",
    ERC1155PredicateProxy: "0xB19a86ba1b50f0A395BfdC3557608789ee184dC8",
    EtherPredicate: "0xd8AA0d2C537137916E6A0ea4b2AFE96188884a84",
    EtherPredicateProxy: "0xe2B01f3978c03D6DdA5aE36b2f3Ac0d66C54a6D5",
    MintableERC20Predicate: "0x21b018b6FA1A563B25ff3E19F814B09dFdC83067",
    MintableERC20PredicateProxy: "0x37c3bfC05d5ebF9EBb3FF80ce0bd0133Bf221BC8",
    MintableERC721Predicate: "0x90445D7f2838198Dc8c034ac7F365E5d6144c90C",
    MintableERC721PredicateProxy: "0x56E14C4C1748a818a5564D33cF774c59EB3eDF59",
    MintableERC1155Predicate: "0xbeBB933Fb0e6D60083d8E53b162544B2d63CD372",
    MintableERC1155PredicateProxy: "0x72d6066F486bd0052eefB9114B66ae40e0A6031a",
    Tokens: {
    DummyERC20: "0x655F2166b0709cd575202630952D71E2bB0d61Af",
    DummyERC721: "0x084297B12F204Adb74c689be08302FA3f12dB8A7",
    DummyERC1155: "0x2e3Ef7931F2d0e4a7da3dea950FF3F19269d9063",
    DummyMintableERC20: "0x6668BfceC8F6fE54B57Da04D487d1fC95FEd78cb",
    DummyMintableERC721: "0xFf3aD71e6323dD584348d3E5FfFD4d07d82a2355",
    DummyMintableERC1155: "0x9f5755D47fB80100E7ee65Bf7e136FCA85Dd9334"
    }
    }
    },
    Matic: {
    NetworkName: "Mumbai Testnet",
    ChainId: 80001,
    RPC: "https://rpc-mumbai.matic.today",
    DaggerEndpoint: "wss://mumbai-dagger.matic.today",
    Explorer: "https://mumbai-explorer.matic.today",
    NetworkAPI: "https://apis.matic.network/api/v1/mumbai",
    Contracts: {
    ChildChain: "0x1EDd419627Ef40736ec4f8ceffdE671a30803c5e",
    Tokens: {
    MaticWeth: "0x4DfAe612aaCB5b448C12A591cD0879bFa2e51d62",
    MaticToken: "0x0000000000000000000000000000000000001010",
    TestToken: "0x2d7882beDcbfDDce29Ba99965dd3cdF7fcB10A1e",
    RootERC721: "0x33FC58F12A56280503b04AC7911D1EceEBcE179c"
    }
    },
    POSContracts: {
    ChildChainManager: "0x2e5e27d50EFa501D90Ad3638ff8441a0C0C0d75e",
    ChildChainManagerProxy: "0xb5505a6d998549090530911180f38aC5130101c6",
    Tokens: {
    DummyERC20: "0xfe4F5145f6e09952a5ba9e956ED0C25e3Fa4c7F1",
    DummyERC721: "0x757b1BD7C12B81b52650463e7753d7f5D0565C0e",
    DummyERC1155: "0xA07e45A987F19E25176c877d98388878622623FA",
    DummyMintableERC20: "0x4d350e8A3C0D57714d3b80c9e2030ab8f1Bb7875",
    DummyMintableERC721: "0xd854928B54c408F1D38D869BE744c9E6Ce0A2448",
    DummyMintableERC1155: "0xfAc5F13459EB4241D2C3F8BbfC2789FC006BCBc8",
    MaticWETH: "0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa"
    }
    },
    GenesisContracts: {
    BorValidatorSet: "0000000000000000000000000000000000001000",
    StateReceiver: "0000000000000000000000000000000000001001"
    }
    },
    Heimdall: {
    ChainId: "heimdall-80001",
    API: "https://heimdall.api.matic.today"
    }
}

const configJSON = JSON.stringify(configs)

fs.writeFileSync('./configs/polygon.json', configJSON)