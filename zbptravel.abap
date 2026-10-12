CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
       entities FOR CREATE Travel.
ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '10'
            object            =  '/DMO/TRV_M'
        quantity          = CONV #( lines( lt_entities ) )
      IMPORTING
        number            = DATA(lv_num)
        returncode        = DATA(lv_rtcod)
        returned_quantity = DATA(lv_retqua)
        ).
      CATCH cx_nr_object_not_found INTO DATA(lo_exc).
      CATCH cx_number_ranges INTO DATA(lo_number).
        LOOP AT lt_entities INTO DATA(ls_entiti).
          INSERT VALUE #( %cid = ls_entiti-%cid
                          %key = ls_entiti-%key ) INTO TABLE failed-travel .
          INSERT VALUE #( %cid = ls_entiti-%cid
                          %key = ls_entiti-%key
                          %msg = lo_number  ) INTO TABLE reported-travel .
        ENDLOOP.
        EXIT.
    ENDTRY.
    ASSERT lv_retqua = lines( lt_entities ).
    lv_num -= lv_retqua.
    LOOP AT lt_entities INTO DATA(ls_entity).
      lv_num += 1.
      INSERT VALUE #( %cid = ls_entity-%cid travelid = lv_num ) INTO TABLE mapped-travel.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
