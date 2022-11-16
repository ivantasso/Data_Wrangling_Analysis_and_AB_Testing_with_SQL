--+------------------------------------------------------------------------------------------+
--                                        QUESTION 01                                        |
--+------------------------------------------------------------------------------------------+
--We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?

SELECT * FROM  dsv1069.final_assignments_qa
--+-------------------------------------------------+
--ANSWER : No, the record creation date is required.|
--+-------------------------------------------------+

--+------------------------------------------------------------------------------------------+
--                                        QUESTION 02                                        |
--+------------------------------------------------------------------------------------------+
--Reformat the final_assignments_qa to look like the final_assignments table, filling in any missing values with a placeholder of the appropriate data type.
SELECT item_id,
       test_a AS test_assignment,
       'test_a' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_b AS test_assignment,
       'test_b' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_c AS test_assignment,
       'test_c' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_d AS test_assignment,
       'test_d' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_e AS test_assignment,
       'test_e' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_f AS test_assignment,
       'test_f' AS test_number,
       CAST('2022-11-15 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa;

--+------------------------------------------------------------------------------------------+
--                                        QUESTION 03                                        |
--+------------------------------------------------------------------------------------------+
-- Use this table to 
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2
 SELECT order_binary.test_assignment,
        COUNT(DISTINCT order_binary.item_id) AS num_orders,
        SUM(order_binary.ob30d) AS sum_orders_bin_30d
FROM
  (
  SELECT assignments.item_id,
          assignments.test_assignment,
          MAX(CASE
                  WHEN (DATE(orders.created_at)-DATE(assignments.test_start_date)) BETWEEN 1 AND 30 THEN 1
                  ELSE 0
              END) AS ob30d
   FROM dsv1069.final_assignments AS assignments
   LEFT JOIN dsv1069.orders AS orders
     ON assignments.item_id=orders.item_id
   WHERE assignments.test_number='item_test_2'
   GROUP BY assignments.item_id,
            assignments.test_assignment) AS order_binary
GROUP BY order_binary.test_assignment

--+------------------------------------------------------------------------------------------+
--                                        QUESTION 04                                        |
--+------------------------------------------------------------------------------------------+
-- Use this table to 
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2
SELECT view_binary.test_assignment,
       COUNT(DISTINCT view_binary.item_id) AS num_views,
       SUM(view_binary.view_bin_30d) AS sum_view_bin_30d,
       AVG(view_binary.view_bin_30d) AS avg_view_bin_30d
FROM
  (SELECT assignments.item_id,
          assignments.test_assignment,
          MAX(CASE
                  WHEN (DATE(views.event_time)-DATE(assignments.test_start_date)) BETWEEN 1 AND 30 THEN 1
                  ELSE 0
              END) AS view_bin_30d
   FROM dsv1069.final_assignments AS assignments
   LEFT JOIN dsv1069.view_item_events AS views
     ON assignments.item_id=views.item_id
   WHERE assignments.test_number='item_test_2'
   GROUP BY assignments.item_id,
            assignments.test_assignment
   ORDER BY item_id) AS view_binary
GROUP BY view_binary.test_assignment

--+------------------------------------------------------------------------------------------+
--                                        QUESTION 05                                        |
--+------------------------------------------------------------------------------------------+
