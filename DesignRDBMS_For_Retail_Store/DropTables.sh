mysql -h localhost -uroot -psmarthome retail_store -e "drop table customer;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table sales_representatives;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table zip_city;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table zip_state;" 
mysql -h localhost -uroot -psmarthome retail_store -e "drop table state;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table city;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table region;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table order_lines;" 
mysql -h localhost -uroot -psmarthome retail_store -e "drop table orders;"
mysql -h localhost -uroot -psmarthome retail_store -e "drop table parts;"
mysql -h localhost -uroot -psmarthome -e "drop database retail_store;"