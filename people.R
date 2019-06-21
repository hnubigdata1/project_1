library(readxl)
library(dplyr)
library(stringr)


animal<-read_excel("animal.xlsx")
laundry<-read_excel("laundry.xlsx")
people<-read.csv("people.csv")

head(people)
head(laundry)
head(animal)

peo<-people%>%
  filter(시도 == "서울특별시")%>%
  filter(시군구 != "" )%>%
  filter(읍면동 != "")

peo$small<-(peo$X1인세대 + peo$X2인세대)
peo$middle<-(peo$X3인세대+ peo$X4인세대 + peo$X5인세대)           


people<-peo%>%
  select(시군구, small, middle)%>%
  group_by(시군구)%>%
  summarise(small=sum(small), middle=sum(middle))



ani<-animal%>%
  filter(영업상태명 =='휴업' | 영업상태명 == "영업/정상")

sampling<-str_split(ani$소재지전체주소, pattern=" ", n =3, simplify=TRUE)

ani$시도<-sampling[,1]
ani$시군구<-sampling[,2]

animal<-ani%>%
  filter(시도 == "서울특별시")%>%
  group_by(시군구)%>%
  summarise(ani=n())



laun<-laundry%>%
  filter(영업상태명 =='휴업' | 영업상태명 == "영업/정상")

lau_sam<-str_split(laun$소재지전체주소, pattern=" ", n = 3, simplify=TRUE)

laun$시도<-lau_sam[,1]
laun$시군구<-lau_sam[,2]

laun<-laun%>%
  filter(시도 =="서울특별시")%>%
  filter(업태구분명 == "빨래방업" |업태구분명 == "일반세탁업")%>%
  group_by(시군구, 업태구분명)%>%
  summarise(laund = n())

laun_room<-laun%>%
  filter(업태구분명 == "빨래방업")%>%
  select(시군구, laund)
laun_room<-rename(laun_room,room = laund)

laun_so<-laun%>%
  filter(업태구분명 == "일반세탁업")%>%
  select(시군구, laund)
laun_so<-rename(laun_so,so = laund)

tot<-left_join(people,animal,by='시군구')
tot<-left_join(tot,laun_room,by='시군구')
tot<-left_join(tot,laun_so, by="시군구")


tot$room<-ifelse(is.na(tot$room),0,tot$room)

