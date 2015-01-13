package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de MetaBuenVivir
 */
class MetaBuenVivirController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
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
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = MetaBuenVivir.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = MetaBuenVivir.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return metaBuenVivirInstanceList: la lista de elementos filtrados, metaBuenVivirInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def metaBuenVivirInstanceList = getList(params, false)
        def metaBuenVivirInstanceCount = getList(params, true).size()
        return [metaBuenVivirInstanceList: metaBuenVivirInstanceList, metaBuenVivirInstanceCount: metaBuenVivirInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return metaBuenVivirInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def metaBuenVivirInstance = MetaBuenVivir.get(params.id)
            if (!metaBuenVivirInstance) {
                render "ERROR*No se encontró MetaBuenVivir."
                return
            }
            return [metaBuenVivirInstance: metaBuenVivirInstance]
        } else {
            render "ERROR*No se encontró MetaBuenVivir."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return metaBuenVivirInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def metaBuenVivirInstance = new MetaBuenVivir()
        if (params.id) {
            metaBuenVivirInstance = MetaBuenVivir.get(params.id)
            if (!metaBuenVivirInstance) {
                render "ERROR*No se encontró MetaBuenVivir."
                return
            }
        }
        metaBuenVivirInstance.properties = params
        return [metaBuenVivirInstance: metaBuenVivirInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def metaBuenVivirInstance = new MetaBuenVivir()
        if (params.id) {
            metaBuenVivirInstance = MetaBuenVivir.get(params.id)
            if (!metaBuenVivirInstance) {
                render "ERROR*No se encontró MetaBuenVivir."
                return
            }
        }
        metaBuenVivirInstance.properties = params
        if (!metaBuenVivirInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar MetaBuenVivir: " + renderErrors(bean: metaBuenVivirInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de MetaBuenVivir exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def metaBuenVivirInstance = MetaBuenVivir.get(params.id)
            if (!metaBuenVivirInstance) {
                render "ERROR*No se encontró MetaBuenVivir."
                return
            }
            try {
                metaBuenVivirInstance.delete(flush: true)
                render "SUCCESS*Eliminación de MetaBuenVivir exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar MetaBuenVivir"
                return
            }
        } else {
            render "ERROR*No se encontró MetaBuenVivir."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = MetaBuenVivir.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render MetaBuenVivir.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render MetaBuenVivir.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

}
