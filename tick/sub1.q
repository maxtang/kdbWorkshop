/ example tickerplant subscriber
//
/ this connects to the tickerplant
/ requests trades for two stocks
/ and stores them in a trade table

h:hopen `::5010
upd:{insert[`trade;y];}
h("sub";`trade;enlist`AAPL`GOOG);
