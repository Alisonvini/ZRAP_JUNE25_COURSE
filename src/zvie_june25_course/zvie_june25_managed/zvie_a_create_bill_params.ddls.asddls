@EndUserText.label: 'Parameters fro Create Bill Header Action'
define abstract entity ZVIE_A_CREATE_BILL_PARAMS
{
    @EndUserText.label: 'Bill ID'
    @Consumption.filter.mandatory: true
    BillID : abap.char( 10 );
    
    @EndUserText.label: 'Bill Type'
    @Consumption.valueHelpDefinition: [{ entity: { element: 'BillType', name: 'ZVIE_I_BILL_DOC_TYPE' } } ]    
    BillType : abap.char( 4 );
    
    @EndUserText.label: 'Bill Date'
    BillDate : abap.dats;
    
}
