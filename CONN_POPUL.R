Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211")
install.packages("rJava")
install.packages("RJDBC")

library(rJava)
library(RJDBC)

drv <- JDBC("oracle.jdbc.driver.OracleDriver","C:/app/CPB06GameN/product/11.2.0/dbhome_2/jdbc/lib/ojdbc6.jar")

conn<- dbConnect(drv,
                 "jdbc:oracle:thin:localhost:1512:orcl",
                 "scott","tiger")

query <- "select * from POPUL_2"   


result <- dbGetQuery(conn,query)

head(result)

dbDisconnect(conn)

library(dplyr)
library(ggplot2)


# dbListTables(conn)


summary(result)

View(result)

population <- result


# SAMLL 가구를 정리
go1 <- population %>% select(AREA, SMALL)
go1 <- rename(go1, 가구= SMALL)
go11 <- go1 %>% mutate(세대 = "SMALL")

# MIDDLE 가구를 정리
go2 <- population %>% select(AREA, MIDDLE)
go2 <- rename(go2, 가구= MIDDLE)
go22 <- go2 %>% mutate(세대 = "MIDDLE")

# BIG 가구를 정리
go3 <- population %>% select(AREA, BIG)
go3 <- rename(go3, 가구= BIG)
go33 <- go3 %>% mutate(세대 = "BIG")

# 가구를 하나의 변수에 합치기
pop_all <- bind_rows(go11, go22, go33)

# 그래프 만들기 (기준: 세대)
ggplot(data = pop_all, aes(x= AREA, y= 가구, fill = 세대)) + geom_col(position = "dodge")

# 그래프 만들기(기준:AREA)
ggplot(data = pop_all, aes(x= 세대, y= 가구, fill = AREA)) + geom_col(position = "dodge")
