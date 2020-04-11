import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        "It works!"
    }
    
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self)
            .flatMap(to: Acronym.self, { acronym in
                return acronym.save(on: req)
            })
    }
    
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        Acronym.query(on: req).all()
    }

    router.get("api", "acronym", Acronym.parameter) { req -> Future<Acronym> in 
        try req.parameters.next(Acronym.self)
    }
}
