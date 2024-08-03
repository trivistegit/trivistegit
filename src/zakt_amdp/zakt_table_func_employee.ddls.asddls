@EndUserText.label: 'TABLE_FUNC_EMPLOYEE'
@AccessControl.authorizationCheck: #CHECK
define table function ZAKT_TABLE_FUNC_EMPLOYEE
with parameters 
//p_empid : zakt_employee_id,
@Environment.systemField: #CLIENT
p_clnt : mandt
returns {
  client : abap.clnt;
  employee_id : zakt_employee_id;
  name :  abap.char( 90 );
  birth_date      : zakt_birth_date;
  @Semantics.amount.currencyCode : 'currency_code'
  annual_salary   : zakt_annual_salary;
  currency_code   : waers;
  
}
implemented by method ZCL_AKT_AMDP_CLS01=>get_employee;