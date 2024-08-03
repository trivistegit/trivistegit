CLASS zcl_akt_code_pushdown DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_akt_code_pushdown IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA:lv_str TYPE c LENGTH 50.
*    SELECT FROM /dmo/carrier AS a
*           INNER JOIN /dmo/connection AS b
*           ON a~carrier_id = b~carrier_id
*           FIELDS a~carrier_id,
*                  a~name,
*                  b~connection_id,
*                  b~airport_from_id,
*                  b~airport_to_id,
*                  b~distance,
*                  b~distance_unit
*            WHERE a~currency_code = 'EUR'
*            INTO TABLE @DATA(lt_connection).
*
*    out->write(
*      EXPORTING
*        data   = lt_connection
*        name   = 'Carrier and Connection'
**            RECEIVING
**              output =
*    ).
*    lv_str = '************Left Outer******************'.
*    out->write( lv_str ).
*    CLEAR lt_connection.
*    SELECT FROM /dmo/carrier AS a
*               LEFT OUTER JOIN /dmo/connection AS b
*               ON a~carrier_id = b~carrier_id
*               FIELDS a~carrier_id,
*                      a~name,
*                      b~connection_id,
*                      b~airport_from_id,
*                      b~airport_to_id,
*                      b~distance,
*                      b~distance_unit
*                WHERE a~currency_code = 'EUR'
*                INTO TABLE @lt_connection.
*
*    out->write(
*      EXPORTING
*        data   = lt_connection
*        name   = 'Carrier and Connection'
**            RECEIVING
**              output =
*    ).
*
*    lv_str = '************right Outer******************'.
*    out->write( lv_str ).
*    CLEAR lt_connection.
*    SELECT FROM /dmo/carrier AS a
*               RIGHT OUTER JOIN /dmo/connection AS b
*               ON a~carrier_id = b~carrier_id
*               FIELDS a~carrier_id,
*                      a~name,
*                      b~connection_id,
*                      b~airport_from_id,
*                      b~airport_to_id,
*                      b~distance,
*                      b~distance_unit
*                WHERE a~currency_code = 'EUR'
*                INTO TABLE @lt_connection.
*    out->write(
*      EXPORTING
*        data   = lt_connection
*        name   = 'Carrier and Connection'
**            RECEIVING
**              output =
*    ).
*
*    lv_str = '************Multi Joins-1******************'.
*    out->write( lv_str ).
*
*    CLEAR lt_connection.
*    SELECT FROM (  /dmo/carrier AS a
*               LEFT OUTER JOIN /dmo/connection AS b
*               ON a~carrier_id = b~carrier_id )
*               left OUTER join /dmo/airport as c
*               on b~airport_from_id = c~airport_id
*               FIELDS a~carrier_id,
*                      a~name,
*                      b~connection_id,
*                      b~airport_from_id,
*                      b~airport_to_id,
*                      b~distance,
*                      b~distance_unit,
*                      c~name as Airport_From,
*                      c~city as airport_from_city
*                WHERE a~currency_code = 'EUR'
*                INTO TABLE @data(lt_connection2).
*    out->write(
*      EXPORTING
*        data   = lt_connection2
*        name   = 'Carrier and Connection'
**            RECEIVING
**              output =
*    ).
*
*    lv_str = '************Multi Joins-2******************'.
*    out->write( lv_str ).
*
*    CLEAR lt_connection.
*    SELECT FROM (  (  /dmo/carrier AS a
*               LEFT OUTER JOIN /dmo/connection AS b
*               ON a~carrier_id = b~carrier_id )
*               left OUTER join /dmo/airport as c
*               on b~airport_from_id = c~airport_id )
*               left outer join /dmo/airport as d
*               on b~airport_to_id = d~airport_id
*               FIELDS a~carrier_id,
*                      a~name,
*                      b~connection_id,
*                      b~airport_from_id,
*                      b~airport_to_id,
*                      b~distance,
*                      b~distance_unit,
*                      c~name as Airport_From,
*                      c~city as airport_from_city,
*                      d~name as Airport_to,
*                      d~city as airport_to_city
*                WHERE a~currency_code = 'EUR'
*                INTO TABLE @data(lt_connection3).
*    out->write(
*      EXPORTING
*        data   = lt_connection3
*        name   = 'Carrier and Connection'
**            RECEIVING
**              output =
*    ).

    lv_str = '************Multi Joins-w/o brackets******************'.
    out->write( lv_str ).

    SELECT FROM  /dmo/carrier AS a
                LEFT OUTER JOIN

               /dmo/connection AS b
                ON a~carrier_id = b~carrier_id
               LEFT OUTER JOIN /dmo/airport AS c
               ON b~airport_from_id = c~airport_id

               LEFT OUTER JOIN /dmo/airport AS d
               ON b~airport_to_id = d~airport_id


               FIELDS a~carrier_id,
                      a~name,
                      b~connection_id,
                      b~airport_from_id,
                      b~airport_to_id,
                      b~distance,
                      b~distance_unit,
                      c~name AS Airport_From,
                      c~city AS airport_from_city,
                      d~name AS Airport_to,
                      d~city AS airport_to_city
                WHERE a~currency_code = 'EUR'
                INTO TABLE @DATA(lt_connection4).
    out->write(
      EXPORTING
        data   = lt_connection4
        name   = 'Carrier and Connection'
*            RECEIVING
*              output =
    ).
  ENDMETHOD.
ENDCLASS.
