-- Expense Upload
copy into expenses(year_month_day, month, amount, pay_partner, title, type, description, department, department_id, quarter, year, label, filename, viewership_type)
from (select t.$1, t.$2, to_number(REPLACE(REPLACE(t.$3, '$', ''), ','), 12, 2), t.$4, t.$5, t.$6, t.$7, t.$8, t.$9, t.$10, t.$11, t.$12, 'expenses_q4_2022.csv', 'VOD'
from @oo_expenses t) pattern='.*expenses_q4_2022.*' file_format = nosey_viewership 
ON_ERROR=SKIP_FILE FORCE=TRUE; 
