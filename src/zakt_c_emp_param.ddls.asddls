@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee parameters'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAKT_C_EMP_PARAM
with parameters 
targetcurr: abap.cuky,
@Environment.systemField: #SYSTEM_DATE
exchang_date: abap.dats
 as select from ZAKT_C_EMPLOYEE

{
    key EmployeeId,
    FirstName,
    LastName,
    BirthDate,
    EntryDate,
    AnnualSalary,
    currcode,
    Pay_grade,
    DepartmentID,
@Semantics.amount.currencyCode: 'TargetCurrency' 

    currency_conversion( amount => AnnualSalary, 
    source_currency => currcode, 
    target_currency => $parameters.targetcurr, 
    exchange_rate_date => $parameters.exchang_date,
//cast( '20240724' as abap.dats),
    client => $session.client
     ) as AnnualSalaryConv,
     $parameters.targetcurr as TargetCurrency,
     $session.system_date as system_date,
    /* Associations */
    _department
}
