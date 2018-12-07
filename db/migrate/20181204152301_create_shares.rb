class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.string :isin
      t.string :secid
      t.string :performanceid
      t.string :fundid
      t.string :securityname
      t.string :companyname

      t.string :fundname
      t.string :legalstructure
      t.string :shareclasslegalname
      t.boolean :ucits

      t.string :morningstarcategoryid
      t.boolean :isbasecurrency
      t.boolean :isprimaryshareclass

      t.string :currencyspecificisin
      t.string :currencyid
      t.string :masterportfolioid
      t.string :legalstructureid
      t.boolean :fr_pea
      t.datetime :portfoliodate

      t.timestamps
    end
  end
end

#################################################################
# Liste des champs du master MS

# domicileid

# inceptiondate
# status
# obsoletedate
# isoldestclass
# incomedistribution
# accumulateddistribution
# insurancefund
# hedgefund
# fundoffunds
# exchangetradedshare
# cusip

# sedol
# ticker
# germanwkn
# austrianwkn
# valoren
# mex
# oslobors
# fundserv
# apir
# itaj
# focusid
# pricingfrequency
# pricingdelay
# reportsonfridays
# reportsonsundays

# fr_amf
# it_categoriaassogestioni
# uk_imasector
# uk_aicsector
# es_categoriainverco
# be_cbf
# dk_ifr
# es_inp
# fr_fip
# hk_ifa
# hk_mpf
# hk_sch
# il_isa

# za_asisa
# availableforpensionplan
# gifscode
# suspendedpricing
# exchangeid
# institutionalonly
# pencetraded
# datareadiness
# datareadinesschangedate
# sociallyconscious
# amfi
# krcodeclass
# krcodefund

# sitcacode
# sitcacategoryid
# ciccode
# globalcategoryid
# moneymarketfund
# availableforretirementplan
# availableforinsuranceproduct
# shareclasstypeid
# shareclasstype
# restrictedscheme
# broadassetclass
# csdcccode
# morningstarcategoryid_fund
# fr_pea_pme
# spanishesp
# indexingapproach
# synthetictype
# ukreportingfund
# ukstatusstartdate
# germantaxtransparence
# auttaxtransparence
# trackrecordextension
# trackrecordinheritedfrom
# trackrecordextensiontype
