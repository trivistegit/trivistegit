@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS_EMPLOYEE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAKT_CDS_EMPLOYEE as select from zakt_employee
association[1..1] to ZAKT_R_DEPT as _department 
on $projection.DepartmentID = _department.DepartmentId
{
    key employee_id as EmployeeId,
    first_name as FirstName,
    last_name as LastName,
    birth_date as BirthDate,
    entry_date as EntryDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    annual_salary as AnnualSalary,
    currency_code as CurrencyCode,
    department_id as DepartmentID,
    _department
}
where birth_date < $session.system_date;
