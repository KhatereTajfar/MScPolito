CREATE OR REPLACE TRIGGER maxCallsMgmt
BEFORE UPDATE OF MAXCALLS ON CELL
FOR EACH ROW
DECLARE
  -- Vars
  active# NUMBER;
BEGIN
  -- Trigger body

  SELECT COUNT(*) INTO active#
  FROM TELEPHONE
  WHERE PHONESTATE='Active' AND (X BETWEEN :NEW.X0 AND :NEW.X1) AND (Y BETWEEN :NEW.Y0 AND :NEW.Y1);

  IF (active# > :NEW.MAXCALLS) THEN
    :NEW.MAXCALLS := active#;
  END IF;

  IF (:NEW.MAXCALLS < 31) THEN
    raise_application_error(-20000,'Service of 30 minimum calls has to be guaranteed.',TRUE);
  END IF;

END;
