/ example tickerplant subscriber
//
/ this connects to the tickerplant
/ requests trades for two stocks
/ runs a check on paired prices

lasttrade:{.[`trades;();,;select by sym from y]}
prices:{(trades each x)`price}
open:0

h:hopen `::5010
upd:{
 lasttrade[x;y];
 if[open~0;p:prices `GOOG`AAPL;if[0n in p;:0];open::p];
 p:prices `AAPL`GOOG;
 r:open * p;
 s:(r 0) % r 1;
 m:$[s<0.98;"buy apple, sell google";s>1.02;"sell apple, buy google";"hold"];
 show (" " sv string p,s)," ",m}
h("sub";`trade;enlist`AAPL`GOOG);
