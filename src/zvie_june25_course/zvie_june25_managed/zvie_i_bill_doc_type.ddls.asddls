@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic view for Billing Document Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVIE_I_BILL_DOC_TYPE
  as select from zvie_bill_doc_tp
{
  key bill_type      as BillType,
      bill_type_desc as BillTypeDesc
}
