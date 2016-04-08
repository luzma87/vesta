<g:select from="${asignaciones}" optionKey="id" name="asg${params.mod}" noSelection="['-1': 'Seleccione...']"
          optionValue='${{
              (it.presupuesto.numero + " " + it.presupuesto.descripcion) + " Monto: " +
                      g.formatNumber(number: it.priorizado, type: "currency", currencySymbol: " ")
          }}'
          style="width: 100%" class="form-control input-sm selectpicker"/>

<script>

    if(${incremento != 'incremento'}){
        $("#asg${params.mod}").change(function () {
            getMaximo($(this).val(), "${params.mod}");
        })
    }

</script>