
\l ws/buildtaq.q

\l db/taq

trade

count trade

select from trade where date=last date, sym=`IBM

select count i by date from trade

/ if plot available:
plot select time,price from trade where date=last date, sym=`IBM
\

