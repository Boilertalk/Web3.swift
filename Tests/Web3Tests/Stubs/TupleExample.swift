extension JSONStubs {
    static let TupleExamples = """
    [
      {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": false,
            "internalType": "address",
            "name": "previousAdmin",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "address",
            "name": "newAdmin",
            "type": "address"
          }
        ],
        "name": "AdminChanged",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "beacon",
            "type": "address"
          }
        ],
        "name": "BeaconUpgraded",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": false,
            "internalType": "uint8",
            "name": "version",
            "type": "uint8"
          }
        ],
        "name": "Initialized",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "previousOwner",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "newOwner",
            "type": "address"
          }
        ],
        "name": "OwnershipTransferred",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "implementation",
            "type": "address"
          }
        ],
        "name": "Upgraded",
        "type": "event"
      },
      {
        "inputs": [],
        "name": "owner",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "proxiableUUID",
        "outputs": [
          {
            "internalType": "bytes32",
            "name": "",
            "type": "bytes32"
          }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "renounceOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "newOwner",
            "type": "address"
          }
        ],
        "name": "transferOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "newImplementation",
            "type": "address"
          }
        ],
        "name": "upgradeTo",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "newImplementation",
            "type": "address"
          },
          {
            "internalType": "bytes",
            "name": "data",
            "type": "bytes"
          }
        ],
        "name": "upgradeToAndCall",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function",
        "payable": true
      },
      {
        "inputs": [],
        "name": "initialize",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "returnSimpleStaticTuple",
        "outputs": [
          {
            "components": [
              {
                "internalType": "uint256",
                "name": "x",
                "type": "uint256"
              },
              {
                "internalType": "uint256",
                "name": "y",
                "type": "uint256"
              }
            ],
            "internalType": "struct TupleExamples.SimpleStaticTuple",
            "name": "returnTuple",
            "type": "tuple"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnComplexStaticTuple",
        "outputs": [
          {
            "components": [
              {
                "internalType": "int16",
                "name": "x",
                "type": "int16"
              },
              {
                "internalType": "uint256[4]",
                "name": "yArr",
                "type": "uint256[4]"
              },
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "bytes10",
                "name": "b",
                "type": "bytes10"
              }
            ],
            "internalType": "struct TupleExamples.ComplexStaticTuple",
            "name": "returnTuple",
            "type": "tuple"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnSimpleStaticTupleArray",
        "outputs": [
          {
            "components": [
              {
                "internalType": "uint256",
                "name": "x",
                "type": "uint256"
              },
              {
                "internalType": "uint256",
                "name": "y",
                "type": "uint256"
              }
            ],
            "internalType": "struct TupleExamples.SimpleStaticTuple[4]",
            "name": "returnTupleArray",
            "type": "tuple[4]"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnComplexStaticTupleArray",
        "outputs": [
          {
            "components": [
              {
                "internalType": "int16",
                "name": "x",
                "type": "int16"
              },
              {
                "internalType": "uint256[4]",
                "name": "yArr",
                "type": "uint256[4]"
              },
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "bytes10",
                "name": "b",
                "type": "bytes10"
              }
            ],
            "internalType": "struct TupleExamples.ComplexStaticTuple[4]",
            "name": "returnTupleArray",
            "type": "tuple[4]"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnSimpleDynamicTuple",
        "outputs": [
          {
            "components": [
              {
                "internalType": "string",
                "name": "s",
                "type": "string"
              },
              {
                "internalType": "bytes",
                "name": "b",
                "type": "bytes"
              }
            ],
            "internalType": "struct TupleExamples.SimpleDynamicTuple",
            "name": "returnTuple",
            "type": "tuple"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnComplexDynamicTuple",
        "outputs": [
          {
            "components": [
              {
                "internalType": "string",
                "name": "s",
                "type": "string"
              },
              {
                "internalType": "uint256[]",
                "name": "xArr",
                "type": "uint256[]"
              },
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "bytes10",
                "name": "b",
                "type": "bytes10"
              }
            ],
            "internalType": "struct TupleExamples.ComplexDynamicTuple",
            "name": "returnTuple",
            "type": "tuple"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnSimpleDynamicTupleArray",
        "outputs": [
          {
            "components": [
              {
                "internalType": "string",
                "name": "s",
                "type": "string"
              },
              {
                "internalType": "bytes",
                "name": "b",
                "type": "bytes"
              }
            ],
            "internalType": "struct TupleExamples.SimpleDynamicTuple[4]",
            "name": "returnTupleArray",
            "type": "tuple[4]"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnComplexDynamicTupleArray",
        "outputs": [
          {
            "components": [
              {
                "internalType": "string",
                "name": "s",
                "type": "string"
              },
              {
                "internalType": "uint256[]",
                "name": "xArr",
                "type": "uint256[]"
              },
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "bytes10",
                "name": "b",
                "type": "bytes10"
              }
            ],
            "internalType": "struct TupleExamples.ComplexDynamicTuple[]",
            "name": "returnTupleArray",
            "type": "tuple[]"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [],
        "name": "returnComplexStaticTupleMultidimensionalArray",
        "outputs": [
          {
            "components": [
              {
                "internalType": "string",
                "name": "s",
                "type": "string"
              },
              {
                "internalType": "uint256[]",
                "name": "xArr",
                "type": "uint256[]"
              },
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "bytes10",
                "name": "b",
                "type": "bytes10"
              }
            ],
            "internalType": "struct TupleExamples.ComplexDynamicTuple[][]",
            "name": "returnTupleArray",
            "type": "tuple[][]"
          }
        ],
        "stateMutability": "pure",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "toAccount",
            "type": "address"
          }
        ],
        "name": "withdrawLockedFunds",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "contract IERC20Upgradeable",
            "name": "token",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "toAccount",
            "type": "address"
          }
        ],
        "name": "withdrawLockedFunds",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]
    """
}

extension JSONStubs {
    static let TupleExamplesReturnStub = """
    {
        "jsonrpc": "2.0",
        "id": 0,
        "result": "0x00000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000100"
    }
    """
}
