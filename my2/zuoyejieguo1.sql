
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数  
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score>c.s_score;
 

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select s.* ,b.s_score as 1score,c.s_score as 2score from student s join score b on s.s_id=b.s_id and b.c_id='01' left join score c on s.s_id=c.s_id and c.c_id='02' or c.c_id = NULL where b.s_score<c.s_score;
 
  


-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from 
student s join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)>=60;
 


-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
        -- (包括有成绩的和无成绩的)
 
select s.s_id,s.s_name,ROUND(AVG(a.s_score),2) as avg_score from  student s left join score a on s.s_id = a.s_id GROUP BY s.s_id,s.s_name HAVING ROUND(AVG(a.s_score),2)<60 union select a.s_id,a.s_name,0 as avg_score from student a where a.s_id not in (select distinct s_id from score);
 

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
 select s.s_id,s.s_name,count(b.c_id) as sum_course,sum(b.s_score) as sum_score from 
 student s left join score b on s.s_id=b.s_id GROUP BY s.s_id,s.s_name;
 

-- 6、查询"李"姓老师的数量 
select count(t_id) from teacher where t_name like '李%';
 
-- 7、查询学过"张三"老师授课的同学的信息 
 select s.* from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三'));
 

-- 8、查询没学过"张三"老师授课的同学的信息 

select * from student c where c.s_id not in(select s.s_id from student s join score b on s.s_id=b.s_id where b.c_id in(select c_id from course where t_id =(select t_id from teacher where t_name = '张三')));
 
-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select s.* from student s,score b,score c where s.s_id = b.s_id  and s.s_id = c.s_id and b.c_id='01' and c.c_id='02';
 

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
 
select s.* from student s where s.s_id in (select s_id from score where c_id='01' ) and s.s_id not in(select s_id from score where c_id='02');

-- 11、查询没有学全所有课程的同学的信息 
select s.* from  student s where s.s_id in(select s_id from score where s_id not in(
select a.s_id from score a join score b on a.s_id = b.s_id and b.c_id='02'
join score c on a.s_id = c.s_id and c.c_id='03' where a.c_id='01'));
 

-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
select * from student where s_id in(select distinct a.s_id from score a where a.c_id in(select a.c_id from score a where a.s_id='01'));
 

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.* from student s where s.s_id in(select distinct s_id from score where s_id!='01' and c_id in(select c_id from score where s_id='01') group by s_id having count(1)=(select count(1) from score where s_id='01'));
 
-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
select s.s_name from student s where s.s_id not in (select s_id from score where c_id = (select c_id from course where t_id =(select t_id from teacher where t_name = '张三')) group by s_id);

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.s_id,s.s_name,ROUND(AVG(b.s_score)) from student s left join score b on s.s_id = b.s_id where s.s_id in(select s_id from score where s_score<60 GROUP BY  s_id having count(1)>=2)GROUP BY s.s_id,s.s_name;


-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select student.*, sc.score from student, sc
where student.s_id = sc.s_id and sc.s_score < 60 and c_id = "01" ORDER BY sc.score DESC;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
 
select *  from sc 
left join (
    select sid,avg(score) as avscore from sc 
    group by sid
    )r 
on sc.sid = r.sid
order by avscore desc;
-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- --及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
 select 
sc.CId ,
max(sc.score)as 最高分,
min(sc.score)as 最低分,
AVG(sc.score)as 平均分,
count(*)as 选修人数,
sum(case when sc.score>=60 then 1 else 0 end )/count(*)as 及格率,
sum(case when sc.score>=70 and sc.score<80 then 1 else 0 end )/count(*)as 中等率,
sum(case when sc.score>=80 and sc.score<90 then 1 else 0 end )/count(*)as 优良率,
sum(case when sc.score>=90 then 1 else 0 end )/count(*)as 优秀率 
from sc
GROUP BY sc.CId
ORDER BY count(*)DESC, sc.CId ASC

-- 19、按各科成绩进行排序，并显示排名 
 
select a.cid, a.sid, a.score, count(b.score)+1 as rank
from sc as a 
left join sc as b 
on a.score<b.score and a.cid = b.cid
group by a.cid, a.sid,a.score
order by a.cid, rank ASC;
-- 20、查询学生的总成绩并进行排名
 
set @crank=0;
select q.sid, total, @crank := @crank +1 as rank from(
select sc.sid, sum(sc.score) as total from sc
group by sc.sid
order by total desc)q;
-- 21、查询不同老师所教不同课程平均分从高到低显示 
 
