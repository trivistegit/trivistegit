@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS_01_conn'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_01_conn as select from /dmo/connection
{
    key carrier_id as CarrierId,
    key connection_id as ConnectionId,
    airport_from_id as AirportFromId,
    airport_to_id as AirportToId,
    departure_time as DepartureTime,
    arrival_time as ArrivalTime,
    
    distance as Distance,
    
    distance_unit as DistanceUnit,
    @EndUserText.label: 'Measure param'
    case 
     when distance > 1000
     then 'Long'
     else 'Short'
     end as Measure 
     
} 
