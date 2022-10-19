
import Quick
import Nimble
@testable import Web3

final class EthereumUtilsTests: QuickSpec {
    
    override func spec() {
        
        describe("getCreate2Address") {
            context("various addresses") {
                let address0: String = "0x0000000000000000000000000000000000000000"
                let salt0: [UInt8] = "0x0000000000000000000000000000000000000000000000000000000000000000".hexToBytes()
                let init_code_hash0: [UInt8] = "0x00".hexToBytes().sha3(.keccak256)
                
                let address1: String = "0xdeadbeef00000000000000000000000000000000"
                let salt1: [UInt8] = "0x000000000000000000000000feed000000000000000000000000000000000000".hexToBytes()
                let init_code_hash1: [UInt8] = "0xdeadbeef".hexToBytes().sha3(.keccak256)
                
                let address2: String = "0x00000000000000000000000000000000deadbeef"
                let salt2: [UInt8] = "0x00000000000000000000000000000000000000000000000000000000cafebabe".hexToBytes()
                let init_code0: [UInt8] = "0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef".hexToBytes()
                let init_code1: [UInt8] = "0x".hexToBytes()
                
                it("should be 0x4D1A2e2bB4F88F0250f26Ffff098B0b30B26BF38") {
                   let result = try EthereumUtils.getCreate2Address(
                    from: address0, salt: salt0, initCodeHash: init_code_hash0)
                   expect(result) == "0x4D1A2e2bB4F88F0250f26Ffff098B0b30B26BF38"
                }
                
                it("should be 0xB928f69Bb1D91Cd65274e3c79d8986362984fDA3") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address1, salt: salt0, initCodeHash: init_code_hash0)
                    expect(result) == "0xB928f69Bb1D91Cd65274e3c79d8986362984fDA3"
                }
                
                it("should be 0xD04116cDd17beBE565EB2422F2497E06cC1C9833") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address1, salt: salt1, initCodeHash: init_code_hash0)
                    expect(result) == "0xD04116cDd17beBE565EB2422F2497E06cC1C9833"
                }
                
                it("should be 0x70f2b2914A2a4b783FaEFb75f459A580616Fcb5e") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address0, salt: salt0, initCodeHash: init_code_hash1)
                    expect(result) == "0x70f2b2914A2a4b783FaEFb75f459A580616Fcb5e"
                }
                
                it("should be 0x60f3f640a8508fC6a86d45DF051962668E1e8AC7") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address2, salt: salt2, initCodeHash: init_code_hash1)
                    expect(result) == "0x60f3f640a8508fC6a86d45DF051962668E1e8AC7"
                }
                
                it("should be 0x1d8bfDC5D46DC4f61D6b6115972536eBE6A8854C") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address2, salt: salt2, initCode: init_code0)
                    expect(result) == "0x1d8bfDC5D46DC4f61D6b6115972536eBE6A8854C"
                }
                
                it("should be 0xE33C0C7F7df4809055C3ebA6c09CFe4BaF1BD9e0") {
                    let result = try EthereumUtils.getCreate2Address(
                        from: address0, salt: salt0, initCode: init_code1)
                    expect(result) == "0xE33C0C7F7df4809055C3ebA6c09CFe4BaF1BD9e0"
                }
                
            }
            
        }
    }
}
