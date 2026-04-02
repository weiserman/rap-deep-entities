CLASS ysid_cl_seed_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS ysid_cl_seed_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " ─── Company Codes ───────────────────────────────────────────
    DATA lt_coco TYPE TABLE OF ysid_t_coco.

    lt_coco = VALUE #(
      ( client = sy-mandt  bukrs = '1000'  bukrs_desc = 'Company Code 1000' )
      ( client = sy-mandt  bukrs = '2000'  bukrs_desc = 'Company Code 2000' )
      ( client = sy-mandt  bukrs = '3000'  bukrs_desc = 'Company Code 3000' )
      ( client = sy-mandt  bukrs = 'ZZZZ'  bukrs_desc = 'Test Invalid - should not match' )
    ).

    DELETE FROM ysid_t_coco.
    INSERT ysid_t_coco FROM TABLE @lt_coco.

    IF sy-subrc = 0.
      out->write( |Company codes seeded: { lines( lt_coco ) } rows| ).
    ELSE.
      out->write( |Company code insert failed - subrc: { sy-subrc }| ).
    ENDIF.

    " ─── Plants ──────────────────────────────────────────────────
    DATA lt_plant TYPE TABLE OF ysid_t_plant.

    lt_plant = VALUE #(
      ( client = sy-mandt  werks = '0001'  werks_desc = 'Plant 0001 - Main'     )
      ( client = sy-mandt  werks = '0002'  werks_desc = 'Plant 0002 - Secondary')
      ( client = sy-mandt  werks = '1000'  werks_desc = 'Plant 1000 - Cape Town')
      ( client = sy-mandt  werks = '9999'  werks_desc = 'Test Invalid - should not match' )
    ).

    DELETE FROM ysid_t_plant.
    INSERT ysid_t_plant FROM TABLE @lt_plant.

    IF sy-subrc = 0.
      out->write( |Plants seeded: { lines( lt_plant ) } rows| ).
    ELSE.
      out->write( |Plant insert failed - subrc: { sy-subrc }| ).
    ENDIF.

    " ─── Summary ─────────────────────────────────────────────────
    out->write( '--- Seed complete ---' ).
    out->write( |Client: { sy-mandt }| ).

  ENDMETHOD.

ENDCLASS.
