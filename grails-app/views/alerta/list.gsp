<%@ page import="vesta.avales.Aval; vesta.modificaciones.DetalleReforma; vesta.modificaciones.Reforma; vesta.alertas.Alerta" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Lista de Alerta</title>

    <style type="text/css">
    .clickable {
        vertical-align : middle !important;
        cursor         : pointer;
    }

    .selected {
        font-weight : bold;
    }

    .d0 {
        background : #e0ffc8;
    }

    .d1 {
        background : #fff949;
    }

    .d2 {
        background : #ff9d4d;
    }

    .dmas {
        background : #ff573f;
    }
    </style>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="alert tdn-note alert-warning" style="margin-top: 15px;">
    <i class="fa fa-2x fa-exclamation-triangle text-shadow" style="margin-top: 15px;"></i> Tiene ${alertaInstanceCount} alertas sin revisar
</div>

<p>
    <a href="#" class="btn btn-default" id="btnRead">
        <i class="fa fa-check"></i>
        Marcar como leídas las alertas seleccionadas
    </a>
</p>

<div class="hide">
    <g:set var="valorReforma" value="${0}"/>
</div>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th></th>
        <th style="width: 85px;">Fecha</th>
        <th>Área de gestión</th>
        <th>Nombre del proceso</th>
        <th>Monto</th>
        <th>Link</th>
    </tr>
    </thead>
    <tbody>

    <g:if test="${alertaInstanceCount > 0}">
        <g:each in="${alertaInstanceList}" status="i" var="alertaInstance">
            <g:set var="valorReforma" value="${0}"/>
            <tr>
                <td class="d${(((new Date()) - alertaInstance.fechaEnvio) > 2) ? "mas" : (new Date()) - alertaInstance.fechaEnvio} clickable" data-id="${alertaInstance.id}">
                    <i class="fa fa-square-o"></i>
                </td>
                <td><g:formatDate date="${alertaInstance.fechaEnvio}" format="dd-MM-yyyy"/></td>

                <g:if test="${alertaInstance?.controlador == 'reforma'}">
                    <td><elm:textoBusqueda busca="${params.search}">
                        ${vesta.modificaciones.Reforma.get(alertaInstance.id_remoto)?.persona?.unidad?.nombre}
                    </elm:textoBusqueda></td>
                    <td>${Reforma.get(alertaInstance.id_remoto)?.concepto}</td>
                    <g:each in="${DetalleReforma.findAllByReforma(Reforma.get(alertaInstance.id_remoto))}" var="valor">
                        <g:if test="${valor?.tipoReforma?.codigo != 'O'}">
                            <g:set var="valorReforma" value="${valorReforma += valor.valor}"/>
                        </g:if>
                    </g:each>
                    <td><g:formatNumber number="${valorReforma}" type="currency" minFractionDigits="2" maxFractionDigits="2"/> </td>
                    <td class="text-center">
                        <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                    </td>
                </g:if>
                <g:elseif test="${alertaInstance?.controlador == 'aval' || alertaInstance?.controlador == 'revisionAval' }">
                    <td><elm:textoBusqueda busca="${params.search}">
                        ${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.usuario?.unidad?.nombre}
                    </elm:textoBusqueda></td>
                    <td>${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.proceso?.nombre}</td>
                    <td><g:formatNumber number="${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="text-center">
                        <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                    </td>
                </g:elseif>
                <g:elseif test="${alertaInstance?.controlador == 'avalCorriente'}">
                    <td><elm:textoBusqueda busca="${params.search}">
                        ${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.usuario?.unidad?.nombre}
                    </elm:textoBusqueda></td>
                    <td>${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.nombreProceso}</td>
                    <td><g:formatNumber number="${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="text-center">
                        <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                    </td>
                </g:elseif>
                <g:elseif test="${alertaInstance?.controlador == 'firma'}">
                    <g:if test="${alertaInstance?.parametros == 'tab=AVAL'}">
                        <g:if test="${alertaInstance?.tipo == 'aval'}">
                            <td><elm:textoBusqueda busca="${params.search}">
                                ${vesta.avales.SolicitudAval.findByAval(vesta.avales.Aval.get(alertaInstance.id_remoto))?.usuario?.unidad?.nombre}
                            </elm:textoBusqueda></td>
                            <td>${vesta.avales.SolicitudAval.findByAval(Aval.get(alertaInstance.id_remoto))?.proceso?.nombre}</td>
                            <td><g:formatNumber number="${vesta.avales.SolicitudAval.findByAval(Aval.get(alertaInstance.id_remoto))?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-center">
                                <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                            </td>
                        </g:if>
                        <g:else>
                            <td><elm:textoBusqueda busca="${params.search}">
                                ${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.usuario?.unidad?.nombre}
                            </elm:textoBusqueda></td>
                            <td>${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.proceso?.nombre}</td>
                            <td><g:formatNumber number="${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-center">
                                <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                            </td>
                        </g:else>

                    </g:if>
                    <g:else>
                        <g:if test="${alertaInstance?.parametros == 'tab=AVCR'}">
                            <td><elm:textoBusqueda busca="${params.search}">
                                ${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.usuario?.unidad?.nombre}
                            </elm:textoBusqueda></td>
                            <td>${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.nombreProceso}</td>
                            <td><g:formatNumber number="${vesta.avales.AvalCorriente.get(alertaInstance.id_remoto)?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-center">
                                <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                            </td>
                        </g:if>
                        <g:else>
                            %{--Valor de la asignacion en firma de la reforma--}%
                            <td><elm:textoBusqueda busca="${params.search}">
                                ${vesta.modificaciones.Reforma.get(alertaInstance.id_remoto)?.persona?.unidad?.nombre}
                            </elm:textoBusqueda></td>
                            <td>${Reforma.get(alertaInstance.id_remoto)?.concepto}</td>
                            %{--<g:each in="${DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(Reforma.get(alertaInstance.id_remoto))}" var="valor">--}%
                            <g:each in="${DetalleReforma.findAllByReforma(Reforma.get(alertaInstance.id_remoto))}" var="valor">
                                <g:if test="${valor?.tipoReforma?.codigo == 'O'}">
                                </g:if>
                                <g:else>
                                    <g:set var="valorReforma" value="${valorReforma += valor.valor}"/>
                                </g:else>
                            </g:each>
                            <td><g:formatNumber number="${valorReforma}" type="currency" minFractionDigits="2" maxFractionDigits="2"/> </td>
                            <td class="text-center">
                                <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                            </td>
                        </g:else>
                    </g:else>
                </g:elseif>
                <g:else>
                    <td>${alertaInstance.from.unidad}</td>
                    <td><elm:textoBusqueda busca="${params.search}">
                        ${alertaInstance.mensaje}
                    </elm:textoBusqueda></td>
                    <td></td>
                    <td class="text-center">
                        <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                    </td>
                </g:else>


                %{--<g:else>--}%
                    %{--<g:if test="${alertaInstance?.controlador == 'aval' || alertaInstance?.controlador == 'revisionAval' }">--}%
                        %{--<td><elm:textoBusqueda busca="${params.search}">--}%
                            %{--${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.usuario?.unidad?.nombre}--}%
                        %{--</elm:textoBusqueda></td>--}%
                        %{--<td>${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.proceso?.nombre}</td>--}%
                        %{--<td><g:formatNumber number="${vesta.avales.SolicitudAval.get(alertaInstance.id_remoto)?.monto}" type="currency" minFractionDigits="2" maxFractionDigits="2"/></td>--}%
                        %{--<td class="text-center">--}%
                            %{--<g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>--}%
                        %{--</td>--}%
                    %{--</g:if>--}%
                    %{--<g:else>--}%
                        %{--<g:if test="${alertaInstance?.controlador == 'firma'}">--}%
                            %{--<g:if test="">--}%
                                %{--<td>${alertaInstance.from.unidad}</td>--}%
                                %{--<td><elm:textoBusqueda busca="${params.search}">--}%
                                    %{--${alertaInstance.mensaje}--}%
                                %{--</elm:textoBusqueda></td>--}%
                                %{--<td></td>--}%
                                %{--<td class="text-center">--}%
                                    %{--<g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>--}%
                                %{--</td>--}%

                            %{--</g:if>--}%


                        %{--</g:if>--}%
                        %{--<g:else>--}%
                            %{--<td>${alertaInstance.from.unidad}</td>--}%
                            %{--<td><elm:textoBusqueda busca="${params.search}">--}%
                                %{--${alertaInstance.mensaje}--}%
                            %{--</elm:textoBusqueda></td>--}%
                            %{--<td></td>--}%
                            %{--<td class="text-center">--}%
                                %{--<g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>--}%
                            %{--</td>--}%
                        %{--</g:else>--}%

                    %{--</g:else>--}%
                %{--</g:else>--}%
            </tr>
        </g:each>
    </g:if>
    <g:else>
        <tr class="danger">
            <td class="text-center" colspan="8">
                <g:if test="${params.search && params.search != ''}">
                    No se encontraron resultados para su búsqueda
                </g:if>
                <g:else>
                    No se encontraron registros que mostrar
                </g:else>
            </td>
        </tr>
    </g:else>
    </tbody>
</table>

<elm:pagination total="${alertaInstanceCount}" params="${params}"/>

<script type="text/javascript">
    $(function () {
        $(".clickable").click(function () {
            var $i = $(this).children("i");
            if ($i.hasClass("fa-square-o")) {
                $i.removeClass("fa-square-o").addClass("fa-check-square-o selected");
            } else {
                $i.removeClass("fa-check-square-o selected").addClass("fa-square-o");
            }
        });

        $("#btnRead").click(function () {
            var ids = "";
            var c = 0;
            $(".selected").each(function () {
                ids += $(this).parent().data("id") + ";";
                c++;
            });
            if (c > 0) {
                var s = c == 1 ? "" : "s";
                var n = c == 1 ? "" : "n";
                bootbox.confirm("¿Está seguro de querer marcar como leída" + s + " <strong>" + c + "</strong> alerta" + s + " seleccionada" + s + "? " +
                "<br/>Este proceso es irreversible y ya no se mostrará" + n + " en la lista.", function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink( action:'marcarLeidas_ajax')}",
                        data    : {
                            ids : ids
                        },
                        success : function (msg) {
                            location.reload(true);
                        }
                    });
                });
            }
            return false;
        });
    });
</script>

</body>
</html>
