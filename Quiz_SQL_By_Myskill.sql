use my_db;
#Quiz Modul 2
#1.tampilkan 50 Baris pertama tabel olist_orders
SELECT *
FROM olist_orders
LIMIT 50;
#2.Tampilkan kolom order_id, customer_id, order_purchase_timestamp pada tabel olist_orders batasi 50 baris
SELECT
	order_id,
    customer_id,
    order_purchase_timestamp
FROM
	olist_orders
LIMIT 50;
#3. Dari tabel olist_order_items, tampilkan kolom (1)Price, (2)Price ditambah 100, (3) price ditambah dengan freight_value.
#Berikan alias pada kolom kedua dan ketiga dengan nama bebas.Batasi 50 Baris Pertama

SELECT
	price,
	price + 100 as Pricetax,
    price + freight_value as price_freight
FROM
	olist_order_items
LIMIT 50;

#4.Tampilkan secara unik semua customer_state dari tabel olist_customers
SELECT distinct
	*
FROM olist_customers;

#5.Urutkan Tabel olist_orders berdasarkan order_purchase_timestamp terlama sampai terbaru
SELECT
	*
FROM olist_orders
ORDER BY
	order_purchase_timestamp DESC
LIMIT 3;

#Quiz Modul 3: Conditional
#1. Tampilkan 50 baris dari tabel olist_customer dengan cutomer_state ='RJ'
SELECT
	*
FROM
	olist_customers
WHERE
	customer_state='RJ'
LIMIT 50;
    
#2. Tampilkan 50 baris dari tabel olist_sellers dengan seller_city Urutkan berdasarkan Alfabet

SELECT
	*
FROM
	olist_sellers
ORDER BY
	seller_city
LIMIT 50;

#3. Tampilkan product_id dari tabel olist_products dengan product_weight_g tidak lebih dari 1000
# atau product_length_cm tidak kurang dari 40

SELECT
	product_id,
    product_weight_g,
    product_length_cm
FROM
	olist_products
WHERE
	product_weight_g < 1000 
    OR
    product_length_cm < 40
LIMIT 10;

#4. Tampilkan Secara unik order_status dari tabel olist_orders dengan order_approved_at berapa null
SELECT
	order_status,
	order_approved_at
FROM
	olist_orders
WHERE
	order_approved_at = null
LIMIT 50;

# 5.
SELECT
	payment_value,
    case when payment_value between 100 and 200 then 'Qualyfied' end
FROM olist_order_payments;

#6 Tampilkan Review_id dan review_comment_message dari tabel olist_order_reviews dengan
#review_comment_message diawali kata super

SELECT
	review_id,
	review_comment_message
FROM
	olist_order_reviews
WHERE 
	review_comment_message like'super%';

-- Quiz Modul 4 : Aggregation
-- 1.Hitung banyaknya baris pada tabel olist_sellers
SELECT
	count(seller_id)
FROM olist_sellers;
-- 2.Berdasarakan tabel olist_customers, hitung banyaknya kota di masing masing state.
-- Urutkan state secara alfabetis.
SELECT 
	customer_state,
	count(distinct customer_city),
    count(customer_city)
FROM olist_customers
where customer_state is not null
GROUP BY customer_state;
-- 3.Hitung jumlah payment_value dari tabel olist_order_payments yang menggunakan 
-- credit_card serta payment_installments dari yang terkecil sampai terbesar
SELECT
	sum(payment_value) as total_payment,
	payment_type,
    payment_installments
FROM olist_order_payments
where 
	payment_type = 'credit_card'
	and payment_installments > 1
group by payment_installments
order by total_payment asc;
-- 4.Berdasarkan tabel olist_products, berapa rata-rata berat(product_weight_g) dari product
-- yang memiliki panjang antara 40cm sampai 80cm (product_length_cm)
select
	avg(product_weight_g)
