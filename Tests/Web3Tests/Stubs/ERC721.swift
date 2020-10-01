extension JSONStubs {
    static let ERC721 = """
    {
        "contractName": "ERC721",
        "abi": [
                {
                "anonymous": false,
                "inputs": [
                           {
                           "indexed": true,
                           "name": "_from",
                           "type": "address"
                           },
                           {
                           "indexed": true,
                           "name": "_to",
                           "type": "address"
                           },
                           {
                           "indexed": false,
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "Transfer",
                "type": "event"
                },
                {
                "anonymous": false,
                "inputs": [
                           {
                           "indexed": true,
                           "name": "_owner",
                           "type": "address"
                           },
                           {
                           "indexed": true,
                           "name": "_approved",
                           "type": "address"
                           },
                           {
                           "indexed": false,
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "Approval",
                "type": "event"
                },
                {
                "constant": true,
                "inputs": [],
                "name": "totalSupply",
                "outputs": [
                            {
                            "name": "_totalSupply",
                            "type": "uint256"
                            }
                            ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
                },
                {
                "constant": true,
                "inputs": [
                           {
                           "name": "_owner",
                           "type": "address"
                           }
                           ],
                "name": "balanceOf",
                "outputs": [
                            {
                            "name": "_balance",
                            "type": "uint256"
                            }
                            ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
                },
                {
                "constant": true,
                "inputs": [
                           {
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "ownerOf",
                "outputs": [
                            {
                            "name": "_owner",
                            "type": "address"
                            }
                            ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
                },
                {
                "constant": false,
                "inputs": [
                           {
                           "name": "_to",
                           "type": "address"
                           },
                           {
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "approve",
                "outputs": [],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
                },
                {
                "constant": true,
                "inputs": [
                           {
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "getApproved",
                "outputs": [
                            {
                            "name": "_approved",
                            "type": "address"
                            }
                            ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
                },
                {
                "constant": false,
                "inputs": [
                           {
                           "name": "_from",
                           "type": "address"
                           },
                           {
                           "name": "_to",
                           "type": "address"
                           },
                           {
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "transferFrom",
                "outputs": [],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
                },
                {
                "constant": false,
                "inputs": [
                           {
                           "name": "_to",
                           "type": "address"
                           },
                           {
                           "name": "_tokenId",
                           "type": "uint256"
                           }
                           ],
                "name": "transfer",
                "outputs": [],
                "payable": false,
                "stateMutability": "nonpayable",
                "type": "function"
                },
                {
                "constant": true,
                "inputs": [],
                "name": "implementsERC721",
                "outputs": [
                            {
                            "name": "_implementsERC721",
                            "type": "bool"
                            }
                            ],
                "payable": false,
                "stateMutability": "view",
                "type": "function"
                }
                ],
        "bytecode": "0x",
        "deployedBytecode": "0x",
        "sourceMap": "",
        "deployedSourceMap": "",
        "source": "pragma solidity ^0.4.19;\n\n\n/**\n * Interface for required functionality in the ERC721 standard\n * for non-fungible tokens.\n *\n * Author: Nadav Hollander (nadav at dharma.io)\n */\ncontract ERC721 {\n    // Function\n    function totalSupply() public view returns (uint256 _totalSupply);\n    function balanceOf(address _owner) public view returns (uint256 _balance);\n    function ownerOf(uint _tokenId) public view returns (address _owner);\n    function approve(address _to, uint _tokenId) public;\n    function getApproved(uint _tokenId) public view returns (address _approved);\n    function transferFrom(address _from, address _to, uint _tokenId) public;\n    function transfer(address _to, uint _tokenId) public;\n    function implementsERC721() public view returns (bool _implementsERC721);\n\n    // Events\n    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n}\n",
        "sourcePath": "/Users/jp/Work/example-dapp-game/contracts/ERC721.sol",
        "ast": {
            "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/ERC721.sol",
            "exportedSymbols": {
                "ERC721": [
                           104
                           ]
            },
            "id": 105,
            "nodeType": "SourceUnit",
            "nodes": [
                      {
                      "id": 33,
                      "literals": [
                                   "solidity",
                                   "^",
                                   "0.4",
                                   ".19"
                                   ],
                      "nodeType": "PragmaDirective",
                      "src": "0:24:1"
                      },
                      {
                      "baseContracts": [],
                      "contractDependencies": [],
                      "contractKind": "contract",
                      "documentation": "Interface for required functionality in the ERC721 standard\nfor non-fungible tokens.\n * Author: Nadav Hollander (nadav at dharma.io)",
                      "fullyImplemented": false,
                      "id": 104,
                      "linearizedBaseContracts": [
                                                  104
                                                  ],
                      "name": "ERC721",
                      "nodeType": "ContractDefinition",
                      "nodes": [
                                {
                                "body": null,
                                "documentation": null,
                                "id": 38,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "totalSupply",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 34,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "235:2:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 37,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 36,
                                               "name": "_totalSupply",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 38,
                                               "src": "259:20:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 35,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "259:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "258:22:1"
                                },
                                "scope": 104,
                                "src": "215:66:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 45,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "balanceOf",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 41,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 40,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 45,
                                               "src": "305:14:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 39,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "305:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "304:16:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 44,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 43,
                                               "name": "_balance",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 45,
                                               "src": "342:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 42,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "342:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "341:18:1"
                                },
                                "scope": 104,
                                "src": "286:74:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 52,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "ownerOf",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 48,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 47,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 52,
                                               "src": "382:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 46,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "382:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "381:15:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 51,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 50,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 52,
                                               "src": "418:14:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 49,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "418:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "417:16:1"
                                },
                                "scope": 104,
                                "src": "365:69:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 59,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "approve",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 57,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 54,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 59,
                                               "src": "456:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 53,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "456:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 56,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 59,
                                               "src": "469:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 55,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "469:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "455:28:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 58,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "490:0:1"
                                },
                                "scope": 104,
                                "src": "439:52:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 66,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "getApproved",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 62,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 61,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 66,
                                               "src": "517:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 60,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "517:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "516:15:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 65,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 64,
                                               "name": "_approved",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 66,
                                               "src": "553:17:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 63,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "553:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "552:19:1"
                                },
                                "scope": 104,
                                "src": "496:76:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 75,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "transferFrom",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 73,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 68,
                                               "name": "_from",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "599:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 67,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "599:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 70,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "614:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 69,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "614:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 72,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "627:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 71,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "627:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "598:43:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 74,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "648:0:1"
                                },
                                "scope": 104,
                                "src": "577:72:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 82,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "transfer",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 80,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 77,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 82,
                                               "src": "672:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 76,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "672:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 79,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 82,
                                               "src": "685:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 78,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "685:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "671:28:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 81,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "706:0:1"
                                },
                                "scope": 104,
                                "src": "654:53:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 87,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "implementsERC721",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 83,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "737:2:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 86,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 85,
                                               "name": "_implementsERC721",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 87,
                                               "src": "761:22:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_bool",
                                               "typeString": "bool"
                                               },
                                               "typeName": {
                                               "id": 84,
                                               "name": "bool",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "761:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_bool",
                                               "typeString": "bool"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "760:24:1"
                                },
                                "scope": 104,
                                "src": "712:73:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "anonymous": false,
                                "documentation": null,
                                "id": 95,
                                "name": "Transfer",
                                "nodeType": "EventDefinition",
                                "parameters": {
                                "id": 94,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 89,
                                               "indexed": true,
                                               "name": "_from",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "820:21:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 88,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "820:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 91,
                                               "indexed": true,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "843:19:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 90,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "843:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 93,
                                               "indexed": false,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "864:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 92,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "864:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "819:62:1"
                                },
                                "src": "805:77:1"
                                },
                                {
                                "anonymous": false,
                                "documentation": null,
                                "id": 103,
                                "name": "Approval",
                                "nodeType": "EventDefinition",
                                "parameters": {
                                "id": 102,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 97,
                                               "indexed": true,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "902:22:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 96,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "902:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 99,
                                               "indexed": true,
                                               "name": "_approved",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "926:25:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 98,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "926:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 101,
                                               "indexed": false,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "953:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 100,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "953:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "901:69:1"
                                },
                                "src": "887:84:1"
                                }
                                ],
                      "scope": 105,
                      "src": "177:796:1"
                      }
                      ],
            "src": "0:974:1"
        },
        "legacyAST": {
            "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/ERC721.sol",
            "exportedSymbols": {
                "ERC721": [
                           104
                           ]
            },
            "id": 105,
            "nodeType": "SourceUnit",
            "nodes": [
                      {
                      "id": 33,
                      "literals": [
                                   "solidity",
                                   "^",
                                   "0.4",
                                   ".19"
                                   ],
                      "nodeType": "PragmaDirective",
                      "src": "0:24:1"
                      },
                      {
                      "baseContracts": [],
                      "contractDependencies": [],
                      "contractKind": "contract",
                      "documentation": "Interface for required functionality in the ERC721 standard\nfor non-fungible tokens.\n * Author: Nadav Hollander (nadav at dharma.io)",
                      "fullyImplemented": false,
                      "id": 104,
                      "linearizedBaseContracts": [
                                                  104
                                                  ],
                      "name": "ERC721",
                      "nodeType": "ContractDefinition",
                      "nodes": [
                                {
                                "body": null,
                                "documentation": null,
                                "id": 38,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "totalSupply",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 34,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "235:2:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 37,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 36,
                                               "name": "_totalSupply",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 38,
                                               "src": "259:20:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 35,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "259:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "258:22:1"
                                },
                                "scope": 104,
                                "src": "215:66:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 45,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "balanceOf",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 41,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 40,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 45,
                                               "src": "305:14:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 39,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "305:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "304:16:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 44,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 43,
                                               "name": "_balance",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 45,
                                               "src": "342:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 42,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "342:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "341:18:1"
                                },
                                "scope": 104,
                                "src": "286:74:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 52,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "ownerOf",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 48,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 47,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 52,
                                               "src": "382:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 46,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "382:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "381:15:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 51,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 50,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 52,
                                               "src": "418:14:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 49,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "418:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "417:16:1"
                                },
                                "scope": 104,
                                "src": "365:69:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 59,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "approve",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 57,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 54,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 59,
                                               "src": "456:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 53,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "456:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 56,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 59,
                                               "src": "469:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 55,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "469:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "455:28:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 58,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "490:0:1"
                                },
                                "scope": 104,
                                "src": "439:52:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 66,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "getApproved",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 62,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 61,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 66,
                                               "src": "517:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 60,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "517:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "516:15:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 65,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 64,
                                               "name": "_approved",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 66,
                                               "src": "553:17:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 63,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "553:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "552:19:1"
                                },
                                "scope": 104,
                                "src": "496:76:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 75,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "transferFrom",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 73,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 68,
                                               "name": "_from",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "599:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 67,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "599:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 70,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "614:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 69,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "614:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 72,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 75,
                                               "src": "627:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 71,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "627:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "598:43:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 74,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "648:0:1"
                                },
                                "scope": 104,
                                "src": "577:72:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 82,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": false,
                                "modifiers": [],
                                "name": "transfer",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 80,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 77,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 82,
                                               "src": "672:11:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 76,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "672:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 79,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 82,
                                               "src": "685:13:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 78,
                                               "name": "uint",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "685:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "671:28:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 81,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "706:0:1"
                                },
                                "scope": 104,
                                "src": "654:53:1",
                                "stateMutability": "nonpayable",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "body": null,
                                "documentation": null,
                                "id": 87,
                                "implemented": false,
                                "isConstructor": false,
                                "isDeclaredConst": true,
                                "modifiers": [],
                                "name": "implementsERC721",
                                "nodeType": "FunctionDefinition",
                                "parameters": {
                                "id": 83,
                                "nodeType": "ParameterList",
                                "parameters": [],
                                "src": "737:2:1"
                                },
                                "payable": false,
                                "returnParameters": {
                                "id": 86,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 85,
                                               "name": "_implementsERC721",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 87,
                                               "src": "761:22:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_bool",
                                               "typeString": "bool"
                                               },
                                               "typeName": {
                                               "id": 84,
                                               "name": "bool",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "761:4:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_bool",
                                               "typeString": "bool"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "760:24:1"
                                },
                                "scope": 104,
                                "src": "712:73:1",
                                "stateMutability": "view",
                                "superFunction": null,
                                "visibility": "public"
                                },
                                {
                                "anonymous": false,
                                "documentation": null,
                                "id": 95,
                                "name": "Transfer",
                                "nodeType": "EventDefinition",
                                "parameters": {
                                "id": 94,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 89,
                                               "indexed": true,
                                               "name": "_from",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "820:21:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 88,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "820:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 91,
                                               "indexed": true,
                                               "name": "_to",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "843:19:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 90,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "843:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 93,
                                               "indexed": false,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 95,
                                               "src": "864:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 92,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "864:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "819:62:1"
                                },
                                "src": "805:77:1"
                                },
                                {
                                "anonymous": false,
                                "documentation": null,
                                "id": 103,
                                "name": "Approval",
                                "nodeType": "EventDefinition",
                                "parameters": {
                                "id": 102,
                                "nodeType": "ParameterList",
                                "parameters": [
                                               {
                                               "constant": false,
                                               "id": 97,
                                               "indexed": true,
                                               "name": "_owner",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "902:22:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 96,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "902:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 99,
                                               "indexed": true,
                                               "name": "_approved",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "926:25:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               },
                                               "typeName": {
                                               "id": 98,
                                               "name": "address",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "926:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_address",
                                               "typeString": "address"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               },
                                               {
                                               "constant": false,
                                               "id": 101,
                                               "indexed": false,
                                               "name": "_tokenId",
                                               "nodeType": "VariableDeclaration",
                                               "scope": 103,
                                               "src": "953:16:1",
                                               "stateVariable": false,
                                               "storageLocation": "default",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               },
                                               "typeName": {
                                               "id": 100,
                                               "name": "uint256",
                                               "nodeType": "ElementaryTypeName",
                                               "src": "953:7:1",
                                               "typeDescriptions": {
                                               "typeIdentifier": "t_uint256",
                                               "typeString": "uint256"
                                               }
                                               },
                                               "value": null,
                                               "visibility": "internal"
                                               }
                                               ],
                                "src": "901:69:1"
                                },
                                "src": "887:84:1"
                                }
                                ],
                      "scope": 105,
                      "src": "177:796:1"
                      }
                      ],
            "src": "0:974:1"
        },
        "compiler": {
            "name": "solc",
            "version": "0.4.23+commit.124ca40d.Emscripten.clang"
        },
        "networks": {},
        "schemaVersion": "2.0.0",
        "updatedAt": "2018-05-11T03:36:11.155Z"
    }
    """
}
