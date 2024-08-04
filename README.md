
# ECommerceDB SQL Scripts

Este repositório contém scripts SQL para a criação e gerenciamento do banco de dados `ECommerceDB`, incluindo a criação de tabelas, inserção de dados, consultas avançadas, views, procedimentos armazenados e triggers.

## Arquivos

1. **Criação do Banco de Dados e Tabelas.sql**
   - Criação do banco de dados `ECommerceDB` e suas tabelas:
     - Categories
     - Suppliers
     - Products
     - Customers
     - Orders
     - OrderItems

2. **Consultas Avançadas.sql**
   - Consultas SQL avançadas para:
     - Buscar produtos com estoque abaixo de um certo valor.
     - Buscar pedidos de um cliente específico.
     - Buscar itens de um pedido específico.
     - Relatório de vendas por mês.

3. **Inserção de Dados.sql**
   - Scripts para inserção de dados iniciais nas tabelas:
     - Categories
     - Suppliers
     - Products
     - Customers

4. **Views.sql**
   - Criação de views para facilitar consultas:
     - TopSellingProducts: Lista os produtos mais vendidos.
     - TopCustomers: Lista os clientes com mais pedidos.

5. **Procedimentos Armazenados.sql**
   - Procedimentos armazenados para automação de tarefas:
     - InsertOrder: Procedimento para inserir um novo pedido junto com seus itens.

6. **Triggers.sql**
   - Triggers para manter a consistência dos dados:
     - UpdateStockAfterInsert: Atualiza o estoque após a inserção de um item do pedido.

## Como Usar

### 1. Criação do Banco de Dados e Tabelas
Execute o script `Criação do Banco de Dados e Tabelas.sql` para criar o banco de dados `ECommerceDB` e todas as tabelas necessárias.

```sql
-- Criação do banco de dados
CREATE DATABASE ECommerceDB;

-- Seleciona o banco de dados
USE ECommerceDB;

-- Criação da tabela de categorias
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(255) NOT NULL
);

-- Criação da tabela de fornecedores
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(255) NOT NULL,
    ContactName VARCHAR(255),
    ContactEmail VARCHAR(255)
);

-- Criação da tabela de produtos
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    UnitPrice DECIMAL(10, 2),
    Stock INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Criação da tabela de clientes
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20)
);

-- Criação da tabela de pedidos
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Criação da tabela de itens do pedido
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
```

### 2. Inserção de Dados
Execute o script `Inserção de Dados.sql` para inserir dados iniciais nas tabelas.

```sql
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
```

### 3. Consultas Avançadas
Execute o script `Consultas Avançadas.sql` para realizar consultas avançadas.

```sql
-- Buscar todos os produtos com estoque abaixo de um certo valor
SELECT * FROM Products
WHERE Stock < 10;

-- Buscar os pedidos de um cliente específico
SELECT o.OrderID, o.OrderDate, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID = 1;

-- Buscar os itens de um pedido específico
SELECT oi.OrderItemID, p.ProductName, oi.Quantity, oi.UnitPrice
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
WHERE oi.OrderID = 1;

-- Relatório de vendas por mês
SELECT DATE_FORMAT(o.OrderDate, '%Y-%m') AS Month, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
GROUP BY Month
ORDER BY Month;
```

### 4. Views
Execute o script `Views.sql` para criar as views.

```sql
-- View para listar os produtos mais vendidos
CREATE VIEW TopSellingProducts AS
SELECT p.ProductID, p.ProductName, SUM(oi.Quantity) AS TotalSold
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC;

-- View para listar os clientes com mais pedidos
CREATE VIEW TopCustomers AS
SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalOrders DESC;
```

### 5. Procedimentos Armazenados
Execute o script `Procedimentos Armazenados.sql` para criar os procedimentos armazenados.

```sql
DELIMITER //

CREATE PROCEDURE InsertOrder (
    IN p_CustomerID INT,
    IN p_OrderDate DATE,
    IN p_TotalAmount DECIMAL(10, 2),
    IN p_OrderItems JSON
)
BEGIN
    DECLARE v_OrderID INT;

    -- Inserir pedido na tabela Orders
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (p_CustomerID, p_OrderDate, p_TotalAmount);

    SET v_OrderID = LAST_INSERT_ID();

    -- Inserir itens do pedido na tabela OrderItems
    INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
    SELECT v_OrderID, ProductID, Quantity, UnitPrice
    FROM JSON_TABLE(p_OrderItems, '$[*]'
        COLUMNS (
            ProductID INT PATH '$.ProductID',
            Quantity INT PATH '$.Quantity',
            UnitPrice DECIMAL(10, 2) PATH '$.UnitPrice'
        )
    ) AS items;
END //

DELIMITER ;
```

### 6. Triggers
Execute o script `Triggers.sql` para criar os triggers.

```sql
DELIMITER //

CREATE TRIGGER UpdateStockAfterInsert
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END //

DELIMITER ;
```

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## Licença

Este projeto está licenciado sob a Licença MIT.
