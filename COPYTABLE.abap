CLASS zcl_copydata DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_copydata IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    INSERT zbooksupapp_m FROM (  SELECT * FROM /dmo/booksuppl_m ).
    IF sy-subrc = 0.
      COMMIT WORK.
    ENDIF.
    out->write( 'Data inserted for Booking Supplements' ).
  ENDMETHOD.
ENDCLASS.
