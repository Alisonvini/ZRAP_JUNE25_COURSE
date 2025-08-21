@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for Billing Document Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVIE_I_BILL_ITEM
  as select from zvie_bill_item
  association to parent ZVIE_I_BILL_HEAD as _header on $projection.BillId = _header.BillId
{
  key bill_id            as BillId,
  key item_no            as ItemNo,
      material_id        as MaterialId,
      description        as Description,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      quantity           as Quantity,
      @Semantics.amount.currencyCode: 'Currency'
      item_amount        as ItemAmount,
      currency           as Currency,
      uom                as Uom,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby      as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      
      _header
}
