@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Bill Doc Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVIE_R_BILL_ITEM
  as select from ZVIE_I_BILL_ITEM
  association to parent ZVIE_R_BILL_HEAD as _header on $projection.BillId = _header.BillId
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
      _header
}
