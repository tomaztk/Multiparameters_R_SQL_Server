/*

** Author: Tomaz Kastrun
** Created: 01.08.2016; Ljubljana
** Testing @param parameter for sp_execute_external_script 
** R and T-SQL

*/


USE WideWorldImporters;
Go


-- TEST Query
-- select CustomerID, count(*) as Nof_Orders from [Sales].[Orders] GROUP BY CustomerID



-- 1. Original Query
EXECUTE sys.sp_execute_external_script
		  @language = N'R'
		 ,@script = N'mytable <- table(WWI_OrdersPerCustomer$CustomerID, WWI_OrdersPerCustomer$Nof_Orders) 
					 OutputDataSet<-data.frame(margin.table(mytable, 2))'
		 ,@input_data_1 = N'select CustomerID, count(*) as Nof_Orders from [Sales].[Orders] GROUP BY CustomerID'
		 ,@input_data_1_name = N'WWI_OrdersPerCustomer'
		 ,@parallel = 0
 WITH RESULT SETS(
				  (Cust_data INT
				  ,Freq INT)




-- 2. Adding Parameters as an output
DECLARE @F_Value VARCHAR(1000)
DECLARE @Signif VARCHAR(1000)


  EXECUTE sys.sp_execute_external_script
		  @language = N'R'
		 ,@script = N'mytable <- table(WWI_OrdersPerCustomer$CustomerID, WWI_OrdersPerCustomer$Nof_Orders) 
					 data.frame(margin.table(mytable, 2))
					 Ch <- unlist(chisq.test(mytable))
					 F_Val <- as.character(Ch[1])
					 Sig <- as.character(Ch[3])'
		 ,@input_data_1 = N'select TOP 10 CustomerID, count(*) as Nof_Orders from [Sales].[Orders] GROUP BY CustomerID'
		 ,@input_data_1_name = N'WWI_OrdersPerCustomer'
		 ,@params = N' @F_Val VARCHAR(1000) OUTPUT, @Sig VARCHAR(1000) OUTPUT'
		 ,@F_Val = @F_Value OUTPUT 
		 ,@Sig = @Signif OUTPUT


SELECT @F_Value AS CHI_Value
	,@Signif AS CHI_Square_SIGNIFICANCE        





-- 3. Adding Parameters as an output
--  and output data set through results set
DECLARE @F_Value VARCHAR(1000)
DECLARE @Signif VARCHAR(1000)


  EXECUTE sys.sp_execute_external_script
		  @language = N'R'
		 ,@script = N'mytable <- table(WWI_OrdersPerCustomer$CustomerID, WWI_OrdersPerCustomer$Nof_Orders) 
					 data.frame(margin.table(mytable, 2))
					 Ch <- unlist(chisq.test(mytable))
					 F_Val <- as.character(Ch[1])
					 Sig <- as.character(Ch[3])
					 OutputDataSet<-data.frame(margin.table(mytable, 2))'
		 ,@input_data_1 = N'select TOP 10 CustomerID, count(*) as Nof_Orders from [Sales].[Orders] GROUP BY CustomerID'
		 ,@input_data_1_name = N'WWI_OrdersPerCustomer'
		 ,@params = N' @F_Val VARCHAR(1000) OUTPUT, @Sig VARCHAR(1000) OUTPUT'
		 ,@F_Val = @F_Value OUTPUT 
		 ,@Sig = @Signif OUTPUT
 WITH RESULT SETS(
				  (Cust_data INT
				  ,Freq INT)
				  )

SELECT @F_Value AS CHI_Value
	,@Signif AS CHI_Square_SIGNIFICANCE        