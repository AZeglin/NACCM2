IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tr_DI_DrugItemPrice_Changes')
	BEGIN
		DROP  Trigger tr_DI_DrugItemPrice_Changes
	END
GO

CREATE TRIGGER [dbo].[tr_DI_DrugItemPrice_Changes] ON [dbo].[DI_DrugItemPrice] FOR UPDATE, DELETE
AS

DECLARE @type varchar(1) ,
	    @AuditId int,
		@NewAuditId int,
		@ListOfAuditIds varchar(1000),
		@LastModifiedBy nvarchar(120)
       
	IF exists (select top 1 1 from inserted) and exists (select top 1 1 from deleted)
	Begin
		Select @type = 'U',
			@LastModifiedBy = 
				Case 
					when system_user = 'VHAMASTER\AMMHINSQL2$' then LastModifiedBy
					when system_user = 'NACCM' then LastModifiedBy					
					when system_user = 'VHAMASTER\AMMHINPRDAPP1$' then LastModifiedBy					
					else system_user
				End	

		From inserted
	End
	ELSE IF exists (select top 1 1 from inserted)
	Begin
		Select @type = 'I',
			@LastModifiedBy = 
				Case 
					when system_user = 'VHAMASTER\AMMHINSQL2$' then LastModifiedBy
					when system_user = 'NACCM' then LastModifiedBy					
					when system_user = 'VHAMASTER\AMMHINPRDAPP1$' then LastModifiedBy					
					else system_user
				End		
		From inserted
	End
	Else
	Begin
		Select @type = 'D',@LastModifiedBy = 
				Case 
					when system_user = 'VHAMASTER\AMMHINSQL2$' then LastModifiedBy
					when system_user = 'NACCM' then LastModifiedBy					
					when system_user = 'VHAMASTER\AMMHINPRDAPP1$' then LastModifiedBy					
					else system_user
				End
		From Deleted
	End

	
