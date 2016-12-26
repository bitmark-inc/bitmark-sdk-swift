//
//  Result.swift
//  Bitmark
//
//  From https://github.com/JadenGeller/Burrow-Client
//  Ported to Swift 3 by Anh Nguyen on 12/24/16.
//
//

public protocol ResultType {
    associatedtype Element
    init(_ closure: () throws -> Element)
    func unwrap() throws -> Element
}

public enum Result<Element>: ResultType {
    case success(Element)
    case failure(Error)
}

extension Result {
    public init(_ closure: () throws -> Element) {
        do {
            self = .success(try closure())
        } catch let error {
            self = .failure(error)
        }
    }
    
    public func unwrap() throws -> Element {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension Result {
    public func map<V>(_ transform: (Element) throws -> V) -> Result<V> {
        switch self {
        case .success(let value):
            do {
                return .success(try transform(value))
            } catch let error {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public mutating func mutate(_ mutation: (inout Element) throws -> ()) {
        if case .success(let value) = self {
            do {
                var copy = value
                try mutation(&copy)
                self = .success(copy)
            } catch let error {
                self = .failure(error)
            }
        }
    }
    
    public func recover(_ handle: (Error) throws -> Element) -> Result<Element> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            do {
                return .success(try handle(error))
            } catch let error {
                return .failure(error)
            }
        }
    }
}
