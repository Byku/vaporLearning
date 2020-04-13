import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
    var id: Int?
    var userID: User.ID
    var short: String
    var long: String
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
}
 
extension Acronym: Model {
    typealias Database = PostgreSQLDatabase
    typealias ID = Int
    public static var idKey: IDKey = \Acronym.id
}

//extension Acronym: PostgreSQLModel {}

extension Acronym: Migration {
    public static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Acronym: Content {}

extension Acronym: Parameter {}

extension Acronym {
    var user: Parent<Acronym, User> {
        parent(\.userID)
    }

    var categories: Siblings<Acronym,
                             Category,
                             AcronymCategoryPivot> {
        siblings()
    }
}