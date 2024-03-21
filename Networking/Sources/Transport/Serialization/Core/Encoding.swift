import Foundation

/// Object encoder interface
public protocol Encoding: AnyObject {
    /// Encodes given object
    /// - Parameter value: Object
    /// - Returns: Binary data
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

