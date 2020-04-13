import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api", "categories")
        categoriesRoute.post(Category.self, use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
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
}