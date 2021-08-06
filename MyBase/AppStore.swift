// swiftlint:disable identifier_name
// swiftlint:disable redundant_string_enum_value
// swiftlint:disable type_name
//
//  AppStore.swift
//  MyBase
//
//  Created by Harvey on 2021/8/5.
//

import Foundation

public class AppStore {
    
    public init() { }
    
    /// 获取应用在 AppStore 上的最新信息
    public func lookup(appID: String, completionHandler: @escaping (Result?) -> Void) {
        let url = URL(string: "https://itunes.apple.com/lookup?id=" + appID)!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completionHandler(nil) }
            do {
                let lookup = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(lookup)
            } catch {
                completionHandler(nil)
                print(error)
            }
        }.resume()
    }
    
    public struct Result: Codable {
        
        var count: Int
        var results: [AppInfo]
        
        enum CodingKeys: String, CodingKey {
            case count = "resultCount"
            case results = "results"
        }
    }
    
    public struct AppInfo: Codable {
        
        public var price: Int
        public var kind: String
        public var trackID: Int
        public var artistID: Int
        public var version: String
        public var genres: [String]
        public var bundleID: String
        public var currency: String
        public var trackName: String
        public var sellerName: String
        public var features: [String]
        public var artistName: String
        public var genreIDs: [String]
        public var description: String
        public var wrapperType: String
        public var primaryGenreID: Int
        public var releaseDate: String
        public var trackViewURL: String
        public var artworkURL60: String
        public var advisories: [String]
        public var releaseNotes: String
        public var userRatingCount: Int
        public var fileSizeBytes: String
        public var artistViewURL: String
        public var artworkUrl100: String
        public var artworkUrl512: String
        public var formattedPrice: String
        public var minimumOsVersion: String
        public var screenshotURLs: [String]
        public var primaryGenreName: String
        public var averageUserRating: Float
        public var trackCensoredName: String
        public var isGameCenterEnabled: Bool
        public var supportedDevices: [String]
        public var trackContentRating: String
        public var ipadScreenshotURLs: [String]
        public var languageCodesISO2A: [String]
        public var contentAdvisoryRating: String
        public var appletvScreenshotURLs: [String]
        public var currentVersionReleaseDate: String
        public var userRatingCountForCurrentVersion: Int
        public var isVppDeviceBasedLicensingEnabled: Bool
        public var averageUserRatingForCurrentVersion: Float
        
        enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case price = "price"
            case genres = "genres"
            case trackID = "trackId"
            case version = "version"
            case features = "features"
            case artistID = "artistId"
            case bundleID = "bundleId"
            case genreIDs = "genreIds"
            case currency = "currency"
            case trackName = "trackName"
            case sellerName = "sellerName"
            case artistName = "artistName"
            case advisories = "advisories"
            case description = "description"
            case wrapperType = "wrapperType"
            case releaseDate = "releaseDate"
            case trackViewURL = "trackViewUrl"
            case artworkURL60 = "artworkUrl60"
            case releaseNotes = "releaseNotes"
            case fileSizeBytes = "fileSizeBytes"
            case artistViewURL = "artistViewUrl"
            case artworkUrl100 = "artworkUrl100"
            case artworkUrl512 = "artworkUrl512"
            case screenshotURLs = "screenshotUrls"
            case formattedPrice = "formattedPrice"
            case primaryGenreID = "primaryGenreId"
            case userRatingCount = "userRatingCount"
            case supportedDevices = "supportedDevices"
            case minimumOsVersion = "minimumOsVersion"
            case primaryGenreName = "primaryGenreName"
            case trackCensoredName = "trackCensoredName"
            case averageUserRating = "averageUserRating"
            case ipadScreenshotURLs = "ipadScreenshotUrls"
            case trackContentRating = "trackContentRating"
            case languageCodesISO2A = "languageCodesISO2A"
            case isGameCenterEnabled = "isGameCenterEnabled"
            case contentAdvisoryRating = "contentAdvisoryRating"
            case appletvScreenshotURLs = "appletvScreenshotUrls"
            case currentVersionReleaseDate = "currentVersionReleaseDate"
            case isVppDeviceBasedLicensingEnabled = "isVppDeviceBasedLicensingEnabled"
            case userRatingCountForCurrentVersion = "userRatingCountForCurrentVersion"
            case averageUserRatingForCurrentVersion = "averageUserRatingForCurrentVersion"
        }
    }
}

