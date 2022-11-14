library(sqldf)

library(readxl)

SQL <- read_excel("SQL Problem.xlsx") 
View(SQL)

library(dplyr)

SQL <- SQL %>% select(-4,-5)

A <- sqldf("SELECT * , ROW_NUMBER()OVER(PARTITION BY Call_to ORDER BY Call_at) AS Rownum
            FROM SQL") 
B <- sqldf("SELECT Call_to, Duration_sec,MIN(Rownum) as First_M_call from A WHERE Duration_sec>=30
            GROUP BY Call_to") 
View(A)
View(B)
C <- sqldf("SELECT A.Call_to,A.Duration_sec,COUNT(*)OVER(PARTITION BY A.Call_to) as Count from A JOIN B 
            WHERE A.Call_to=B.Call_to and Rownum >First_M_call") 
View(C)

library(dplyr)

Table1<- SQL %>% group_by(Call_to) %>% mutate(rownum=row_number()) %>% arrange(Call_at)
View(Table1)
Table2<- Table1 %>% filter(Duration_sec>=30) %>% group_by(Call_to) %>% summarise(First_M_call=min(rownum)) 
View(Table2)
Table3<- left_join(Table1,Table2,by='Call_to') %>% select(Table1$Call_to,Table1$Duration_sec) %>% 
  group_by(Table1$Call_to) %>%  summarise(N=n())
