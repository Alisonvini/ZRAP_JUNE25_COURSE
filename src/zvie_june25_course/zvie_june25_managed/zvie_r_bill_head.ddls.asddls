@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Bill Doc Head'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #TRANSACTIONAL
define root view entity ZVIE_R_BILL_HEAD
  as select from ZVIE_I_BILL_HEAD
  composition [0..*] of ZVIE_R_BILL_ITEM as _item

{
  key BillId,
      BillType,
      BillDate,
      CustomerId,
      @Semantics.amount.currencyCode: 'Currency'
      NetAmount,
      Currency,
      SalesOrg,
      PlanStartDate,
      PlanEndtDate,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,

      _item
}
