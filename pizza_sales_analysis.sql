-- Retrieve the total number of orders placed.


SELECT 
    COUNT(order_id) AS total_num_of_orders_placed
FROM
    orders;
    
    
    
    -- Calculate the total revenue generated from pizza sales


SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            3) AS tot_rev_generated
FROM
    pizzashop.order_details
        JOIN
    pizzashop.pizzas ON order_details.pizza_id = pizzas.pizza_id;
  
  
  
  
  
  
  -- Identify the highest-priced pizza.  



SELECT 
    pizza_types.name, pizzas.price as highest_price_pizza
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;








-- Identify the most common pizza size ordered




SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS most_ordered_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY most_ordered_count DESC;








-- List the top 5 most ordered pizza types along with their quantities.


SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS tot_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY name
ORDER BY tot_quantity DESC
LIMIT 5;








-- Join the necessary tables to find the total quantity of  each pizza category ordered.*/

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC; 









#Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);









#Join relevant tables to find the category-wise distribution of pizzas.

select category,count(name ) from pizza_types
 group by category;  
 
 
 
 
 
 
 
 
 
 -- Group the orders by date and calculate the average number of pizzas ordered per day.
 
 SELECT 
    ROUND(AVG(quantity), 2) as Avg_pizza_orders_perday
FROM
    (SELECT 
        orders.order_date AS Date,
            SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY Date) AS order_quantity;
    
    
    
    
    
    
    
    
    
    
   -- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;




-- Calculate the percentage contribution of each pizza type to total revenue.




SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;  







-- Analyze the cumulative revenue generated over time.


select order_date , sum(revenue) over(order by order_date) as cum_revenue
from 
(select  orders.order_date,sum(order_details.quantity *pizzas.price ) as revenue 
from order_details join pizzas  on order_details.pizza_id = pizzas.pizza_id
join orders on  orders.order_id = order_details.order_id
group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


select name, revenue from 
(select category,name,revenue,rank() over(partition by category order by revenue desc) as revenues
from
(select pizza_types.category ,pizza_types.name, sum(pizzas.price * (order_details.quantity)) as revenue 
from pizzas join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id 
join order_details on pizzas.pizza_id = order_details.pizza_id  
group by pizza_types.category ,pizza_types.name ) as first ) as second
where revenues <= 3 ;















  
    
    
    