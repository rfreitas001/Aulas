USE [bd_site]
GO


-- ====== Verificando existências de tabelas ======================================================================================================

IF OBJECT_ID('dbo.products', 'u') IS NOT NULL 
  DROP TABLE dbo.products;
GO
IF OBJECT_ID('dbo.subcategory', 'u') IS NOT NULL 
  DROP TABLE dbo.subcategory;
GO
IF OBJECT_ID('dbo.typecategory', 'u') IS NOT NULL 
  DROP TABLE dbo.typecategory;
GO
IF OBJECT_ID('dbo.category', 'u') IS NOT NULL 
  DROP TABLE dbo.category;
GO

IF OBJECT_ID('dbo.access_group', 'u') IS NOT NULL 
  DROP TABLE dbo.access_group;
GO

IF OBJECT_ID('dbo.permission', 'u') IS NOT NULL 
  DROP TABLE dbo.permission;
GO

IF OBJECT_ID('dbo.access_control', 'u') IS NOT NULL 
  DROP TABLE dbo.access_control;
GO

IF OBJECT_ID('dbo.access_user', 'u') IS NOT NULL 
  DROP TABLE dbo.access_user;
GO

-- ====== Criando Estruturas de tabelas ===========================================================================================================

CREATE TABLE [dbo].[category] (
	  [categoryID]			INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [description]			VARCHAR (500) NOT NULL,	  
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_category_date_registration] DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED ([categoryID] ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[typecategory] (
	  [typecategoryID]		INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [description]			VARCHAR (500) NOT NULL,	 
	  [id_category]			INT								CONSTRAINT [FK_typecategory_category]  REFERENCES category(categoryID),
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_typecategory_date_registration] DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_typecategory] PRIMARY KEY CLUSTERED ([typecategoryID] ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[subcategory] (
	  [subcategoryID]		INT IDENTITY (1, 1)	NOT NULL,
	  [nome]				VARCHAR (100) NOT NULL,
	  [description]			VARCHAR (500) NOT NULL,	 
	  [id_category]			INT								CONSTRAINT [FK_subcategory_category]		REFERENCES category(categoryID),
	  [id_typecategory]		INT								CONSTRAINT [FK_subcategory_typecategory]  REFERENCES typecategory(typecategoryID),
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_subcategory_date_registration] DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_subcategory] PRIMARY KEY CLUSTERED ([subcategoryID] ASC),
	  CONSTRAINT [UQ_subcategory] UNIQUE NONCLUSTERED (
				subcategoryID, id_category, id_typecategory ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
GO 

CREATE TABLE [dbo].[products] (
	  [productsID]			INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [description]			VARCHAR (500) NOT NULL,
	  [id_category]			INT NOT NULL					CONSTRAINT [FK_products_category]		REFERENCES category(categoryID),
	  [id_typecategory]		INT NOT NULL					CONSTRAINT [FK_products_typecategory]	REFERENCES typecategory(typecategoryID),
	  [id_subcategory]		INT NOT NULL					CONSTRAINT [FK_products_subcategory]	REFERENCES subcategory(subcategoryID),	  
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_products_date_registration] DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_products] PRIMARY KEY CLUSTERED ([productsID] ASC),
	  CONSTRAINT [UQ_products] UNIQUE NONCLUSTERED (
				productsID, id_category, id_typecategory, id_subcategory ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[access_group] (
	  [access_groupID]		INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [description]			VARCHAR (500) NOT NULL,
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_access_group_date_registration]	DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_access_group] PRIMARY KEY CLUSTERED ([access_groupID] ASC)
	  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[permission] (
	  [permissionID]		INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [grant]				BIT NOT NULL,
	  [refuse]				BIT NOT NULL,
	  [id_access_group]		INT NOT NULL					CONSTRAINT [FK_permission_access_group]			REFERENCES access_group(access_groupID),  
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_permission_date_registration]	DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_permission] PRIMARY KEY CLUSTERED ([permissionID] ASC),
	  CONSTRAINT [UQ_permission] UNIQUE NONCLUSTERED (
				permissionID, id_access_group ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[access_control] (
	  [access_controlID]	INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (100) NOT NULL,
	  [id_access_group]		INT NOT NULL					CONSTRAINT [FK_access_control_access_group]			REFERENCES access_group(access_groupID),
	  [id_permission]		INT NOT NULL					CONSTRAINT [FK_access_control_permission]			REFERENCES permission(permissionID),  
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_access_control_date_registration]	DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_access_control] PRIMARY KEY CLUSTERED ([access_controlID] ASC),
	  CONSTRAINT [UQ_access_control] UNIQUE NONCLUSTERED (
				access_controlID, id_permission, id_access_group ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[contact_user] (
	  [contact_userID]		INT IDENTITY (1, 1)	NOT NULL,
	  [address_1]			VARCHAR (100) NOT NULL,
	  [address_2]			VARCHAR (100) NOT NULL,
	  [city]				VARCHAR (50) NOT NULL,
	  [state]				VARCHAR (50) NOT NULL,
	  [ZIP_Code]			VARCHAR (10) NOT NULL,
	  [region_number]		CHAR(3) NOT NULL,
	  [phone_number]		CHAR(9) NOT NULL,
	  [Email_Address]		VARCHAR (100) NOT NULL,
	  [date_registration]	DATETIME						CONSTRAINT [DF_contact_user_date_registration]	DEFAULT (GETDATE()) NOT NULL,
	  [modified_date]		DATETIME						CONSTRAINT [DF_contactuser_modified_date]		DEFAULT GETDATE() NOT NULL

	  CONSTRAINT [PK_contact_user] PRIMARY KEY CLUSTERED ([contact_userID] ASC),
	  CONSTRAINT [UQ_contact_user] UNIQUE NONCLUSTERED (
				contact_userID ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[agent] (
	  [agentID]			INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (40) NOT NULL,
	  [surname]				VARCHAR (100) NOT NULL,
	  [user_name]			VARCHAR (20) NULL,
	  [password]			VARCHAR (100) NOT NULL,
	  [birthdate]			DATE NOT NULL,
	  [CPF]					VARCHAR (100) NOT NULL,
	  [id_access_control]	INT NOT NULL					CONSTRAINT [FK_agent_control_access]		REFERENCES access_control(access_controlID), 
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_agent_date_registration]		DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_agent] PRIMARY KEY CLUSTERED ([agentID] ASC),
	  CONSTRAINT [UQ_agent] UNIQUE NONCLUSTERED (
				agentID, user_name, id_access_control ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[access_user] (
	  [access_userID]		INT IDENTITY (1, 1)	NOT NULL,
	  [name]				VARCHAR (40) NOT NULL,
	  [surname]				VARCHAR (100) NOT NULL,
	  [password]			VARCHAR (100) NOT NULL,
	  [birthdate]			DATE NOT NULL,
	  [CPF]					VARCHAR (100) NOT NULL,
	  [id_contact_user]		INT NOT NULL					CONSTRAINT [FK_access_user_contact_user]		REFERENCES contact_user (contact_userID),
	  [id_access_control]	INT NOT NULL					CONSTRAINT [FK_access_user_control_access]		REFERENCES access_control(access_controlID), 
	  [id_agent]			INT NOT NULL					CONSTRAINT [FK_access_user_agent]				REFERENCES agent(agentID), 
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_access_user_date_registration]	DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_access_user] PRIMARY KEY CLUSTERED ([access_userID] ASC),
	  CONSTRAINT [UQ_access_user] UNIQUE NONCLUSTERED (
				access_userID, id_contact_user, id_access_control, id_agent ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[contact_store] (
	  [contact_storeID]		INT IDENTITY (1, 1)	NOT NULL,
	  [address_1]			VARCHAR (100) NOT NULL,
	  [address_2]			VARCHAR (100) NOT NULL,
	  [city]				VARCHAR (50) NOT NULL,
	  [state]				VARCHAR (50) NOT NULL,
	  [ZIP_Code]			VARCHAR (10) NOT NULL,
	  [region_number]		CHAR(3) NOT NULL,
	  [phone_number]		CHAR(9) NOT NULL,
	  [Email_Address]		VARCHAR (100) NOT NULL,
	  [date_registration]	DATETIME						CONSTRAINT [DF_contact_store_date_registration]	DEFAULT (GETDATE()) NOT NULL,
	  [modified_date]		DATETIME						CONSTRAINT [DF_contact_store_modified_date]	DEFAULT GETDATE() NOT NULL

	  CONSTRAINT [PK_contact_store] PRIMARY KEY CLUSTERED ([contact_storeID] ASC),
	  CONSTRAINT [UQ_contact_store] UNIQUE NONCLUSTERED (
				contact_storeID ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO

CREATE TABLE [dbo].[store] (
	  [storeID]				INT IDENTITY (1, 1)	NOT NULL,
	  [fantasy_name]		VARCHAR (150) NOT NULL,
	  [company_name]		VARCHAR (100) NOT NULL,
	  [Employer_Number]		NUMERIC NOT NULL,
	  [id_contact_store]	INT NOT NULL					CONSTRAINT [FK_store_contact_store]		REFERENCES contact_store(contact_storeID),
	  [id_agent]			INT NOT NULL					CONSTRAINT [FK_store_agent]				REFERENCES agent(agentID), 
	  [active]				BIT NOT NULL,	  
	  [date_registration]	DATETIME						CONSTRAINT [DF_store_date_registration]	DEFAULT (GETDATE()) NOT NULL,

	  CONSTRAINT [PK_store] PRIMARY KEY CLUSTERED ([storeID] ASC),
	  CONSTRAINT [UQ_store] UNIQUE NONCLUSTERED (
				storeID, id_contact_store, id_agent ASC
	  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


