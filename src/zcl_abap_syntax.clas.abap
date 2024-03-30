CLASS zcl_abap_syntax DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CLASS-DATA out TYPE REF TO if_oo_adt_classrun_out .

    METHODS read_itab.
    METHODS inline_declaration .
    METHODS value_declaration .
    METHODS corresponding_declaration .
    METHODS cond_conv .
    METHODS group_by_statement .
    METHODS filter_data.
    METHODS reduce_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abap_syntax IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->out = out.  " Add Reference

*    me->read_itab( ).
*    me->inline_declaration( ).
*    me->value_declaration( ).
*    me->corresponding_declaration( ).
*    me->cond_conv(  ).
*    me->group_by_statement( ).
*    me->filter_data(  ).
    me->reduce_data(  ).
  ENDMETHOD.

  METHOD read_itab.

    SELECT * FROM /dmo/booking INTO TABLE @DATA(itab) UP TO 1000 ROWS.
*    out->write( itab ).
    TRY.
        DATA(ls_out) = itab[ carrier_id = 'UA' ].
        out->write( ls_out ).
      CATCH cx_sy_itab_line_not_found.
        out->write( |Read failed| ).
    ENDTRY.
  ENDMETHOD.

  METHOD inline_declaration.
*   Select Statement
    SELECT * FROM /dmo/booking INTO TABLE @DATA(trav) UP TO 5 ROWS.
    out->write(  trav  ).
*   In class
    cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(
      RECEIVING
        uuid = DATA(uid)
    ).
*    CATCH cx_uuid_error..
    out->write(  uid  ).
*   Field Symbols.
    LOOP AT trav ASSIGNING FIELD-SYMBOL(<fs>).
      out->write(  <fs>-carrier_id ).
    ENDLOOP.
  ENDMETHOD.

  METHOD value_declaration.

    TYPES: BEGIN OF da,
             caption TYPE c LENGTH 10,
             team    TYPE c LENGTH 10,
           END OF da,
           ty_da TYPE TABLE OF  da WITH DEFAULT KEY.

    DATA:lt_da TYPE ty_da.

    lt_da = VALUE #(

     ( caption = 'new' team = 'ali' )
     ( caption = 'new1' team = 'ali2' )

     ).

*      in this case, explicitly add type instead of #
    DATA(newd) = VALUE ty_da(

    ( caption = 'new' team = 'ali' )
    ( caption = 'new1' team = 'ali2' )

    ).

    out->write( lt_da ).
    out->write( newd ).

  ENDMETHOD.

  METHOD corresponding_declaration.
    TYPES: BEGIN OF da,
             caption TYPE c LENGTH 10,
             team    TYPE c LENGTH 10,
           END OF da,
           BEGIN OF da2,
             name TYPE c LENGTH 10,
             tea  TYPE c LENGTH 10,
           END OF da2,
           ty_da  TYPE TABLE OF  da WITH DEFAULT KEY,
           ty_da2 TYPE TABLE OF  da2 WITH DEFAULT KEY.

    DATA:lt_da  TYPE ty_da,
         lt_da2 TYPE ty_da,
         lt_da3 TYPE ty_da2.

    lt_da = VALUE #(

     ( caption = 'new' team = 'ali' )
     ( caption = 'new1' team = 'ali2' )

     ).

*    New syntax don't use MOVE anymore
    lt_da2 = CORRESPONDING #( lt_da ).
*    lt_da3 = CORRESPONDING #( lt_da2 EXCEPT team ). " remove field
    lt_da3 = CORRESPONDING #( lt_da2 MAPPING name = caption tea = team ). " different name, same type field

    out->write( lt_da2 ).
    out->write( lt_da3 ).

  ENDMETHOD.

  METHOD cond_conv.
    DATA: lv_numc(4) TYPE c VALUE '0600',
          lv_num     TYPE i,
          lv_result  TYPE c.
*   used for type casting for matching data types
    lv_num = CONV #( lv_numc ).
*   to check a simple condition - inline with program
    lv_result = COND #(  LET val = 500 IN WHEN lv_num > val THEN 'X' ELSE '' ).

    out->write( lv_result ).
  ENDMETHOD.

  METHOD group_by_statement.
    TYPES: tt_bookings TYPE TABLE OF /dmo/booking WITH  DEFAULT KEY.
    DATA: total TYPE p DECIMALS 2.

    SELECT * FROM /dmo/booking INTO TABLE @DATA(lt_bookings) UP TO 20 ROWS .

*    loop at lt_bookings into data(wa).
*        out->write( wa ).
*    ENDLOOP.
**********************************************************************
*    what if you want to send result back to a function
    DATA(rs_group) = VALUE tt_bookings(  ). " First create emtpy
**********************************************************************
*    GROUP BY FIELD ON LOOP
    LOOP AT lt_bookings INTO DATA(wa1) GROUP BY wa1-travel_id.
      out->write( |Travel Request {  wa1-travel_id }| ).
*      LOOP AT CHILD AND PRINT
      LOOP AT GROUP wa1 INTO DATA(wa1c).
**********************************************************************
*    what if you want to send result back to a function
        rs_group = VALUE #( BASE lt_bookings ( wa1c ) ). " then add child - Now its all back without grouping
**********************************************************************
        out->write( |Bookings { wa1c-booking_id } - { wa1c-carrier_id } - { wa1c-flight_price } | ).
        total = total + wa1c-flight_price.
      ENDLOOP.
    ENDLOOP.

    out->write( |Bookings Total { total }| ).
    CLEAR total.
    out->write( rs_group ).
  ENDMETHOD.

  METHOD filter_data.
    DATA: ret TYPE SORTED TABLE OF /dmo/booking WITH UNIQUE  KEY carrier_id,
          ch  TYPE c LENGTH 3.
    ch = 'UA'.
    SELECT * FROM /dmo/booking INTO TABLE @DATA(itab) UP TO 1000 ROWS.
    DATA(uas) = FILTER #( ret WHERE carrier_id = ch ).
    out->write( uas ).
  ENDMETHOD.

  METHOD reduce_data.
    "With implicit data type
    DATA(lv_sum) = REDUCE #( INIT s = 0
                             FOR  i = 1 UNTIL i > 50
                             NEXT s = s + i ).

    "With specified data type
    DATA(lv_sum1) = REDUCE i( INIT s = 0
                             FOR  i = 1 UNTIL i > 50
                             NEXT s = s + i ).

    out->write( lv_sum ).
    out->write( lv_sum1 ).
  ENDMETHOD.
ENDCLASS.