public extension AppStore {
    
    /// 获取 App 在 AppStore 上的评论
    ///
    /// - Parameters:
    ///   - appID: app 在应用商店上的 ID
    ///   - country: 指定国家(地区)用户的评论，默认不指定；国家(地区)代码小写，如中国，应传"/cn"；国家(地区)代码请参照
    ///   [App Store 国家(地区)代码](https://help.apple.com/app-store-connect/#/dev997f9cf7c)
    ///   - completionHandler: 结果回调
    func customerReviews(appID: String, country: String = "", completionHandler: @escaping (Review?, [Comment]) -> Void) {
        let url = URL(string: "https://itunes.apple.com\(country)/rss/customerreviews/id=\(appID)/json")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completionHandler(nil, []) }
            do {
                let review = try JSONDecoder().decode(Review.self, from: data)
                completionHandler(review, review.result.comments)
            } catch {
                completionHandler(nil, [])
                print(error)
            }
        }.resume()
    }
    /// 评论
    struct Review: Codable {

        public var result: Feed
        enum CodingKeys: String, CodingKey {
            case result = "feed"
        }
    }

    struct Feed: Codable {

        public var id: Id
        public var icon: Icon
        public var link: [Link]
        public var title: Title
        public var author: Author
        public var rights: Rights
        public var updated: Updated
        public var comments: [Comment]

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case link = "link"
            case icon = "icon"
            case title = "title"
            case author = "author"
            case rights = "rights"
            case comments = "entry"
            case updated = "updated"
        }
    }

    /// 评论内容
    struct Comment: Codable {

        public var id: Id
        public var title: Title
        public var author: Author
        public var rating: Rating
        public var link: EntryLink
        public var updated: Updated
        public var content: Content
        public var voteSum: VoteSum
        public var version: Version
        public var voteCount: VoteCount
        public var contentType: ContentType

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case link = "link"
            case title = "title"
            case author = "author"
            case updated = "updated"
            case content = "content"
            case rating = "im:rating"
            case voteSum = "im:voteSum"
            case version = "im:version"
            case voteCount = "im:voteCount"
            case contentType = "im:contentType"
        }
    }

    struct Attributes: Codable {

        public var rel: String
        public var href: String
        public var type: String?
        
        enum CodingKeys: String, CodingKey {
            case rel = "rel"
            case href = "href"
            case type = "type"
        }
    }

    struct Author: Codable {

        public var uri: Uri
        public var name: Name
        public var value: String?

        enum CodingKeys: String, CodingKey {
            case uri = "uri"
            case name = "name"
            case value = "label"
        }
    }

    struct Content: Codable {

        public var value: String
        public var attributes: ContentAttributes

        enum CodingKeys: String, CodingKey {
            case value = "label"
            case attributes = "attributes"
        }
    }

    struct ContentTypeAttributes: Codable {

        public var term: String
        public var value: String

        enum CodingKeys: String, CodingKey {
            case term = "term"
            case value = "label"
        }
    }

    struct LinkAttributes: Codable {

        public var rel: String
        public var href: String

        enum CodingKeys: String, CodingKey {
            case rel = "rel"
            case href = "href"
        }
    }

    struct EntryLink: Codable {
        public var attributes: LinkAttributes
        enum CodingKeys: String, CodingKey {
            case attributes = "attributes"
        }
    }

    struct ContentAttributes: Codable {
        public var type: String
        enum CodingKeys: String, CodingKey {
            case type = "type"
        }
    }

    struct ContentType: Codable {
        public var attributes: ContentTypeAttributes
        enum CodingKeys: String, CodingKey {
            case attributes = "attributes"
        }
    }

    struct Link: Codable {
        public var attributes: Attributes
        enum CodingKeys: String, CodingKey {
            case attributes = "attributes"
        }
    }

    struct Name: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Rating: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Title: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Updated: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Uri: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct VoteCount: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Id: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct VoteSum: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Version: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Rights: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }

    struct Icon: Codable {
        public var value: String
        enum CodingKeys: String, CodingKey {
            case value = "label"
        }
    }
}
