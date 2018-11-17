import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Auditoriums
    let auditoriumsController = AuditoriumsController()
    router.get("auditoriums", use: auditoriumsController.index)
    
    // Groups
    let groupsController = GroupsController()
    router.get("groups", use: groupsController.index)
    
    // Teachers
    let teachersController = TeachersController()
    router.get("teachers", use: teachersController.index)
}
