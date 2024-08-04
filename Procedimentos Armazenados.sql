-- Procedimento para inserir um novo pedido
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
