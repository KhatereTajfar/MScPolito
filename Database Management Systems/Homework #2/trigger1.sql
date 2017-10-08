CREATE OR REPLACE TRIGGER PhoneStateChange
AFTER INSERT ON STATE_CHANGE
FOR EACH ROW
DECLARE
  x NUMBER;

BEGIN
  IF (:NEW.CHANGETYPE = 'O') THEN
    -- Branch for phone switching ON
    INSERT INTO TELEPHONE(PHONENO,X,Y,PHONESTATE) VALUES (:NEW.PHONENO,:NEW.X,:NEW.Y,'ON');
    x := 1;
  ELSE
    IF (:NEW.CHANGETYPE = 'F') THEN
        -- Branch for phone switching OFF
        DELETE FROM TELEPHONE WHERE PHONENO=:NEW.PHONENO;
        x := -1;
    END IF;
  END IF;

  UPDATE CELL
  SET CURRENTPHONE# = CURRENTPHONE# + x
  WHERE (:NEW.x BETWEEN X0 AND X1) AND (:NEW.y BETWEEN Y0 AND Y1);

END;
