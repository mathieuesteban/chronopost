{*
  * MODULE PRESTASHOP OFFICIEL CHRONOPOST
  * 
  * LICENSE : All rights reserved - COPY AND REDISTRIBUTION FORBIDDEN WITHOUT PRIOR CONSENT FROM OXILEO
  * LICENCE : Tous droits réservés, le droit d'auteur s'applique - COPIE ET REDISTRIBUTION INTERDITES SANS ACCORD EXPRES D'OXILEO
  *
  * @author    Oxileo SAS <contact@oxileo.eu>
  * @copyright 2001-2015 Oxileo SAS
  * @license   Proprietary - no redistribution without authorization
  *}

<script type="text/javascript">
    /* VAR INIT */
    // Define ChronoRelais' radio ID
    var cust_address="{$cust_address|escape:'html'}";
    var cust_address_clean="{$cust_address_clean|escape:'html'}";
    var cust_city="{$cust_city|escape:'html'}"; // HERLLO
    var cust_codePostal="{$cust_codePostal|escape:'html'}";
    var cust_lastname="{$cust_lastname|escape:'html'}";
    var cust_firstname="{$cust_firstname|escape:'html'}";
    var cartID="{$cartID|escape:'html'}";
    var carrierID="{$carrierID|escape:'html'}";
    var carrierIntID="{$carrierIntID|escape:'html'}";
    var path="{$module_uri|escape:'html'}";
    var oldCodePostal=null;
    var relais_map=null; // our map
    var latlngbounds= new google.maps.LatLngBounds();
    var infowindow=null; // currently displayed infowindow
    var map_markers=new Array();
    var data=new Array();
    var errormessage="{l s='No pickup point has been selected !\nPlease select a pickup point to continue.' mod='chronopost'}";

    {literal}
        $(function() {
    
        // Listener for selection of the ChronoRelais carrier radio button
        $('input.delivery_option_radio, input[name=id_carrier]').click(function() {
            toggleRelaisMap(cust_address_clean, cust_codePostal, cust_city);
        });


        // move in DOM
        //$('#extra_carrier').after($('#chronorelais_container')); 

        // toggle on load
        toggleRelaisMap(cust_address_clean, cust_codePostal, cust_city);
        
            // Listener for CP change
            $('#changeCustCP').on('click', function(e) {
                cust_address=$('#relais_codePostal').val()+", France";
                oldCodePostal=cust_codePostal;
                cust_codePostal=$('#relais_codePostal').val();

                initRelaisMap(cust_address, cust_codePostal);
            });

            // Listener for BT select in InfoWindow
            $('#chronorelais_map').click(function(e) {
                if( $(e.target).is('.btselect') )
                   btSelect.call(e.target,e);
            });

            // Listener for cart navigation to next step TODO
            $('input[name=processCarrier]').click(function() {
                if ($('input[name=id_carrier]:checked').val()==carrierID && !$("input[name=chronorelaisSelect]:checked").val()) {
                    alert(errormessage);
                    $.scrollTo($('#relais_txt_cont'));
                    return false;
                }
            });

            // 
        });
    {/literal}
</script>


<div id="chronorelais_container" style="{if $opc!=true}display:none;{/if}" class="container-fluid">
    <h3>{l mod='chronopost' s="Select a pickup point for delivery"}</h3>
    <div class="row">
        <p class="alert col-lg-9">{l mod='chronopost' s="Select a pickup point here below then confirm by choosing 'Select'"}</p>

        <div class="col-lg-3">

        <div class="input-group">
            <input type="text" name="relais_codePostal" class="form-control" value="{$cust_codePostal|escape:'html'}" id="relais_codePostal"/>
              <span class="input-group-btn">
                <button class="btn btn-info" id="changeCustCP" type="button">{l mod='chronopost' s="Change my postcode"}</button>
              </span>
            </div>  
        </div>
    </div>
    <div class="row">
        <div id="chronorelais_map" class="col-xs-12"></div>
    </div>
    <div id="relais_txt_cont">
            <h4>{l mod='chronopost' s="Closest pickup points"}</h4>
            <div id="relais_txt"></div>
    </div>
</div>
