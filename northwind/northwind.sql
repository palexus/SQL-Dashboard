DROP TABLE order_details CASCADE;
DROP TABLE orders CASCADE;
DROP TABLE employee_territories CASCADE;
DROP TABLE employees CASCADE;
DROP TABLE territories CASCADE;
DROP TABLE regions CASCADE;
DROP TABLE shippers CASCADE;
DROP TABLE customers CASCADE;
DROP TABLE products CASCADE;
DROP TABLE suppliers CASCADE;
DROP TABLE categories CASCADE;


CREATE TABLE IF NOT EXISTS categories (
    categoryID SERIAL PRIMARY KEY,
    categoryName TEXT,
    description TEXT,
    picture BYTEA
);

\copy categories FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/categories.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS suppliers (
    supplierID SERIAL PRIMARY KEY,
    companyName TEXT,
    contactName TEXT,
    contactTitle TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postalCode TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT,
    homePage TEXT
);

\copy suppliers FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/suppliers.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS products (
    productID SERIAL PRIMARY KEY,
    productName TEXT,
    supplierID INT,
    categoryID INT,
    quantityPerUnit TEXT,
    unitPrice NUMERIC,
    unitsInStock INT,
    unitsOnOrder INT,
    reorderLevel INT,
    discontinued INT,

    FOREIGN KEY(categoryID)
      REFERENCES categories(categoryID) ON DELETE CASCADE,

    FOREIGN KEY(supplierID)
      REFERENCES suppliers(supplierID) ON DELETE CASCADE
);

\copy products FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/products.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS customers (
    customerID VARCHAR(5) PRIMARY KEY,
    companyName TEXT,
    contactName TEXT,
    contactTitle TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postalCode TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT
);

\copy customers FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/customers.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS shippers (
    shipperID SERIAL PRIMARY KEY,
    companyName TEXT,
    phone TEXT
);

\copy shippers FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/shippers.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS regions (
    regionID SERIAL PRIMARY KEY,
    regionDescription VARCHAR(8)
);

\copy regions FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/regions.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS territories (
    territoryID INT PRIMARY KEY,
    territoryDescription TEXT,
    regionID SMALLINT,

    FOREIGN KEY(regionID)
      REFERENCES regions(regionID) ON DELETE CASCADE
);

\copy territories FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/territories.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS employees (
    employeeID SERIAL PRIMARY KEY,
    lastName TEXT,
    firstName TEXT,
    title TEXT,
    titleOfCourtesy VARCHAR(5),
    birthDate TIMESTAMP,
    hireDate TIMESTAMP,
    address TEXT,
    city TEXT,
    region TEXT,
    postalCode TEXT,
    country TEXT,
    homePhone TEXT,
    extension INT,
    photo BYTEA,
    notes TEXT,
    reportsTo SMALLINT,
    photoPath TEXT,

    FOREIGN KEY(reportsTo)
      REFERENCES employees(employeeID) ON DELETE CASCADE
);

\copy employees FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/employees.csv' WITH DELIMITER AS ',' NULL AS 'NULL' CSV HEADER;


CREATE TABLE IF NOT EXISTS employee_territories (
    employeeID SMALLINT,
    territoryID INT,

    FOREIGN KEY(territoryID)
      REFERENCES territories(territoryID) ON DELETE CASCADE,

    FOREIGN KEY(employeeID)
      REFERENCES employees(employeeID) ON DELETE CASCADE
);

\copy employee_territories FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/employee_territories.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE IF NOT EXISTS orders (
    orderID SERIAL PRIMARY KEY,
    customerID VARCHAR(5),
    employeeID SMALLINT,
    orderDate TIMESTAMP,
    requiredDate TIMESTAMP,
    shippedDate TIMESTAMP NULL,
    shipVia SMALLINT,
    freight NUMERIC,
    shipName TEXT,
    shipAddress TEXT,
    shipCity TEXT,
    shipRegion TEXT,
    shipPostalCode TEXT,
    shipCountry TEXT,

    FOREIGN KEY(customerID)
      REFERENCES customers(customerID) ON DELETE CASCADE,
    FOREIGN KEY(shipvia)
      REFERENCES shippers(shipperID) ON DELETE CASCADE,
    FOREIGN KEY(employeeID)
      REFERENCES employees(employeeID) ON DELETE CASCADE
);

\copy orders FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/orders.csv' WITH DELIMITER AS ',' NULL AS 'NULL' CSV HEADER;



CREATE TABLE IF NOT EXISTS order_details (
    orderID INT,
    productID INT,
    unitPrice NUMERIC,
    quantity INT,
    discount NUMERIC,

    FOREIGN KEY(productID)
      REFERENCES products(productID) ON DELETE CASCADE,
    FOREIGN KEY(orderID)
      REFERENCES orders(orderID) ON DELETE CASCADE
);

\copy order_details FROM '/Users/palex/Projects/spiced/scikit-cilantro-student-code/week_05/northwind_data/data/order_details.csv' DELIMITER ',' CSV HEADER;







