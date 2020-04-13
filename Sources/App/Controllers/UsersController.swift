import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(User.self, use: createHandler)
        usersRoute.get(use: getAllhandler)
        usersRoute.get(User.parameter, use: getHandler)
        usersRoute.get(User.parameter, "acronyms", use: getAcronymsHandler)
    }

    func createHandler(_ req: Request, user: User) throws -> Future<User> {
        user.save(on: req)
    }

    func getAllhandler(_ req: Request) throws -> Future<[User]> {
        User.query(on: req).all()
    }

    func getHandler(_ req: Request) throws -> Future<User> {
        try req.parameters.next(User.self)
    }

    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        try req.parameters.next(User.self)
        .flatMap(to: [Acronym].self) { user in
            try user.acronyms.query(on: req).all()
        }
    }
}