<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/04/15
  Time: 03:18 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA Por Área de gestión</title>
        <style type="text/css">
        .actual {
            background : #c7daed;
        }

        tr:hover .actual {
            background : #a3c2e0;
        }
        </style>
    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-file-pdf-o text-danger"></i> Exportar a PDF
                </a>
                <a href="#" class="btn btn-default" id="btnXls">
                    <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
                </a>
            </div>

            <div class="btn-group" role="group">
                <g:link action="poaProyectoGUI" class="btn btn-default">POA por proyecto</g:link>
                <g:link action="poaGrupoGastoGUI" class="btn btn-default">POA por grupo de gasto</g:link>
                <g:link action="poaFuenteGUI" class="btn btn-default">POA por fuente de financiamiento</g:link>
            </div>
        </div>

        <g:set var="anio" value="${Anio.findByAnio(new Date().format('yyyy'))}"/>

        <elm:container tipo="horizontal" titulo="Reporte de POA Resumen por Área de gestión">
            <table class="table table-bordered table-hover table-condensed table-bordered">
                <thead>
                    <tr>
                        <th>Número</th>
                        <th>Descripción</th>
                        <th>Siglas</th>
                        <th>Arrastre año ${anio.anio.toInteger() - 1}</th>
                        <th>Requerimiento año ${anio.anio}</th>
                        <th>Presupuesto codificado año ${anio.anio}</th>
                        <g:each in="${anios}" var="a">
                            <th>Año ${a}</th>
                        </g:each>
                        <th>Total Plurianual</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${data}" var="v" status="i">
                        <tr>
                            <td>${i + 1}</td>
                            <td>${v.unidad}</td>
                            <td class="text-center">${v.unidad.codigo}</td>
                            <td class="text-right actual">
                                <g:if test="${v.valores["" + (anio.anio.toInteger() - 1)] > 0}">
                                    <g:formatNumber number="${v.valores["" + (anio.anio.toInteger() - 1)]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <td class="text-right actual">
                                <g:if test="${v.valores[anio.anio] > 0}">
                                    <g:formatNumber number="${v.valores[anio.anio]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <td class="text-right info">
                                <g:if test="${v.valores["T" + anio.anio] > 0}">
                                    <g:formatNumber number="${v.valores["T" + anio.anio]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <g:each in="${anios}" var="a">
                                <td class="text-right">
                                    <g:if test="${v.valores[a] > 0}">
                                        <g:formatNumber number="${v.valores[a] ?: 0}" type="currency" currencySymbol=""/>
                                    </g:if>
                                    <g:else>
                                        -&nbsp;&nbsp;&nbsp;&nbsp;
                                    </g:else>
                                </td>
                            </g:each>
                            <td class="text-right">
                                <g:formatNumber number="${v.valores['T']}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th class="text-right" colspan="3">TOTAL</th>
                        <th class="text-right"><g:formatNumber number="${totales["" + (anio.anio.toInteger() - 1)]}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales["" + anio.anio]}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales['T' + anio.anio]}" type="currency" currencySymbol=""/></th>
                        <g:each in="${anios}" var="a">
                            <th class="text-right"><g:formatNumber number="${totales[a] ?: 0}" type="currency" currencySymbol=""/></th>
                        </g:each>
                        <th class="text-right"><g:formatNumber number="${totales['T']}" type="currency" currencySymbol=""/></th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <script type="text/javascript">
            function reporte(tipo) {
                var url;
                if (tipo == "pdf") {
                    url = "${createLink(action: 'poaAreaGestionPdf')}";
                    url += "?anio=" + $("#anio").val();
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=poa_unidad_ejecutora.pdf";
                } else if (tipo == "xls") {
                    url = "${createLink(controller: 'reportesNuevosExcel', action: 'poaAreaGestionXls')}";
                    url += "?anio=" + $("#anio").val();
                    location.href = url;
                }
            }

            $(function () {
                $("#btnXls").click(function () {
                    reporte("xls");
                });
                $("#btnPrint").click(function () {
                    reporte("pdf");
                });
            });
        </script>

    </body>
</html>