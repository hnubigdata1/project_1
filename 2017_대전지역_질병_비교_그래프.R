library(dplyr)

c_code<-read.csv('시도 지역코드.csv')
c_code

gamgi<-read.csv("실제진료정보_감기_시도.csv")
noon<-read.csv("실제진료정보_눈병_시도.csv")
cheon<-read.csv("실제진료정보_천식_시도.csv")
pee<-read.csv("실제진료정보_피부염_시도.csv")


deageon1<-gamgi%>%
  filter(시도지역코드 == 30 & 날짜>20170000 & 날짜<20180000)%>%
  select(날짜, 발생건수.건.)

deageon1<-rename(deageon1,감기 = 발생건수.건.)

deageon2<-noon%>%
  filter(시도지역코드 == 30 & 날짜>20170000 & 날짜<20180000)%>%
  select(날짜, 발생건수.건.)

deageon2<-rename(deageon2,눈병 = 발생건수.건.)

deageon3<-cheon%>%
  filter(시도지역코드 == 30 & 날짜>20170000 & 날짜<20180000)%>%
  select(날짜, 발생건수.건.)

deageon3<-rename(deageon3,천식 = 발생건수.건.)

deageon4<-pee%>%
  filter(시도지역코드 == 30 & 날짜>20170000 & 날짜<20180000)%>%
  select(날짜, 발생건수.건.)

deageon4<-rename(deageon4,피부염 = 발생건수.건.)

deageon<-left_join(deageon1,deageon2, id ="날짜")
deageon<-left_join(deageon,deageon3, id ="날짜")
deageon<-left_join(deageon,deageon4, id ="날짜")

deageon

install.packages("plotly")
install.packages("dygraphs")

library(plotly)
library(ggplot2)
library(dygraphs)
library(xts)

#write.csv(deageon,file="deageon.csv")
deageon<- read.csv("deageon.csv")
deageon

deageon$날짜<-as.Date(deageon$날짜)
deageon


dea_g<-xts(deageon$감기,order.by = deageon$날짜)
dea_c<-xts(deageon$천식,order.by = deageon$날짜)
dea_n<-xts(deageon$눈병,order.by = deageon$날짜)
dea_p<-xts(deageon$피부염,order.by = deageon$날짜)

dea<-cbind(dea_g,dea_c,dea_n,dea_p)
colnames(dea)<-c("cold","asthma","Eyedisease","dermatitis")

head(dea)


dygraph(dea)%>%dyRangeSelector()
dygraph(dea$cold)%>%dyRangeSelector()
dygraph(dea$asthma)%>%dyRangeSelector()
dygraph(dea$Eyedisease)%>%dyRangeSelector()
dygraph(dea$dermatitis)%>%dyRangeSelector()


