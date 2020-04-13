import FluentPostgreSQL
import Vapor

/// A single entry of a Todo list.
final class Todo: Codable {
    var id: Int?
    var short: String
    var long: String

    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

extension Todo : PostgreSQLModel { }
//extension Todo: Model {
//  typealias Database = PostgreSQLDatabase
//  typealias ID = Int
//  public static var idKey: IDKey = \Todo.id
//
//}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }
