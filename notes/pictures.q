
/ picture:localhost:8888::

\l db/taq


\l C:\q\rinit.q
.z.ts:{Rcmd"1+a"}
\t 500
r) plot(c(1,2,3))
r) library(ggplot2)
r) library(scales)

t:select from trade
(::)t:select date,time:`datetime$date+time,sym:`$string sym,`float$price,`float$size from t
t:select from t where date = first distinct date

/ trade

r) g<-ggplot(`t,aes(x=time,y=price,color=sym))
r) p<-g + geom_line() + facet_wrap(~sym,scales='free_y')
r) print(p + theme(legend.position='none'))
r) ggsave(file='../../pictures/taq_price.pdf',p + theme(legend.position='none')	)

/ quote
ibm: select from quote where sym=`IBM,date= 2013.05.01

(::)ibm:200#ungroup select time:`datetime$date+time,prx:flip[(bid;ask;next bid;next ask)],side:flip[(count[bid]#/:`bid`ask`bid`ask)]  from ibm 


r) g<-ggplot(`ibm,aes(x=time,y=prx,color=side))
r) p<-g + geom_point() + geom_line()
r) print(p)
r) ggsave(file='../../pictures/quote.pdf',p)

/ timing

q1:"\\t select from trade where date=2013.05.21,sym=`IBM"
q2:"\\t select from trade where sym=`IBM,date=2013.05.21"
n:100
t1:([] ind:til n;q1:{value q1}each til n;q2: {value q2}each til n)

t1:ungroup select ind:flip[(ind;ind)],timing:flip[(q1;q2)],query:flip[(count[ind]#`smart_query;count[ind]#`stupid_query)] from t1

r) g<-ggplot(`t1,aes(x=ind,y=timing,color=query))
r) p<-g + geom_point()
r) print(p + stat_smooth())
r) ggsave(file='../../pictures/timing.pdf',p)

/ vwap

(::)vwap:0!select vwap:size wavg price by date,sym:`$ string sym from trade

r) g <- ggplot(`vwap,aes(x=date,y=vwap,color = sym))
r) p<-g + geom_point()
r) print(p + stat_smooth())
r) ggsave(file='../../pictures/vwap1.pdf',p + stat_smooth())
r) print(p + stat_smooth() + facet_wrap(~sym,scales='free_y') + theme(legend.position='none'))
r) ggsave(file='../../pictures/vwap2.pdf',p + stat_smooth() + facet_wrap(~sym,scales='free_y') + theme(legend.position='none'))


f:{ [x] 0!select vwap:size wavg price,frequency:(`$string[x],"minute") by time:`datetime$ .z.d + x xbar time.minute from trade where date =2013.05.01 ,sym=`IBM}

vwap:raze f each 1 3 5 7 10

r) g <- ggplot(`vwap,aes(x=time,y=vwap,color = frequency))
r) p<-g + geom_point() 
r) print(p+geom_line() )
r) ggsave(file='../../pictures/vwap3.pdf',p +geom_line())

/ correlation
(::)k:key t:exec close by sym from daily
(::)c:t cor/:\: t:value[t]
t:`sym xdesc ungroup ([]sym:k;sym1:count[k]#enlist k;val:c)

Rset `t
r) t$sym<-factor(t$sym,levels = (t$sym))
r) t$sym1<-factor(t$sym1,levels = t$sym1)
r) g <- ggplot(t,aes(x=sym1,y=sym,fill = val))
r) p<-g + geom_tile() 
r) print(pp<-p + geom_text(aes(label = percent(val))) +scale_fill_gradient2(low='red', high='blue') )
r) ggsave(file='../../pictures/corr.pdf',pp)

/ windows join

(::)t:select time,price from trade where date=last date,sym=`IBM

(::)q:select time,mid:0.5*bid+ask from quote where date=last date,sym=`IBM

w:(-[;5000]; 10000+) @ \: t.time
c:`time

r:wj[w;c;t;(q;min,`mid;max,`mid)]

p:50#update time:.z.d+time, ind:i from flip `time`price`mn`mx!value flip r

r) g<-ggplot(`p,aes(x=time,ymin=mn,ymax=mx))
r) p<-g + geom_linerange() 
r) p<- p + geom_point(aes(y=price,color='trade'))
r) p<- p + geom_point(aes(y=mn,color='min mid'))
r) p<- p + geom_point(aes(y=mx,color='max mid'))
r) print(p +  labs(title='window joins',color='color') )
r) ggsave(file='../../pictures/matching.pdf',p+labs(title='window joins',color='color'))