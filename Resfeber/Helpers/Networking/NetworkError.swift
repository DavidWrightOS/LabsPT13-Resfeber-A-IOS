//
//  NetworkError.swift
//  Resfeber
//
//  Created by David Wright on 1/21/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badAuth
    case badRequest
    case otherError
    case unableToComplete
    case invalidResponse
    case noData
    case badData
    case decodingError
    case encodingError
}
