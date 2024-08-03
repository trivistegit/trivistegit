CLASS zcl_akt_amdp_cls01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES: BEGIN OF ty_s_result,
             airline_name      TYPE /dmo/carrier_name,
             flight_connection TYPE /dmo/connection_id,
             old_price         TYPE /dmo/flight_price,
             old_currency      TYPE /dmo/currency_code,
             new_price         TYPE /dmo/flight_price,
             new_currency      TYPE /dmo/currency_code,
           END OF ty_s_result.

    TYPES: BEGIN OF ty_s_flights_table,
             airline_name      TYPE /dmo/carrier_name,
             flight_connection TYPE /dmo/connection_id,
             price             TYPE /dmo/flight_price,
             currency          TYPE /dmo/currency_code,
           END OF ty_s_flights_table.


    TYPES: ty_t_result        TYPE TABLE OF ty_s_result WITH EMPTY KEY,
           ty_t_flights_table TYPE TABLE OF ty_s_flights_table WITH EMPTY KEY.

* Type declaration
    TYPES: BEGIN OF lty_sflight,
             airline_id   TYPE /dmo/carrier_id,
             airline_name TYPE /dmo/carrier_name,
             sum_price    TYPE /dmo/flight_price,
           END OF lty_sflight,

* Table Type declaration
           ltt_sflight TYPE STANDARD TABLE OF lty_sflight WITH EMPTY KEY.

    METHODS: get_flights IMPORTING VALUE(iv_client)   TYPE mandt
                                   VALUE(iv_currency) TYPE /dmo/currency_code
                         EXPORTING VALUE(lt_result)   TYPE ty_t_result
                         RAISING   cx_amdp_execution_error,

      convert_currency IMPORTING VALUE(iv_client)   TYPE mandt
                                 VALUE(lt_flights)  TYPE  ty_t_flights_table
                                 VALUE(iv_currency) TYPE /dmo/currency_code
                       EXPORTING VALUE(lt_result)   TYPE ty_t_result
                       RAISING   cx_amdp_execution_error.

   class-METHODS:   get_flight_function for TABLE FUNCTION ZCDS_R_AMDP_FUN,
                   get_employee for TABLE FUNCTION ZAKT_TABLE_FUNC_EMPLOYEE.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_akt_amdp_cls01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*data: lt_carrid type RANGE OF /dmo/carrier_id,
*      lt_connid type range of /dmo/connection_id.
*
*   lt_carrid = value #( ( sign = 'I' option = 'EQ' low = 'UA' )
*                        ( sign = 'I' option = 'EQ' low = 'AA' ) ).
*
*   lt_connid = value #( ( sign = 'I' option = 'EQ' low = '0058' )
*                        ( sign = 'I' option = 'EQ' low = '0017' ) ).
*
*               .
*                      try.
*                      data(lv_where) = cl_shdb_seltab=>combine_seltabs(
*                                         it_named_seltabs = value #( ( name = 'AIRLINE_NAME' dref = REF #( lt_carrid )  )
*                                                                     ( name = 'FLIGHT_CONNECTION' dref = REF #( lt_connid )  ) )
*                                         iv_client_field  = 'CLIENT'
*                                       ).
*
*                      "catch cx_shdb_exception.
*                      endtry.
    TRY.
        me->get_flights(
          EXPORTING
            iv_client   = sy-mandt
            iv_currency = 'GBP'
          IMPORTING
            lt_result   = DATA(lt_result)
        ).
      CATCH cx_amdp_execution_error.

    ENDTRY.

    out->write(
      EXPORTING
        data   = lt_result
        name   = 'Output flight'
*  RECEIVING
*    output =
    ).
  ENDMETHOD.

  METHOD convert_currency BY DATABASE PROCEDURE FOR HDB LANGUAGE
  SQLSCRIPT OPTIONS READ-ONLY .

    DECLARE today DATE;
    declare new_currency NVARCHAR( 3 );

     select CURRENT_DATE into today from dummy;

     new_currency := :iv_currency;

lt_result = select distinct
             airline_name,
             flight_connection,
             price as old_price,
             currency as old_currency,
             convert_currency(
      "AMOUNT"          => price,
      "SOURCE_UNIT"     => currency,
      "TARGET_UNIT"     => :new_currency,
      "REFERENCE_DATE"  => :today,
      "CLIENT"          => iv_client,
      "ERROR_HANDLING"  => 'set to null',
      "SCHEMA"          => current_schema
    ) as new_price,
    :new_currency as new_currency
    from :lt_flights;


  ENDMETHOD.

  METHOD get_flights BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY USING /dmo/flight
                          /dmo/carrier
                         zcl_akt_amdp_cls01=>convert_currency.

    declare lv_currency NVARCHAR( 3 );

    lv_currency := iv_currency;

        lt_flights =  select DISTINCT
                         c.name as airline_name,
                         f.connection_id as flight_connection,
                         f.price as price,
                         f.currency_code as currency
                         from
                          "/DMO/FLIGHT" as f
                         inner join "/DMO/CARRIER" as c
                         on f.carrier_id = c.carrier_id
                         where f.client = :iv_client;


        call "ZCL_AKT_AMDP_CLS01=>CONVERT_CURRENCY"( iv_client,  :lt_flights, :lv_currency, lt_result);


  ENDMETHOD.

  METHOD get_flight_function
  BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY USING /dmo/flight
                          /dmo/carrier.

    RETURN select
             f.client as client,
             f.carrier_id as airline_id,
             c.name as airline_name,
             sum( f.price ) as sum_price
            from "/DMO/FLIGHT" as f
            inner join "/DMO/CARRIER" as c
            on ( f.carrier_id = c.carrier_id
              and f.client = c.client )
            where f.client = :p_clnt
            and f.carrier_id = :p_carrid
            GROUP BY f.client,
                     f.carrier_id,
                     c.name;


  endmethod.

  METHOD get_employee by database function for hdb language sqlscript
*       options READ-ONLY
       using zakt_employee.


       return select
                 client,
                 employee_id,
                 CONCAT( Concat( first_name, ',' ), last_name ) as name,
                 birth_date,
                 annual_salary,
                 currency_code
                 from "ZAKT_EMPLOYEE"
                 where
                 client = :p_clnt
                 ORDER BY employee_id;
*                 and employee_id = :p_empid;

*update ZAKT_EMPLOYEE
*set employee_id = '000004',
*birth_date = '19900105',
*client = :p_clnt,
*first_name = 'VJ',
*last_name = 'Sathish',
*annual_salary = '300000',
*currency_code = 'USD';



  ENDMETHOD.

ENDCLASS.
