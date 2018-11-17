import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Auditoriums
    try router.register(collection: AuditoriumController())
    
    // Groups
    try router.register(collection: GroupController())
    
    // Teachers
    try router.register(collection: TeacherController())
}
