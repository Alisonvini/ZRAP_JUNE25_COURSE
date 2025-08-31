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

    DELETE FROM zvie_bill_header.

    DATA(lt_bill_heade) = VALUE tt_zvie_bill_header(
      ( client      = sy-mandt bill_id = '1000000001' bill_type = 'F2' bill_date = '20250401' customer_id = '100001' plan_start_date = '20250401' plan_end_date = '20250402' net_amount = '1500.00' currency = 'INR' sales_org = '1000' )
      ( client      = sy-mandt bill_id = '1000000002' bill_type = 'F2' bill_date = '20250402' customer_id = '100002' plan_start_date = '20260401' plan_end_date = '20260402' net_amount = '2500.00' currency = 'INR' sales_org = '1000' )
      ( client      = sy-mandt bill_id = '1000000003' bill_type = 'F8' bill_date = '20250403' customer_id = '100003' plan_start_date = sy-datum plan_end_date = sy-datum + 1 net_amount = '1800.00' currency = 'USD' sales_org = '2000' )
      ( client      = sy-mandt bill_id = '1000000004' bill_type = 'F2' bill_date = '20250404' customer_id = '100004' plan_start_date = '20250201' plan_end_date = '20250302' net_amount = '3000.00' currency = 'EUR' sales_org = '3000' )
      ( client      = sy-mandt bill_id = '1000000005' bill_type = 'F2' bill_date = '20250405' customer_id = '100005' plan_start_date = '20250401' plan_end_date = '20250402' net_amount = '2200.00' currency = 'INR' sales_org = '1000' )
    ).

    MODIFY zvie_bill_header FROM TABLE @lt_bill_heade.

    TYPES tt_zvie_bill_doc_tp TYPE TABLE OF zvie_bill_doc_tp WITH DEFAULT KEY.

    DELETE FROM zvie_bill_doc_tp.

    DATA(lt_zvie_bill_doc_tp) = VALUE tt_zvie_bill_doc_tp(
      ( client      = sy-mandt bill_type = 'AR' bill_type_desc = 'Invoice' )
      ( client      = sy-mandt bill_type = 'IL' bill_type_desc = 'Notification' )
      ( client      = sy-mandt bill_type = 'BE' bill_type_desc = 'Order' )

      ).

    MODIFY zvie_bill_doc_tp FROM TABLE @lt_zvie_bill_doc_tp.



  ENDMETHOD.

ENDCLASS.
