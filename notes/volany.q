/ volatility analysis

select close from daily where sym=`IBM

select ratios close from daily where sym=`IBM

select 1 _ ratios close from daily where sym=`IBM

select log 1 _ ratios close from daily where sym=`IBM

select dev log 1 _ ratios close from daily where sym=`IBM

select dev log 1 _ ratios close by sym from daily

desc select dev log 1 _ ratios close by sym from daily

/
volany:{[portfolio]
 desc select dev log 1 _ ratios close by sym from daily
 where sym in portfolio}
\

\l ws/volany.q

volany `IBM`AAPL`GOOG

