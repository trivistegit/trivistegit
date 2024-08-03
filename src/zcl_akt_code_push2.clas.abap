CLASS zcl_akt_code_push2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_akt_code_push2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS c_number TYPE i VALUE 1234.
    DATA lv_str TYPE string.

    lv_str = '**********literals in SQL'.

    out->write( lv_str ).
    SELECT FROM /dmo/carrier
         FIELDS 'Hello'    AS Character,    " Type c
                 1         AS Integer1,     " Type i
                -1         AS Integer2,     " Type i

                @c_number  AS constant      " Type i  (same as constant)

          INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT'
    ).




    lv_str = '**********Cast Opn'.

    out->write( lv_str ).
    SELECT FROM /dmo/carrier
         FIELDS
         '11182001' AS char8,
         CAST( '11182001' AS CHAR( 4 ) ) AS char,
         CAST( '11182001' AS NUMC( 8 ) ) AS numc,
CAST( '11182001' AS INT4 ) AS int4,
CAST( '11182001' AS DEC( 10, 2 ) ) AS dec,
CAST( '11182001' AS FLTP ) AS fltp,
CAST( '11182001' AS DATS ) AS date
          INTO TABLE @DATA(result1).

    out->write(
      EXPORTING
        data   = result1
        name   = 'RESULT1'
    ).

    lv_str = '**********Case exp'.

    out->write( lv_str ).
    SELECT FROM /dmo/flight
         FIELDS
         carrier_id,
         connection_id,
         flight_date,
         CASE
         WHEN seats_occupied < seats_max THEN 'Seats Available'
         WHEN seats_occupied = seats_max THEN 'Seats Full'
         WHEN seats_occupied > seats_max THEN 'Overbooked'
         ELSE 'Not possible'
         END AS booking_status

          INTO TABLE @DATA(result2).

    out->write(
      EXPORTING
        data   = result2
        name   = 'RESULT1'
    ).

    lv_str = '**********Integer Operations'.

    out->write( lv_str ).
***Field SEATS_AVAILABLE is calculated by subtracting the number of
***occupied seats (table field SEATS_OCCUPIED) from the overall
***number of seats on that flight (table field SEATS_MAX).
***Because both operands are of type integer, the result of this expression
***is also an integer.
***
***Field PERCENTAGE_FLTP calculates the percentage of occupied
***seats as a number between 0 and 100.
***For this, it is necessary to multiply the number of
***occupied seats with literal 100 and divide the result by
***the overall number of seats. Because the division operator
***is only available in floating point expressions, all operands
***have to be converted into type FLTP. As a consequence,
***the result is also of type FLTP, which is displayed in scientific
***notation by default.

    SELECT FROM /dmo/flight
           FIELDS carrier_id,
                  connection_id,
                  seats_max - seats_occupied AS seats_available,
                  seats_max,
                  seats_occupied,
                   CAST( (
                   (
                    CAST( seats_occupied AS FLTP ) * CAST(  100 AS FLTP )
                  )

                  / CAST( seats_max AS FLTP )  ) AS DEC( 10, 4 ) )

                   AS per_dec
                  INTO TABLE @DATA(result4).

    out->write(
      EXPORTING
        data   = result4
        name   = 'RESULT1'
    ).

    SELECT FROM /dmo/customer
            FIELDS customer_id,

                   street && ',' && ' ' && postal_code && ' ' && city   AS address_expr,

                   concat( street,
                           concat_with_space(  ',',
                                                concat_with_space( postal_code,
                                                                   upper(  city ),
                                                                   1
                                                                 ),
                                               1
                                            )
                        ) AS address_func

             WHERE country_code = 'ES'
              INTO TABLE @DATA(result_concat).

    out->write(
      EXPORTING
        data   = result_concat
        name   = 'RESULT_CONCAT'
    ).

    SELECT FROM /dmo/carrier
             FIELDS carrier_id,
                    name,
                    upper( name )   AS name_upper,
                    lower( name )   AS name_lower,
                    initcap( name ) AS name_initcap

             WHERE carrier_id = 'SR'
              INTO TABLE @DATA(result_transform).

    out->write(
      EXPORTING
        data   = result_transform
        name   = 'RESULT_TRANSLATE'
    ).


    SELECT FROM /dmo/flight
           FIELDS flight_date,
                  CAST( flight_date AS CHAR( 8 ) )  AS flight_date_raw,

                  left( flight_Date, 4   )          AS year,

                  right(  flight_date, 2 )          AS day,

                  substring(  flight_date, 5, 2 )   AS month "20240505

            WHERE carrier_id = 'LH'
              AND connection_id = '0400'
             INTO TABLE @DATA(result_substring).

    out->write(
      EXPORTING
        data   = result_substring
        name   = 'RESULT_SUBSTRING'
    ).

    SELECT FROM /dmo/connection
             FIELDS carrier_id,
                    connection_id,
                    airport_from_id,
                    distance
              WHERE carrier_id = 'LH'
               INTO TABLE @DATA(result_raw).


    out->write(
      EXPORTING
        data   = result_raw
        name   = 'RESULT_RAW'
    ).

    SELECT FROM /dmo/connection
             FIELDS MAX( distance ) AS max,
                    MIN( distance ) AS min,
                    SUM( distance ) AS sum,
                    CAST( AVG( distance ) AS DEC( 10,5 ) ) AS average,
                    COUNT( * ) AS count,
                    COUNT( DISTINCT airport_from_id ) AS count_dist

              WHERE carrier_id = 'LH'
               INTO TABLE @DATA(result_aggregate).

    out->write(
      EXPORTING
        data   = result_aggregate
        name   = 'RESULT_AGGREGATED'
    ).

    SELECT FROM /dmo/connection
         FIELDS
             carrier_id,
             connection_id,
                MAX( distance ) AS max,
                MIN( distance ) AS min,
                SUM( distance ) AS sum,
                COUNT( * ) AS count

      GROUP BY carrier_id, connection_id
*      HAVING SUM( distance ) > 13000
    having max(  distance ) > 8000
              order by connection_id
         INTO TABLE @DATA(result_grp)

        .
    out->write(
      EXPORTING
        data   = result_grp
        name   = 'RESULT'
    ).
  ENDMETHOD.
ENDCLASS.
