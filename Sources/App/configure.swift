import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config,
                      _ env: inout Environment,
                      _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    let databaseName: String
    let databasePort: Int
    if env == .testing {
        databaseName = "vapor-test"
        databasePort = 5433
    } else {
        databaseName = "vapor"
        databasePort = 5432
    }
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: "localhost",
            port: databasePort,
        username: "vapor",
        database: databaseName,
        password: "password")
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: DatabaseIdentifier<Todo.Database>.psql)
    migrations.add(model: User.self, database:  DatabaseIdentifier<User.Database>.psql)
    migrations.add(model: Acronym.self, database:  DatabaseIdentifier<Acronym.Database>.psql)
    migrations.add(model: Category.self, database:  DatabaseIdentifier<Category.Database>.psql)
    migrations.add(model: AcronymCategoryPivot.self, database:  DatabaseIdentifier<AcronymCategoryPivot.Database>.psql)
    services.register(migrations)

    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
