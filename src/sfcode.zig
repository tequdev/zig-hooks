pub const FieldCode = enum(u32) {
    CloseResolution = (16 << 16) + 1,
    Method = (16 << 16) + 2,
    TransactionResult = (16 << 16) + 3,
    TickSize = (16 << 16) + 16,
    UNLModifyDisabling = (16 << 16) + 17,
    HookResult = (16 << 16) + 18,
    LedgerEntryType = (1 << 16) + 1,
    TransactionType = (1 << 16) + 2,
    SignerWeight = (1 << 16) + 3,
    TransferFee = (1 << 16) + 4,
    Version = (1 << 16) + 16,
    HookStateChangeCount = (1 << 16) + 17,
    HookEmitCount = (1 << 16) + 18,
    HookExecutionIndex = (1 << 16) + 19,
    HookApiVersion = (1 << 16) + 20,
    NetworkID = (2 << 16) + 1,
    Flags = (2 << 16) + 2,
    SourceTag = (2 << 16) + 3,
    Sequence = (2 << 16) + 4,
    PreviousTxnLgrSeq = (2 << 16) + 5,
    LedgerSequence = (2 << 16) + 6,
    CloseTime = (2 << 16) + 7,
    ParentCloseTime = (2 << 16) + 8,
    SigningTime = (2 << 16) + 9,
    Expiration = (2 << 16) + 10,
    TransferRate = (2 << 16) + 11,
    WalletSize = (2 << 16) + 12,
    OwnerCount = (2 << 16) + 13,
    DestinationTag = (2 << 16) + 14,
    HighQualityIn = (2 << 16) + 16,
    HighQualityOut = (2 << 16) + 17,
    LowQualityIn = (2 << 16) + 18,
    LowQualityOut = (2 << 16) + 19,
    QualityIn = (2 << 16) + 20,
    QualityOut = (2 << 16) + 21,
    StampEscrow = (2 << 16) + 22,
    BondAmount = (2 << 16) + 23,
    LoadFee = (2 << 16) + 24,
    OfferSequence = (2 << 16) + 25,
    FirstLedgerSequence = (2 << 16) + 26,
    LastLedgerSequence = (2 << 16) + 27,
    TransactionIndex = (2 << 16) + 28,
    OperationLimit = (2 << 16) + 29,
    ReferenceFeeUnits = (2 << 16) + 30,
    ReserveBase = (2 << 16) + 31,
    ReserveIncrement = (2 << 16) + 32,
    SetFlag = (2 << 16) + 33,
    ClearFlag = (2 << 16) + 34,
    SignerQuorum = (2 << 16) + 35,
    CancelAfter = (2 << 16) + 36,
    FinishAfter = (2 << 16) + 37,
    SignerListID = (2 << 16) + 38,
    SettleDelay = (2 << 16) + 39,
    TicketCount = (2 << 16) + 40,
    TicketSequence = (2 << 16) + 41,
    NFTokenTaxon = (2 << 16) + 42,
    MintedNFTokens = (2 << 16) + 43,
    BurnedNFTokens = (2 << 16) + 44,
    HookStateCount = (2 << 16) + 45,
    EmitGeneration = (2 << 16) + 46,
    LockCount = (2 << 16) + 47,
    RewardTime = (2 << 16) + 98,
    RewardLgrFirst = (2 << 16) + 99,
    RewardLgrLast = (2 << 16) + 100,
    IndexNext = (3 << 16) + 1,
    IndexPrevious = (3 << 16) + 2,
    BookNode = (3 << 16) + 3,
    OwnerNode = (3 << 16) + 4,
    BaseFee = (3 << 16) + 5,
    ExchangeRate = (3 << 16) + 6,
    LowNode = (3 << 16) + 7,
    HighNode = (3 << 16) + 8,
    DestinationNode = (3 << 16) + 9,
    Cookie = (3 << 16) + 10,
    ServerVersion = (3 << 16) + 11,
    NFTokenOfferNode = (3 << 16) + 12,
    EmitBurden = (3 << 16) + 13,
    HookInstructionCount = (3 << 16) + 17,
    HookReturnCode = (3 << 16) + 18,
    ReferenceCount = (3 << 16) + 19,
    RewardAccumulator = (3 << 16) + 100,
    EmailHash = (4 << 16) + 1,
    TakerPaysCurrency = (10 << 16) + 1,
    TakerPaysIssuer = (10 << 16) + 2,
    TakerGetsCurrency = (10 << 16) + 3,
    TakerGetsIssuer = (10 << 16) + 4,
    LedgerHash = (5 << 16) + 1,
    ParentHash = (5 << 16) + 2,
    TransactionHash = (5 << 16) + 3,
    AccountHash = (5 << 16) + 4,
    PreviousTxnID = (5 << 16) + 5,
    LedgerIndex = (5 << 16) + 6,
    WalletLocator = (5 << 16) + 7,
    RootIndex = (5 << 16) + 8,
    AccountTxnID = (5 << 16) + 9,
    NFTokenID = (5 << 16) + 10,
    EmitParentTxnID = (5 << 16) + 11,
    EmitNonce = (5 << 16) + 12,
    EmitHookHash = (5 << 16) + 13,
    BookDirectory = (5 << 16) + 16,
    InvoiceID = (5 << 16) + 17,
    Nickname = (5 << 16) + 18,
    Amendment = (5 << 16) + 19,
    HookOn = (5 << 16) + 20,
    Digest = (5 << 16) + 21,
    Channel = (5 << 16) + 22,
    ConsensusHash = (5 << 16) + 23,
    CheckID = (5 << 16) + 24,
    ValidatedHash = (5 << 16) + 25,
    PreviousPageMin = (5 << 16) + 26,
    NextPageMin = (5 << 16) + 27,
    NFTokenBuyOffer = (5 << 16) + 28,
    NFTokenSellOffer = (5 << 16) + 29,
    HookStateKey = (5 << 16) + 30,
    HookHash = (5 << 16) + 31,
    HookNamespace = (5 << 16) + 32,
    HookSetTxnID = (5 << 16) + 33,
    OfferID = (5 << 16) + 34,
    EscrowID = (5 << 16) + 35,
    URITokenID = (5 << 16) + 36,
    Amount = (6 << 16) + 1,
    Balance = (6 << 16) + 2,
    LimitAmount = (6 << 16) + 3,
    TakerPays = (6 << 16) + 4,
    TakerGets = (6 << 16) + 5,
    LowLimit = (6 << 16) + 6,
    HighLimit = (6 << 16) + 7,
    Fee = (6 << 16) + 8,
    SendMax = (6 << 16) + 9,
    DeliverMin = (6 << 16) + 10,
    MinimumOffer = (6 << 16) + 16,
    RippleEscrow = (6 << 16) + 17,
    DeliveredAmount = (6 << 16) + 18,
    NFTokenBrokerFee = (6 << 16) + 19,
    HookCallbackFee = (6 << 16) + 20,
    LockedBalance = (6 << 16) + 21,
    PublicKey = (7 << 16) + 1,
    MessageKey = (7 << 16) + 2,
    SigningPubKey = (7 << 16) + 3,
    TxnSignature = (7 << 16) + 4,
    URI = (7 << 16) + 5,
    Signature = (7 << 16) + 6,
    Domain = (7 << 16) + 7,
    FundCode = (7 << 16) + 8,
    RemoveCode = (7 << 16) + 9,
    ExpireCode = (7 << 16) + 10,
    CreateCode = (7 << 16) + 11,
    MemoType = (7 << 16) + 12,
    MemoData = (7 << 16) + 13,
    MemoFormat = (7 << 16) + 14,
    Fulfillment = (7 << 16) + 16,
    Condition = (7 << 16) + 17,
    MasterSignature = (7 << 16) + 18,
    UNLModifyValidator = (7 << 16) + 19,
    ValidatorToDisable = (7 << 16) + 20,
    ValidatorToReEnable = (7 << 16) + 21,
    HookStateData = (7 << 16) + 22,
    HookReturnString = (7 << 16) + 23,
    HookParameterName = (7 << 16) + 24,
    HookParameterValue = (7 << 16) + 25,
    Blob = (7 << 16) + 26,
    Account = (8 << 16) + 1,
    Owner = (8 << 16) + 2,
    Destination = (8 << 16) + 3,
    Issuer = (8 << 16) + 4,
    Authorize = (8 << 16) + 5,
    Unauthorize = (8 << 16) + 6,
    RegularKey = (8 << 16) + 8,
    NFTokenMinter = (8 << 16) + 9,
    EmitCallback = (8 << 16) + 10,
    HookAccount = (8 << 16) + 16,
    Indexes = (19 << 16) + 1,
    Hashes = (19 << 16) + 2,
    Amendments = (19 << 16) + 3,
    NFTokenOffers = (19 << 16) + 4,
    HookNamespaces = (19 << 16) + 5,
    Paths = (18 << 16) + 1,
    TransactionMetaData = (14 << 16) + 2,
    CreatedNode = (14 << 16) + 3,
    DeletedNode = (14 << 16) + 4,
    ModifiedNode = (14 << 16) + 5,
    PreviousFields = (14 << 16) + 6,
    FinalFields = (14 << 16) + 7,
    NewFields = (14 << 16) + 8,
    TemplateEntry = (14 << 16) + 9,
    Memo = (14 << 16) + 10,
    SignerEntry = (14 << 16) + 11,
    NFToken = (14 << 16) + 12,
    EmitDetails = (14 << 16) + 13,
    Hook = (14 << 16) + 14,
    Signer = (14 << 16) + 16,
    Majority = (14 << 16) + 18,
    DisabledValidator = (14 << 16) + 19,
    EmittedTxn = (14 << 16) + 20,
    HookExecution = (14 << 16) + 21,
    HookDefinition = (14 << 16) + 22,
    HookParameter = (14 << 16) + 23,
    HookGrant = (14 << 16) + 24,
    Signers = (15 << 16) + 3,
    SignerEntries = (15 << 16) + 4,
    Template = (15 << 16) + 5,
    Necessary = (15 << 16) + 6,
    Sufficient = (15 << 16) + 7,
    AffectedNodes = (15 << 16) + 8,
    Memos = (15 << 16) + 9,
    NFTokens = (15 << 16) + 10,
    Hooks = (15 << 16) + 11,
    Majorities = (15 << 16) + 16,
    DisabledValidators = (15 << 16) + 17,
    HookExecutions = (15 << 16) + 18,
    HookParameters = (15 << 16) + 19,
    HookGrants = (15 << 16) + 20,
};
