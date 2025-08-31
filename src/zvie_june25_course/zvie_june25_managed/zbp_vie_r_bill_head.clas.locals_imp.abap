CLASS lhc_ZVIE_R_BILL_HEAD DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zvie_r_bill_head RESULT result.
    METHODS updateBillingDate FOR MODIFY
      IMPORTING keys FOR ACTION zvie_r_bill_head~updateBillingDate RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zvie_r_bill_head RESULT result.
    METHODS createbillingdocheader FOR MODIFY
      IMPORTING keys FOR ACTION zvie_r_bill_head~createbillingdocheader RESULT result.
    METHODS copybillingdocument FOR MODIFY
      IMPORTING keys FOR ACTION zvie_r_bill_head~copybillingdocument.
    METHODS validateamount FOR VALIDATE ON SAVE
      IMPORTING keys FOR zvie_r_bill_head~validateamount.
    METHODS precheck_create FOR PRECHECK
      IMPORTING entities FOR CREATE zvie_r_bill_head.
    METHODS is_update_allowed RETURNING VALUE(update_allowed) TYPE abap_bool.
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR zvie_r_bill_head RESULT result.

ENDCLASS.

CLASS lhc_ZVIE_R_BILL_HEAD IMPLEMENTATION.

  METHOD is_update_allowed.
    update_allowed = abap_false.
  ENDMETHOD.


  METHOD get_instance_authorizations.


    DATA: update_requested TYPE abap_bool,
          update_granted   TYPE abap_bool.

    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
        ENTITY zvie_r_bill_head
        FIELDS ( Currency BillType ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_billdoc).

    CHECK lt_billdoc IS NOT INITIAL.
    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on THEN
                                    abap_true ELSE abap_false ).

    LOOP AT lt_billdoc ASSIGNING FIELD-SYMBOL(<lfs_billdoc>).
      IF <lfs_billdoc>-Currency = 'EUR' AND <lfs_billdoc>-BillType = 'F2'.
        IF update_requested = abap_true.
          update_granted = is_update_allowed(  ).
          IF update_granted = abap_false.
            APPEND VALUE #( %tky = <lfs_billdoc>-%tky ) TO failed-zvie_r_bill_head.
            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text = 'No Authorization to update the record!'
                                    )
                                   ) TO reported-zvie_r_bill_head.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD updatebillingdate.

    MODIFY ENTITIES OF zvie_r_bill_head IN LOCAL MODE
      ENTITY zvie_r_bill_head
          UPDATE FROM VALUE #( FOR key IN keys
              ( BillId = key-BillId
*                %key-BillId = key-BillId
*                %tky-BillId = key-BillId
                BillDate = cl_abap_context_info=>get_system_date(  )
                %control-BillDate = if_abap_behv=>mk-on ) )
                FAILED failed
                REPORTED reported.

    "Read changed data for action result
    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
    ENTITY zvie_r_bill_head
    ALL FIELDS WITH "returning all fields due to $self
    CORRESPONDING #( keys )
    RESULT DATA(lt_billdocs).

    result = VALUE #( FOR ls_billdoc IN lt_billdocs
        ( %tky = ls_billdoc-%tky
          %param = ls_billdoc ) ).


  ENDMETHOD.

  METHOD createBillingDocHeader.


    DATA: bill_header_create TYPE TABLE FOR CREATE zvie_r_bill_head,
          bill_header_result TYPE TABLE FOR ACTION RESULT zvie_r_bill_head~createBillingDocHeader,
          response_data      TYPE TABLE FOR READ RESULT zvie_r_bill_head.

    LOOP AT keys INTO DATA(key).

      "Create bill header entry
      APPEND VALUE #( %Cid = key-%cid
        BillId   = key-%param-BillID
        BillType = key-%param-BillType
        BillDate = key-%param-BillDate ) TO bill_header_create.

      "Prepare result entry
      APPEND VALUE #( %cid = key-%cid ) TO bill_header_result.

      "Create bill header records
      MODIFY ENTITIES OF zvie_r_bill_head IN LOCAL MODE
      ENTITY zvie_r_bill_head
      CREATE FIELDS ( BillId BillType BillDate )
      WITH bill_header_create
      MAPPED DATA(mapped_create)
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).

      "Converte mapped results to action result format
      result = VALUE #( FOR create IN mapped_create-zvie_r_bill_head INDEX INTO i (
        %cid = create-%cid
        %param-BillId = bill_header_create[ %cid = create-%cid ]-BillId
      ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD copyBillingDocument.

    DATA: lt_billingdocuments TYPE TABLE FOR CREATE zvie_r_bill_head\\zvie_r_bill_head.
    DATA: lv_billingdoc TYPE c LENGTH 10.

    SELECT BillId FROM zvie_r_bill_head ORDER BY BillId DESCENDING
      INTO @lv_billingdoc UP TO 1 ROWS.
    ENDSELECT.

    lv_billingdoc = lv_billingdoc + 1.

    "Remove instances with initial %cid (i.e, not set by caller API)
    READ TABLE keys WITH KEY %cid = '' INTO DATA(key_with_initial_cid).
    ASSERT key_with_initial_cid IS INITIAL.

    "Read the data from the travel instances to be copied
    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
    ENTITY zvie_r_bill_head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_billdoc).

    LOOP AT lt_billdoc ASSIGNING FIELD-SYMBOL(<lfs_billdoc>).
      "Fill in  container for creating new  instance
      APPEND VALUE #( %cid = keys[ KEY entity %key = <lfs_billdoc>-%key ]-%cid
                      %data = CORRESPONDING #( <lfs_billdoc> EXCEPT BillId )
      )
      TO lt_billingdocuments ASSIGNING FIELD-SYMBOL(<new_bill_doc>).

      "adjust the copied billing document header instance data
      <new_bill_doc>-BillId = CONV #( lv_billingdoc ).
      <new_bill_doc>-BillDate = cl_abap_context_info=>get_system_date(  ).

    ENDLOOP.

    "create new BO instance
    MODIFY ENTITIES OF zvie_r_bill_head IN LOCAL MODE
    ENTITY zvie_r_bill_head
    CREATE FIELDS ( BillId BillDate BillType Currency CustomerId NetAmount SalesOrg )
    WITH lt_billingdocuments
    MAPPED DATA(mapped_create).

    "set the new BO instances
    mapped-zvie_r_bill_head = mapped_create-zvie_r_bill_head.

  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.



  METHOD get_instance_features.

    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
      ENTITY zvie_r_bill_head
      FIELDS ( Currency ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_billdoc).

    result = VALUE #( FOR ls_billdoc IN lt_billdoc
        ( %key = ls_billdoc-%key

          "Disable delete button if currency is INR
          %features-%delete = COND #( WHEN ls_billdoc-Currency = 'INR'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          %features-%action-updateBillingDate = COND #( WHEN ls_billdoc-Currency = 'USD'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )

*         %features-%field-Currency
              ) ).

  ENDMETHOD.


  METHOD validateAmount.

    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
    ENTITY zvie_r_bill_head
    FIELDS ( NetAmount ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_billdoc).

    LOOP AT lt_billdoc INTO DATA(ls_billdoc).
      IF ls_billdoc-NetAmount IS NOT INITIAL AND ls_billdoc-NetAmount < 1000.
        APPEND VALUE #( %tky = ls_billdoc-%tky ) TO failed-zvie_r_bill_head.
        APPEND VALUE #( %tky = ls_billdoc-%tky
                        %element-NetAmount = if_abap_behv=>mk-on
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Net Amount cannot be less than 1000' )
                                                      ) TO reported-zvie_r_bill_head.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD precheck_create.

    LOOP AT entities INTO DATA(ls_entity).
      IF ls_entity-CustomerId IS NOT INITIAL.
