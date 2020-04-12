import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        "It works!"
    }

    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
}
