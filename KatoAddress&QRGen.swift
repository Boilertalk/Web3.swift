//
//  Create Address
//
//  Created by Amato Alireza AKA Kato on 26/05/2023.
//
import SwiftUI
import secp256k1
import CoreImage.CIFilterBuiltins

class CreateWallet: ObservableObject {
    @Published var address: String = ""
    @Published var publicKey: String = ""
    @Published var privateKey: String = ""
    
    // MARK: - ACCOUNT ADDRESS CREATION
    
    // MARK: - GENERATE PRIVATE KEY
    // Generate a 32-byte private key using a cryptographically secure random number generator
    func generatePrivateKey() -> Data? {
        var privateKeyData = Data(count: 32)
        let result = privateKeyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        return result == errSecSuccess ? privateKeyData : nil
    }
    // MARK: - GENERATE PUBLIC KEY
    // Generate a public key from the given private key using the secp256k1 elliptic curve
    func generatePublicKey(from privateKey: Data) -> Data? {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer {
            secp256k1_context_destroy(context)
        }
        var pubkey = secp256k1_pubkey()
        let result = privateKey.withUnsafeBytes {
            (privateKeyPtr: UnsafeRawBufferPointer) -> Int32 in
            guard let privateKeyBytes = privateKeyPtr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return 0
            }
            return secp256k1_ec_pubkey_create(context, &pubkey, privateKeyBytes)
        }
        if result != 1 {
            print("Failed to generate public key")
            return nil
        }
        var pubkeySerialized = Data(count: 65)
        var pubkeySize = 65
        pubkeySerialized.withUnsafeMutableBytes {
            (pubkeySerializedPtr: UnsafeMutableRawBufferPointer) -> Void in
            guard let pubkeySerializedBytes = pubkeySerializedPtr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            secp256k1_ec_pubkey_serialize(context, pubkeySerializedBytes, &pubkeySize, &pubkey, UInt32(SECP256K1_EC_UNCOMPRESSED))
        }
        return pubkeySerialized
    }

    // MARK: - GENERATE ETHERUM ADDRESS
    // Generate a Etherum Address from public key
    func ethereumAddress(from publicKey: Data) -> String {
        // Step a: Remove the first byte from the public key
        let publicKeyWithoutPrefix = publicKey[1...]
        // Step b: Hash the resulting 64-byte (uncompressed) public key using the Keccak-256 hash function
        let keccak256Hash = publicKeyWithoutPrefix.sha3(.keccak256)
        // Step c: Take the last 20 bytes of the hash, which represents the Ethereum address
        let ethereumAddressData = keccak256Hash.suffix(20)
        // Convert the address data to a hex string and add the '0x' prefix
        let ethereumAddress = "0x" + ethereumAddressData.map {
            String(format: "%02x", $0)
        }
        .joined()
        return ethereumAddress
    }

    func createAddress() {
        if let privateKeyData = generatePrivateKey() {
            privateKey = privateKeyData.map {
                String(format: "%02x", $0)
            }
            .joined()
            print("Private Key: \(privateKey)")
            if let publicKeyData = generatePublicKey(from: privateKeyData) {
                publicKey = publicKeyData.map {
                    String(format: "%02x", $0)
                }
                .joined()
                print("Public Key: \(publicKey)")
                address = ethereumAddress(from: publicKeyData)
                print("Ethereum Address: \(address)")
            }
            else {
                print("Failed to generate public key.")
            }
        }
        else {
            print("Failed to generate private key.")
        }
    }
}
struct CreateAddress: View {
    @StateObject private var createWallet = CreateWallet()
    @State private var isCopiedAddress = false
    @State private var isCopiedPublicKey = false
    @State private var isCopiedPrivateKey = false
    @State private var showPublicKey = false
    @State private var showPrivateKey = false
    var body: some View {
        VStack(spacing: 3) {
            if createWallet.address.isEmpty {
                Button("Create Address") {
                    createWallet.createAddress()
                }
            }
            else {
                Text("Your Address")
                .font(.headline)
                .foregroundColor(.accentColor)
                QRCodeView(url: createWallet.address)
                HStack {
                    Text(createWallet.address)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.leading,35)
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = createWallet.address
                        isCopiedAddress = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isCopiedAddress = false
                        }
                    })
                    {
                        Image(systemName: isCopiedAddress ? "checkmark.circle" : "doc.on.doc").frame(width: 20)
                    }
                }
                .frame(width: 380, height: 30, alignment: .center)
                if showPublicKey {
                    HStack {
                        Button(action: {
                            showPublicKey = false
                        })
                        {
                            Image(systemName: "eye.slash")
                        }
                        Text(createWallet.publicKey)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        Button(action: {
                            UIPasteboard.general.string = createWallet.publicKey
                            isCopiedPublicKey = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCopiedPublicKey = false
                            }
                        })
                        {
                            Image(systemName: isCopiedPublicKey ? "checkmark.circle" : "doc.on.doc").frame(width: 20)
                        }
                    }
                    .frame(width: 380, height: 55, alignment: .center)
                }
                else {
                    Button(action: {
                        showPublicKey = true
                    })
                    {
                        Text("Show Public Key")
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 55)
                }
                if showPrivateKey {
                    HStack {
                        Button(action: {
                            showPrivateKey = false
                        })
                        {
                            Image(systemName: "eye.slash")
                        }
                        Text(createWallet.privateKey)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        Button(action: {
                            UIPasteboard.general.string = createWallet.privateKey
                            isCopiedPrivateKey = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCopiedPrivateKey = false
                            }
                        })
                        {
                            Image(systemName: isCopiedPrivateKey ? "checkmark.circle" : "doc.on.doc").frame(width: 20)
                        }
                    }
                    .frame(width: 380, height: 55, alignment: .center)
                }
                else {
                    Button(action: {
                        showPrivateKey = true
                    })
                    {
                        Text("Show Private Key")
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 55)
                }
            }
        }
    }

}

struct QRCodeView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var url: String
    var body: some View {
        Image(uiImage: generateQRCode(from: url))
        .interpolation(.none)
        .resizable()
        .scaledToFit()
        .frame(width: 230, height: 230)
    }

    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

}

struct CreateAddress_Previews: PreviewProvider {
    static var previews: some View {
        CreateAddress()
    }

}

