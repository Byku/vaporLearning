import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \User.id
}

//extension User: PostgreSQLUUIDModel {}

extension User: Content {}

extension User: Migration {}

extension User: Parameter {}

extension User {
    var acronyms: Children<User, Acronym> {
        children(\.userID)
    }
}