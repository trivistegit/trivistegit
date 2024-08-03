CLASS zakt_misc_work DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zakt_misc_work IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: tt_emp TYPE TABLE OF zakt_employee WITH DEFAULT KEY.

    TYPES: tt_dept TYPE TABLE OF zakt_emp_dept WITH DEFAULT KEY.

*    DATA(lt_emp) = VALUE tt_emp(
*               (  employee_id = '2' first_name = 'Johny' last_name = 'Simmons'
*               birth_date = '19770101' annual_salary = '130000'
*               currency_code = 'USD' entry_date = '20240722'
*               department_id = 1 )
*               (  employee_id = '1' first_name = 'John' last_name = 'Young'
*               birth_date = '19750101' annual_salary = '140000'
*               currency_code = 'USD' entry_date = '20240722'
*               department_id = 2 )
*               (  employee_id = '3' first_name = 'Angela' last_name = 'Thomas'
*               birth_date = '19790101' annual_salary = '70000'
*               currency_code = 'USD' entry_date = '20240722'
*               department_id = 3 ) ).
*
*    MODIFY zakt_employee FROM TABLE @lt_emp.

    DATA(lt_dept) = VALUE tt_dept(
                       ( department_id = 1 description = 'Maintenance'
                        entry_date = '20240722' )
                         ( department_id = 2 description = 'Inspection'
                        entry_date = '20240722' )
                        ( department_id = 3 description = 'Maintenance'
                        entry_date = '20240722' )
                         ( department_id = 4 description = 'ARO'
                        entry_date = '20240722' )
                        ( department_id = 5 description = 'BackOffice'
                        entry_date = '20240722' )
                       ).

    MODIFY zakt_emp_dept FROM TABLE @lt_dept.
  ENDMETHOD.
ENDCLASS.
