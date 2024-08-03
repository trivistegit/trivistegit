@EndUserText.label: 'AMDP_FUN'
define table function ZCDS_R_AMDP_FUN
with parameters p_carrid : /dmo/carrier_id,
@Environment.systemField: #CLIENT
p_clnt : abap.clnt
returns {
  client : abap.clnt;
  airline_id : /dmo/carrier_id;
  airline_name : /dmo/carrier_name;
  sum_price : /dmo/flight_price;
  
  
}
implemented by method zcl_akt_amdp_cls01=>get_flight_function;