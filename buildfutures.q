/ buildhfutures.q
/ builds a historical futures database
//
/ tables:
/ trade: date time sym base price size
/ daily: date sym open high low close price size
/ pcday: date sym close vol pclose vol (all syms)
//
/ requires write permission in target directories

/ config
dst:`:db/futures       / database root
/ dsp:""               / optional database segment root
/ dsx:5                / number of segments

bgn:2010.01.01         / begin
end:2011.12.31         / end
drn:210                / duration of options in days
tpd:10                 / average trades per day per option

months:`H`M`U`Z        / for these month ends (end of quarter)

\S 235721
/ util

pi:acos -1
basesym:{`$-3_string x}
gen:{exp 0.001 * normalrand x}
normalrand:{(cos 2 * pi * x ? 1f) * sqrt neg 2 * log x ? 1f}
rnd:{0.01*floor 0.5+x*100}
timeprof:{09:30:00.0 + asc x?23400000}
volprof:{rnd sin ((2*acos 0)%1+x*1.1) * 1+til x}
volrand:{0.75+x?0.5}
weekdays:{x where 5 > x-`week$x}
/ symbol data for futures

sn:2 cut (
 `CL;"Crude Oil";
 `EC;"Eurodollar";
 `ED;"Eurodollar, 90-Day";
 `ES;"E-mini S&P 500 Futures";
 `TY;"Treasury Notes, 10-Yr")

bases:first each sn
names:last each sn
mas:([]sym:bases;name:names)
prices:10 20 30 40 50f

years:bgn.year + til 1 + end.year-bgn.year
efx:-1+"d"$"m"$raze (12*years-2000) +\: 3*1+til 4
sfx:-1 rotate' (2 _' string years) cross string[months]
syms:` $ (string bases) cross sfx
basesymmap:syms!basesym each syms

expiration:([]
 base:basesym each syms;
 sym:syms;
 date:efx sfx ? -3 #' string syms)


/main

/ =========================================================
maketrade:{
 a:maketrade1 each til count bases;
 `date`time xasc raze a}

/ =========================================================
maketrade1:{
  P::prices x;
  I::1;
  syms:` $ (enlist string bases x) cross sfx;
  raze maketrade2 each syms}

maketrade2:{
  r:string x;
  i:sfx?-3#r;
  e:efx i;
  d:weekdays (1+e-drn)+til drn;
  len:count d;
  v:"i"$tpd*(volprof len)*volrand len;
  n:sum v;
  d:raze v #' d;
  t:raze timeprof each v;
  p:rnd P * prds 1.0,gen n-1;
  P::(p 60) * 1.10 xexp -1 1 rand 2;
  s:"i"$10+(n?45)*2 xexp (til n)%n-1;
  w:iasc d+t;
  w:w where (bgn<=d w) & end>=d w;
  ([]date:d w;time:t w;sym:x;base:`$-3_r;price:p w;size:s w)}

/ =========================================================
makedaily:{
 0!select
  open:first price,high:max price,low:min price,
  close:last price,price:sum price*size,size:sum size
 by date,sym from trade where sym in syms}

/ =========================================================
trade:maketrade 0
daily:makedaily 0

(` sv dst,`daily) set .Q.en[dst] daily;
(` sv dst,`trade) set .Q.en[dst] trade;
(` sv dst,`expiration) set .Q.en[dst] expiration;
(` sv dst,`mas) set .Q.en[dst] mas;
