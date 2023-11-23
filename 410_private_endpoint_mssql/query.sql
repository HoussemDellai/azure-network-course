-- Create a new table called '[Products]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Products]', 'U') IS NOT NULL
DROP TABLE [dbo].[Products]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Products]
(
    [Id] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [Name] NVARCHAR(50) NOT NULL,
    [Cost] NVARCHAR(50) NOT NULL
    -- Specify more columns here
);
GO


-- Insert rows into table 'Products' in schema '[dbo]'
INSERT INTO [dbo].[Products]
( -- Columns to insert data into
 [Id], [Name], [Cost]
)
VALUES
( -- First row: values for the columns in the list above
 1, 'Phone', 500
)
-- Add more rows here
GO


-- Select rows from a Table or View '[Products]' in schema '[dbo]'
SELECT * FROM [dbo].[Products]
-- WHERE /* add search conditions here */
GO