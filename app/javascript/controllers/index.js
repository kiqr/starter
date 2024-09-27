// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

// Import and register controllers from the Irelia UI kit. [https://github.com/kiqr/irelia] 
import { registerIreliaControllers } from "irelia"
registerIreliaControllers(application)