from olist_products 
where product_length_cm between 40 and 80;
-- 5.Pada tabel olist_order_items, tampilkan seller_id dan jumlah price masing-masing apabila
-- jumlah price si penjual tersebut lebih besar dari 2000. urutkan berdasarakan jumlah price
-- terbesar ke terkecil
select
	seller_id,
    sum(price) as total_price
from olist_order_items
group by seller_id
having total_price > 2000
order by total_price desc;

-- Quiz 5 JOin
-- 1. Tampilkan kolom order_id, customer_unique_id,order_status, dan order_purchase_timestamp dari tabel
-- olist_orders digabung dengan tabel olist_customer dengan key customer_id pada kedua tabel ? 
select
	order_id,
    customer_unique_id, 
    order_status,
    order_purchase_timestamp
from 
	olist_orders as t1
	inner join
    olist_customers as t2
    on
    t1.customer_id = t2.customer_id;
-- 2.Tampilkan product_category_name dan price dari tabel olist_products dan olist_order_items dengan key
-- product_id.Tampilkan hanya product_category_name yang memiliki harga saja.

select
	product_category_name,
    price
from
	olist_products as t1
    inner join
    olist_order_items as t2
    on t1.product_id = t2.product_id
where price is not null;
	
--  Konteks :  Customer_unique_id adalah d yang diberikan kepada seorang customer secara unik, sementara
--  customer_id adalah yang berasosiasi dengan pesanan dan berbeda beda setiap waktu. Seorang
--  customer(satu customer_unique_id) bisa memiliki lebih dari 1 customer_id
--  
--  Jika customer tersebut membuat 4 pesanan, maka customer_unique_id miliknya akan berasosiasi dengan 
--  4 customer_id yang berbeda 
-- 3. hitung banyaknya customer yang tercatat dalam olist_customer yang tidak memesan apa pun sepanjang
-- tahun 2017
Select
	count(distinct customer_unique_id) as customer
From
	(
		select
			*
		from
			(select customer_id, customer_unique_id from olist_customers) as t1
			left join
			(select customer_id as customer_id_2 from olist_orders where order_purchase_timestamp like "2017%") as t2
			on t1.customer_id = t2.customer_id_2 ) as t
where customer_id_2 is null;
-- 4.Berdasarkan review yang diberikan pada tahun 2018 (review_creation_date), kelompokkan dan hitung dan
-- banyaknya review_score yang diterima setiap seller_id. Siapa seller yang menerimapaling banyak review
-- bintang 5 pada tahun ini
select
	seller_id,
    count(order_id) as count_order
from
	( select
		*
		from 
        (select
			order_id,
			seller_id
		from olist_order_items) as t1
		inner join
		(select order_id as order_id_2, review_score, review_creation_date from olist_order_reviews 
        where review_creation_date like "2018%" and review_score = 5) as t2
		on t1.order_id = t2.order_id_2) as t
group by seller_id
order by count_order desc;


-- Quiz 6 Numeric Operator dan Function 
-- 1. Tampilkan order_id dari tabel olist_order_payments yang memiliki payment_value
-- dibagi payment_installments lebih besar atau sama 30 serta dibayar menggunakan kartu Kredit.
select
	order_id,
    payment,
    payment_type
from
    (
	select
		order_id,
		payment_value/payment_installments as payment,
		payment_type
	from 
		olist_order_payments
	having
		payment >= 30 and payment_type = "credit_card"
	) as t;
		
-- 2.Tampilkan payment_value serta pembulatan keatas kelipatan 100 darinya dari tabel olist_order_payments
select
	payment_value,
    100*ceil(payment_value/100) as payment
from olist_order_payments;
-- 3.Setiap product didalam olist_products memiliki dimensi panjang (product_length_cm),lebar(product_weigth_cm),
-- dan tinggi (product_heigth_cm)
--  pada tabel olist_products, asumsikan volume product berupa panjang x lebar x tinggi.Masa jenis (density)
--  definisikan masa(weight) dibagi volume.Tampilkan density terbesar masing masing kategori tapi tampilkan dalam bahasa inggris,
--  bukan bahasa portugis.Gunakan tabel product_category_name_translation untuk menerjemahkan kategori produck dari bahasa portugis
--  ke bahasa inggris
select
    product_category_name_english as name_category,
    max_density
