import FluentPostgreSQL
import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a PostgreSQL database
    let postgresql = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig.init(hostname: "localhost", username: "postgres", password: "class135"))
    
    /// Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: AuditoriumModel.self, database: .psql)
    migrations.add(model: GroupModel.self, database: .psql)
    migrations.add(model: TeacherModel.self, database: .psql)
    services.register(migrations)
    
    // MARK: Command
    
    /// Create a `CommandConfig` with default commands.
    var commandConfig = CommandConfig.default()
    /// Add the `CowsayCommand`.
    commandConfig.use(ImportAuditoriumsSumDU(), as: "import-auditoriums-sumdu")
    commandConfig.use(ImportGroupsSumDU(), as: "import-groups-sumdu")
    commandConfig.use(ImportTeachersSumDU(), as: "import-teachers-sumdu")
    /// Register this `CommandConfig` to services.
    services.register(commandConfig)
}
