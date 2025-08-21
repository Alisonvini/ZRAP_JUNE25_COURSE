CLASS zvie_cl_fill_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvie_cl_fill_table IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES tt_zvie_bill_header TYPE TABLE OF zvie_bill_header WITH DEFAULT KEY.

    delete from zvie_bill_header.

*    DATA(lt_bill_heade) = VALUE tt_zvie_bill_header(
*       (  bill_id = 1 bill_type = 'TY' )
*    ).
*
*    MODIFY zvie_bill_header FROM TABLE @lt_bill_heade.

  ENDMETHOD.

ENDCLASS.
