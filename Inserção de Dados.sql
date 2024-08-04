-- Inserção de dados na tabela de categorias
INSERT INTO Categories (CategoryName)
VALUES ('Electronics'), ('Books'), ('Clothing'), ('Home & Kitchen');

-- Inserção de dados na tabela de fornecedores
INSERT INTO Suppliers (SupplierName, ContactName, ContactEmail)
VALUES ('Supplier One', 'John Doe', 'john@example.com'),
       ('Supplier Two', 'Jane Smith', 'jane@example.com');

-- Inserção de dados na tabela de produtos
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, Stock)
VALUES ('Laptop', 1, 1, 1000.00, 50),
       ('Smartphone', 1, 1, 500.00, 100),
       ('Novel', 2, 2, 20.00, 200),
       ('T-shirt', 2, 3, 15.00, 150);

-- Inserção de dados na tabela de clientes
INSERT INTO Customers (CustomerName, Email, Phone)
VALUES ('Alice Johnson', 'alice@example.com', '555-1234'),
       ('Bob Smith', 'bob@example.com', '555-5678');
