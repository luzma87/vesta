<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reforma de POA</title>
        <rep:estilos orientacion="l" pagTitle="Reforma al POA"/>
        <style type="text/css">
        table {
            font-size : 9pt;
        }

        ol {
            counter-reset : item;
            padding       : 0;
        }

        ol li {
            display       : block;
            margin-bottom : 5px;
        }

        ol li:before {
            content           : counter(item) ". ";
            counter-increment : item;
            font-weight       : bold;
        }

        .table {
            border-collapse : collapse;
            border          : solid 1px #000000;
        }

        .center {
            text-align : center;
        }

        .fright {
            float : right;
        }

        .valor {
            text-align : right;
        }

        .formato {
            font-weight : bold;
            background  : #008080;
            color       : #ffffff;
        }

        td {
            border : solid 1px #000000;

        }

        th {
            border : solid 1px #000000;
        }

        .text-right {
            text-align : right;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="REFORMA AL POA" unidad="${reforma.fecha.format('yyyy')}-GP"
                          numero="${reforma.numero}" estilo="right"/>
        <div style="margin-left: 10px;">
            <div>
                <ol>
                    <li>
                        <strong>Unidad responsable (Gerencia-Dirección):</strong> ${reforma.persona.unidad}
                    </li>
                    <li>
                        <strong>Matriz de la reforma:</strong>
                        <g:set var="ti" value="${0}"/>
                        <g:set var="tvi" value="${0}"/>
                        <g:set var="tvf" value="${0}"/>
                        <g:set var="tf" value="${0}"/>
                        <table style="width:100%;margin-top: 15px" class="table " border="1">
                            <thead>
                                <tr>
                                    <th style="background: #9dbfdb; text-align: center">Proyecto</th>
                                    <th style="background: #9dbfdb; text-align: center">Componente</th>
                                    <th style="background: #9dbfdb; text-align: center">No</th>
                                    <th style="background: #9dbfdb; text-align: center">Nombre de la actividad</th>
                                    <th style="background: #9dbfdb; text-align: center">
                                        Partida <br/>
                                        presupuestaria
                                    </th>
                                    <th style="background: #9dbfdb; text-align: center">Valor inicial</th>
                                    <th style="background: #9dbfdb; text-align: center">Disminución</th>
                                    <th style="background: #9dbfdb; text-align: center">Aumento</th>
                                    <th style="background: #9dbfdb; text-align: center">Valor final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:set var="totalInicial" value="${modificaciones.first().originalOrigen}"/>
                                <g:set var="totalDisminucion" value="${0}"/>
                                <g:set var="totalAumento" value="${0}"/>
                                <g:set var="menos" value="${modificaciones.sum {
                                    it.valor
                                }}"/>
                                <g:set var="totalFinal" value="${totalInicial - menos + menos}"/>
                                <tr class="info">
                                    <td>
                                        ${modificaciones.first().desde.marcoLogico.proyecto.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${modificaciones.first().desde.marcoLogico.marcoLogico.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${modificaciones.first().desde.marcoLogico.numero}
                                    </td>
                                    <td>
                                        ${modificaciones.first().desde.marcoLogico.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${modificaciones.first().desde}
                                    </td>
                                    <td class="text-right">
                                        <g:formatNumber number="${modificaciones.first().originalOrigen}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="text-right">
                                        <g:formatNumber number="${menos}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td></td>
                                    <td class="text-right">
                                        <g:formatNumber number="${modificaciones.first().originalOrigen - menos}" type="currency" currencySymbol=""/>
                                    </td>
                                </tr>
                                <g:each in="${modificaciones}" var="modificacion">
                                    <g:set var="totalDisminucion" value="${totalDisminucion + modificacion.valor}"/>
                                    <g:set var="totalAumento" value="${totalAumento + modificacion.valor}"/>
                                    <tr class="success">
                                        <td>
                                            ${modificacion.recibe.marcoLogico.proyecto.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${modificacion.recibe.marcoLogico.marcoLogico.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${modificacion.recibe.marcoLogico.numero}
                                        </td>
                                        <td>
                                            ${modificacion.recibe.marcoLogico.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${modificacion.recibe}
                                        </td>
                                        <td class="text-right">
                                            %{--<g:formatNumber number="${rma.asignacionDestino.priorizado}" type="currency" currencySymbol=""/>--}%
                                        </td>
                                        <td></td>
                                        <td class="text-right">
                                            <g:formatNumber number="${modificacion.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                        <td class="text-right">
                                            <g:formatNumber number="${modificacion.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                    </tr>
                                </g:each>
                                <tr>
                                    <td colspan="4" style="background: #008080"></td>
                                    <td class="formato">TOTAL</td>
                                    <td class="valor formato"><g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </li>
                </ol>

                <div style="margin-bottom: 10px">
                    <strong>Observación:</strong>  ${reforma.concepto}
                </div>

                <div>
                    <strong>Elaborado por:</strong> ${reforma.persona.sigla}
                </div>

                <div class="fright">
                    <strong>FECHA:</strong> ${reforma.fechaRevision?.format("dd-MM-yyyy")}
                </div>

                <div class="no-break">
                    <table width="100%" style="margin-top: 0.5cm; border: none" border="none">
                        <tr>
                            <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado == 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                            <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado != 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                            <g:if test="${reforma.firma2?.estado == 'F' && reforma.firma1?.estado != 'F'}">
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                        </tr>
                    </table>

                    <table width="100%" style="border: none" border="none">
                        <tr>
                            <td width="50%" style=" text-align: center;border: none">
                                <g:if test="${reforma?.firma1?.estado == 'F'}">
                                    <g:if test="${resource(dir: 'firmas', file: reforma.firma1.path)}">
                                        <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px"></div>
                                        <b style="text-align: center">${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                        </b>
                                        <b style="text-align: center;">${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:if>
                                    <g:else>
                                        <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                        <b style="text-align: center">${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                        </b>
                                        <b style="text-align: center;">${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:else>

                                </g:if>
                            </td>
                            <td width="50%" style=" text-align: center;;border: none">
                                <g:if test="${reforma?.firma2?.estado == 'F'}">
                                    <g:if test="${resource(dir: 'firmas', file: reforma.firma2.path)}">
                                        <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px;"></div>
                                        <b class="center">${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                        </b>
                                        <b class="center">${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>
                                        </b>

                                    </g:if>
                                    <g:else>
                                        <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                        <b class="center">${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                        </b>
                                        <b class="center">${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:else>

                                </g:if>
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>
    </body>
</html>