create database retail_store;
use retail_store;
create table state (state_id int, state varchar(64), primary key(state_id));
create table city (city_id int, city varchar(64), primary key(city_id));
create table zip_city (zipcode varchar(10) , city_id int, primary key(zipcode), constraint FK_city_id foreign key(city_id) references city(city_id));
create table zip_state (zipcode varchar(10), state_id int, primary key(zipcode), constraint FK_state_id foreign key(state_id) references state(state_id));
create table region (region_id int, region_description varchar(128), primary key(region_id));
create table sales_representatives (sales_rep_id int, last_name varchar(64), first_name varchar(64), street_address varchar(128), zipcode varchar(10), region_id int, total_commission float, commission_rate float, primary key(sales_rep_id),constraint FK_zip_city foreign key(zipcode) references zip_city(zipcode),constraint FK_zip_state foreign key(zipcode) references zip_state(zipcode) ,constraint FK_region foreign key(region_id) references region(region_id));
create table customer (customer_id int, last_name varchar(64), first_name varchar(64), street_address varchar(128), zipcode varchar(10), current_balance float, sales_rep_id int, primary key(customer_id), constraint FK_customer_zip_city foreign key(zipcode) references zip_city(zipcode) , constraint FK_customer_zip_state foreign key(zipcode) references zip_state(zipcode), constraint FK_sales_rep_id foreign key(sales_rep_id) references sales_representatives(sales_rep_id));
create table orders (order_id int, order_date date, customer_id int, shipping_date date, primary key(order_id),constraint FK_order_cust_id foreign key(customer_id) references customer(customer_id));
create table parts (part_id varchar(8), part_description varchar(32), units_on_hand int, class varchar(8), warehouse_number int, unit_price float, primary key(part_id));
create table order_lines (order_id int, part_id varchar(8), number_ordered int, quoted_price float, primary key(order_id, part_id),constraint FK_order_id foreign key(order_id) references orders(order_id),constraint FK_part_id foreign key(part_id) references  parts(part_id));