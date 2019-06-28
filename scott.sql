DESC POPUL;

SELECT *
FROM POPUL;

--1) �����,���ʱ�,���鵿 1�ΰ��� ��

SELECT �õ�, �ñ���, ���鵿, ����_1��
FROM POPUL
WHERE �õ� = '����Ư����'
    AND �ñ��� = '���ʱ�' 
    AND ���鵿 ='�����' ;
    
SELECT �õ�, �ñ���, ���鵿, ����_3��
FROM POPUL
WHERE ����_3�� BETWEEN 500 AND 600;

--5���̻� ����� 

CREATE TABLE POPUL_1
    AS SELECT * FROM POPUL ;

select * from popul_1;

---������ ��ó��

ALTER TABLE POPUL_1(
    ADD SMALL NUMBER(5), 
         MIDDLE NUMBER(5),
         BIG NUMBER(4)
         );

ALTER TABLE POPUL_1 DROP(���鵿);

ALTER TABLE POPUL_1 ADD SMALL NUMBER(5);

ALTER TABLE POPUL_1 ADD MIDDLE NUMBER(5);

ALTER TABLE POPUL_1 ADD BIG NUMBER(5);

CREATE TABLE POPUL_2
AS SELECT �ñ���, SUM(����_1��+����_2��) AS SMALL,
            SUM(����_3��+����_4��+����_5��) AS MIDDLE,
            SUM(����_6��+����_7��+����_8��+����_9��+����_10��) AS BIG
FROM POPUL_1
WHERE �õ� =  '����Ư����'
    AND �ñ��� IS NOT NULL
GROUP BY �ñ��� ;

SELECT * FROM POPUL_2;

ALTER TABLE POPUL_2
    RENAME COLUMN "�ñ���" TO AREA;