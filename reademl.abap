CLASS zcl_read_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_read_eml IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    READ ENTITY zi_travelapp_m  ALL FIELDS
    WITH VALUE #( ( %key-TravelId = 00053343 )
                    ( %key-TravelId = 00007894 ) )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).
    out->write(
      EXPORTING
        data   = lt_result
    ).
    READ ENTITY zi_travelapp_m FROM
    VALUE #( ( %key-TravelId = 00053343
               %control-AgencyId = if_abap_behv=>mk-on
               %control-TravelId = if_abap_behv=>mk-on ) )
               RESULT DATA(lt_result1)
               FAILED DATA(lt_failed1)
               REPORTED DATA(lt_reported1).
    out->write(
        EXPORTING
          data   = lt_result1
      ).


    READ ENTITIES OF zi_travelapp_m
    ENTITY Travel
    ALL FIELDS
    WITH VALUE #( ( %key-TravelId = 00053343 ) )
    RESULT DATA(lt_result2)
*    failed data(lt_failed2)
*    REPORTED data(lt_mapped2)
    ENTITY Booking
    ALL FIELDS
    WITH VALUE #( ( %key-TravelId = 00053343 %key-BookingId = 1245 ) )
    RESULT DATA(lt_result3)
    FAILED DATA(lt_failed3)
    REPORTED DATA(lt_mapped3).
    out->write( lt_result2 ).
    out->write( lt_result3 ).
    out->write(
      EXPORTING
        data   = |Dynamic Selection|
*        name   =
*      RECEIVING
*        output =
    ).

* dynamic
    DATA: lt_optab        TYPE abp_behv_retrievals_tab,
          lt_table_imp    TYPE TABLE FOR READ IMPORT zi_travelapp_m,
          lt_table_result TYPE TABLE FOR READ RESULT zi_travelapp_m,
          lt_book_imp     TYPE TABLE FOR READ IMPORT zi_bookingapp_m,
          lt_book_result  TYPE TABLE FOR READ RESULT zi_bookingapp_m.
    lt_table_imp = VALUE #( ( %key-TravelId = 00053343
              %control-AgencyId = if_abap_behv=>mk-on
              %control-TravelId = if_abap_behv=>mk-on )  ).
    lt_book_imp = VALUE #( ( %key-TravelId = 00053343
                             %key-BookingId = 1245
                             %control = VALUE #( BookingId = if_abap_behv=>mk-on ) ) ).
    lt_optab = VALUE #( ( op = if_abap_behv=>op-r-read
                        entity_name = 'ZI_TRAVELAPP_M'
                        instances = REF #( lt_table_imp )
                        results = REF #( lt_table_result ) )
                        ( op = if_abap_behv=>op-r-read_ba
                        entity_name = 'ZI_TRAVELAPP_M'
                        sub_name = '_BOOKING'
                        instances = REF #( lt_book_imp )
                        results = REF #( lt_book_result ) )  ).
     READ ENTITIES operations lt_optab failed data(lt_failed4).
     out->write( lt_table_result ).
     out->write( lt_book_result ).

  ENDMETHOD.
ENDCLASS.
