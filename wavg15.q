/ build 15-minute weighted average function
/ copy into the database directory db/taq
/ reload database and use as:
/ wavg15[2013.05.23;`IBM]

wavg15:{[d;s]
 select lprice:last price, wprice:size wavg price
 by 15 xbar time.minute from trade where date=d,sym=s}