*        SELECT SINGLE * FROM i_businesspartner
*            WHERE BusinessPartner = @ls_entity-CustomerId
*            INTO @DATA(ls_customer).
        IF sy-subrc NE 0.
          APPEND VALUE #( %key = ls_entity-%key ) TO failed-zvie_r_bill_head.
          APPEND VALUE #( %key = ls_entity-%key
                          %element-CustomerId = if_abap_behv=>mk-on
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = 'Customer does not exists' )
                                                        ) TO reported-zvie_r_bill_head.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zvie_r_bill_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS determineItemDescription FOR DETERMINE ON SAVE
      IMPORTING keys FOR zvie_r_bill_item~determineItemDescription.

ENDCLASS.

CLASS lhc_zvie_r_bill_item IMPLEMENTATION.

  METHOD determineItemDescription.

    READ ENTITIES OF zvie_r_bill_head IN LOCAL MODE
    ENTITY zvie_r_bill_item
    FIELDS ( BillId ItemNo )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_bill_items).

*    Fetch text from item
*if lt_bill_items is not initial.
*    SELECT FROM I_BillingDocumentItem
*        FIELDS BillingDocument, BillingDocumentItem, BillingDocumentItemText
*        FOR ALL ENTRIES IN @lt_bill_items
*        where BillingDocument = @lt_bill_items-BillId
*        and BillingDocumentItem = @lt_bill_items-ItemNo
*        INto TABLE @DATA(lt_bill_item_texts).
*endif.

*    MODIFY ENTITIES OF zvie_r_bill_head IN LOCAL MODE
*        ENTITY zvie_r_bill_item
*        UPDATE FIELDS ( Description )
*        WITH VALUE #( FOR ls_billitem IN lt_bill_items (
*                          %tky = ls_billitem-%tky
*                          Description = VALUE #( lt_bill_item_texts[ BillingDocument = ls_billitem-BillId
*                                                 BillingDocumentItem = ls_billitem-ItemNo ]-BillingDocumentItemText OPTIONAL
*                                                 )
*                         )
*                         ).

  ENDMETHOD.

ENDCLASS.
