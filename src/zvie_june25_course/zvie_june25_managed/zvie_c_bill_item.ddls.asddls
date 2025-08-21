@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View of Billing Doc Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZVIE_C_BILL_ITEM
  as projection on ZVIE_R_BILL_ITEM
{
  key BillId,
  key ItemNo,
      MaterialId,
      Description,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      Quantity,
      @Semantics.amount.currencyCode: 'Currency'
      ItemAmount,
      Currency,
      Uom,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _header : redirected to parent ZVIE_C_BILL_HEAD
}
