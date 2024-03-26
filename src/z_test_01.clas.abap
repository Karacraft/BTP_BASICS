CLASS z_test_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_test_01 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    CONSTANTS: m_1 TYPE string VALUE 'none',
               m_2 TYPE string VALUE 'some'.


    DATA my_var1 TYPE i.
    DATA my_var2 TYPE string.
    DATA my_var3 TYPE string VALUE 'Duke of Hazards'.

    TYPES: BEGIN OF ty_my,
             my_var1 TYPE i,
             my_var2 TYPE string,
           END OF ty_my.


    TYPES my_type TYPE p LENGTH 3 DECIMALS 2.
    DATA: my_type_data TYPE my_type,
          w_ty_my type ty_my.

    my_type_data = '369.22' .
    w_ty_my-my_var1 = 94.
    w_ty_my-my_var2 = 'Disco'.

    out->write( |{ my_var3 } , { my_type_data } , { w_ty_my-my_var1 } .. { w_ty_my-my_var2 }  | ).


  ENDMETHOD.

ENDCLASS.
