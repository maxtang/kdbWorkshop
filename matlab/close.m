% plot daily close for IBM

ibm = fetch(h, 'select from daily where sym=`IBM')

plot(fints(ibm.date,ibm.close))

