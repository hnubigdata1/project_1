library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_welfare<-read.spss(file = "Koweps_hpc10_2015_beta1.sav",to.data.frame = T)
welfare<-raw_welfare

welfare <- rename(welfare,
                  sex=h10_g3,
                  birth=h10_g4,
                  marriage=h10_g10,
                  religion=h10_g11,
                  income=p1002_8aq1,
                  code_job=h10_eco9,
                  code_region=h10_reg7)




# 1. 연령대 별 남여 수 비교

#숫자 코드를 성별 문자로 변경 및 이상치 제거
welfare$sex<-ifelse(welfare$sex == 1 , "male",
                    ifelse(welfare$sex == 2, "female",NA))

#출생년도를 나이로 변환
welfare$age<-2019 -welfare$birth + 1

#연령대 설정
welfare<-welfare%>%
  mutate(ageg = ifelse(age<30, "young",
                       ifelse(age<=59,"middle","old")))

table(welfare$ageg)

welfare$birth

table(is.na(welfare$birth))
table(is.na(welfare$sex))

#그래프 출력/young,middle,old 순으로 출력
ggplot(data = welfare, aes(x=ageg, fill = sex))+
  geom_bar(position = "dodge")+
  scale_x_discrete(limits = c("young","middle","old"))




# 2. 지역&연령대 별 이혼율

list_region<-data.frame(code_region = c(1:7),
                        region = c("서울",
                                   "수도권(인천/경기)",
                                   "부산/경남/울산",
                                   "대구/경북",
                                   "대전/충남",
                                   "강원/충북",
                                   "광주/전남/전북/제주도"))

list_region

welfare<- left_join(welfare, list_region, id="code_region")

welfare%>%
  select(code_region, region)

table(welfare$marriage)

welfare$st_marrige<- ifelse(welfare$marriage == 1,"marriage",
                            ifelse(welfare$marriage == 3,"divorce",NA))

table(welfare$st_marrige)
table(is.na(welfare$st_marrige))

div<-welfare%>%
  filter(!is.na(st_marrige))%>%
  group_by(ageg,region,st_marrige)%>%
  summarise(n=n())%>%
  mutate(sum_gr = sum(n))%>%
  mutate(per_gr = round(n/sum_gr*100,1))

div

div_ageg<-div%>%
  filter(ageg != "young" & st_marrige == "divorce")

div_ageg

#출력
ggplot(data = div_ageg, aes(x=region, y=per_gr, fill=ageg))+geom_col(position = "dodge")


#3. 최종 학력에 따른 임금 분석

welfare <- rename(welfare,
                  code_hak=p1007_3aq1)

list_hak<-data.frame(code_hak = c(1:5),
                        hak = c("중학교 졸업 이하",
                                   "고등학교 중퇴/졸업",
                                   "전문대학 재학/중퇴/졸업",
                                   "대학교(4년제) 재학/중퇴/졸업",
                                   "대학원 이상"))

list_region

welfare<- left_join(welfare, list_hak, id="code_hak")


#학력 별로 따로 저장 후 이상치 제거
df_mid<- welfare%>%
  filter(hak=="중학교 졸업 이하")%>%
  select(hak,income)

boxplot(df_mid$income)



df_high<- welfare%>%
  filter(hak=="고등학교 중퇴/졸업")%>%
  select(hak,income)

boxplot(df_high$income)
boxplot(df_high$income)$stats

df_high$income<-ifelse(df_high$income >428.3, NA, df_high$income)
  
df_col<- welfare%>%
  filter(hak=="전문대학 재학/중퇴/졸업")%>%
  select(hak,income)

boxplot(df_col$income)

df_uni<- welfare%>%
  filter(hak=="대학교(4년제) 재학/중퇴/졸업")%>%
  select(hak,income)

boxplot(df_uni$income)
boxplot(df_uni$income)$stats
df_uni$income<-ifelse(df_uni$income >508, NA, df_uni$income)

df_suk<- welfare%>%
  filter(hak=="대학원 이상")%>%
  select(hak,income)

boxplot(df_suk$income)

df<-bind_rows(df_mid,df_high,df_col,df_uni,df_suk)


df<-df%>%
  filter(!is.na(income))%>%
  group_by(hak)%>%
  summarise(mean_n = mean(income))


ggplot(data = df, aes(x=hak, y=mean_n))+
  geom_col()+
  scale_x_discrete(limits = c("중학교 졸업 이하","고등학교 중퇴/졸업","전문대학 재학/중퇴/졸업","대학교(4년제) 재학/중퇴/졸업","대학원 이상"))

