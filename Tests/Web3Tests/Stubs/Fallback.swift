extension JSONStubs {
    static let Fallback = """
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
                },
                {
                "payable": true,
                "stateMutability": "payable",
                "type": "fallback"
                }
            ]
    }
    """
}
