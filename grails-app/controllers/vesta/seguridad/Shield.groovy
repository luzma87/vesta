package vesta.seguridad

class Shield {
    def beforeInterceptor = [action: this.&auth, except: 'login']
    /**
     * Verifica si se ha iniciado una sesión
     * Verifica si el usuario actual tiene los permisos para ejecutar una acción
     */
    def auth() {
//        println "auth usuario: ${session.usuario}"
        if (!actionName.contains("ajax")) {
            session.an = actionName
            session.cn = controllerName
            session.pr = params
        }
//        return true
        /** **************************************************************************/
        if (!session.usuario) {
            redirect(controller: 'login', action: 'login')
            session.finalize()
            return false
        } else {
            if (!isAllowed()) {
                redirect(controller: 'shield', action: 'unauthorized')
                return false
            } else
                return true
        }
        /*************************************************************************** */
    }

    boolean isAllowed() {
//        try {
//            if (session.permisos[actionName] == controllerName)
//                return true
//        } catch (e) {
//            println "Shield execption e: " + e
//            return true
//        }
//        return true
        return true
    }
}
 
