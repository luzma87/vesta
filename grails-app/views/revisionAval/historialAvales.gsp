<%@ page import="vesta.avales.Aval" %>
<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/15
  Time: 01:13 PM
--%>

<div class="modal-contenido">
<table class="table table-condensed table-bordered table-striped table-hover">
  <thead>
  <tr>
      <th sort="numero" class="sort ${(sort=='numero')?order:''}">Número</th>
        <th sort="proyecto" class="sort ${(sort=='proyecto')?order:''}">Proyecto</th>
        <th sort="proceso" class="sort ${(sort=='proceso')?order:''}">Proceso</th>
        <th sort="monto" class="sort ${(sort=='monto')?order:''}">Monto</th>
        <th sort="requiriente" class="">Requiriente</th>
        <th sort="fechaAprobacion" class="sort ${(sort=='fechaAprobacion')?order:''}">F. Emisión</th>
        <th sort="estado" class="sort ${(sort=='estado')?order:''}">Estado</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${datos}" var="aval">
        <g:set var="sol" value="${vesta.avales.SolicitudAval.findByAval(aval)}"/>
        <tr estadoTr="${aval.estado.codigo}" data-id="${aval?.id}">
            <td>${aval.fechaAprobacion?.format("yyyy")}-GP No.<elm:imprimeNumero aval="${aval.id}"/></td>
            <td style="text-align: center">${aval.proceso.proyecto}</td>
            <td>${aval.proceso.nombre}</td>
            <td style="text-align: right">
                <g:formatNumber number="${aval.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
            </td>
            <td>${sol?.usuario}</td>
            <td>
                ${aval.fechaAprobacion?.format("dd-MM-yyyy")}
            </td>
            <td style="text-align: center" class="${aval.estado?.codigo}">
                ${aval.estado?.descripcion}
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
</div>

<div id="dlgCaducar">
    <g:form action="caducarAval" class="frmCaducar" enctype="multipart/form-data">
        <input type="hidden" name="id" id="idCaducar">
    </g:form>
</div>

<script>
    %{--$(".liberar").button({icons:{ primary:"ui-icon-extlink"},text:false}).click(function(){--}%
%{--//        $("#idLiberar").val($(this).attr("iden"))--}%
%{--//        $("#max").html($(this).attr("max"))--}%
%{--//        $("#monto").val("")--}%
%{--//        $("#contrato").val("")--}%
%{--//        $("#archivo").val("")--}%
%{--//        $("#dlgLiberar").dialog("open")--}%
        %{--location.href="${g.createLink(action: 'liberarAval')}/"+$(this).attr("iden")--}%
    %{--})--}%
    %{----}%

    $(".caducar").button({icons:{ primary:"ui-icon-alert"},text:false}).click(function(){
        $("#idCaducar").val($(this).attr("iden"))
        $("#dlgCaducar").dialog("open")
    })

    function submitForm() {
        var $form = $("#frmLiberar");
        var $btn = $("#dlgLiberar").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Liberando Aval");
            var formData = new FormData($form[0]);
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data        : formData,
                async       : false,
                cache       : false,
                contentType : false,
                processData : false,
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
                        } else {
                            spinner.replaceWith($btn);
                            return false;
                        }
                    }, 1000);
                }
            });
        } else {
            $('.modal-contenido').animate({
                scrollTop: $($(".has-error")[0]).offset().top-100
            }, 1000);
            return false;
        } //else
    }


    function liberarAval(id) {
        var data = id ? { id: id } : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'liberarAval')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgLiberar",
                    title   : "Liberar Aval",

                    class   : "modal-lg",

                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitForm();

                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //crea



//    $("#dlgLiberar").dialog({
//        autoOpen:false,
//        position:"center",
//        title:'Liberar Aval',
//        width:500,
//        modal:true,
//        buttons:{
//            "Liberar":function(){
//                var file = $("#archivo").val()
//                var contrato = $("#contrato").val()
//                var monto = $("#monto").val()
//                var msg =""
//                if(monto==""){
//                    msg+="<br>Por favor ingrese un monto."
//                }
//                if(isNaN(monto)){
//                    msg+="<br>El monto debe ser un número positivo mayor a cero."
//                }else{
//                    if(monto*1<0){
//                        msg+="<br>El monto debe ser un número positivo mayor a cero."
//                    } else{
//                        if(monto>$("#max").html()*1){
//                            msg+="<br>El monto no puede ser mayor a: "+$("#max").html()
//                        }
//                    }
//                }
//                if(contrato==""){
//                    msg+="<br>Ingrese un número de contrato."
//                }
//
//                if(file.length<1){
//                    msg+="<br>Por favor seleccione un archivo."
//                }else{
//                    var ext = file.split('.').pop();
//                    if(ext!="pdf"){
//                        msg+="<br>Por favor seleccione un archivo de formato pdf. El formato "+ext+" no es aceptado por el sistema"
//                    }
//                }
//                if(msg==""){
//                    $(".frmLiberar").submit()
//                }else{
//                    $.box({
//                        title:"Error",
//                        text:msg,
//                        dialog: {
//                            resizable: false,
//                            buttons  : {
//                                "Cerrar":function(){
//
//                                }
//                            }
//                        }
//                    });
//                }
//
//            },"Cerrar":function(){
//                $("#dlgLiberar").dialog("close")
//            }
//        }
//    })

    $("#dlgCaducar").dialog({
        autoOpen:false,
        position:"center",
        title:'Caducar Aval',
        width:500,
        modal:true,
        buttons:{
            "Caducar":function(){

                var msg =""

                if(msg==""){
                    $(".frmCaducar").submit()
                }else{
                    $.box({
                        title:"Error",
                        text:msg,
                        dialog: {
                            resizable: false,
                            buttons  : {
                                "Cerrar":function(){

                                }
                            }
                        }
                    });
                }

            },"Cerrar":function(){
                $("#dlgCaducar").dialog("close")
            }
        }
    })

    $(".imprimiAval").button({icons:{ primary:"ui-icon-print"},text:false}).click(function(){
        //location.href = "${createLink(controller:'avales',action:'descargaAval')}/"+$(this).attr("iden")
        var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id="+$(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=aval.pdf"
    })
    $(".imprimiSolicitud").button({icons:{ primary:"ui-icon-print"},text:false}).click(function(){
        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id="+$(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=solicitud.pdf"
    })
    $(".sort").click(function(){
        var header = $(this)
        var sort = header.attr("sort")
        var order =""
        if(header.hasClass("asc")){
            order="desc"
        }else{
            order="asc"
        }
        cargarHistorialSort($("#anio").val(),$("#numero").val(),$("#descProceso").val(),sort,order)
    }).css({"cursor":"pointer"})

    function createContextMenu(node) {
        var $tr = $(node);

        var items = {
            header: {
                label: "Acciones",
                header: true
            },
            imprimir      : {
                label  : "Imprimir Aval",
                icon   : "fa fa-print",
                action : function ($element) {
                    var id = $element.data("id");
                    var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id="+id;
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=aval.pdf"
                }
            }
        };

        if($tr.attr("estadoTr") == 'E02') {
            items. liberar      = {
                label  : "Liberar",
                icon   : "fa fa-unlink",
                action : function ($element) {
                    var id = $element.data("id");
                    liberarAval(id)
                    return false
                }
            };
        }
        return items;
    }


    $("tbody>tr").contextMenu({

        items  :createContextMenu,
        onShow : function ($element) {
            $element.addClass("success");
        },
        onHide : function ($element) {
            $(".success").removeClass("success");
        }
    });

</script>