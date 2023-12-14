SELECT 
  week_number,
  day_of_week,
  sales_amount,
  SUM(sales_amount) OVER (PARTITION BY week_number ORDER BY day_of_week) AS CUM_SUM,
  CASE 
    WHEN day_of_week = 'Monday' THEN
      AVG(sales_amount) OVER (PARTITION BY week_number ORDER BY day_of_week ROWS BETWEEN 2 PRECEDING AND 1 FOLLOWING)
    WHEN day_of_week = 'Friday' THEN
      AVG(sales_amount) OVER (PARTITION BY week_number ORDER BY day_of_week ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING)
    ELSE
      AVG(sales_amount) OVER (PARTITION BY week_number ORDER BY day_of_week ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
  END AS CENTERED_3_DAY_AVG
FROM 
  sales
WHERE 
  -- Include specific days for accurate calculation at the beginning of week 49
  (week_number = 49 AND day_of_week IN ('Monday', 'Tuesday', 'Saturday', 'Sunday'))
  OR
  -- Include the entire week 50
  (week_number = 50)
  OR
  -- Include specific days for accurate calculation at the end of week 51
  (week_number = 51 AND day_of_week IN ('Thursday', 'Friday', 'Sunday'))
ORDER BY 
  week_number, 
  CASE 
    WHEN day_of_week = 'Monday' THEN 1
    WHEN day_of_week = 'Tuesday' THEN 2
    WHEN day_of_week = 'Wednesday' THEN 3
    WHEN day_of_week = 'Thursday' THEN 4
    WHEN day_of_week = 'Friday' THEN 5
    WHEN day_of_week = 'Saturday' THEN 6
    WHEN day_of_week = 'Sunday' THEN 7
  END;