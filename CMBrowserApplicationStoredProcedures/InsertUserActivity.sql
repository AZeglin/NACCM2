IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertUserActivity')
	BEGIN
		DROP  Procedure  InsertUserActivity
	END

GO

CREATE procedure InsertUserActivity
(
@UserName nvarchar(100),
@ActionType nchar(1),
@ActionDetails nvarchar(80),
@ActionDetailsType nchar(1)
)

AS

BEGIN

	insert into tbl_UserActivity
	( UserName, ActionType, ActionDate, ActionDetails, ActionDetailsType )
	values
	( @UserName, @ActionType, getdate(), @ActionDetails, @ActionDetailsType )

END