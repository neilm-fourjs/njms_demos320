# check gl_db.inc, value here should be the same!

PUBLIC TYPE t_disc RECORD
	stock_disc    CHAR(2),
	customer_disc CHAR(2),
	disc_percent  DECIMAL(5, 2),
	dbsync_muser  VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime  DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat  CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_disc_pk =  "stock_disc, customer_disc"

PUBLIC TYPE t_countries RECORD
	country_code CHAR(3), -- PRIMARY KEY
	country_name CHAR(40),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_countries_pk  = "country_code"

PUBLIC TYPE t_addresses RECORD
	rec_key      INTEGER ATTRIBUTE(XMLType = "SERIAL"),
	line1        VARCHAR(40),
	line2        VARCHAR(40) ATTRIBUTE(XMLNillable),
	line3        VARCHAR(40) ATTRIBUTE(XMLNillable),
	line4        VARCHAR(40) ATTRIBUTE(XMLNillable),
	line5        VARCHAR(40) ATTRIBUTE(XMLNillable),
	postal_code  VARCHAR(8) ATTRIBUTE(XMLNillable),
	country_code CHAR(3), -- FOREIGN KEY(country_code) REFERENCES countries(country_code)
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_addresses_pk = "rec_key"
CONSTANT c_addresses_extra = "FOREIGN KEY(country_code) REFERENCES countries(country_code)"

PUBLIC TYPE t_customer RECORD
	customer_code      CHAR(8), -- PRIMARY KEY
	customer_name      VARCHAR(30),
	contact_name       VARCHAR(30) ATTRIBUTE(XMLNillable),
	email              VARCHAR(100) ATTRIBUTE(XMLNillable),
	web_passwd         CHAR(10) ATTRIBUTE(XMLNillable),
	del_addr           INTEGER, -- FOREIGN KEY(del_addr) REFERENCES addresses(rec_key)
	inv_addr           INTEGER, -- FOREIGN KEY(inv_addr) REFERENCES addresses(rec_key)
	disc_code          CHAR(2),
	credit_limit       INTEGER ATTRIBUTE(XMLNillable),
	total_invoices     DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	outstanding_amount DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	dbsync_muser       VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime       DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat       CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_customer_pk = "customer_code"
CONSTANT c_customer_extra = "FOREIGN KEY(del_addr) REFERENCES addresses(rec_key), FOREIGN KEY(inv_addr) REFERENCES addresses(rec_key)"

PUBLIC TYPE t_stock_cat RECORD
	cat_code     CHAR(10), -- PRIMARY KEY
	cat_name     CHAR(80),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_stock_cat_pk = "cat_code"

PUBLIC TYPE t_supplier RECORD
	supp_code    CHAR(10), -- PRIMARY KEY
	supp_name    CHAR(80),
	disc_code    CHAR(2),
	addr_line1   VARCHAR(40) ATTRIBUTE(XMLNillable),
	addr_line2   VARCHAR(40) ATTRIBUTE(XMLNillable),
	addr_line3   VARCHAR(40) ATTRIBUTE(XMLNillable),
	addr_line4   VARCHAR(40) ATTRIBUTE(XMLNillable),
	addr_line5   VARCHAR(40) ATTRIBUTE(XMLNillable),
	postal_code  VARCHAR(8) ATTRIBUTE(XMLNillable),
	tel          CHAR(20) ATTRIBUTE(XMLNillable),
	email        VARCHAR(60) ATTRIBUTE(XMLNillable),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_supplier_pk = "supp_code"

PUBLIC TYPE t_colours RECORD
	colour_key   INTEGER ATTRIBUTE(XMLType = "SERIAL"),
	colour_name  VARCHAR(30),
	colour_hex   CHAR(7),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_colours_pk = "colour_key"

