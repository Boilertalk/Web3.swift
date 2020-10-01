extension JSONStubs {
    static let LimitedMintableNonFungibleToken = """
    {
      "contractName": "LimitedMintableNonFungibleToken",
      "abi": [
        {
          "constant": true,
          "inputs": [],
          "name": "name",
          "outputs": [
            {
              "name": "_name",
              "type": "string"
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
          "constant": true,
          "inputs": [
            {
              "name": "_owner",
              "type": "address"
            },
            {
              "name": "_index",
              "type": "uint256"
            }
          ],
          "name": "tokenOfOwnerByIndex",
          "outputs": [
            {
              "name": "_tokenId",
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
          "constant": true,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "tokenMetadata",
          "outputs": [
            {
              "name": "_infoUrl",
              "type": "string"
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
          "inputs": [],
          "name": "symbol",
          "outputs": [
            {
              "name": "_symbol",
              "type": "string"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "mintLimit",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
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
          "name": "transfer",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "numTokensTotal",
          "outputs": [
            {
              "name": "",
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
          "name": "getOwnerTokens",
          "outputs": [
            {
              "name": "_tokenIds",
              "type": "uint256[]"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "name": "_mintLimit",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "_to",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "Mint",
          "type": "event"
        },
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
          "constant": false,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "mint",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        }
      ],
      "bytecode": "0x608060405234801561001057600080fd5b506040516020806115db8339810180604052810190808051906020019092919050505080600881905550506115918061004a6000396000f3006080604052600436106100e6576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806306fdde03146100eb578063081812fc1461017b578063095ea7b3146101e85780631051db341461023557806318160ddd1461026457806323b872dd1461028f5780632f745c59146102fc5780636352211e1461035d5780636914db60146103ca57806370a082311461047057806395d89b41146104c7578063996517cf14610557578063a0712d6814610582578063a9059cbb146105af578063af129dc2146105fc578063d63d4af014610627575b600080fd5b3480156100f757600080fd5b506101006106bf565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610140578082015181840152602081019050610125565b50505050905090810190601f16801561016d5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561018757600080fd5b506101a660048036038101908080359060200190929190505050610761565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156101f457600080fd5b50610233600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610773565b005b34801561024157600080fd5b5061024a610920565b604051808215151515815260200191505060405180910390f35b34801561027057600080fd5b50610279610929565b6040518082815260200191505060405180910390f35b34801561029b57600080fd5b506102fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610933565b005b34801561030857600080fd5b50610347600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610afe565b6040518082815260200191505060405180910390f35b34801561036957600080fd5b5061038860048036038101908080359060200190929190505050610b12565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156103d657600080fd5b506103f560048036038101908080359060200190929190505050610b24565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561043557808201518184015260208101905061041a565b50505050905090810190601f1680156104625780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561047c57600080fd5b506104b1600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610bd9565b6040518082815260200191505060405180910390f35b3480156104d357600080fd5b506104dc610c25565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561051c578082015181840152602081019050610501565b50505050905090810190601f1680156105495780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561056357600080fd5b5061056c610cc7565b6040518082815260200191505060405180910390f35b34801561058e57600080fd5b506105ad60048036038101908080359060200190929190505050610ccd565b005b3480156105bb57600080fd5b506105fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610e06565b005b34801561060857600080fd5b50610611610f8e565b6040518082815260200191505060405180910390f35b34801561063357600080fd5b50610668600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610f94565b6040518080602001828103825283818151815260200191508051906020019060200280838360005b838110156106ab578082015181840152602081019050610690565b505050509050019250505060405180910390f35b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107575780601f1061072c57610100808354040283529160200191610757565b820191906000526020600020905b81548152906001019060200180831161073a57829003601f168201915b5050505050905090565b600061076c82610fa6565b9050919050565b80600073ffffffffffffffffffffffffffffffffffffffff1661079582610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515156107b857600080fd5b6107c182610b12565b73ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415156107fa57600080fd5b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415151561083557600080fd5b600073ffffffffffffffffffffffffffffffffffffffff1661085683610fa6565b73ffffffffffffffffffffffffffffffffffffffff161415806108a65750600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614155b1561091b576108b58383610fe3565b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a35b505050565b60006001905090565b6000600254905090565b80600073ffffffffffffffffffffffffffffffffffffffff1661095582610b12565b73ffffffffffffffffffffffffffffffffffffffff161415151561097857600080fd5b3373ffffffffffffffffffffffffffffffffffffffff1661099883610761565b73ffffffffffffffffffffffffffffffffffffffff161415156109ba57600080fd5b8373ffffffffffffffffffffffffffffffffffffffff166109da83610b12565b73ffffffffffffffffffffffffffffffffffffffff161415156109fc57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610a3857600080fd5b610a43848484611039565b60008473ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a350505050565b6000610b0a8383611065565b905092915050565b6000610b1d826110c6565b9050919050565b6060600560008381526020019081526020016000208054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610bcd5780601f10610ba257610100808354040283529160200191610bcd565b820191906000526020600020905b815481529060010190602001808311610bb057829003601f168201915b50505050509050919050565b6000600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490509050919050565b606060018054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610cbd5780601f10610c9257610100808354040283529160200191610cbd565b820191906000526020600020905b815481529060010190602001808311610ca057829003601f168201915b5050505050905090565b60085481565b80600073ffffffffffffffffffffffffffffffffffffffff166003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610d3c57600080fd5b600854600660003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050101515610d8e57600080fd5b610d988233611103565b610da23383611159565b610db8600160025461122390919063ffffffff16565b600281905550813373ffffffffffffffffffffffffffffffffffffffff167f0f6798a560793a54c3bcfe86a93cde1e73087d944c0ea20544137d412139688560405160405180910390a35050565b80600073ffffffffffffffffffffffffffffffffffffffff16610e2882610b12565b73ffffffffffffffffffffffffffffffffffffffff1614151515610e4b57600080fd5b3373ffffffffffffffffffffffffffffffffffffffff16610e6b83610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515610e8d57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610ec957600080fd5b610ed4338484611039565b60003373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3505050565b60025481565b6060610f9f82611241565b9050919050565b60006004600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b816004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b611042816112d8565b61104c838261132e565b6110568183611103565b6110608282611159565b505050565b6000600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020828154811015156110b357fe5b9060005260206000200154905092915050565b60006003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b806003600084815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190806001815401808255809150509060018203906000526020600020016000909192909190915055506001600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490500360076000838152602001908152602001600020819055505050565b600080828401905083811015151561123757fe5b8091505092915050565b6060600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208054806020026020016040519081016040528092919081815260200182805480156112cc57602002820191906000526020600020905b8154815260200190600101908083116112b8575b50505050509050919050565b60006004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000806000600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050925060076000858152602001908152602001600020549150600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156113dd57fe5b9060005260206000200154905080600660008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208381548110151561143757fe5b9060005260206000200181905550816007600083815260200190815260200160002081905550600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156114ac57fe5b9060005260206000200160009055600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080548091906001900361150c9190611514565b505050505050565b81548183558181111561153b5781836000526020600020918201910161153a9190611540565b5b505050565b61156291905b8082111561155e576000816000905550600101611546565b5090565b905600a165627a7a723058207688f4bdd24340cc70ce22e63119085ece9749191d9fef2c9e4b1ad9eb438f600029",
      "deployedBytecode": "0x6080604052600436106100e6576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806306fdde03146100eb578063081812fc1461017b578063095ea7b3146101e85780631051db341461023557806318160ddd1461026457806323b872dd1461028f5780632f745c59146102fc5780636352211e1461035d5780636914db60146103ca57806370a082311461047057806395d89b41146104c7578063996517cf14610557578063a0712d6814610582578063a9059cbb146105af578063af129dc2146105fc578063d63d4af014610627575b600080fd5b3480156100f757600080fd5b506101006106bf565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610140578082015181840152602081019050610125565b50505050905090810190601f16801561016d5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561018757600080fd5b506101a660048036038101908080359060200190929190505050610761565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156101f457600080fd5b50610233600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610773565b005b34801561024157600080fd5b5061024a610920565b604051808215151515815260200191505060405180910390f35b34801561027057600080fd5b50610279610929565b6040518082815260200191505060405180910390f35b34801561029b57600080fd5b506102fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610933565b005b34801561030857600080fd5b50610347600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610afe565b6040518082815260200191505060405180910390f35b34801561036957600080fd5b5061038860048036038101908080359060200190929190505050610b12565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156103d657600080fd5b506103f560048036038101908080359060200190929190505050610b24565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561043557808201518184015260208101905061041a565b50505050905090810190601f1680156104625780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561047c57600080fd5b506104b1600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610bd9565b6040518082815260200191505060405180910390f35b3480156104d357600080fd5b506104dc610c25565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561051c578082015181840152602081019050610501565b50505050905090810190601f1680156105495780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561056357600080fd5b5061056c610cc7565b6040518082815260200191505060405180910390f35b34801561058e57600080fd5b506105ad60048036038101908080359060200190929190505050610ccd565b005b3480156105bb57600080fd5b506105fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610e06565b005b34801561060857600080fd5b50610611610f8e565b6040518082815260200191505060405180910390f35b34801561063357600080fd5b50610668600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610f94565b6040518080602001828103825283818151815260200191508051906020019060200280838360005b838110156106ab578082015181840152602081019050610690565b505050509050019250505060405180910390f35b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107575780601f1061072c57610100808354040283529160200191610757565b820191906000526020600020905b81548152906001019060200180831161073a57829003601f168201915b5050505050905090565b600061076c82610fa6565b9050919050565b80600073ffffffffffffffffffffffffffffffffffffffff1661079582610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515156107b857600080fd5b6107c182610b12565b73ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415156107fa57600080fd5b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415151561083557600080fd5b600073ffffffffffffffffffffffffffffffffffffffff1661085683610fa6565b73ffffffffffffffffffffffffffffffffffffffff161415806108a65750600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614155b1561091b576108b58383610fe3565b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a35b505050565b60006001905090565b6000600254905090565b80600073ffffffffffffffffffffffffffffffffffffffff1661095582610b12565b73ffffffffffffffffffffffffffffffffffffffff161415151561097857600080fd5b3373ffffffffffffffffffffffffffffffffffffffff1661099883610761565b73ffffffffffffffffffffffffffffffffffffffff161415156109ba57600080fd5b8373ffffffffffffffffffffffffffffffffffffffff166109da83610b12565b73ffffffffffffffffffffffffffffffffffffffff161415156109fc57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610a3857600080fd5b610a43848484611039565b60008473ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a350505050565b6000610b0a8383611065565b905092915050565b6000610b1d826110c6565b9050919050565b6060600560008381526020019081526020016000208054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610bcd5780601f10610ba257610100808354040283529160200191610bcd565b820191906000526020600020905b815481529060010190602001808311610bb057829003601f168201915b50505050509050919050565b6000600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490509050919050565b606060018054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610cbd5780601f10610c9257610100808354040283529160200191610cbd565b820191906000526020600020905b815481529060010190602001808311610ca057829003601f168201915b5050505050905090565b60085481565b80600073ffffffffffffffffffffffffffffffffffffffff166003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610d3c57600080fd5b600854600660003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050101515610d8e57600080fd5b610d988233611103565b610da23383611159565b610db8600160025461122390919063ffffffff16565b600281905550813373ffffffffffffffffffffffffffffffffffffffff167f0f6798a560793a54c3bcfe86a93cde1e73087d944c0ea20544137d412139688560405160405180910390a35050565b80600073ffffffffffffffffffffffffffffffffffffffff16610e2882610b12565b73ffffffffffffffffffffffffffffffffffffffff1614151515610e4b57600080fd5b3373ffffffffffffffffffffffffffffffffffffffff16610e6b83610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515610e8d57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610ec957600080fd5b610ed4338484611039565b60003373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3505050565b60025481565b6060610f9f82611241565b9050919050565b60006004600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b816004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b611042816112d8565b61104c838261132e565b6110568183611103565b6110608282611159565b505050565b6000600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020828154811015156110b357fe5b9060005260206000200154905092915050565b60006003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b806003600084815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190806001815401808255809150509060018203906000526020600020016000909192909190915055506001600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490500360076000838152602001908152602001600020819055505050565b600080828401905083811015151561123757fe5b8091505092915050565b6060600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208054806020026020016040519081016040528092919081815260200182805480156112cc57602002820191906000526020600020905b8154815260200190600101908083116112b8575b50505050509050919050565b60006004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000806000600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050925060076000858152602001908152602001600020549150600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156113dd57fe5b9060005260206000200154905080600660008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208381548110151561143757fe5b9060005260206000200181905550816007600083815260200190815260200160002081905550600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156114ac57fe5b9060005260206000200160009055600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080548091906001900361150c9190611514565b505050505050565b81548183558181111561153b5781836000526020600020918201910161153a9190611540565b5b505050565b61156291905b8082111561155e576000816000905550600101611546565b5090565b905600a165627a7a723058207688f4bdd24340cc70ce22e63119085ece9749191d9fef2c9e4b1ad9eb438f600029",
      "sourceMap": "236:546:2:-;;;339:104;8:9:-1;5:2;;;30:1;27;20:12;5:2;339:104:2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;426:10;414:9;:22;;;;339:104;236:546;;;;;;",
      "deployedSourceMap": "236:546:2:-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1227:107:5;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1227:107:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;23:1:-1;8:100;33:3;30:1;27:10;8:100;;;99:1;94:3;90:11;84:18;80:1;75:3;71:11;64:39;52:2;49:1;45:10;40:15;;8:100;;;12:14;1227:107:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3685:150;;8:9:-1;5:2;;;30:1;27;20:12;5:2;3685:150:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;2065:377;;8:9:-1;5:2;;;30:1;27;20:12;5:2;2065:377:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3550:129;;8:9:-1;5:2;;;30:1;27;20:12;5:2;3550:129:5;;;;;;;;;;;;;;;;;;;;;;;;;;;1459:132;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1459:132:5;;;;;;;;;;;;;;;;;;;;;;;2448:397;;8:9:-1;5:2;;;30:1;27;20:12;5:2;2448:397:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3201:183;;8:9:-1;5:2;;;30:1;27;20:12;5:2;3201:183:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1759:139;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1759:139:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1904:155;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1904:155:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;23:1:-1;8:100;33:3;30:1;27:10;8:100;;;99:1;94:3;90:11;84:18;80:1;75:3;71:11;64:39;52:2;49:1;45:10;40:15;;8:100;;;12:14;1904:155:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1597:156;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1597:156:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1340:113;;8:9:-1;5:2;;;30:1;27;20:12;5:2;1340:113:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;23:1:-1;8:100;33:3;30:1;27:10;8:100;;;99:1;94:3;90:11;84:18;80:1;75:3;71:11;64:39;52:2;49:1;45:10;40:15;;8:100;;;12:14;1340:113:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;311:21:2;;8:9:-1;5:2;;;30:1;27;20:12;5:2;311:21:2;;;;;;;;;;;;;;;;;;;;;;;449:331;;8:9:-1;5:2;;;30:1;27;20:12;5:2;449:331:2;;;;;;;;;;;;;;;;;;;;;;;;;;2851:344:5;;8:9:-1;5:2;;;30:1;27;20:12;5:2;2851:344:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;551:26;;8:9:-1;5:2;;;30:1;27;20:12;5:2;551:26:5;;;;;;;;;;;;;;;;;;;;;;;3390:154;;8:9:-1;5:2;;;30:1;27;20:12;5:2;3390:154:5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;23:1:-1;8:100;33:3;30:1;27:10;8:100;;;99:1;94:3;90:11;84:18;80:1;75:3;71:11;64:39;52:2;49:1;45:10;40:15;;8:100;;;12:14;3390:154:5;;;;;;;;;;;;;;;;;1227:107;1288:12;1323:4;1316:11;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1227:107;:::o;3685:150::-;3766:17;3806:22;3819:8;3806:12;:22::i;:::-;3799:29;;3685:150;;;:::o;2065:377::-;2149:8;1200:1;1171:31;;:17;1179:8;1171:7;:17::i;:::-;:31;;;;1163:40;;;;;;;;2195:17;2203:8;2195:7;:17::i;:::-;2181:31;;:10;:31;;;2173:40;;;;;;;;2245:3;2231:17;;:10;:17;;;;2223:26;;;;;;;;2298:1;2264:36;;:22;2277:8;2264:12;:22::i;:::-;:36;;;;:73;;;;2335:1;2320:17;;:3;:17;;;;2264:73;2260:176;;;2353:23;2362:3;2367:8;2353;:23::i;:::-;2411:3;2390:35;;2399:10;2390:35;;;2416:8;2390:35;;;;;;;;;;;;;;;;;;2260:176;2065:377;;;:::o;3550:129::-;3623:22;3668:4;3661:11;;3550:129;:::o;1459:132::-;1527:20;1570:14;;1563:21;;1459:132;:::o;2448:397::-;2552:8;1200:1;1171:31;;:17;1179:8;1171:7;:17::i;:::-;:31;;;;1163:40;;;;;;;;2609:10;2584:35;;:21;2596:8;2584:11;:21::i;:::-;:35;;;2576:44;;;;;;;;2659:5;2638:26;;:17;2646:8;2638:7;:17::i;:::-;:26;;;2630:35;;;;;;;;2698:1;2683:17;;:3;:17;;;;2675:26;;;;;;;;2712:47;2738:5;2745:3;2750:8;2712:25;:47::i;:::-;2786:1;2779:5;2770:28;;;2789:8;2770:28;;;;;;;;;;;;;;;;;;2824:3;2808:30;;2817:5;2808:30;;;2829:8;2808:30;;;;;;;;;;;;;;;;;;2448:397;;;;:::o;3201:183::-;3304:13;3340:37;3362:6;3370;3340:21;:37::i;:::-;3333:44;;3201:183;;;;:::o;1759:139::-;1836:14;1873:18;1882:8;1873;:18::i;:::-;1866:25;;1759:139;;;:::o;1904:155::-;1987:15;2025:17;:27;2043:8;2025:27;;;;;;;;;;;2018:34;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1904:155;;;:::o;1597:156::-;1677:13;1713:18;:26;1732:6;1713:26;;;;;;;;;;;;;;;:33;;;;1706:40;;1597:156;;;:::o;1340:113::-;1403:14;1440:6;1433:13;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1340:113;:::o;311:21:2:-;;;;:::o;449:331::-;509:8;475:1:4;439:38;;:14;:24;454:8;439:24;;;;;;;;;;;;;;;;;;;;;:38;;;431:47;;;;;;;;577:9:2;;537:18;:30;556:10;537:30;;;;;;;;;;;;;;;:37;;;;:49;529:58;;;;;;;;598:36;613:8;623:10;598:14;:36::i;:::-;644:43;666:10;678:8;644:21;:43::i;:::-;715:21;734:1;715:14;;:18;;:21;;;;:::i;:::-;698:14;:38;;;;764:8;752:10;747:26;;;;;;;;;;;;449:331;;:::o;2851:344:5:-;2936:8;1200:1;1171:31;;:17;1179:8;1171:7;:17::i;:::-;:31;;;;1163:40;;;;;;;;2989:10;2968:31;;:17;2976:8;2968:7;:17::i;:::-;:31;;;2960:40;;;;;;;;3033:1;3018:17;;:3;:17;;;;3010:26;;;;;;;;3047:52;3073:10;3085:3;3090:8;3047:25;:52::i;:::-;3131:1;3119:10;3110:33;;;3134:8;3110:33;;;;;;;;;;;;;;;;;;3174:3;3153:35;;3162:10;3153:35;;;3179:8;3153:35;;;;;;;;;;;;;;;;;;2851:344;;;:::o;551:26::-;;;;:::o;3390:154::-;3475:16;3514:23;3530:6;3514:15;:23::i;:::-;3507:30;;3390:154;;;:::o;4414:165::-;4498:17;4538:24;:34;4563:8;4538:34;;;;;;;;;;;;;;;;;;;;;4531:41;;4414:165;;;:::o;4284:124::-;4398:3;4361:24;:34;4386:8;4361:34;;;;;;;;;;;;:40;;;;;;;;;;;;;;;;;;4284:124;;:::o;3841:283::-;3950:29;3970:8;3950:19;:29::i;:::-;3989:43;4016:5;4023:8;3989:26;:43::i;:::-;4042:29;4057:8;4067:3;4042:14;:29::i;:::-;4081:36;4103:3;4108:8;4081:21;:36::i;:::-;3841:283;;;:::o;4749:183::-;4856:12;4891:18;:26;4910:6;4891:26;;;;;;;;;;;;;;;4918:6;4891:34;;;;;;;;;;;;;;;;;;4884:41;;4749:183;;;;:::o;4130:148::-;4210:14;4247;:24;4262:8;4247:24;;;;;;;;;;;;;;;;;;;;;4240:31;;4130:148;;;:::o;5073:126::-;5186:6;5159:14;:24;5174:8;5159:24;;;;;;;;;;;;:33;;;;;;;;;;;;;;;;;;5073:126;;:::o;5205:237::-;5298:18;:26;5317:6;5298:26;;;;;;;;;;;;;;;5330:8;5298:41;;39:1:-1;33:3;27:10;23:18;57:10;52:3;45:23;79:10;72:17;;0:93;5298:41:5;;;;;;;;;;;;;;;;;;;;;;5434:1;5398:18;:26;5417:6;5398:26;;;;;;;;;;;;;;;:33;;;;:37;5349:24;:34;5374:8;5349:34;;;;;;;;;;;:86;;;;5205:237;;:::o;1094:143:6:-;1152:7;1171:9;1187:1;1183;:5;1171:17;;1210:1;1205;:6;;1198:14;;;;;;1229:1;1222:8;;1094:143;;;;;:::o;4585:158:5:-;4673:14;4710:18;:26;4729:6;4710:26;;;;;;;;;;;;;;;4703:33;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;4585:158;;;:::o;4938:129::-;5058:1;5013:24;:34;5038:8;5013:34;;;;;;;;;;;;:47;;;;;;;;;;;;;;;;;;4938:129;:::o;5448:484::-;5546:11;5603:10;5660:14;5560:18;:26;5579:6;5560:26;;;;;;;;;;;;;;;:33;;;;5546:47;;5616:24;:34;5641:8;5616:34;;;;;;;;;;;;5603:47;;5677:18;:26;5696:6;5677:26;;;;;;;;;;;;;;;5713:1;5704:6;:10;5677:38;;;;;;;;;;;;;;;;;;5660:55;;5762:9;5726:18;:26;5745:6;5726:26;;;;;;;;;;;;;;;5753:5;5726:33;;;;;;;;;;;;;;;;;:45;;;;5819:5;5781:24;:35;5806:9;5781:35;;;;;;;;;;;:43;;;;5842:18;:26;5861:6;5842:26;;;;;;;;;;;;;;;5878:1;5869:6;:10;5842:38;;;;;;;;;;;;;;;;;5835:45;;;5890:18;:26;5909:6;5890:26;;;;;;;;;;;;;;;:35;;;;;;;;;;;;:::i;:::-;;5448:484;;;;;:::o;236:546:2:-;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::i;:::-;;;;;:::o;:::-;;;;;;;;;;;;;;;;;;;;;;;;;;;:::o",
      "source": "pragma solidity ^0.4.19;\n\nimport \"./MintableNonFungibleToken.sol\";\n\n/**\n * @title LimitedMintableNonFungibleToken\n *\n * Superset of the ERC721 standard that allows for the minting\n * of non-fungible tokens, but limited to n tokens.\n */\ncontract LimitedMintableNonFungibleToken is MintableNonFungibleToken {\n    uint public mintLimit;\n\n    function LimitedMintableNonFungibleToken(uint _mintLimit) public {\n        mintLimit = _mintLimit;\n    }\n\n    function mint(uint256 _tokenId) public onlyNonexistentToken(_tokenId) {\n        require(ownerToTokensOwned[msg.sender].length < mintLimit);\n\n        _setTokenOwner(_tokenId, msg.sender);\n        _addTokenToOwnersList(msg.sender, _tokenId);\n\n        numTokensTotal = numTokensTotal.add(1);\n\n        Mint(msg.sender, _tokenId);\n    }\n}\n",
      "sourcePath": "/Users/jp/Work/example-dapp-game/contracts/LimitedMintableNonFungibleToken.sol",
      "ast": {
        "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/LimitedMintableNonFungibleToken.sol",
        "exportedSymbols": {
          "LimitedMintableNonFungibleToken": [
            166
          ]
        },
        "id": 167,
        "nodeType": "SourceUnit",
        "nodes": [
          {
            "id": 106,
            "literals": [
              "solidity",
              "^",
              "0.4",
              ".19"
            ],
            "nodeType": "PragmaDirective",
            "src": "0:24:2"
          },
          {
            "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/MintableNonFungibleToken.sol",
            "file": "./MintableNonFungibleToken.sol",
            "id": 107,
            "nodeType": "ImportDirective",
            "scope": 167,
            "sourceUnit": 289,
            "src": "26:40:2",
            "symbolAliases": [],
            "unitAlias": ""
          },
          {
            "baseContracts": [
              {
                "arguments": null,
                "baseName": {
                  "contractScope": null,
                  "id": 108,
                  "name": "MintableNonFungibleToken",
                  "nodeType": "UserDefinedTypeName",
                  "referencedDeclaration": 288,
                  "src": "280:24:2",
                  "typeDescriptions": {
                    "typeIdentifier": "t_contract$_MintableNonFungibleToken_$288",
                    "typeString": "contract MintableNonFungibleToken"
                  }
                },
                "id": 109,
                "nodeType": "InheritanceSpecifier",
                "src": "280:24:2"
              }
            ],
            "contractDependencies": [
              31,
              104,
              288,
              845
            ],
            "contractKind": "contract",
            "documentation": "@title LimitedMintableNonFungibleToken\n * Superset of the ERC721 standard that allows for the minting\nof non-fungible tokens, but limited to n tokens.",
            "fullyImplemented": true,
            "id": 166,
            "linearizedBaseContracts": [
              166,
              288,
              845,
              31,
              104
            ],
            "name": "LimitedMintableNonFungibleToken",
            "nodeType": "ContractDefinition",
            "nodes": [
              {
                "constant": false,
                "id": 111,
                "name": "mintLimit",
                "nodeType": "VariableDeclaration",
                "scope": 166,
                "src": "311:21:2",
                "stateVariable": true,
                "storageLocation": "default",
                "typeDescriptions": {
                  "typeIdentifier": "t_uint256",
                  "typeString": "uint256"
                },
                "typeName": {
                  "id": 110,
                  "name": "uint",
                  "nodeType": "ElementaryTypeName",
                  "src": "311:4:2",
                  "typeDescriptions": {
                    "typeIdentifier": "t_uint256",
                    "typeString": "uint256"
                  }
                },
                "value": null,
                "visibility": "public"
              },
              {
                "body": {
                  "id": 120,
                  "nodeType": "Block",
                  "src": "404:39:2",
                  "statements": [
                    {
                      "expression": {
                        "argumentTypes": null,
                        "id": 118,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "lValueRequested": false,
                        "leftHandSide": {
                          "argumentTypes": null,
                          "id": 116,
                          "name": "mintLimit",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 111,
                          "src": "414:9:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "nodeType": "Assignment",
                        "operator": "=",
                        "rightHandSide": {
                          "argumentTypes": null,
                          "id": 117,
                          "name": "_mintLimit",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 113,
                          "src": "426:10:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "src": "414:22:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "id": 119,
                      "nodeType": "ExpressionStatement",
                      "src": "414:22:2"
                    }
                  ]
                },
                "documentation": null,
                "id": 121,
                "implemented": true,
                "isConstructor": true,
                "isDeclaredConst": false,
                "modifiers": [],
                "name": "LimitedMintableNonFungibleToken",
                "nodeType": "FunctionDefinition",
                "parameters": {
                  "id": 114,
                  "nodeType": "ParameterList",
                  "parameters": [
                    {
                      "constant": false,
                      "id": 113,
                      "name": "_mintLimit",
                      "nodeType": "VariableDeclaration",
                      "scope": 121,
                      "src": "380:15:2",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 112,
                        "name": "uint",
                        "nodeType": "ElementaryTypeName",
                        "src": "380:4:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "value": null,
                      "visibility": "internal"
                    }
                  ],
                  "src": "379:17:2"
                },
                "payable": false,
                "returnParameters": {
                  "id": 115,
                  "nodeType": "ParameterList",
                  "parameters": [],
                  "src": "404:0:2"
                },
                "scope": 166,
                "src": "339:104:2",
                "stateMutability": "nonpayable",
                "superFunction": null,
                "visibility": "public"
              },
              {
                "body": {
                  "id": 164,
                  "nodeType": "Block",
                  "src": "519:261:2",
                  "statements": [
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "commonType": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            },
                            "id": 136,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftExpression": {
                              "argumentTypes": null,
                              "expression": {
                                "argumentTypes": null,
                                "baseExpression": {
                                  "argumentTypes": null,
                                  "id": 130,
                                  "name": "ownerToTokensOwned",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": 316,
                                  "src": "537:18:2",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_mapping$_t_address_$_t_array$_t_uint256_$dyn_storage_$",
                                    "typeString": "mapping(address => uint256[] storage ref)"
                                  }
                                },
                                "id": 133,
                                "indexExpression": {
                                  "argumentTypes": null,
                                  "expression": {
                                    "argumentTypes": null,
                                    "id": 131,
                                    "name": "msg",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 958,
                                    "src": "556:3:2",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_magic_message",
                                      "typeString": "msg"
                                    }
                                  },
                                  "id": 132,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": false,
                                  "lValueRequested": false,
                                  "memberName": "sender",
                                  "nodeType": "MemberAccess",
                                  "referencedDeclaration": null,
                                  "src": "556:10:2",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_address",
                                    "typeString": "address"
                                  }
                                },
                                "isConstant": false,
                                "isLValue": true,
                                "isPure": false,
                                "lValueRequested": false,
                                "nodeType": "IndexAccess",
                                "src": "537:30:2",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_array$_t_uint256_$dyn_storage",
                                  "typeString": "uint256[] storage ref"
                                }
                              },
                              "id": 134,
                              "isConstant": false,
                              "isLValue": true,
                              "isPure": false,
                              "lValueRequested": false,
                              "memberName": "length",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": null,
                              "src": "537:37:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "nodeType": "BinaryOperation",
                            "operator": "<",
                            "rightExpression": {
                              "argumentTypes": null,
                              "id": 135,
                              "name": "mintLimit",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 111,
                              "src": "577:9:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "src": "537:49:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          ],
                          "id": 129,
                          "name": "require",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [
                            961,
                            962
                          ],
                          "referencedDeclaration": 961,
                          "src": "529:7:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_require_pure$_t_bool_$returns$__$",
                            "typeString": "function (bool) pure"
                          }
                        },
                        "id": 137,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "529:58:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 138,
                      "nodeType": "ExpressionStatement",
                      "src": "529:58:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "id": 140,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "613:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 141,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "623:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 142,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "623:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            },
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          ],
                          "id": 139,
                          "name": "_setTokenOwner",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 744,
                          "src": "598:14:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_internal_nonpayable$_t_uint256_$_t_address_$returns$__$",
                            "typeString": "function (uint256,address)"
                          }
                        },
                        "id": 143,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "598:36:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 144,
                      "nodeType": "ExpressionStatement",
                      "src": "598:36:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 146,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "666:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 147,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "666:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "id": 148,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "678:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            },
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          ],
                          "id": 145,
                          "name": "_addTokenToOwnersList",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 770,
                          "src": "644:21:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_internal_nonpayable$_t_address_$_t_uint256_$returns$__$",
                            "typeString": "function (address,uint256)"
                          }
                        },
                        "id": 149,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "644:43:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 150,
                      "nodeType": "ExpressionStatement",
                      "src": "644:43:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "id": 156,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "lValueRequested": false,
                        "leftHandSide": {
                          "argumentTypes": null,
                          "id": 151,
                          "name": "numTokensTotal",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 299,
                          "src": "698:14:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "nodeType": "Assignment",
                        "operator": "=",
                        "rightHandSide": {
                          "argumentTypes": null,
                          "arguments": [
                            {
                              "argumentTypes": null,
                              "hexValue": "31",
                              "id": 154,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "kind": "number",
                              "lValueRequested": false,
                              "nodeType": "Literal",
                              "src": "734:1:2",
                              "subdenomination": null,
                              "typeDescriptions": {
                                "typeIdentifier": "t_rational_1_by_1",
                                "typeString": "int_const 1"
                              },
                              "value": "1"
                            }
                          ],
                          "expression": {
                            "argumentTypes": [
                              {
                                "typeIdentifier": "t_rational_1_by_1",
                                "typeString": "int_const 1"
                              }
                            ],
                            "expression": {
                              "argumentTypes": null,
                              "id": 152,
                              "name": "numTokensTotal",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 299,
                              "src": "715:14:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 153,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "add",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": 942,
                            "src": "715:18:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$",
                              "typeString": "function (uint256,uint256) pure returns (uint256)"
                            }
                          },
                          "id": 155,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "kind": "functionCall",
                          "lValueRequested": false,
                          "names": [],
                          "nodeType": "FunctionCall",
                          "src": "715:21:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "src": "698:38:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "id": 157,
                      "nodeType": "ExpressionStatement",
                      "src": "698:38:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 159,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "752:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 160,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "752:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "id": 161,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "764:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            },
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          ],
                          "id": 158,
                          "name": "Mint",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 238,
                          "src": "747:4:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_event_nonpayable$_t_address_$_t_uint256_$returns$__$",
                            "typeString": "function (address,uint256)"
                          }
                        },
                        "id": 162,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "747:26:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 163,
                      "nodeType": "ExpressionStatement",
                      "src": "747:26:2"
                    }
                  ]
                },
                "documentation": null,
                "id": 165,
                "implemented": true,
                "isConstructor": false,
                "isDeclaredConst": false,
                "modifiers": [
                  {
                    "arguments": [
                      {
                        "argumentTypes": null,
                        "id": 126,
                        "name": "_tokenId",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 123,
                        "src": "509:8:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      }
                    ],
                    "id": 127,
                    "modifierName": {
                      "argumentTypes": null,
                      "id": 125,
                      "name": "onlyNonexistentToken",
                      "nodeType": "Identifier",
                      "overloadedDeclarations": [],
                      "referencedDeclaration": 254,
                      "src": "488:20:2",
                      "typeDescriptions": {
                        "typeIdentifier": "t_modifier$_t_uint256_$",
                        "typeString": "modifier (uint256)"
                      }
                    },
                    "nodeType": "ModifierInvocation",
                    "src": "488:30:2"
                  }
                ],
                "name": "mint",
                "nodeType": "FunctionDefinition",
                "parameters": {
                  "id": 124,
                  "nodeType": "ParameterList",
                  "parameters": [
                    {
                      "constant": false,
                      "id": 123,
                      "name": "_tokenId",
                      "nodeType": "VariableDeclaration",
                      "scope": 165,
                      "src": "463:16:2",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 122,
                        "name": "uint256",
                        "nodeType": "ElementaryTypeName",
                        "src": "463:7:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "value": null,
                      "visibility": "internal"
                    }
                  ],
                  "src": "462:18:2"
                },
                "payable": false,
                "returnParameters": {
                  "id": 128,
                  "nodeType": "ParameterList",
                  "parameters": [],
                  "src": "519:0:2"
                },
                "scope": 166,
                "src": "449:331:2",
                "stateMutability": "nonpayable",
                "superFunction": null,
                "visibility": "public"
              }
            ],
            "scope": 167,
            "src": "236:546:2"
          }
        ],
        "src": "0:783:2"
      },
      "legacyAST": {
        "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/LimitedMintableNonFungibleToken.sol",
        "exportedSymbols": {
          "LimitedMintableNonFungibleToken": [
            166
          ]
        },
        "id": 167,
        "nodeType": "SourceUnit",
        "nodes": [
          {
            "id": 106,
            "literals": [
              "solidity",
              "^",
              "0.4",
              ".19"
            ],
            "nodeType": "PragmaDirective",
            "src": "0:24:2"
          },
          {
            "absolutePath": "/Users/jp/Work/example-dapp-game/contracts/MintableNonFungibleToken.sol",
            "file": "./MintableNonFungibleToken.sol",
            "id": 107,
            "nodeType": "ImportDirective",
            "scope": 167,
            "sourceUnit": 289,
            "src": "26:40:2",
            "symbolAliases": [],
            "unitAlias": ""
          },
          {
            "baseContracts": [
              {
                "arguments": null,
                "baseName": {
                  "contractScope": null,
                  "id": 108,
                  "name": "MintableNonFungibleToken",
                  "nodeType": "UserDefinedTypeName",
                  "referencedDeclaration": 288,
                  "src": "280:24:2",
                  "typeDescriptions": {
                    "typeIdentifier": "t_contract$_MintableNonFungibleToken_$288",
                    "typeString": "contract MintableNonFungibleToken"
                  }
                },
                "id": 109,
                "nodeType": "InheritanceSpecifier",
                "src": "280:24:2"
              }
            ],
            "contractDependencies": [
              31,
              104,
              288,
              845
            ],
            "contractKind": "contract",
            "documentation": "@title LimitedMintableNonFungibleToken\n * Superset of the ERC721 standard that allows for the minting\nof non-fungible tokens, but limited to n tokens.",
            "fullyImplemented": true,
            "id": 166,
            "linearizedBaseContracts": [
              166,
              288,
              845,
              31,
              104
            ],
            "name": "LimitedMintableNonFungibleToken",
            "nodeType": "ContractDefinition",
            "nodes": [
              {
                "constant": false,
                "id": 111,
                "name": "mintLimit",
                "nodeType": "VariableDeclaration",
                "scope": 166,
                "src": "311:21:2",
                "stateVariable": true,
                "storageLocation": "default",
                "typeDescriptions": {
                  "typeIdentifier": "t_uint256",
                  "typeString": "uint256"
                },
                "typeName": {
                  "id": 110,
                  "name": "uint",
                  "nodeType": "ElementaryTypeName",
                  "src": "311:4:2",
                  "typeDescriptions": {
                    "typeIdentifier": "t_uint256",
                    "typeString": "uint256"
                  }
                },
                "value": null,
                "visibility": "public"
              },
              {
                "body": {
                  "id": 120,
                  "nodeType": "Block",
                  "src": "404:39:2",
                  "statements": [
                    {
                      "expression": {
                        "argumentTypes": null,
                        "id": 118,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "lValueRequested": false,
                        "leftHandSide": {
                          "argumentTypes": null,
                          "id": 116,
                          "name": "mintLimit",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 111,
                          "src": "414:9:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "nodeType": "Assignment",
                        "operator": "=",
                        "rightHandSide": {
                          "argumentTypes": null,
                          "id": 117,
                          "name": "_mintLimit",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 113,
                          "src": "426:10:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "src": "414:22:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "id": 119,
                      "nodeType": "ExpressionStatement",
                      "src": "414:22:2"
                    }
                  ]
                },
                "documentation": null,
                "id": 121,
                "implemented": true,
                "isConstructor": true,
                "isDeclaredConst": false,
                "modifiers": [],
                "name": "LimitedMintableNonFungibleToken",
                "nodeType": "FunctionDefinition",
                "parameters": {
                  "id": 114,
                  "nodeType": "ParameterList",
                  "parameters": [
                    {
                      "constant": false,
                      "id": 113,
                      "name": "_mintLimit",
                      "nodeType": "VariableDeclaration",
                      "scope": 121,
                      "src": "380:15:2",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 112,
                        "name": "uint",
                        "nodeType": "ElementaryTypeName",
                        "src": "380:4:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "value": null,
                      "visibility": "internal"
                    }
                  ],
                  "src": "379:17:2"
                },
                "payable": false,
                "returnParameters": {
                  "id": 115,
                  "nodeType": "ParameterList",
                  "parameters": [],
                  "src": "404:0:2"
                },
                "scope": 166,
                "src": "339:104:2",
                "stateMutability": "nonpayable",
                "superFunction": null,
                "visibility": "public"
              },
              {
                "body": {
                  "id": 164,
                  "nodeType": "Block",
                  "src": "519:261:2",
                  "statements": [
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "commonType": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            },
                            "id": 136,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "leftExpression": {
                              "argumentTypes": null,
                              "expression": {
                                "argumentTypes": null,
                                "baseExpression": {
                                  "argumentTypes": null,
                                  "id": 130,
                                  "name": "ownerToTokensOwned",
                                  "nodeType": "Identifier",
                                  "overloadedDeclarations": [],
                                  "referencedDeclaration": 316,
                                  "src": "537:18:2",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_mapping$_t_address_$_t_array$_t_uint256_$dyn_storage_$",
                                    "typeString": "mapping(address => uint256[] storage ref)"
                                  }
                                },
                                "id": 133,
                                "indexExpression": {
                                  "argumentTypes": null,
                                  "expression": {
                                    "argumentTypes": null,
                                    "id": 131,
                                    "name": "msg",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 958,
                                    "src": "556:3:2",
                                    "typeDescriptions": {
                                      "typeIdentifier": "t_magic_message",
                                      "typeString": "msg"
                                    }
                                  },
                                  "id": 132,
                                  "isConstant": false,
                                  "isLValue": false,
                                  "isPure": false,
                                  "lValueRequested": false,
                                  "memberName": "sender",
                                  "nodeType": "MemberAccess",
                                  "referencedDeclaration": null,
                                  "src": "556:10:2",
                                  "typeDescriptions": {
                                    "typeIdentifier": "t_address",
                                    "typeString": "address"
                                  }
                                },
                                "isConstant": false,
                                "isLValue": true,
                                "isPure": false,
                                "lValueRequested": false,
                                "nodeType": "IndexAccess",
                                "src": "537:30:2",
                                "typeDescriptions": {
                                  "typeIdentifier": "t_array$_t_uint256_$dyn_storage",
                                  "typeString": "uint256[] storage ref"
                                }
                              },
                              "id": 134,
                              "isConstant": false,
                              "isLValue": true,
                              "isPure": false,
                              "lValueRequested": false,
                              "memberName": "length",
                              "nodeType": "MemberAccess",
                              "referencedDeclaration": null,
                              "src": "537:37:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "nodeType": "BinaryOperation",
                            "operator": "<",
                            "rightExpression": {
                              "argumentTypes": null,
                              "id": 135,
                              "name": "mintLimit",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 111,
                              "src": "577:9:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "src": "537:49:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_bool",
                              "typeString": "bool"
                            }
                          ],
                          "id": 129,
                          "name": "require",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [
                            961,
                            962
                          ],
                          "referencedDeclaration": 961,
                          "src": "529:7:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_require_pure$_t_bool_$returns$__$",
                            "typeString": "function (bool) pure"
                          }
                        },
                        "id": 137,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "529:58:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 138,
                      "nodeType": "ExpressionStatement",
                      "src": "529:58:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "id": 140,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "613:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 141,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "623:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 142,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "623:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            },
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          ],
                          "id": 139,
                          "name": "_setTokenOwner",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 744,
                          "src": "598:14:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_internal_nonpayable$_t_uint256_$_t_address_$returns$__$",
                            "typeString": "function (uint256,address)"
                          }
                        },
                        "id": 143,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "598:36:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 144,
                      "nodeType": "ExpressionStatement",
                      "src": "598:36:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 146,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "666:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 147,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "666:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "id": 148,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "678:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            },
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          ],
                          "id": 145,
                          "name": "_addTokenToOwnersList",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 770,
                          "src": "644:21:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_internal_nonpayable$_t_address_$_t_uint256_$returns$__$",
                            "typeString": "function (address,uint256)"
                          }
                        },
                        "id": 149,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "644:43:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 150,
                      "nodeType": "ExpressionStatement",
                      "src": "644:43:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "id": 156,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "lValueRequested": false,
                        "leftHandSide": {
                          "argumentTypes": null,
                          "id": 151,
                          "name": "numTokensTotal",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 299,
                          "src": "698:14:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "nodeType": "Assignment",
                        "operator": "=",
                        "rightHandSide": {
                          "argumentTypes": null,
                          "arguments": [
                            {
                              "argumentTypes": null,
                              "hexValue": "31",
                              "id": 154,
                              "isConstant": false,
                              "isLValue": false,
                              "isPure": true,
                              "kind": "number",
                              "lValueRequested": false,
                              "nodeType": "Literal",
                              "src": "734:1:2",
                              "subdenomination": null,
                              "typeDescriptions": {
                                "typeIdentifier": "t_rational_1_by_1",
                                "typeString": "int_const 1"
                              },
                              "value": "1"
                            }
                          ],
                          "expression": {
                            "argumentTypes": [
                              {
                                "typeIdentifier": "t_rational_1_by_1",
                                "typeString": "int_const 1"
                              }
                            ],
                            "expression": {
                              "argumentTypes": null,
                              "id": 152,
                              "name": "numTokensTotal",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 299,
                              "src": "715:14:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_uint256",
                                "typeString": "uint256"
                              }
                            },
                            "id": 153,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "add",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": 942,
                            "src": "715:18:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$",
                              "typeString": "function (uint256,uint256) pure returns (uint256)"
                            }
                          },
                          "id": 155,
                          "isConstant": false,
                          "isLValue": false,
                          "isPure": false,
                          "kind": "functionCall",
                          "lValueRequested": false,
                          "names": [],
                          "nodeType": "FunctionCall",
                          "src": "715:21:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_uint256",
                            "typeString": "uint256"
                          }
                        },
                        "src": "698:38:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "id": 157,
                      "nodeType": "ExpressionStatement",
                      "src": "698:38:2"
                    },
                    {
                      "expression": {
                        "argumentTypes": null,
                        "arguments": [
                          {
                            "argumentTypes": null,
                            "expression": {
                              "argumentTypes": null,
                              "id": 159,
                              "name": "msg",
                              "nodeType": "Identifier",
                              "overloadedDeclarations": [],
                              "referencedDeclaration": 958,
                              "src": "752:3:2",
                              "typeDescriptions": {
                                "typeIdentifier": "t_magic_message",
                                "typeString": "msg"
                              }
                            },
                            "id": 160,
                            "isConstant": false,
                            "isLValue": false,
                            "isPure": false,
                            "lValueRequested": false,
                            "memberName": "sender",
                            "nodeType": "MemberAccess",
                            "referencedDeclaration": null,
                            "src": "752:10:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            }
                          },
                          {
                            "argumentTypes": null,
                            "id": 161,
                            "name": "_tokenId",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": 123,
                            "src": "764:8:2",
                            "typeDescriptions": {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          }
                        ],
                        "expression": {
                          "argumentTypes": [
                            {
                              "typeIdentifier": "t_address",
                              "typeString": "address"
                            },
                            {
                              "typeIdentifier": "t_uint256",
                              "typeString": "uint256"
                            }
                          ],
                          "id": 158,
                          "name": "Mint",
                          "nodeType": "Identifier",
                          "overloadedDeclarations": [],
                          "referencedDeclaration": 238,
                          "src": "747:4:2",
                          "typeDescriptions": {
                            "typeIdentifier": "t_function_event_nonpayable$_t_address_$_t_uint256_$returns$__$",
                            "typeString": "function (address,uint256)"
                          }
                        },
                        "id": 162,
                        "isConstant": false,
                        "isLValue": false,
                        "isPure": false,
                        "kind": "functionCall",
                        "lValueRequested": false,
                        "names": [],
                        "nodeType": "FunctionCall",
                        "src": "747:26:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_tuple$__$",
                          "typeString": "tuple()"
                        }
                      },
                      "id": 163,
                      "nodeType": "ExpressionStatement",
                      "src": "747:26:2"
                    }
                  ]
                },
                "documentation": null,
                "id": 165,
                "implemented": true,
                "isConstructor": false,
                "isDeclaredConst": false,
                "modifiers": [
                  {
                    "arguments": [
                      {
                        "argumentTypes": null,
                        "id": 126,
                        "name": "_tokenId",
                        "nodeType": "Identifier",
                        "overloadedDeclarations": [],
                        "referencedDeclaration": 123,
                        "src": "509:8:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      }
                    ],
                    "id": 127,
                    "modifierName": {
                      "argumentTypes": null,
                      "id": 125,
                      "name": "onlyNonexistentToken",
                      "nodeType": "Identifier",
                      "overloadedDeclarations": [],
                      "referencedDeclaration": 254,
                      "src": "488:20:2",
                      "typeDescriptions": {
                        "typeIdentifier": "t_modifier$_t_uint256_$",
                        "typeString": "modifier (uint256)"
                      }
                    },
                    "nodeType": "ModifierInvocation",
                    "src": "488:30:2"
                  }
                ],
                "name": "mint",
                "nodeType": "FunctionDefinition",
                "parameters": {
                  "id": 124,
                  "nodeType": "ParameterList",
                  "parameters": [
                    {
                      "constant": false,
                      "id": 123,
                      "name": "_tokenId",
                      "nodeType": "VariableDeclaration",
                      "scope": 165,
                      "src": "463:16:2",
                      "stateVariable": false,
                      "storageLocation": "default",
                      "typeDescriptions": {
                        "typeIdentifier": "t_uint256",
                        "typeString": "uint256"
                      },
                      "typeName": {
                        "id": 122,
                        "name": "uint256",
                        "nodeType": "ElementaryTypeName",
                        "src": "463:7:2",
                        "typeDescriptions": {
                          "typeIdentifier": "t_uint256",
                          "typeString": "uint256"
                        }
                      },
                      "value": null,
                      "visibility": "internal"
                    }
                  ],
                  "src": "462:18:2"
                },
                "payable": false,
                "returnParameters": {
                  "id": 128,
                  "nodeType": "ParameterList",
                  "parameters": [],
                  "src": "519:0:2"
                },
                "scope": 166,
                "src": "449:331:2",
                "stateMutability": "nonpayable",
                "superFunction": null,
                "visibility": "public"
              }
            ],
            "scope": 167,
            "src": "236:546:2"
          }
        ],
        "src": "0:783:2"
      },
      "compiler": {
        "name": "solc",
        "version": "0.4.23+commit.124ca40d.Emscripten.clang"
      },
      "networks": {
        "42": {
          "events": {},
          "links": {},
          "address": "0x8c51dff8fcd48c292354ee751cceabeb25357df4",
          "transactionHash": "0x6ecf5950471f96a7b7dc2460bc9d8f73da019f372f3567e8f80ba768f5e79be2"
        }
      },
      "schemaVersion": "2.0.0",
      "updatedAt": "2018-05-11T03:36:11.157Z"
    }
    """
}
