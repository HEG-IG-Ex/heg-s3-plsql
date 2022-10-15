--https://medium.com/oracledevs/debugging-pl-sql-with-visual-studio-code-and-more-45631f3952cf

exec DBMS_DEBUG_JDWP.CONNECT_TCP('127.0.0.1', '65000'); 


SELECT PKG_COMPET.AFFICHERCOMPETITION(I_COM_NO  => 5 /*IN NUMBER(5)*/) FROM dual;


exec DBMS_DEBUG_JDWP.DISCONNECT(); 