PUBLIC TYPE t_stock RECORD
	stock_code      CHAR(8),  -- PRIMARY KEY
	stock_cat       CHAR(10), -- FOREIGN KEY(stock_cat) REFERENCES stock_cat(cat_code)
	pack_flag       CHAR(1) ATTRIBUTE(XMLNillable),
	supp_code       CHAR(10), -- FOREIGN KEY(supp_code) REFERENCES supplier(supp_code)
	barcode         CHAR(13) ATTRIBUTE(XMLNillable),
	description     CHAR(30),
	colour_code     INTEGER ATTRIBUTE(XMLNillable),
	price           DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	cost            DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	tax_code        CHAR(1) ATTRIBUTE(XMLNillable),
	disc_code       CHAR(2) ATTRIBUTE(XMLNillable),
	physical_stock  INTEGER ATTRIBUTE(XMLNillable),
	allocated_stock INTEGER ATTRIBUTE(XMLNillable),
	free_stock      INTEGER ATTRIBUTE(XMLNillable),
	long_desc       VARCHAR(100) ATTRIBUTE(XMLNillable),
	img_url         VARCHAR(100) ATTRIBUTE(XMLNillable),
	dbsync_muser    VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime    DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat    CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_stock_pk = "stock_code"
CONSTANT c_stock_extra = "FOREIGN KEY(stock_cat) REFERENCES stock_cat(cat_code), FOREIGN KEY(supp_code) REFERENCES supplier(supp_code)"

PUBLIC TYPE t_pack_items RECORD
	pack_code    CHAR(8),
	stock_code   CHAR(8), -- FOREIGN KEY(stock_code) REFERENCES stock(stock_code)
	qty          INTEGER ATTRIBUTE(XMLNillable),
	price        DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	cost         DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	tax_code     CHAR(1) ATTRIBUTE(XMLNillable),
	disc_code    CHAR(2) ATTRIBUTE(XMLNillable),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_pack_items_pk = "pack_code, stock_code"
CONSTANT c_pack_items_extra = "FOREIGN KEY(stock_code) REFERENCES stock(stock_code)"

PUBLIC TYPE t_ord_head RECORD
	order_number   INTEGER ATTRIBUTE(XMLType = "SERIAL"),
	order_datetime DATETIME YEAR TO SECOND,
	order_date     DATE,
	order_ref      VARCHAR(40),
	req_del_date   DATE,
	customer_code  CHAR(8), -- FOREIGN KEY(customer_code) REFERENCES customer(customer_code)
	customer_name  VARCHAR(30),
	del_address1   VARCHAR(40) ATTRIBUTE(XMLNillable),
	del_address2   VARCHAR(40) ATTRIBUTE(XMLNillable),
	del_address3   VARCHAR(40) ATTRIBUTE(XMLNillable),
	del_address4   VARCHAR(40) ATTRIBUTE(XMLNillable),
	del_address5   VARCHAR(40) ATTRIBUTE(XMLNillable),
	del_postcode   VARCHAR(8) ATTRIBUTE(XMLNillable),
	inv_address1   VARCHAR(40) ATTRIBUTE(XMLNillable),
	inv_address2   VARCHAR(40) ATTRIBUTE(XMLNillable),
	inv_address3   VARCHAR(40) ATTRIBUTE(XMLNillable),
	inv_address4   VARCHAR(40) ATTRIBUTE(XMLNillable),
	inv_address5   VARCHAR(40) ATTRIBUTE(XMLNillable),
	inv_postcode   VARCHAR(8) ATTRIBUTE(XMLNillable),
	username       CHAR(8) ATTRIBUTE(XMLNillable),
	items          INTEGER ATTRIBUTE(XMLNillable),
	total_qty      INTEGER ATTRIBUTE(XMLNillable),
	total_nett     DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	total_tax      DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	total_gross    DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	total_disc     DECIMAL(12, 3) ATTRIBUTE(XMLNillable),
	dbsync_muser   VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime   DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat   CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_ord_head_pk = "order_number"
CONSTANT c_ord_head_extra = "FOREIGN KEY(customer_code) REFERENCES customer(customer_code)"

PUBLIC TYPE t_ord_payment RECORD
	payment_key    INTEGER ATTRIBUTE(XMLType = "SERIAL"),
	order_number   INTEGER,
	payment_type   CHAR(1) ATTRIBUTE(XMLNillable),
	del_type       CHAR(1) ATTRIBUTE(XMLNillable),
	card_type      CHAR(1) ATTRIBUTE(XMLNillable),
	card_no        CHAR(20) ATTRIBUTE(XMLNillable),
	expires_m      SMALLINT ATTRIBUTE(XMLNillable),
	expires_y      SMALLINT ATTRIBUTE(XMLNillable),
	issue_no       SMALLINT ATTRIBUTE(XMLNillable),
	payment_amount DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	del_amount     DECIMAL(6, 2) ATTRIBUTE(XMLNillable),
	dbsync_muser   VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime   DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat   CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_ord_payment_pk = "payment_key"