-- DrugItemId
	IF update(DrugItemId) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,DrugitemId,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'DrugItemId', 
				convert(varchar(1000),d.DrugItemId), convert(varchar(1000),i.DrugItemId), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.DrugItemId <> d.DrugItemId or (i.DrugItemId is null and d.DrugItemId is not null) or (i.DrugItemId is not null and d.DrugItemId is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End


-- DrugItemSubItemId
	IF update(DrugItemSubItemId) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,DrugitemId,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'DrugItemSubItemId', 
				convert(varchar(1000),d.DrugItemSubItemId), convert(varchar(1000),i.DrugItemSubItemId), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.DrugItemSubItemId <> d.DrugItemSubItemId or (i.DrugItemSubItemId is null and d.DrugItemSubItemId is not null) or (i.DrugItemSubItemId is not null and d.DrugItemSubItemId is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- HistoricalNValue
	IF update(HistoricalNValue) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,DrugItemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'HistoricalNValue', 
				convert(varchar(1000),d.HistoricalNValue), convert(varchar(1000),i.HistoricalNValue), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.HistoricalNValue <> d.HistoricalNValue or (i.HistoricalNValue is null and d.HistoricalNValue is not null) or (i.HistoricalNValue is not null and d.HistoricalNValue is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- PriceId
	IF update(PriceId) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,Drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'PriceId', 
				convert(varchar(1000),d.PriceId), convert(varchar(1000),i.PriceId), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.PriceId <> d.PriceId or (i.PriceId is null and d.PriceId is not null) or (i.PriceId is not null and d.PriceId is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- PriceStartDate
	IF update(PriceStartDate) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,Drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'PriceStartDate', 
				convert(varchar(1000),d.PriceStartDate), convert(varchar(1000),i.PriceStartDate), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.PriceStartDate <> d.PriceStartDate or (i.PriceStartDate is null and d.PriceStartDate is not null) or (i.PriceStartDate is not null and d.PriceStartDate is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- PriceStopDate
	IF update(PriceStopDate) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'PriceStopDate', 
				convert(varchar(1000),d.PriceStopDate), convert(varchar(1000),i.PriceStopDate), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.PriceStopDate <> d.PriceStopDate or (i.PriceStopDate is null and d.PriceStopDate is not null) or (i.PriceStopDate is not null and d.PriceStopDate is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- Price
	IF update(Price) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'Price', 
				convert(varchar(1000),d.Price), convert(varchar(1000),i.Price), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.Price <> d.Price or (i.Price is null and d.Price is not null) or (i.Price is not null and d.Price is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsTemporary
	IF update(IsTemporary) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsTemporary', 
				convert(varchar(1000),d.IsTemporary), convert(varchar(1000),i.IsTemporary), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsTemporary <> d.IsTemporary or (i.IsTemporary is null and d.IsTemporary is not null) or (i.IsTemporary is not null and d.IsTemporary is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsFSS
	IF update(IsFSS) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsFSS', 
				convert(varchar(1000),d.IsFSS), convert(varchar(1000),i.IsFSS), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsFSS <> d.IsFSS or (i.IsFSS is null and d.IsFSS is not null) or (i.IsFSS is not null and d.IsFSS is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsBIG4
	IF update(IsBIG4) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsBIG4', 
				convert(varchar(1000),d.IsBIG4), convert(varchar(1000),i.IsBIG4), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsBIG4 <> d.IsBIG4 or (i.IsBIG4 is null and d.IsBIG4 is not null) or (i.IsBIG4 is not null and d.IsBIG4 is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsVA
	IF update(IsVA) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsVA', 
				convert(varchar(1000),d.IsVA), convert(varchar(1000),i.IsVA), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsVA <> d.IsVA or (i.IsVA is null and d.IsVA is not null) or (i.IsVA is not null and d.IsVA is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End
	
-- IsBOP
	IF update(IsBOP) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsBOP', 
				convert(varchar(1000),d.IsBOP), convert(varchar(1000),i.IsBOP), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsBOP <> d.IsBOP or (i.IsBOP is null and d.IsBOP is not null) or (i.IsBOP is not null and d.IsBOP is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsCMOP
	IF update(IsCMOP) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsCMOP', 
				convert(varchar(1000),d.IsCMOP), convert(varchar(1000),i.IsCMOP), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsCMOP <> d.IsCMOP or (i.IsCMOP is null and d.IsCMOP is not null) or (i.IsCMOP is not null and d.IsCMOP is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsDOD
	IF update(IsDOD) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsDOD', 
				convert(varchar(1000),d.IsDOD), convert(varchar(1000),i.IsDOD), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsDOD <> d.IsDOD or (i.IsDOD is null and d.IsDOD is not null) or (i.IsDOD is not null and d.IsDOD is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsHHS
	IF update(IsHHS) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsHHS', 
				convert(varchar(1000),d.IsHHS), convert(varchar(1000),i.IsHHS), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsHHS <> d.IsHHS or (i.IsHHS is null and d.IsHHS is not null) or (i.IsHHS is not null and d.IsHHS is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsIHS
	IF update(IsIHS) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsIHS', 
				convert(varchar(1000),d.IsIHS), convert(varchar(1000),i.IsIHS), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsIHS <> d.IsIHS or (i.IsIHS is null and d.IsIHS is not null) or (i.IsIHS is not null and d.IsIHS is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsIHS2
	IF update(IsIHS2) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsIHS2', 
				convert(varchar(1000),d.IsIHS2), convert(varchar(1000),i.IsIHS2), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsIHS2 <> d.IsIHS2 or (i.IsIHS2 is null and d.IsIHS2 is not null) or (i.IsIHS2 is not null and d.IsIHS2 is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsDIHS
	IF update(IsDIHS) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsDIHS', 
				convert(varchar(1000),d.IsDIHS), convert(varchar(1000),i.IsDIHS), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsDIHS <> d.IsDIHS or (i.IsDIHS is null and d.IsDIHS is not null) or (i.IsDIHS is not null and d.IsDIHS is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsNIH
	IF update(IsNIH) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsNIH', 
				convert(varchar(1000),d.IsNIH), convert(varchar(1000),i.IsNIH), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsNIH <> d.IsNIH or (i.IsNIH is null and d.IsNIH is not null) or (i.IsNIH is not null and d.IsNIH is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsPHS
	IF update(IsPHS) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsPHS', 
				convert(varchar(1000),d.IsPHS), convert(varchar(1000),i.IsPHS), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsPHS <> d.IsPHS or (i.IsPHS is null and d.IsPHS is not null) or (i.IsPHS is not null and d.IsPHS is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsSVH
	IF update(IsSVH) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsSVH', 
				convert(varchar(1000),d.IsSVH), convert(varchar(1000),i.IsSVH), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsSVH <> d.IsSVH or (i.IsSVH is null and d.IsSVH is not null) or (i.IsSVH is not null and d.IsSVH is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsSVH1
	IF update(IsSVH1) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsSVH1', 
				convert(varchar(1000),d.IsSVH1), convert(varchar(1000),i.IsSVH1), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsSVH1 <> d.IsSVH1 or (i.IsSVH1 is null and d.IsSVH1 is not null) or (i.IsSVH1 is not null and d.IsSVH1 is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsSVH2
	IF update(IsSVH2) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsSVH2', 
				convert(varchar(1000),d.IsSVH2), convert(varchar(1000),i.IsSVH2), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsSVH2 <> d.IsSVH2 or (i.IsSVH2 is null and d.IsSVH2 is not null) or (i.IsSVH2 is not null and d.IsSVH2 is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsTMOP
	IF update(IsTMOP) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'IsTMOP', 
				convert(varchar(1000),d.IsTMOP), convert(varchar(1000),i.IsTMOP), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsTMOP <> d.IsTMOP or (i.IsTMOP is null and d.IsTMOP is not null) or (i.IsTMOP is not null and d.IsTMOP is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsUSCG
	IF update(IsUSCG) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsUSCG', 
				convert(varchar(1000),d.IsUSCG), convert(varchar(1000),i.IsUSCG), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsUSCG <> d.IsUSCG or (i.IsUSCG is null and d.IsUSCG is not null) or (i.IsUSCG is not null and d.IsUSCG is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- IsFHCC
	IF update(IsFHCC) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'IsFHCC', 
				convert(varchar(1000),d.IsFHCC), convert(varchar(1000),i.IsFHCC), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.IsFHCC <> d.IsFHCC or (i.IsFHCC is null and d.IsFHCC is not null) or (i.IsFHCC is not null and d.IsFHCC is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End		

-- AwardedFSSTrackingCustomerRatio
	IF update(AwardedFSSTrackingCustomerRatio) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'AwardedFSSTrackingCustomerRatio', 
				convert(varchar(1000),d.AwardedFSSTrackingCustomerRatio), convert(varchar(1000),i.AwardedFSSTrackingCustomerRatio), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.AwardedFSSTrackingCustomerRatio <> d.AwardedFSSTrackingCustomerRatio or (i.AwardedFSSTrackingCustomerRatio is null and d.AwardedFSSTrackingCustomerRatio is not null) or (i.AwardedFSSTrackingCustomerRatio is not null and d.AwardedFSSTrackingCustomerRatio is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End
	
-- TrackingCustomerName
	IF update(TrackingCustomerName) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'TrackingCustomerName', 
				convert(varchar(1000),d.TrackingCustomerName), convert(varchar(1000),i.TrackingCustomerName), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.TrackingCustomerName <> d.TrackingCustomerName or (i.TrackingCustomerName is null and d.TrackingCustomerName is not null) or (i.TrackingCustomerName is not null and d.TrackingCustomerName is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- CurrentTrackingCustomerPrice
	IF update(CurrentTrackingCustomerPrice) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)),coalesce(d.DrugItemID,i.DrugItemID), 'CurrentTrackingCustomerPrice', 
				convert(varchar(1000),d.CurrentTrackingCustomerPrice), convert(varchar(1000),i.CurrentTrackingCustomerPrice), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.CurrentTrackingCustomerPrice <> d.CurrentTrackingCustomerPrice or (i.CurrentTrackingCustomerPrice is null and d.CurrentTrackingCustomerPrice is not null) or (i.CurrentTrackingCustomerPrice is not null and d.CurrentTrackingCustomerPrice is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- ExcludeFromExport
	IF update(ExcludeFromExport) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'ExcludeFromExport', 
				convert(varchar(1000),d.ExcludeFromExport), convert(varchar(1000),i.ExcludeFromExport), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.ExcludeFromExport <> d.ExcludeFromExport or (i.ExcludeFromExport is null and d.ExcludeFromExport is not null) or (i.ExcludeFromExport is not null and d.ExcludeFromExport is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- LastModificationType
	IF update(LastModificationType) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'LastModificationType', 
				convert(varchar(1000),d.LastModificationType), convert(varchar(1000),i.LastModificationType), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.LastModificationType <> d.LastModificationType or (i.LastModificationType is null and d.LastModificationType is not null) or (i.LastModificationType is not null and d.LastModificationType is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

-- ModificationStatusId
	IF update(ModificationStatusId) AND @type <> 'D'
	Begin
		Select @AuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		INSERT Audit_DI_DrugItemPrice_Changes 
		([Type],DrugItemPriceID,drugitemid,FieldName,OldValue,NewValue,LastModificationdate,LastModifiedBy)
		SELECT 	@type, convert(varchar(20),coalesce(d.DrugItemPriceID,i.DrugItemPriceID)), coalesce(d.DrugItemID,i.DrugItemID),'ModificationStatusId', 
				convert(varchar(1000),d.ModificationStatusId), convert(varchar(1000),i.ModificationStatusId), 
				getdate(), @LastModifiedBy
		FROM	inserted i 
		FULL outer join deleted d ON i.DrugitemPriceID = d.DrugItemPriceID
		WHERE (i.ModificationStatusId <> d.ModificationStatusId or (i.ModificationStatusId is null and d.ModificationStatusId is not null) or (i.ModificationStatusId is not null and d.ModificationStatusId is null))
		
		Select @NewAuditId = max(AuditId)
		From Audit_DI_DrugItemPrice_Changes
		
		If @NewAuditId <> @AuditId or @AuditId is null
		Begin
			Select @ListOfAuditIds = isnull(@ListOfAuditIds,'') + Cast(@NewAuditId as varchar) + ','
		End					
	End

		

	If @ListOfAuditIds is not null or len(@ListOfAuditIds) > 0
	Begin
		Insert into dbo.Audit_DI_DrugItemPriceHistory
		(ListOfAuditId,DrugItemPriceId,DrugItemId,DrugItemSubItemId,HistoricalNValue,PriceId,
		 PriceStartDate,PriceStopDate,Price,IsTemporary,IsFSS,IsBIG4,IsVA,IsBOP,IsCMOP,IsDOD,
		 IsHHS,IsIHS,IsIHS2,IsDIHS,IsNIH,IsPHS,IsSVH,IsSVH1,IsSVH2,IsTMOP,IsUSCG,IsFHCC,
		 AwardedFSSTrackingCustomerRatio,TrackingCustomerName,CurrentTrackingCustomerPrice,
		 ExcludeFromExport,LastModificationType,ModificationStatusId,CreatedBy,CreationDate,
		 LastModifiedBy,LastModificationDate,AuditLastModifiedBy,AuditLastModificationDate
		)
		Select 
		@ListOfAuditIds,DrugItemPriceId,DrugItemId,DrugItemSubItemId,HistoricalNValue,PriceId,
		 PriceStartDate,PriceStopDate,Price,IsTemporary,IsFSS,IsBIG4,IsVA,IsBOP,IsCMOP,IsDOD,
		 IsHHS,IsIHS,IsIHS2,IsDIHS,IsNIH,IsPHS,IsSVH,IsSVH1,IsSVH2,IsTMOP,IsUSCG,IsFHCC,
		 AwardedFSSTrackingCustomerRatio,TrackingCustomerName,CurrentTrackingCustomerPrice,
		 ExcludeFromExport,LastModificationType,ModificationStatusId,CreatedBy,CreationDate,
		 LastModifiedBy,LastModificationDate,@LastModifiedBy,getdate()
	  from deleted
	END
	Else If @ListOfAuditIds is null And @type = 'D'
	Begin
		Insert into dbo.Audit_DI_DrugItemPriceHistory
		(ListOfAuditId,DrugItemPriceId,DrugItemId,DrugItemSubItemId,HistoricalNValue,PriceId,
		 PriceStartDate,PriceStopDate,Price,IsTemporary,IsFSS,IsBIG4,IsVA,IsBOP,IsCMOP,IsDOD,
		 IsHHS,IsIHS,IsIHS2,IsDIHS,IsNIH,IsPHS,IsSVH,IsSVH1,IsSVH2,IsTMOP,IsUSCG,IsFHCC,
		 AwardedFSSTrackingCustomerRatio,TrackingCustomerName,CurrentTrackingCustomerPrice,
		 ExcludeFromExport,LastModificationType,ModificationStatusId,CreatedBy,CreationDate,
		 LastModifiedBy,LastModificationDate,AuditLastModifiedBy,AuditLastModificationDate
		)
		Select 
		'Delete',DrugItemPriceId,DrugItemId,DrugItemSubItemId,HistoricalNValue,PriceId,
		 PriceStartDate,PriceStopDate,Price,IsTemporary,IsFSS,IsBIG4,IsVA,IsBOP,IsCMOP,IsDOD,
		 IsHHS,IsIHS,IsIHS2,IsDIHS,IsNIH,IsPHS,IsSVH,IsSVH1,IsSVH2,IsTMOP,IsUSCG,IsFHCC,
		 AwardedFSSTrackingCustomerRatio,TrackingCustomerName,CurrentTrackingCustomerPrice,
		 ExcludeFromExport,LastModificationType,ModificationStatusId,CreatedBy,CreationDate,
		 LastModifiedBy,LastModificationDate,@LastModifiedBy,getdate()
	  from deleted	
	End
	


             
       


