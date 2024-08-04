-- Trigger para atualizar o estoque após a inserção de um item do pedido
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
