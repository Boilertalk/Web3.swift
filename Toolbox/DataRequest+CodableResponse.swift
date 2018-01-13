//
//  DataRequest+CodableResponse.swift
//  Web3
//
//  Created by Koray Koska on 13.01.18.
//

import Foundation
import Alamofire

extension DataRequest {

    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        response(queue: queue, responseSerializer: DecodableDataResponseSerializerProtocol<T>(), completionHandler: completionHandler)

        return self
    }
}

class DecodableDataResponseSerializerProtocol<D: Decodable>: DataResponseSerializerProtocol {

    let decoder: JSONDecoder

    init() {
        decoder = JSONDecoder()
    }

    typealias SerializedObject = D

    var serializeResponse: (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<D> {
        return { req, resp, data, err in


            guard err == nil else { return .failure(err!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            do {
                let json = try self.decoder.decode(D.self, from: data)
                return .success(json)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
}
