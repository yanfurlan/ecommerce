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
