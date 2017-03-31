//
//  RMError.swift
//  ResourceManager
//
//  Created by 李智慧 on 30/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Moya

public enum RMError: Swift.Error{
    init(code: Int, message: String) {
        self = .serverError(code, message)
    }
    case serverError(Int, String)
}

extension RMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .serverError(_, message):
            return message
        }
    }
}

extension RMError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .serverError(code, message):
            return "error code is {\(code)}\n message is\(message)"
        }
    }
}

func error(code: Int?, message: String?) -> MoyaError {
    return MoyaError.underlying(RMError(code: code ?? 0, message: message ?? "unknow"))
}
