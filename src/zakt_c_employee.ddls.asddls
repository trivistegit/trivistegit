@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AKT_C_EMPLOYEE'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAKT_C_EMPLOYEE
  as select from ZAKT_CDS_EMPLOYEE
{
  key EmployeeId,
      FirstName,
      LastName,
      BirthDate,
      EntryDate,
      AnnualSalary,
      CurrencyCode as currcode,
      case when AnnualSalary > 100000
      then 'H'
      else 'N'
      end          as Pay_grade,
      DepartmentID,
      _department
}
