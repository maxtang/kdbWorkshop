% fetch and plot price by minute for last day

tab = fetch(h, ...
  ['update dt:date+minute from', ...
   ' select last date, last price by time.minute ', ...
   ' from trade where date=last date,sym=`IBM'])

plot(fints(tab.dt,tab.price))
day = floor(tab.dt(1))
xlim([(day+9/24),(day+17/24)])
