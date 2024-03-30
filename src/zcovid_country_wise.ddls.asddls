@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Covid Cases Country Wise'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZCOVID_COUNTRY_WISE
  as select from zcovid_countries
{
  key zcountry   as Country,
      zconfirmed as Confirmed,
      zrecovered as Recovered,
      zdeceased  as Deceased
}
