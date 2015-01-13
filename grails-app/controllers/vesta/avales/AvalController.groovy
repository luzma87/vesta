package vesta.avales

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Aval
 */
class AvalController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Aval.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("certificacion", "%" + params.search + "%")  
                    ilike("concepto", "%" + params.search + "%")  
                    ilike("contrato", "%" + params.search + "%")  
                    ilike("memo", "%" + params.search + "%")  
                    ilike("numero", "%" + params.search + "%")  
                    ilike("path", "%" + params.search + "%")  
                    ilike("pathAnulacion", "%" + params.search + "%")  
                    ilike("pathLiberacion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Aval.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return avalInstanceList: la lista de elementos filtrados, avalInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def avalInstanceList = getList(params, false)
        def avalInstanceCount = getList(params, true).size()
        return [avalInstanceList: avalInstanceList, avalInstanceCount: avalInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return avalInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def avalInstance = Aval.get(params.id)
            if(!avalInstance) {
                render "ERROR*No se encontró Aval."
                return
            }
            return [avalInstance: avalInstance]
        } else {
            render "ERROR*No se encontró Aval."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return avalInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def avalInstance = new Aval()
        if(params.id) {
            avalInstance = Aval.get(params.id)
            if(!avalInstance) {
                render "ERROR*No se encontró Aval."
                return
            }
        }
        avalInstance.properties = params
        return [avalInstance: avalInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def avalInstance = new Aval()
        if(params.id) {
            avalInstance = Aval.get(params.id)
            if(!avalInstance) {
                render "ERROR*No se encontró Aval."
                return
            }
        }
        avalInstance.properties = params
        if(!avalInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Aval: " + renderErrors(bean: avalInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Aval exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def avalInstance = Aval.get(params.id)
            if (!avalInstance) {
                render "ERROR*No se encontró Aval."
                return
            }
            try {
                avalInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Aval exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Aval"
                return
            }
        } else {
            render "ERROR*No se encontró Aval."
            return
        }
    } //delete para eliminar via ajax
    
}
