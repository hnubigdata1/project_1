DESC POPUL;

SELECT *
FROM POPUL;

--1) 서울시,서초구,읍면동 1인가구 수

SELECT 시도, 시군구, 읍면동, 세대_1인
FROM POPUL
WHERE 시도 = '서울특별시'
    AND 시군구 = '서초구' 
    AND 읍면동 ='잠원동' ;
    
SELECT 시도, 시군구, 읍면동, 세대_3인
FROM POPUL
WHERE 세대_3인 BETWEEN 500 AND 600;

--5인이상 세대수 

CREATE TABLE POPUL_1
    AS SELECT * FROM POPUL ;

select * from popul_1;

---데이터 전처리

ALTER TABLE POPUL_1(
    ADD SMALL NUMBER(5), 
         MIDDLE NUMBER(5),
         BIG NUMBER(4)
         );

ALTER TABLE POPUL_1 DROP(읍면동);

ALTER TABLE POPUL_1 ADD SMALL NUMBER(5);

ALTER TABLE POPUL_1 ADD MIDDLE NUMBER(5);

ALTER TABLE POPUL_1 ADD BIG NUMBER(5);

CREATE TABLE POPUL_2
AS SELECT 시군구, SUM(세대_1인+세대_2인) AS SMALL,
            SUM(세대_3인+세대_4인+세대_5인) AS MIDDLE,
            SUM(세대_6인+세대_7인+세대_8인+세대_9인+세대_10인) AS BIG
FROM POPUL_1
WHERE 시도 =  '서울특별시'
    AND 시군구 IS NOT NULL
GROUP BY 시군구 ;

SELECT * FROM POPUL_2;

ALTER TABLE POPUL_2
    RENAME COLUMN "시군구" TO AREA;