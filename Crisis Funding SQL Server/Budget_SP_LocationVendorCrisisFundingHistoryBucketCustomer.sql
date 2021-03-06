/****** Script for SelectTopNRows command from SSMS  ******/
create procedure Budget.SP_LocationVendorCrisisFundingHistoryBucketCustomer

 as 
SELECT [fiscal_year]
      ,[Simple]
      ,[ProductOrServiceArea]
	  ,[ContractCrisisFunding]
	  ,ContractingCustomer
	  ,ContractingSubCustomer
      ,[nationalinterestactioncodeText]
      ,[NIAcrisisFunding]
      ,[CrisisFunding]
	  ,[CrisisFundingTheater]
      ,[PlaceCountryText]
      ,[VendorCountryText]
	  ,[VendorPlaceType]
	  ,[VendorSize]
      ,sum([obligatedAmount]) as [obligatedAmount]
      ,sum([numberOfActions]) as [numberOfActions]
      
  FROM [DIIG].[Vendor].[LocationVendorHistoryBucketSubCustomer]
  group by [fiscal_year]
      ,[Simple]
      ,[ProductOrServiceArea]
	  ,[ContractCrisisFunding]
	  ,ContractingCustomer
	  ,ContractingSubCustomer
      ,[nationalinterestactioncodeText]
      ,[NIAcrisisFunding]
      ,[CrisisFunding]
	  ,[CrisisFundingTheater]
      ,[PlaceCountryText]
      ,[VendorCountryText]
	  ,[VendorPlaceType]
	  ,[VendorSize]