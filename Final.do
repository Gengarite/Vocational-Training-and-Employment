log using "C:\Users\setti\OneDrive\Desktop\PLFS\PLFS_1.smcl"
use "C:\Users\setti\OneDrive\Desktop\PLFS\personal2.dta", clear
drop max1 min1 voctest septrain persid
egen uniqid = concat( qtr vis fsu ssg sstr shnr sno)
destring uniqid, replace
drop uniqid
egen uniqid = concat(fsu ssg sstr shnr sno)
label variable uniqid "Personal Unique ID"
destring uniqid, replace
unique(uniqid)
set more off
gen icode2 = ic/1000
recast int icode2, force
gen icode3 = ic/10
recast int icode3, force
gen icode4  = ic/100
recast int icode4, force
gen indus = 99
replace indus = . if(ic == .)
replace indus = 1 if(icode2== 51)
replace indus = 2 if(icode2 == 1 | icode2 == 3 | icode2 == 10 | icode2 == 12)
replace indus = 3 if(icode2 == 23 | icode2 == 32 | icode2 == 15 | icode2 == 22 | icode2 == 31 | icode2 == 16 | icode2 == 18)
replace indus = 3 if(icode2 == 23 | icode2 == 32 | icode2 == 15 | icode2 == 22 | icode2 == 31 | icode2 == 16 | icode2 == 18)
replace indus = 4 if(icode2 == 90)
replace indus = 5 if(icode2 == 29 | icode2 == 30 | icode2 == 45)
replace indus = 6 if(ic == 96020 | ic == 96905)
replace indus = 7 if(icode2 == 6 | icode2 == 19 | icode2 == 20)
replace indus = 8 if(icode2 == 41 | icode2 == 42 | icode2 == 43)
replace indus = 9 if(icode2 == 26 | icode2 == 27 | ic == 33140 | icode4 == 351)
replace indus = 10 if(icode2 == 86 | icode2 == 87 | icode2 == 88 | icode2 == 75)
replace indus = 11 if(icode2 == 79 | icode2 == 55)
replace indus = 12 if(icode2 == 8 | icode2 == 24 | icode2 == 5 | icode2 == 7 | icode2 == 9)
replace indus = 13 if(icode2 == 62 | icode2 == 63 | icode3 == 5820)
replace indus = 14 if(icode2 == 78 | icode2 == 84)
replace indus = 15 if(icode2 == 28)
replace indus = 16 if(icode2 == 60 | icode2 == 92 | icode2 == 93 | icode3 == 5813 | icode3 == 7420)
replace indus = 17 if(icode2 == 82 | icode2 == 94)
replace indus = 18 if(icode2 == 65 | icode2 == 80)
replace indus = 19 if(icode2 == 61)
replace indus = 20 if(icode2 == 13 | icode2 == 14)
replace indus = 21 if(icode2 == 85 | ic == 96907)
br indus ic icode2 icode3 icode4
nmissing
tab earwa1 voc
replace indus = 21 if(ic == 97005)
replace indus = 18 if(ic == 97004)
gen totwage = earwa1+ earwa2
br totwage earwa1 earwa2
br earwa1
gen voc1 = 0
replace voc1 = . if(voc == .)
replace voc1 = 1 if(voc == 1 | voc1 == 4)
replace voc1 = 2 if(voc == 2 | voc == 3 | voc == 5)
replace voc1 = 0 if(voc == 6)
gen voc2 = 0
replace voc2 = . if(voc == .)
replace voc2 == 1 if(voc == 1 | voc == 4)
replace voc2 = 1 if(voc == 1 | voc == 4)
gen dur1 = .
replace dur1 = 0 if(voc2 == 0)
drop dur1
gen dur1 = .
replace dur1 = 0 if(voc1 == 0)
replace dur1 = dur if(voc1 > 0)
gen dur2 = .
replace dur2 = 0 if(voc2 == 0)
replace dur2 = dur if(voc1 == 1)
drop dur2
gen dur2 = .
replace dur2 = 0 if(voc2 == 0)
replace dur2 = dur if(voc2 == 1)
gen septrain = 0
replace septrain = . if(type == .)
replace septrain = 1 if(type == 2 | type == 3)
gen lgwage = log(totwage)
reg totwage voc2 dur2 sex age marit gedlvl tedlvl y_edu voc365
reg totwage voc2 dur2 i.sex age marit gedlvl tedlvl y_edu voc365
sum sex
desc sex
tab sex
reg totwage voc2 i.sex age marit gedlvl tedlvl y_edu
reg totwage voc2 i.sex age marit gedlvl tedlvl y_edu dur2
vif
gen age2 = age*age
reg totwage voc2 i.sex age age2 marit gedlvl tedlvl y_edu
reg totwage voc2 i.sex age age2 marit gedlvl tedlvl y_edu
reg totwage voc2 i.sex age age2 gedlvl tedlvl y_edu
vif
reg totwage voc2 i.sex age gedlvl tedlvl y_edu
vif
reg totwage voc2 i.sex age gedlvl tedlvl y_edu septrain
reg totwage i.sex age gedlvl tedlvl y_edu septrain
reg totwage septrain i.sex age gedlvl tedlvl y_edu
reg totwage voc2  subs y_edu tedlvl gedlvl sex age
reg totwage voc2  subs y_edu tedlvl gedlvl i.sex age
vif
reg lgwage voc2  subs y_edu tedlvl gedlvl i.sex age
vif
estat hettest
gen field_job = 0
replace field_job = . if(field == . | indus == .)
replace field_job = 1 if(field == indus)
drop field_job
gen field_job = 0
replace field_job = . if(field == . | indus == .)
replace field_job = 1 if(field == indus & (field != . & indus != .))
egen cnt1 = total(field == indus & field != . & indus != .)
egen cnt2 = total(field != . & indus != .)
gen rat = cnt1/cnt2
tab rat
reg totwage voc2  subs y_edu tedlvl gedlvl i.sex age i.dur1
vif
reg totwage voc2  subs y_edu tedlvl gedlvl i.sex age i.dur1 field_job
reg totwage voc2  subs y_edu tedlvl gedlvl i.sex age  field_job
reg totwage subs y_edu tedlvl gedlvl i.sex age  field_job
reg totwage field_job field_job subs y_edu tedlvl gedlvl i.sex age
reg totwage field_job subs y_edu tedlvl gedlvl i.sex age
reg lgwage field_job subs y_edu tedlvl gedlvl i.sex age
gen vfield = field_job* voc2
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age i.dur1
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age i.dur1 septrain
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age dur1 septrain
log off
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age dur1 septrain i.voc1
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age dur1 i.voc1
ovtest
reg lgwage vfield subs y_edu tedlvl gedlvl i.sex age dur1 voc2
reg lgwage field_job subs y_edu tedlvl gedlvl i.sex age voc2
log on
gen field_cat = .
replace field_cat = 0 if( voc2 == 0)
replace field_cat = 1 if(fi field_job == 0)
replace field_cat = 1 if(field_job == 0)
replace field_cat = 2 if(field_job == 1)
br field_cat field_job voc2
reg lgwage sex age gedlvl tedlvl y_edu subs field_cat
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat
estat hettest
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit
estat hettest
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit,robust
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2, robust
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit,robust
estat hettest
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit cur_at
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit dur2
estat hettest
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit dur2, robust
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit septrain
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat age2 marit, robust
vif
reg lgwage sex age gedlvl tedlvl y_edu subs i.field_cat marit, robust
vif
log off