from(
	select
	product_category_name,
    max(density) as max_density
	from(
		select
			product_weight_g/(product_length_cm*product_width_cm*product_height_cm) as density,
			product_category_name
		from
			olist_products
        ) as t
	group by 1 
    ) as t1
	inner join
	product_category_name_translation as t2
	on t1.product_category_name = t2.product_category_name 
order by 2 desc;

-- Quiz Modul 7 : String Opertora and Function
-- 1. Tampilkan tabel olist_order_payments tapi ganti karakter Underscore(_) pada type pembayaran dengan Spasi ( )
select
	*,
	replace(payment_type,'_',' ') as payment
from olist_order_payments ;
-- 2. Tampilkan pesanan yang di terima customer (order_delivered_customer_timestamp) pada tanggal satu bulan Apapun
select
	*
from olist_orders
	having substr(order_delivered_customer_timestamp,9, 2) like '01';
-- 3. Tampilkan Seller_zip_code_order(tabel olist_seller) dengan aturan berikut
-- 		a. Jika terdiri dari 5 digit atau lebih, tampilkan apa adanya
--      b. Jika terdiri dari kurang 5 digit, maka berikan digit 0 di depan hingga menjadi 5 digit
select
	lpad(seller_zip_code_prefix,5,'0') as seller_code
from olist_sellers;
-- 4. Berapa banyak review yang di berikan pada tahun 2017 yang memiliki lebih dari 100 karakter
-- pada pesannya ?
select
	count(1) as count_review
from olist_order_reviews
where review_creation_date like '2017%' and length(review_comment_message) > 155;
-- 5. Tampilkan secara unik kata yang ada di olist_customers dan hitung beberapa banyak hurup a 
-- pada nama kode tesebut ?
select
	customer_city,
    length(customer_city)-length(replace(customer_city,'a','')) as count_a
from
	(
		select distinct
			customer_city
		from olist_customers
    )as t
where customer_city is not null;

-- Quiz 8 : Datetime Oprators and functions
-- 1. Tapilkan selisih hari sejak sebuah review dibuat (review_creation_date) sampai review
-- dijawab (review_answer_timestamp).Hitung banyaknya review berdasarkan selisih hari dijawab tersebut.
-- Urutkan dari yang tercepat hingga yang terlama.
select
	review_id,
	datediff(review_answer_timestamp,review_creation_date) as selisih
from
	olist_order_reviews
having selisih > 0 and selisih is not null
order by selisih desc;
-- 2. Semua timestamp yang ada pada olist_orders memiliki zona waktu UTC. Ubah semua kolom 
-- timestamp pada tabel tersebut agar menampilkan waktu sesuai Waktu Indonesia Barat (UTC + 7)
select
	order_id,
    order_status,
    date_add(order_purchase_timestamp, interval 7 hour) as order_purchase_timestamp_WIB,
    date_add(order_approved_at,interval 7 hour) as order_approved_at_WIB,
    date_add(order_delivered_carrier_timestamp,interval 7 hour) as order_delivered_carrier_timestamp_WIB,
    date_add(order_delivered_customer_timestamp,interval 7 hour) as order_delivered_customer_timestamp_WIB,
    date_add(order_estimated_delivery_date,interval 7 hour) as order_estimated_delivery_date_WIB
from olist_orders;
-- 3. Tampilkan selisih waktu dari shipping_limit_date( tabel olist_order_items) dengan 
-- order_approved_at(tabel olist_orders) untuk setiap order_id.lakukan pengelompokkan berdasarkan selisih hari
select
	dif,
    count(1) as count_dif
from
    (
    select
		datediff(shipping_limit_date,order_approved_at) as dif
	from
		olist_order_items as t1
        	inner join
		olist_orders as t2
		on t1.order_id = t2.order_id
	) as t
group by 1
order by 2 desc;