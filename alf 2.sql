ALTER function [dbo].[alnum](@i int) returns char(1) as
begin	
	return 
		case 
			when (@i >= 36) then 
				'?' 
			when (@i < 0) then
				'?'
			else 
				case 
					when (@i <= 25) then
						char(65 + @i)
					when (@i >= 26) then
						char(47+@i-25)
					else
						'?'
				end 
		end				
end
GO

alter function [dbo].[alfanum](@i int) returns char(5) as
begin
	declare @a char(1)
	declare @b char(1)
	declare @c char(1)
	declare @d char(1)
	declare @x int

	if (@i > 36 * 36 * 36 * 36) return 'OVER'

	if (@i >= 0) 
	begin
		set @x = @i
		set @x = @x % 36
		set @a = dbo.alnum(@x)	
	end
	else return 'ERRO'

	if (@i >= 36)
	begin
		set @x = floor(@i / 36)
		set @x = (@x % 36) 
		set @b = dbo.alnum(@x)	
	end
	else set @b = 'A'


	if (@i >= 36 * 36)
	begin
		set @x = floor(@i / 36 / 36)
		set @x = (@x % 36) 
		set @c = dbo.alnum(@x)	
	end
	else set @c = 'A'


	if (@i >= 36 * 36 * 36)
	begin
		set @x = floor(@i / 36 / 36 / 36)
		set @x = (@x % 36) 
		set @d = dbo.alnum(@x)	
	end
	else set @d = 'A'
	
	return @d + @c + @b + @a + dbo.modulo11(ascii(@d) + ascii(@c) + ascii(@b) + ascii(@a))
end
GO


alter function numal(@c char) returns int as
begin	
	return
		case 
			when (ascii(@c) >= ascii('A')) and (ascii(@c) <= ascii('Z')) then
				ascii(@c) - ascii('A')
			when (ascii(@c) >= ascii('0')) and (ascii(@c) <= ascii('9')) then 
				ascii(@c) - ascii('0') + 26
			else
				-1000000
		end
end
go

alter function numalfa(@s char(5)) returns int as
begin
	declare @a char(1)
	declare @b char(1)
	declare @c char(1)
	declare @d char(1)
	declare @x int

	if (len(@s) > 5) return -1000000

	set @x = 0 
	set @x = @x + dbo.numal(substring(@s, 4, 1))
	set @x = @x + dbo.numal(substring(@s, 3, 1)) * 36
	set @x = @x + dbo.numal(substring(@s, 2, 1)) * 36 * 36
	set @x = @x + dbo.numal(substring(@s, 1, 1)) * 36 * 36 * 36
	
	return @x
end
GO

declare @y int
set @y = 15000

select dbo.numalfa(dbo.alfanum(@y))


 