PUBLIC TYPE t_ord_detail RECORD
	order_number INTEGER,
	line_number  SMALLINT,
	stock_code   VARCHAR(8), -- FOREIGN KEY(stock_code) REFERENCES stock(stock_code)
	pack_flag    CHAR(1) ATTRIBUTE(XMLNillable),
	price        DECIMAL(12, 2) ATTRIBUTE(XMLNillable),
	quantity     INTEGER,
	disc_percent DECIMAL(5, 2) ATTRIBUTE(XMLNillable),
	disc_value   DECIMAL(10, 3) ATTRIBUTE(XMLNillable),
	tax_code     CHAR(1) ATTRIBUTE(XMLNillable),
	tax_rate     DECIMAL(5, 2) ATTRIBUTE(XMLNillable),
	tax_value    DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
	nett_value   DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
	gross_value  DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
	dbsync_muser VARCHAR(20, 0) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mtime DATETIME YEAR TO FRACTION(3) ATTRIBUTE(XMLNillable, XMLOptional),
	dbsync_mstat CHAR(2) ATTRIBUTE(XMLNillable, XMLOptional)
END RECORD
CONSTANT c_ord_detail_pk = "order_number, line_number"
CONSTANT c_ord_detail_extra =  "FOREIGN KEY(order_number) REFERENCES ord_head(order_number)"

PUBLIC TYPE t_quotes RECORD
  quote_number INTEGER ATTRIBUTE(XMLType = "SERIAL"),
  quote_ref CHAR(10) ATTRIBUTE(XMLNillable),
  revision SMALLINT ATTRIBUTE(XMLNillable),
  status CHAR(1) ATTRIBUTE(XMLNillable),
  account_manager INTEGER ATTRIBUTE(XMLNillable),
  raised_by INTEGER ATTRIBUTE(XMLNillable),
  customer_code CHAR(8),
  division INTEGER ATTRIBUTE(XMLNillable),
  quote_date DATE ATTRIBUTE(XMLNillable),
  expiration_date DATE ATTRIBUTE(XMLNillable),
  projected_date DATE ATTRIBUTE(XMLNillable),
  ordered_date DATE ATTRIBUTE(XMLNillable),
  description VARCHAR(250) ATTRIBUTE(XMLNillable),
  end_user VARCHAR(50) ATTRIBUTE(XMLNillable),
  project VARCHAR(50) ATTRIBUTE(XMLNillable),
  registered_project INTEGER ATTRIBUTE(XMLNillable),
  quote_total DECIMAL(10, 2) ATTRIBUTE(XMLNillable)
END RECORD
CONSTANT c_quotes_extra  = "FOREIGN KEY(customer_code) REFERENCES customer(customer_code)"

PUBLIC TYPE t_quote_detail RECORD
  quote_number INTEGER,
  item_num SMALLINT ATTRIBUTE(XMLNillable),
  item_group SMALLINT ATTRIBUTE(XMLNillable), 
  stock_code CHAR(8),
  colour_key INTEGER ATTRIBUTE(XMLNillable),
  colour_surcharge DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
  quantity INTEGER ATTRIBUTE(XMLNillable),
  unit_rrp DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
  unit_surcharge DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
  discount DECIMAL(5, 2) ATTRIBUTE(XMLNillable),
  unit_net DECIMAL(10, 2) ATTRIBUTE(XMLNillable),
  item_detail_net DECIMAL(10, 2) ATTRIBUTE(XMLNillable)
END RECORD
CONSTANT c_quote_detail_pk = "quote_number, item_num"
CONSTANT c_quote_detail_extra = "FOREIGN KEY(quote_number) REFERENCES quotes(quote_number), FOREIGN KEY(stock_code) REFERENCES stock(stock_code), FOREIGN KEY(colour_key) REFERENCES colours(colour_key)"
