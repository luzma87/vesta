<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/03/15
  Time: 11:09 AM
--%>

<%@ page import="vesta.proyectos.Proyecto; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA Proyecto</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-highlight', file: 'jquery-highlight1.js')}"></script>

        <style type="text/css">
        .proyecto {
            border  : solid 1px #555;
            padding : 3px;
            cursor  : pointer;
        }

        .highlight {
            background-color : yellow
        }
        </style>

    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <a href="#" class="btn btn-default" id="btnVer">
                    <i class="fa fa-search"></i> Ver reporte
                </a>
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-print"></i> Imprimir reporte
                </a>
            </div>

            <div class="btn-group" role="group">
                <g:link action="poaAreaGestionGUI" class="btn btn-default">POA por área de gestión</g:link>
                <g:link action="poaGrupoGastoGUI" class="btn btn-default">POA por grupo de gasto</g:link>
            </div>
        </div>

        <g:set var="anio" value="${Anio.findByAnio(new Date().format('yyyy'))}"/>

        <elm:container tipo="horizontal" titulo="Configurar reporte de POA por Proyecto">
            <div class="alert alert-info">
                Seleccione el año y al menos un proyecto (haciendo clic sobre su nombre) para generar el reporte
                <div>
                    Mostrar reporte de <span id="spProyectos" class="text-danger">0 proyectos</span>
                    <span id="spPlanificacion" class="text-success">sin programación</span>
                    del <span id="spAnio" class="text-warning">año ${anio.anio}</span>
                </div>
            </div>

            <form class="form-inline">
                <div class="form-group">
                    <label for="anio">Año</label>
                    <g:select from="${Anio.list([sort: 'anio'])}" name="anio" class="form-control input-sm"
                              optionKey="id" optionValue="anio" value="${anio.id}"/>
                </div>

                <div class="checkbox">
                    <label>
                        <input type="checkbox" id="chkPlan"> Programación
                    </label>
                </div>

                <div class="form-group pull-right" style="margin-left: 15px;">
                    <label for="buscar">Buscar</label>
                    <g:textField name="buscar" class="form-control input-sm"/>
                    <span id="found"></span>
                </div>

                <a href="#" class="btn btn-default pull-right" id="btnAll" data-status="off">
                    Seleccionar todos
                </a>

            </form>

            <g:each in="${Proyecto.list([sort: 'nombre'])}" var="proy" status="i">
                <g:if test="${i % 3 == 0}">
                    <g:if test="${i > 0}">
                        </div>
                    </g:if>
                    <div class="row">
                </g:if>
                <div class="col-md-4" title="${proy.nombre}">
                    <div class="proyecto corner-all" id="${proy.id}">
                        ${proy.nombre.size() > 47 ? proy.nombre[0..47] + '...' : proy.nombre}
                    </div>
                </div>
            </g:each>
            </div>
        </elm:container>

        <script type="text/javascript">

            var selectedClass = "bg-success";

            function reset() {
                $(".search").val("");
                $(".proyecto").removeHighlight();
            }

            function reporte(print) {
                var elems = "", url = "";
                $("." + selectedClass).each(function () {
                    elems += $(this).attr("id") + ",";
                });
                if (elems != "") {
                    if (!print) {
                        if ($("#chkPlan").is(":checked")) {
                            url = "${createLink(action: 'poaProyectoWebProg')}";
                        } else {
                            url = "${createLink(action: 'poaProyectoWeb')}";
                        }
                        url += "?anio=" + $("#anio").val() + "&id=" + elems;
                        window.open(url, "_blank");
                    } else {
                        if ($("#chkPlan").is(":checked")) {
                            url = "${createLink(action: 'poaProyectoPdfProg')}";
                        } else {
                            url = "${createLink(action: 'poaProyectoPdf')}";
                        }
                        url += "?anio=" + $("#anio").val() + "Wid=" + elems;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                } else {
                    bootbox.alert("Escoja al menos un proyecto para generar el reporte.");
                    return false;
                }
            }

            $(function () {

                $("#btnAll").click(function () {
                    var $this = $(this);
                    if ($this.data("status") == "on") {
                        $(".proyecto").removeClass(selectedClass);
                        $this.text("Seleccionar todos");
                        $this.data("status", "off");
                    } else {
                        $(".proyecto").addClass(selectedClass);
                        $this.text("Quitar selección");
                        $this.data("status", "on");
                    }
                    var c = $("." + selectedClass).length;
                    $("#spProyectos").text(c + " proyecto" + (c == 1 ? '' : 's'));
                    return false;
                });

                $(".proyecto").click(function () {
                    $(this).toggleClass(selectedClass);
                    var c = $("." + selectedClass).length;
                    $("#spProyectos").text(c + " proyecto" + (c == 1 ? '' : 's'));
                });

                $("#chkPlan").change(function () {
                    var tx = "sin programación";
                    if ($(this).is(":checked")) {
                        tx = "con programación";
                    }
                    $("#spPlanificacion").text(tx);
                });

                $("#anio").change(function () {
                    var anio = $(this).find("option:selected").text();
                    $("#spAnio").text("año " + anio);
                });

                $("#buscar").keyup(function (evt) {
                    var elm = $(this);
                    var txt = elm.val();
                    if ($.trim(txt) != "") {
                        $(".proyecto").removeHighlight().highlight(txt);
                        var h = $(".highlight");
                        var c = h.length;
                        $("#found").text("Se encontr" + (c == 1 ? "ó " : "aron ") + c + " coincidencia" + (c == 1 ? "" : "s"));
                    } else {
                        reset();
                    }
                });

                $("#btnVer").click(function () {
                    reporte(false);
                });
                $("#btnPrint").click(function () {
                    reporte(true);
                });

            });
        </script>
    </body>
</html>