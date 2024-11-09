create database BlogDB
use BlogDB



create table Users(
Id int primary key identity,
UserName nvarchar(20) unique,
FullName nvarchar(20) not null,
Age int check(Age>0 and Age<150)

)



insert into Users
values('UserName1','FullName1',20)
,('UserName2','FullName2',22)
,('UserName3','FullName3',30)

select *from Users



create table Blogs(
Id int primary key identity,
Title nvarchar(50) not null,
[Description] nvarchar(50),
UserId int references Users(Id),
CategoryId int references Categories(Id)
)


insert into Blogs
values('Blog1','Description1',1,1),
('Blog2','Description2',1,3),
('Blog3','Description3',2,2),
('Blog4','Description4',2,1),
('Blog5','Description5',2,3),
('Blog6','Description6',3,2)


select *from Blogs



create table Comments(
Id int primary key identity,
Content nvarchar(250) not null,
UserId int references Users(Id),
BlogId int references Blogs(Id)
)


insert into Comments
values('Content1',1,1),
('Content2',1,3),
('Content3',3,2),
('Content4',3,3),
('Content5',3,1),
('Content6',2,2),
('Content7',2,1)



select *from Comments




create table Categories(
Id int primary key identity,
[Name] nvarchar(20) unique,
)



insert into Categories
values('Category1'),
('Category2'),
('Category3')

select *from Categories



create table Tags(
Id int primary key identity,
[Name] nvarchar(20) unique
)

insert into Tags
values('Tag1'),
('Tag2'),
('Tag3')

select * from Tags



create table BlogsTags(
Id int primary key identity,
BlogId int foreign key references Blogs(Id),
TagId int foreign key references Tags(Id)
)

insert into BlogsTags
values(1,1),(1,3),(2,2),(2,1),(3,1),(3,3),(3,2)

select *from BlogsTags





alter view Blogs_Users as
select Blogs.Title,Users.UserName,Users.FullName from Users
join Blogs
on Blogs.UserId=Users.Id

select *from Blogs_Users




alter view Blogs_Categories as
select Blogs.Title,Categories.[Name] from Blogs
join Categories
on Blogs.CategoryId=Categories.Id

select *from Blogs_Categories






alter Procedure usp_get_Comments @userId int 
as
select Comments.Content from Users
join Comments
on Comments.UserId=Users.Id
where @userId=Users.Id

execute usp_get_Comments 2




create procedure usp_get_Blogs @userId int
as
select Blogs.Title from Users
join Blogs
on Blogs.UserId=Users.Id
where @userId=Users.Id

execute usp_get_Blogs 1


create function Get_Blogs_Count(@categoryId int)
returns int
as
Begin
declare @BlogCount int
select @BlogCount=Count(*) from Categories
join Blogs
on Blogs.CategoryId=Categories.Id
where @categoryId=Categories.Id
return @BlogCount
End

select dbo.Get_Blogs_Count(1) as [Blogs Count]



create function Get_Blogs_Table1(@userId int)
returns Table
as
return 
select Blogs.Title from Users
join Blogs
on Blogs.UserId=Users.Id
where @userId=Users.Id


select *from Get_Blogs_Table1(2) 


alter trigger IsDeleted 
on Blogs
After Delete
as
begin
print 'One item is removed from Blogs table'
end

delete from Blogs
where Title='Blog1'

 