-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
 


-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
 

-- 24、查询学生平均成绩及其名次 
 
-- 25、查询各科成绩前三名的记录
            -- 1.选出b表比a表成绩大的所有组
            -- 2.选出比当前id成绩大的 小于三个的
 select * from sc a 
left join sc b on a.cid = b.cid and a.score<b.score
order by a.cid,a.score;

-- 26、查询每门课程被选修的学生数 
 select cid, count(sid) from sc 
group by cid;

-- 27、查询出只有两门课程的全部学生的学号和姓名 
    
select student.SId,student.Sname
from sc,student
where student.SId=sc.SId  
GROUP BY sc.SId
HAVING count(*)=2；
-- 28、查询男生、女生人数 
     select ssex, count(*) from student
group by ssex;

-- 29、查询名字中含有"风"字的学生信息
select *
from student 
where student.Sname like '%风%'
  

-- 30、查询同名同性学生名单，并统计同名人数 

   select sname, count(*) from student
group by sname
having count(*)>1;


-- 31、查询1990年出生的学生名单

 select *
from student
where YEAR(student.Sage)=1990;

-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 
 select sc.cid, course.cname, AVG(SC.SCORE) as average from sc, course
where sc.cid = course.cid
group by sc.cid 
order by average desc,cid asc;

-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
select student.sid, student.sname, AVG(sc.score) as aver from student, sc
where student.sid = sc.sid
group by sc.sid
having aver > 85;

 

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
 
select student.sname, sc.score from student, sc, course
where student.sid = sc.sid
and course.cid = sc.cid
and course.cname = "数学"
and sc.score < 60;
-- 35、查询所有学生的课程及分数情况； 
 select student.sname, cid, score from student
left join sc
on student.sid = sc.sid;
 
 -- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数； 
    select student.sname, course.cname,sc.score from student,course,sc
where sc.score>70
and student.sid = sc.sid
and sc.cid = course.cid;


-- 37、查询不及格的课程
 select cid from sc
where score< 60
group by cid;

-- 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 
select student.sid,student.sname 
from student,sc
where cid="01"
and score>=80
and student.sid = sc.sid;
 
-- 39、求每门课程的学生人数 
 select sc.CId,count(*) as 学生人数
from sc
GROUP BY sc.CId;

-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩


        -- 查询老师id   
  
        -- 查询最高分（可能有相同分数）
   
        -- 查询信息
 

select student.*, sc.score, sc.cid from student, teacher, course,sc 
where teacher.tid = course.tid
and sc.sid = student.sid
and sc.cid = course.cid
and teacher.tname = "张三"
order by score desc
limit 1;
-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
 select  a.cid, a.sid,  a.score from sc as a
inner join 
sc as b
on a.sid = b.sid
and a.cid != b.cid
and a.score = b.score
group by cid, sid;


-- 42、查询每门功成绩最好的前两名 
 
select a.s_id,a.c_id,a.score from score as a 
left join s_score as b 
on a.c_id = b.c_id and a.score<b.score
group by a.c_id, a.s_id
having count(b.c_id)<2
order by a.c_id;


-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列  
 select score.c_id, count(s_id) as cc from score
group by c_id having cc >5;

-- 44、查询至少选修两门课程的学生学号 
   select s_id, count(c_id) as cc from score
group by s_id
having cc>=2;

-- 45、查询选修了全部课程的学生信息 
     
select student.*
from score ,student 
where score.s_id=student.s_id
GROUP BY score.s_id
HAVING count(*) = (select DISTINCT count(*) from course );

--46、查询各学生的年龄
    -- 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一

select student.s_id as 学生编号,student.s_name as  学生姓名,
TIMESTAMPDIFF(YEAR,student.s_birth,CURDATE()) as 学生年龄 from student

-- 47、查询本周过生日的学生
 select *
from student 
where WEEKOFYEAR(student.s_birth)=WEEKOFYEAR(CURDATE());

-- 48、查询下周过生日的学生
 
select *
from student 
where WEEKOFYEAR(student.s_birth)=WEEKOFYEAR(CURDATE())+1;
-- 49、查询本月过生日的学生

 select *
from student 
where MONTH(student.s_birth)=MONTH(CURDATE());

-- 50、查询下月过生日的学生

select *
from student 
where MONTH(student.s_birth)=MONTH(CURDATE())+1;









