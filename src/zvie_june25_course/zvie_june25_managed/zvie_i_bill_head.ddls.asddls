@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for Billing Doc Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #BASIC
define root view entity ZVIE_I_BILL_HEAD
  as select from zvie_bill_header
  composition [0..*] of ZVIE_I_BILL_ITEM as _item
{
  key bill_id            as BillId,
      bill_type          as BillType,
      bill_date          as BillDate,
      customer_id        as CustomerId,
      @Semantics.amount.currencyCode: 'Currency'
      net_amount         as NetAmount,
      currency           as Currency,
      plan_start_date    as PlanStartDate,
      plan_end_date      as PlanEndtDate,
      sales_org          as SalesOrg,
      createdby          as Createdby,
      createdat          as Createdat,
      lastchangedby      as Lastchangedby,
      lastchangedat      as Lastchangedat,
      locallastchangedat as Locallastchangedat,

      _item
}
