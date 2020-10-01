//
//  Secp256k1+CTXCreator.swift
//  Web3
//
//  Created by Koray Koska on 21.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import secp256k1

public func secp256k1_default_ctx_create(errorThrowable: Error) throws -> OpaquePointer {
    let c = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN) | UInt32(SECP256K1_CONTEXT_VERIFY))
    guard let ctx = c else {
        throw errorThrowable
    }

    guard var rand = Bytes.secureRandom(count: 32) else {
        throw errorThrowable
    }

    guard secp256k1_context_randomize(ctx, &rand) == 1 else {
        throw errorThrowable
    }

    return ctx
}

public func secp256k1_default_ctx_destroy(ctx: OpaquePointer) {
    secp256k1_context_destroy(ctx)
}
