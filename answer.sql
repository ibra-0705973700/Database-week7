-- ============================================================================
-- Week 7 Assignment: Database Design and Normalization
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Question 1: Achieving First Normal Form (1NF)
-- Problem: The 'Products' column in ProductDetail contains comma-separated
-- multiple values in a single cell (repeating/multi-valued group), which
-- violates 1NF. Each row must represent a single atomic value per column, with
-- one product per order.
-- ----------------------------------------------------------------------------

CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Verify Question 1 (1NF) result
SELECT * FROM ProductDetail_1NF;


-- ----------------------------------------------------------------------------
-- Question 2: Achieving Second Normal Form (2NF)
-- Partial Dependency Identified:
-- In OrderDetails, the assumed composite primary key is (OrderID, Product).
-- However, 'CustomerName' depends only on 'OrderID' (part of the composite
-- key) and not on 'Product'. This partial dependency violates 2NF.
--
-- Solution:
-- Split into 'Orders' (OrderID as PRIMARY KEY, storing CustomerName) and
-- 'OrderItems' (composite PRIMARY KEY on (OrderID, Product), plus a FOREIGN
-- KEY referencing Orders(OrderID), storing Quantity per product in an order).
-- ----------------------------------------------------------------------------

CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID)
);

CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);

-- Verify Question 2 (2NF) results
SELECT * FROM Orders;
SELECT * FROM OrderItems;