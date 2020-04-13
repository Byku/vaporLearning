import Vapor
import FluentPostgreSQL

final class Category: Codable {
    var id: Int?
    var name: String

    init(name: String) {
        self.name = name
    }
}


extension Category: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    public static var idKey: IDKey = \Category.id
}

extension Category: Content {}

extension Category: Migration {}

extension Category: Parameter {}
