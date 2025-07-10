-- =============================================
-- Trigger Name: trg_validate_payment_type
-- Purpose    : Ensures payment_type is valid.
--              If inserted value is not in the accepted list replace with 'not defined'.
-- Table      : Order_Payments
-- Event      : AFTER INSERT
-- =============================================
CREATE TRIGGER trg_validate_payment_type
ON Order_Payments
AFTER INSERT
AS
BEGIN
    UPDATE op
    SET payment_type = 'not defined'
    FROM Order_Payments op
    INNER JOIN inserted i 
	ON op.order_id = i.order_id AND op.payment_sequential = i.payment_sequential
    WHERE i.payment_type NOT IN ('boleto', 'voucher', 'debit_card', 'credit_card');
END;

-- =============================================
-- Trigger Name: trg_validate_review_insert
-- Purpose    : Prevent inserting reviews where review_answer_timestamp is before review_creation_date
-- Table      : Order_Reviews
-- Event      : INSTEAD OF INSERT
-- =============================================
CREATE TRIGGER trg_validate_review_insert
ON Order_Reviews
INSTEAD OF INSERT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE review_answer_timestamp < review_creation_date
    )
    BEGIN
        PRINT 'Error: review_answer_timestamp must be greater than or equal to review_creation_date';
        RETURN;
    END;

  
    INSERT INTO Order_Reviews
    SELECT * FROM inserted;
END;
