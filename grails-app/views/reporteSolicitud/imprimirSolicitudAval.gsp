<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<%@ page import="vesta.seguridad.FirmasService" %>
<%
    def firmasService = grailsApplication.classLoader.loadClass('vesta.seguridad.FirmasService').newInstance()
%>
<html>
    <head>
        <title>Imprimir acta</title>
        <rep:estilos orientacion="p" pagTitle="Solicitud de Aval de POA"/>
        <style type="text/css">

        .tbl {
            border-collapse : collapse;
        }

        .tbl, .tbl th, .tbl td {
            border : solid 1px #555;
        }

        .tbl th {
            /*background  : #bbb;*/
            font-weight : bold;
            text-align  : left;
            width       : 5cm;
        }

        .tbl td, .tbl th {
            padding-left  : 5px;
            padding-right : 5px;
        }

        .bold {
            font-weight : bold;
        }

        .tbl2 {
            border-collapse : collapse;
        }

        .tbl2, .tbl2 th, .tbl2 td {
            border : solid 1px transparent;
        }

        .noBold {
            font-weight : normal !important;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="Solicitud de Aval de POA" unidad="${solicitud.unidad}"
                          numero="${elm.imprimeNumero(solicitud: solicitud.id)}" anio="${solicitud.fecha.format('yyyy')}" estilo="right"/>

        <p style="margin-top: 40px; width: 100%" align="justify">
            Con el propósito de ejecutar las actividades programadas en la planificación operativa institucional
            ${solicitud.proceso.fechaInicio?.format("yyyy")}, la ${ua.nombre}
            solicita emitir el Aval de POA correspondiente al proceso que se detalla a continuación:
        </p>

        <div class="tabla" style="margin-top: 10px">
            <table width="100%" border="1" class="tbl">
                <tr>
                    <th style="width: 200px">
                        UNIDAD REQUIRENTE
                    </th>
                    <td>
                        ${firmasService.requirentes(solicitud.usuario.unidad).nombre}
                    </td>
                </tr>
                <tr>
                    <th>
                        PROYECTO
                    </th>
                    <td>
                        ${solicitud.proceso.proyecto.nombre}
                    </td>
                </tr>
                <tr>
                    <th>
                        PROCESO
                    </th>
                    <td>
                        ${solicitud.proceso.nombre}
                    </td>
                </tr>
                <tr>
                    <th>
                        FECHA DE INICIO
                    </th>
                    <td>
                        ${solicitud?.proceso?.fechaInicio?.format("dd-MM-yyyy")}
                    </td>
                </tr>
                <tr>
                    <th>
                        FECHA DE FIN
                    </th>
                    <td>
                        ${solicitud?.proceso?.fechaFin?.format("dd-MM-yyyy")}
                    </td>
                </tr>
                <tr>
                    <th>
                        MONTO TOTAL SOLICITADO
                    </th>
                    <td>
                        <g:formatNumber number="${solicitud.monto + devengado}" type="currency" currencySymbol="USD "/>
                    </td>
                </tr>
            </table>

            <g:each in="${arr}" var="primero">

                <table width="100%" border="1" class="tbl" style="margin-top: 15px">
                    <tr>
                        <td style="width:200px; font-weight: bold">COMPONENTE</td>
                        <td>${primero?.key?.marcoLogico}</td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">ACTIVIDAD</td>
                        <td>${anio} - ${primero?.key?.numero} - ${primero?.key?.objeto}</td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">CÓDIGO</td>
                        <td>
                            ${primero?.key?.marcoLogico?.proyecto?.codigoEsigef} ${primero?.key?.marcoLogico?.numeroComp} ${primero?.key.numero}
                        </td>
                    </tr>
                    %{--<tr>--}%
                        %{--<td style="font-weight: bold">SUBTOTAL</td>--}%
                        %{--<td>--}%
                            %{--<g:formatNumber number="${primero.value.total}" type="currency" currencySymbol="USD "/>--}%
                        %{--</td>--}%
                    %{--</tr>--}%
                    <g:if test="${primero.value.devengado != 0}">
                        <tr>
                            <td style="font-weight: bold">EJERCICIOS ANTERIORES</td>
                            <td>
                                <g:formatNumber number="${primero.value.devengado}" type="currency" currencySymbol="USD "/>
                            </td>
                        </tr>
                    </g:if>


                    <g:set var="total" value="${0}"/>

                    <g:each in="${primero.value}" var="segundo">
                        <g:if test="${segundo.key.size() == 4}">
                            <g:set var="total2" value="${0}"/>
                            <tr>
                                <td style="font-weight: bold">
                                    MONTO DE AVAL ${segundo.key}
                                </td>
                                <td>
                                    <table class="tbl2">
                                        <g:each in="${segundo.value.asignaciones}" var="tercero">
                                            <tr>
                                                <td>
                                                    <strong>
                                                        Fuente ${tercero.asignacion?.fuente?.codigo},
                                                        Partida ${tercero.asignacion.presupuesto.numero}
                                                    </strong>
                                                </td>
                                                <td style="text-align: right;">
                                                    <g:formatNumber number="${tercero.monto ?: 0}" type="currency" currencySymbol="USD "/>
                                                </td>
                                            </tr>
                                        </g:each>
                                        <tr>
                                            <td><strong>Total</strong></td>
                                            <td style="text-align: right; font-weight: bold">
                                                <g:formatNumber number="${segundo.value.total}" type="currency" currencySymbol="USD "/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </g:if>
                    </g:each>
                </table>
            </g:each>

        </div>

        %{--<div class="texto">--}%
            <table width="100%" border="0">
            <tr>
                <td><strong>Nota Técnica:</strong> ${solicitud?.notaTecnica}</td>
                %{--<td style="text-align: right"><strong>FECHA:</strong>  ${solicitud.fecha.format("dd-MM-yyyy")}</td>--}%
                <td style="text-align: right"><strong>FECHA:</strong>  ${solicitud?.firma?.fecha?.format("dd-MM-yyyy")}</td>
        </tr>
        <tr>

            <td colspan="2">
                    <strong>Revisado por:</strong>  ${solicitud?.director?.sigla ?:
                        solicitud?.director?.nombre && solicitud?.director?.apellido ? solicitud?.director?.nombre + ' ' + solicitud?.director?.apellido : ''}
                </td>
        </tr>
        %{--<tr>--}%
                %{--<td colspan="2">--}%
                    %{--<strong>Revisado por:</strong>  ${solicitud?.director?.sigla ?:--}%
                        %{--solicitud?.director?.nombre && solicitud?.director?.apellido ? solicitud?.director?.nombre + ' ' + solicitud?.director?.apellido : ''}--}%
                %{--</td>--}%
            %{--</tr>--}%

            %{--<span style="float: right">--}%
                %{--<strong>FECHA:</strong>  ${solicitud.fecha.format("dd-MM-yyyy")}--}%
            %{--</span>--}%


            </table>
        %{--</div>--}%

        <div class="no-break">
            %{--<div class="texto">--}%
                %{--<strong>Elaborado por:</strong> ${solicitud?.usuario?.sigla ?: solicitud?.usuario?.nombre + ' ' + solicitud?.usuario?.apellido}--}%
            %{--</div>--}%
            %{--<div class="texto">--}%
                %{--<p>--}%
                    %{--<strong>Revisado por:</strong>  ${solicitud?.director?.sigla ?:--}%
                        %{--solicitud?.director?.nombre && solicitud?.director?.apellido ? solicitud?.director?.nombre + ' ' + solicitud?.director?.apellido : ''}--}%
                %{--</p>--}%
            %{--</div>--}%


            <g:if test="${solicitud.firma?.estado == 'F'}">
                <table width="100%" style="margin-top: 1.5cm;">
                    <tr>
                        <td width="50%" style=" text-align: center;">
                            <img src="${resource(dir: 'firmas', file: solicitud.firma.path)}" style="width: 150px;"/><br/>
                            <b>${solicitud.firma.usuario.nombre} ${solicitud.firma.usuario.apellido}<br/></b>
                            %{--<b>${solicitud.firma.usuario.cargoPersonal}<br/></b>--}%
                            <b>${solicitud.firma.usuario.cargo}<br/></b>
                        </td>
                    </tr>
                </table>
            </g:if>
        </div>

    </body>
</html>