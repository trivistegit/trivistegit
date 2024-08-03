@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SQL_CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAKT_R_SQL_CDS as select from /DMO/I_Connection_R
  {
    key AirlineID,
    key ConnectionID,

        concat_with_space(
          concat_with_space(
            concat_with_space(
              concat(
                 concat( AirlineID,
                         ConnectionID ),
                 ': ' ),
              DepartureAirport, 1 ),
           '->', 1 ),
        DestinationAirport, 1 ) as Description

       ,
       count( distinct _Flight.FlightDate ) as NumberOfFlights,
        min( _Flight.FlightDate )            as FirstFlightDate,
        sum( _Flight.OccupiedSeats )         as TotalOccupiedSeats,
        cast( avg( _Flight.OccupiedSeats as abap.fltp ) as abap.dec(10, 2))        as AverageOccupation
  }
group by
    AirlineID,
    ConnectionID,
    DepartureAirport,
    DestinationAirport
    having sum( _Flight.OccupiedSeats ) > 600;

