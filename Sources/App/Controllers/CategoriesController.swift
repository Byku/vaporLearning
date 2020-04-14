import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api", "categories")
        categoriesRoute.post(Category.self, use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.get(Category.parameter, "acronyms", use: getAcronymsHandler)
    }

    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        category.save(on: req)
    }

    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        Category.query(on: req).all()
    }

    func getHandler(_ req: Request) throws -> Future<Category> {
        try req.parameters.next(Category.self)
    }

    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        try req.parameters.next(Category.self)
            .flatMap(to: [Acronym].self) { category in
                try category.acronyms.query(on: req).all()
            }
    }
}