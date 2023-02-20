//
//  RequestError.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/17/23.
//

import Foundation

public struct Error: LocalizedError, Codable {
    public var code: Int
    public var error: String?
    
    public var statusCode: HttpStatusCode? {
        return HttpStatusCode(rawValue: code)
    }
    
    public var errorDescription: String? {
        return error
    }
}

