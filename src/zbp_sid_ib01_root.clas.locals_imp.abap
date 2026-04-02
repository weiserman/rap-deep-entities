CLASS lhc_ysid_ib01_root DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ysid_ib01_root RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ysid_ib01_root RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ysid_ib01_root.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ysid_ib01_root.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ysid_ib01_root.

    METHODS read FOR READ
      IMPORTING keys FOR READ ysid_ib01_root RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ysid_ib01_root.

    METHODS validate FOR MODIFY
      IMPORTING keys FOR ACTION ysid_ib01_root~validate RESULT result.

ENDCLASS.

CLASS lhc_ysid_ib01_root IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD validate.

  DATA: lr_coco        TYPE RANGE OF bukrs,
        lr_plant       TYPE RANGE OF werks_d,
        lt_success     TYPE TABLE OF ysid_ib01_success,
        lt_fail        TYPE TABLE OF ysid_ib01_fail,
        lt_valid_coco  TYPE SORTED TABLE OF bukrs  WITH UNIQUE KEY table_line,
        lt_valid_plant TYPE SORTED TABLE OF werks_d WITH UNIQUE KEY table_line,
        ls_coco_range  LIKE LINE OF lr_coco,
        ls_plant_range LIKE LINE OF lr_plant.

  DATA(lt_request) = keys[].
  IF lt_request IS INITIAL.
    RETURN.
  ENDIF.

  " Unwrap values from deep request
  LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_request>).
    DATA(lv_key) = <lfs_request>-r.
    lr_coco  = VALUE #( FOR ls_coco  IN <lfs_request>-%param-coco
                          ( sign = ls_coco-sign  option = ls_coco-opt  low = ls_coco-low  high = '' ) ).
    lr_plant = VALUE #( FOR ls_plant IN <lfs_request>-%param-plant
                          ( sign = ls_plant-sign option = ls_plant-opt low = ls_plant-low high = '' ) ).
    SORT lr_coco  BY low.
    DELETE ADJACENT DUPLICATES FROM lr_coco  COMPARING low.
    SORT lr_plant BY low.
    DELETE ADJACENT DUPLICATES FROM lr_plant COMPARING low.
    EXIT.
  ENDLOOP.

  " Validate company codes
  IF lr_coco IS NOT INITIAL.
    SELECT bukrs
      FROM ysid_t_coco
      WHERE bukrs IN @lr_coco
      INTO TABLE @lt_valid_coco.

    LOOP AT lr_coco INTO ls_coco_range.
      IF line_exists( lt_valid_coco[ table_line = ls_coco_range-low ] ).
        APPEND VALUE #( field = 'BUKRS' sign = 'I' opt = 'EQ' low = ls_coco_range-low ) TO lt_success.
      ELSE.
        APPEND VALUE #( field = 'BUKRS' sign = 'I' opt = 'EQ' low = ls_coco_range-low ) TO lt_fail.
      ENDIF.
    ENDLOOP.
  ENDIF.

  " Validate plants
  IF lr_plant IS NOT INITIAL.
    SELECT werks
      FROM ysid_t_plant
      WHERE werks IN @lr_plant
      INTO TABLE @lt_valid_plant.

    LOOP AT lr_plant INTO ls_plant_range.
      IF line_exists( lt_valid_plant[ table_line = ls_plant_range-low ] ).
        APPEND VALUE #( field = 'WERKS' sign = 'I' opt = 'EQ' low = ls_plant_range-low ) TO lt_success.
      ELSE.
        APPEND VALUE #( field = 'WERKS' sign = 'I' opt = 'EQ' low = ls_plant_range-low ) TO lt_fail.
      ENDIF.
    ENDLOOP.
  ENDIF.

  " Build deep response
  APPEND VALUE #(
    r      = lv_key
    %param = VALUE #(
      d       = lv_key
      success = VALUE #( FOR ls_success IN lt_success
                          ( field = ls_success-field
                            sign  = ls_success-sign
                            opt   = ls_success-opt
                            low   = ls_success-low ) )
      failure = VALUE #( FOR ls_fail IN lt_fail
                          ( field = ls_fail-field
                            sign  = ls_fail-sign
                            opt   = ls_fail-opt
                            low   = ls_fail-low ) ) )
  ) TO result.

ENDMETHOD.

ENDCLASS.

CLASS lsc_YSID_IB01_ROOT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize            REDEFINITION.
    METHODS check_before_save   REDEFINITION.
    METHODS save                REDEFINITION.
    METHODS cleanup             REDEFINITION.
    METHODS cleanup_finalize    REDEFINITION.

ENDCLASS.

CLASS lsc_YSID_IB01_ROOT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
