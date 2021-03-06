<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.poa.Asignacion; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Mes" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>POA por Área de gestión</title>

        <rep:estilos orientacion="l" pagTitle="${titulo}"/>

        <style type="text/css">
        .table {
            margin-top      : 0.5cm;
            width           : 100%;
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #444;
        }

        .table td, .table th {
            padding : 3px;
        }

        .text-right {
            text-align : right;
        }

        h1.break {
            page-break-before : always;
        }

        small {
            font-size : 70%;
            color     : #777;
        }

        .table th {
            background     : #326090;
            color          : #fff;
            text-align     : center;
            text-transform : uppercase;
        }

        .actual {
            background : #c7daed;
        }

        .info {
            background : #6fa9ed;
        }

        .text-right {
            text-align : right !important;
        }

        .text-center {
            text-align : center;
        }
        </style>

    </head>

    <body>
        <rep:headerFooter title="${titulo}" subtitulo="${subtitulo}"/>

        <p>
            Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
        </p>

    <g:set var="totalDisponible" value="${0}"/>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th width="3%">GG</th>
                    <th width="3%">#</th>
                    <th width="40%">ACTIVIDAD</th>
                    <th width="30%">RESPONSABLE</th>
                    <g:each in="${anios}" var="anio">
                        <th>${anio.anio}</th>
                        <th> Avalado </th>
                        <th> Disponible </th>
                    </g:each>
                </tr>
            </thead>
            <tbody>
                %{--<g:each in="${data}" var="val" status="i">--}%
                <g:each in="${data}" var="v">
                    %{--<g:set var="v" value="${val.value}"/>--}%
                    <tr>
                        <td>
                            %{--${v?.partida?.numero[0..1]}--}%
                            ${v?.prsp}
                        </td>
                        <td>
                            %{--${v?.actividad?.numero}--}%
                            ${v?.nmro}
                        </td>
                        <td>
                            %{--${v?.actividad?.toStringCompleto()}--}%
                            ${v?.actv}
                        </td>
                        <td>
                            %{--${v?.actividad?.responsable?.nombre}--}%
                            ${v?.unej}
                        </td>

                    <g:each in = "${v.anios}" var="anio">
                        <td class="text-right"> <g:formatNumber number="${anio.prio}" type="currency" currencySymbol=""/></td>
                        <td class="text-right"> <g:formatNumber number="${anio.avalado}" type="currency" currencySymbol=""/> </td>
                        <td class="text-right"> <g:formatNumber number="${anio.prio - anio.avalado}" type="currency" currencySymbol=""/></td>
                    </g:each>

                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th class="text-right" colspan="3"><pre>TOTAL DISPONIBLE:     <g:formatNumber number="${totales}" type="currency" currencySymbol=""/></pre></th>                    %{--<th class="text-right"><g:formatNumber number="${totales}" type="currency" currencySymbol=""/></th>--}%
                    <th class="text-right">TOTALES:</th>
                    <g:each in="${anios}" var="anio">
                        <th class="text-right"> <g:formatNumber number="${anio.prio}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"> <g:formatNumber number="${anio.aval}" type="currency" currencySymbol=""/> </th>
                        <th class="text-right"> <g:formatNumber number="${anio.disp}" type="currency" currencySymbol=""/></th>
                    </g:each>

                </tr>
            </tfoot>
        </table>
    </body>
</html>