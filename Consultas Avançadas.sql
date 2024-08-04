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
