//
//  URLExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/19.
//

import Foundation


// MARK: - Properties
public extension URL {
    /// SwifterSwift: Dictionary of the URL's query parameters
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

}


// MARK: - Initializers
extension URL {

    /// SwifterSwift: Initializes an `URL` object with a base URL and a relative string. If `string` was malformed, returns `nil`.
    /// - Parameters:
    ///   - string: The URL string with which to initialize the `URL` object. Must conform to RFC 2396. `string` is interpreted relative to `url`.
    ///   - url: The base URL for the `URL` object.
    init?(string: String?, relativeTo url: URL? = nil) {
        guard let string = string else { return nil }
        self.init(string: string, relativeTo: url)
    }

}

// MARK: - Methods
public extension URL {

    /// SwifterSwift: URL with appending query parameters.
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }

    /// SwifterSwift: Append query parameters to URL.
    ///
    ///        var url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendQueryParameters(params)
    ///        print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }

    /// SwifterSwift: Get value of a query key.
    ///
    ///    var url = URL(string: "https://google.com?code=12345")!
    ///    queryValue(for: "code") -> "12345"
    ///
    /// - Parameter key: The key of a query value.
    func queryValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// SwifterSwift: Returns a new URL by removing all the path components.
    ///
    ///     let url = URL(string: "https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: URL with all path components removed.
    func deletingAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0..<pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// SwifterSwift: Remove all the path components from the URL.
    ///
    ///        var url = URL(string: "https://domain.com/path/other")!
    ///        url.deleteAllPathComponents()
    ///        print(url) // prints "https://domain.com/"
    mutating func deleteAllPathComponents() {
        for _ in 0..<pathComponents.count - 1 {
            deleteLastPathComponent()
        }
    }

    /// SwifterSwift: Generates new URL that does not have scheme.
    ///
    ///        let url = URL(string: "https://domain.com")!
    ///        print(url.droppedScheme()) // prints "domain.com"
    func droppedScheme() -> URL? {
        if let scheme = scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }

        guard host != nil else { return self }

        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

}

