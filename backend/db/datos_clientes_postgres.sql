-- POr ahora lo dejaré así, ya despues edito para una mejor forma de insertar los datos

select * from empresa;
insert into empresa (emp_ruc, emp_razon_social, emp_nombre_comercial, emp_direccion, emp_lema, dep_id, prv_id, dis_id, estado)
values('10612017445', 'EMPRESA DEMO', 'SOLUCIONES KRONOS CODE STUDIO', 'JR DEMO 12345', 'SOLUCIONES REALES CON RESULTADOS REALES', '1f8cae48-ac68-11f1-8ce3-53d7d813d0cb', 'fedc9e0a-ac68-11f1-8ce4-93bc7123d2c7', '63c48242-ac69-11f1-8ce5-b7c544f9e5ab', 1);

select * from documento;
insert into documento (doc_tipo, doc_descripcion, estado) VALUES( 'DNI', 'DOCUMENTO NACIONAL DE IDENTIDAD', 1);
INSERT INTO documento ( doc_tipo, doc_descripcion, estado) VALUES (  'RUC', 'Registro Único de Contribuyentes', 1)

SELECT * FROM departamento;
insert into departamento (dep_nombre, estado) VALUES('LIMA', 1)

SELECT * FROM provincia;
insert into provincia(dep_id, prv_nombre, estado) VALUES ('1f8cae48-ac68-11f1-8ce3-53d7d813d0cb', 'LIMA', 1)

SELECT * FROM distrito;
insert into distrito (prv_id, dis_nombre, estado) VALUES ('fedc9e0a-ac68-11f1-8ce4-93bc7123d2c7', 'LIMA CENTRO', 1)

BEGIN;
INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43637454',
  'HUAMAN REYES MIGUEL HERNAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20602569943',
  'GM SOLUCIONES E.I.R.L.',
  'JR. CORONEL PORTILLO NRO. 427 URB. CERCADO DE PUCALLPA UCAYALI CORONEL PORTILLO CALLERIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20352308588',
  'SEGURICOMP S.R.L',
  'JR. TARAPACA NRO. 920 UCAYALI CORONEL PORTILLO CALLERIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46088493',
  'USHÑAHUA SHAHUANO KAREN ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00150085',
  'PERALES GOICOCHEA EUSEBIO PRUDENCIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08635060',
  'RAMIREZ PAREDES CELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76863281',
  'DEL AGUILA FIGUEROA ROSSY ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61606727',
  'INFANTE DAVILA KAROL VANESSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10831279',
  'MONTOYA PEÑAFIEL MARIA ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45840118',
  'RAMÍREZ PÉREZ CARLOS ABRAHAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80484655',
  'ZUÑIGA GASPAR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00098773',
  'AREVALO RENGIFO LEYDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45636451',
  'PINCHI RUIZ WIDCER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21143603',
  'PACAYA RUIZ LIRIA LORENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44441066',
  'PINCHI RUIZ LIBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46561569',
  'ZEGARRA BARBARAN JEAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41886600',
  'PEREZ PANDURO PETER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62034805',
  'DEBERNARDI GARCIA DINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70254718',
  'SANGAMA SANCHEZ ERNESTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44868706',
  'ALIAGA NAVARRO EMIR MILLER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45850353',
  'MONTELUIZ CARRANZA GRIMANESA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05705386',
  'CARRANZA TIMA MARITZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41168189',
  'DONAYRE FASABI DIANA LIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40202810',
  'TORDOCILLO YANTAS MARISOL MARLENI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62832396',
  'ANGULO BOLIVAR SANDIA ANITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00018263',
  'MAYNAS NUNTA ROGELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00014312',
  'BURGA DE SOUZA CELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73231216',
  'PINCHI RUIZ FREDESBINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46343525',
  'COLLADO ESCOTO MIGUEL AGUSTIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07647582',
  'MORIN ORMEÑO MANUEL DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46269818',
  'SONCCO CONDORI HILDA MARLENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08926830',
  'TAMINCHI CANAYO BRAULIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75809346',
  'RIMACHI MERMAO WENDY MARISELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44614099',
  'LOPEZ BUENAPICO TAILO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73735950',
  'PICOTA MAYNAS MELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05954607',
  'ALIAGA SAJAMI JULIO ABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45186231',
  'SALIRROSAS MACHUCA JOSE ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09794280',
  'SOTO HILARIO LUIS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41516403',
  'BENAVIDES YAVAR MARFA BERONICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00110976',
  'RUIZ PANDURO EZEQUIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72353855',
  'OCHAVANO MAYTA KIMBERLY ROXY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00071541',
  'SAAVEDRA DE LOJA ANA MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75731868',
  'CERAS ROJAS NATALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00007136',
  'PEÑA CRISPIN ADELAIDA MARINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10081372',
  'SALAZAR LAMA GLICERIO MARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01000588',
  'CABANILLAS MURRIETA ROSA VICTORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43765251',
  'AMASIFUEN MACEDO EDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40685587',
  'OCHOA ZUMAETA KARMY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00021158',
  'DAVILA VILLANUEVA HUGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00090341',
  'FLORES CAHUAZA RAFAEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76921717',
  'FLORES RUIZ KIARA LUCERO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00106926',
  'GOMEZ OJANAMA MARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04430651',
  'MENDOZA DÁVILA PATRICIA ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09409684',
  'SANTAMARIA RUIZ JUAN MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00100605',
  'ARISTA MORIN MARIA IRENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00995566',
  'PINCHI ANGULO WIDCER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00015014',
  'MORIN DE GONZALES EMILIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43005450',
  'CARDENAS GUEVARA CIRO BERNARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60855175',
  'GALVEZ DAVILA KENYO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45176156',
  'ARIMUYA HUALINGA TITO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00087069',
  'RABANAL TORRES BERZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41516430',
  'BARDALES ARAUJO LEIDY CARMINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41643491',
  'LAUREL PERDOMO JORGE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70691009',
  'MORENO ARISTA IRENE ALEXANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21144371',
  'SALDAÑA MAJIN FLOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '28227328',
  'ROCA VDA DE QUISPE YOLANDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80397592',
  'CARDENAS CHAVEZ MANUEL ALEXANDER NEYSER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80682751',
  'CARDENAS GUEVARA KIKER ULICES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40955834',
  'MAMOLADA GONZALES JONAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71852288',
  'GRANADOS PARRAGA IVAN ANDRE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41606523',
  'MONTECILLO CIPRIANO LUIS ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22519284',
  'BURGOS HUERTA RUMA OBDULIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43876141',
  'SAAVEDRA URQUIA JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41459583',
  'CASTAÑEDA PIELAGO ARMANDO AMADOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00074275',
  'PIELAGO BASILIO ESTELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47513249',
  'LUNA PIELAGO WILDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45517610',
  'LUNA PIELAGO WILDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00032722',
  'BALLESTEROS THEO IRMA LUDGARDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41004942',
  'CENEPO RUCOBA LLACLI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75729717',
  'RUIZ CENEPO DIANA ESTEFANI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43302904',
  'FERNANDEZ ORCADA JHOEL FRANCISCO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00091856',
  'DAVILA RUIZ ORLANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40113911',
  'HOYOS PEREYRA ANCELMO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10587767',
  'ALBORNOZ CHEPE DORCA RUTH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60887250',
  'SAJAMI GONZALES JIMY PAOLO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25828589',
  'TRUJILLO FLORES ADITH SUSELVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41926213',
  'SALDARRIAGA FLORES FREDY ORNEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72353856',
  'OCHAVANO MAYTA ESCARLY ZANDALYCK',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05848580',
  'SOLSOL MURCIA SAIDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42354780',
  'VELA VARGAS KAREN PAOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45908465',
  'CACHIQUE AREVALO AMELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44169130',
  'SINARAHUA CACHIQUE GREYS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21140983',
  'DEL AGUILA SINTI RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00127473',
  'DEL AGUILA SINTI MERLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76039124',
  'GONZALES APAGUEÑO FLOR MARLITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00117626',
  'RAMIREZ SOCA SERAFIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46395523',
  'VILLAR ASTUCURI LOURDES MAGALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80118855',
  'HIDALGO NOA JULIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62550977',
  'HIDALGO RIVERA ALEXANDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05248932',
  'HERRERA PEREZ IRMA PAQUITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43428116',
  'CHIAPPERINI FAVERIO GIAN MARCO CARMELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44587217',
  'CARRION AHUANARI CHARLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00028102',
  'BURGA ACOSTA ORLANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41017342',
  'LAUREL PERDOMO MARY ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44875149',
  'ARCENTALES PIELAGO RICHAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48471779',
  'LLANOS FLORES JAZMIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21142480',
  'YOMONA IJUMA ROSA AURORA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80497759',
  'GATICA TANANTA KAREN JANINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00011686',
  'SATALAYA TAMINCHE JAMES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46291001',
  'MANRIQUE PILLPA LEIBNIZ GEIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74869128',
  'CONDORCALLE RAMOS EULOGIO ROBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44156021',
  'RODRIGUEZ RABANAL FLORIAL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47941845',
  'FALCON DE LA ROSA CRISTIAN MELVIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01116301',
  'PEZO TORRES DE AMASIFUEN LILI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46545129',
  'SINARAHUA CACHIQUE MELISSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41341775',
  'GONZALES MORIN JUAN MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05936666',
  'AMASIFUEN VILLACREZ AMADOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76836524',
  'MORALES RICOPA DANITZA ODIZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80505488',
  'OCHOA ZUMAETA LILIAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40374276',
  'BECERRIL CARDENAS ALINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80527389',
  'PEREZ GUERRA MONICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00059588',
  'DEL AGUILA SINTI SARAI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80327477',
  'RIOS TINA SMITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22103999',
  'SORIA RENGIFO LUZ AUGUSTA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22461023',
  'NOBLEJAS NAUPAY MERY DOLLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62980100',
  'TAMANI ROJAS JULIO MICHEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09675986',
  'FLORES PINEDO YOLANDA JANET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62496303',
  'HOYOS BERNALDO JOINER JHON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46994372',
  'SANDOVAL ROMERO YESSENIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44220291',
  'ALVAREZ NAVARRETE ENRIQUETA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41215837',
  'RAMIREZ ARBILDO REYNER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76029435',
  'HUAMAN MOLINA DIANA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43739828',
  'PIÑA TENAZOA ALLINSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40906220',
  'LOPEZ GRATELLI MONICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44561704',
  'ARIMUYA MURAYARI GRICELDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10290366',
  'CAPPILLO SHAPIAMA KISSINGER ARTEMIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42960767',
  'YAURI QUISPE VIVIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46638071',
  'PINCHI SANDOVAL CINDY MIREL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76437554',
  'LUNA PIELAGO JULIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47527600',
  'ROMERO VENTURA AHIMELEC FACTOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48212713',
  'BARRIOS DIAZ PAMELA RUDI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41343319',
  'RODRIGO VITE EILLEEN VICTORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41537017',
  'TUESTA RABANAL CRISTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41637633',
  'BARBARAN VELA JULIO DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23013897',
  'DE LA CRUZ HUAMAN LORENZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76785459',
  'GUERRA MOZOMBITE NELA CRISANIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44351641',
  'GUERRA MOZOMBITE NILSA LORENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44470016',
  'PINCHI SANDOVAL GRIEVE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44531707',
  'PINEDO PEREZ PATSY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00106893',
  'PINEDO PEREZ PEPITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45839140',
  'HUAMANI SISLEY PERCY ALFONSO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44137579',
  'HUAMANI SISLEY VLADIMIR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00076192',
  'DIAZ GARCIA CATALINA RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47036602',
  'SHAHUANO ABISRROR CARLOS ABRAHAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44940726',
  'VEGA FEIJOO JOSE DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44653468',
  'SATALAYA MOZOMBITE ALLEN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00098251',
  'QUINTEROS BARDALES VICTOR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00117443',
  'FLORES ALEGRIA GABRIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47635070',
  'DAVILA FLORES LUIS DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00078080',
  'LUNA VARGAS ELVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05394433',
  'BARBARAN TORRES BETY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00837994',
  'ARIRAMA VASQUEZ ALICER NELIDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40936758',
  'QUIROZ RAMIREZ VICTOR MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22485251',
  'MALDONADO CARDENAS ESTEIBER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76767245',
  'HOYOS BERNALDO NIXON HOAU',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21142429',
  'RENGIFO RIOS FELIPE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05930310',
  'GARCIA LOMAS ANA MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70757154',
  'PEREZ ESPEJO SANTIAGO AGUSTIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01013999',
  'NAVARRETE PEREZ MARIA LUISA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75819278',
  'RIMACHI MERMAO ALFREDO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76301056',
  'HUAMAN MOLINA BLANCA MABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71046025',
  'PANDURO CARDENAS ROBERT WESLEY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40419030',
  'CARDENAS GUEVARA ARMINDA MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75820338',
  'RUIZ CENEPO BEATRIZ MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46680330',
  'NIETO GUEVARA DANIXA SUMICO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00088256',
  'RUCOBA CHOTA GRACIELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80342764',
  'ROMERO BERTINETTY SOFIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44777885',
  'COTERA CANO EVILYN MAYTTE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41714693',
  'TORRES FLORES KATERINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00016637',
  'RUIZ CHICHIPE ARTURO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00091854',
  'MOLINA DELGADO ROSA BLANCA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42513418',
  'AYALA RUIZ DIANA LIZETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41262758',
  'LOPEZ SANDOVAL JAKELINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80394527',
  'LOPEZ MACAYA LILIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71987469',
  'GARCIA DIAZ GISSELL GEORGINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00017106',
  'GARCIA CARDENAS ABRAHAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42781467',
  'VELASCO MEDINA CHRISTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74350760',
  'PIZANGO FLORES ROLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42830519',
  'SAAVEDRA SAAVEDRA SAIDA AMPARO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44931715',
  'JARA ARQUEÑO HERMELINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22504936',
  'GARNELO GARNELO MARIA ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05353057',
  'RODRIGUEZ PEREZ ESTEFITA ESTHER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00124443',
  'AGUILAR YSLA JUAN MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71049948',
  'MOZOMBITE ICOMEDES KASSANDRA DOYLITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00976609',
  'PINCHI LUNA JONAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42478275',
  'GRANDEZ CARDENAS ANGELICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42219762',
  'NAVARRETE CABALLERO NENA JOHANI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46326704',
  'CASTRO ADRIANO ANGELA VERONICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46229490',
  'CRISOSTOMO RABANAL ARLITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00088152',
  'PANDURO VASQUEZ SABINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22521984',
  'TANGOA FASABI VIRGINIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76562114',
  'SANGAMA ISUIZA DANNY CLARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22971440',
  'LOPEZ PAJUELO ROSA ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00039184',
  'REYES TANANTA MILTON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45602857',
  'ATRAVERO ARIRUA KARI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61828828',
  'VELA SILVANO PAOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41793332',
  'TUANAMA VASQUEZ JHON RIVER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46276747',
  'ZUMBA MARIN ARMANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45345875',
  'SORIA GORDON KARLA POLITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47803787',
  'HUANSI CANANAHUAY ALBERT SAMUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73020607',
  'TUCTO ESPINOZA ANA LIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00117179',
  'MELENDEZ PANDURO MERCITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76459459',
  'CANANAHUAY VELA FRANCIS MEGUMY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41119395',
  'TORIBIO HONORIO JESUS CESAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09458731',
  'GUTIERREZ VILDOSO ARMANDO WILVER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43852606',
  'DAHUA GONZALES CARLOS ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47558040',
  'CENEPO VELA ANDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05378093',
  'VASQUEZ RODRIGUEZ KELVIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40743934',
  'TAMANI VELA JULIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00036457',
  'VELA CURICO SUSANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73203677',
  'CENEPO VELA HARRY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70787698',
  'LINARES RENGIFO CLEYTON LADISLAO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00106475',
  'DAHUA GONZALES FROILAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44993972',
  'GOMEZ APARI MICHAEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41588394',
  'VILLAVERDE CARPIO ELSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41596071',
  'CASTRO RAMIREZ RUGEL PELEGRIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75682565',
  'ARMAS NUÑEZ MIGUEL ALONSO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48336219',
  'LOPEZ LAPA IRENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48193626',
  'HUARO DAHUA DEMETRIO CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48505976',
  'HERRERA GALVEZ GERALDINE MARLENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00125851',
  'SANDOVAL SANDOVAL JUANITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09633412',
  'VELARDE SILVA ROXANA CANDELARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76933661',
  'ESPINOZA RENGIFO ALONDRA ANTONELLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73036302',
  'LOPEZ SAJAMI VALERY XIMENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00126851',
  'CARBAJAL VARGAS JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73252389',
  'RIBEIRO RUIZ MAYRIN MICHELLE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00115925',
  'RODRIGUEZ COELHO MARTIN JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41450441',
  'MALLQUI ADRIANO MIRIAM SILVIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41741275',
  'ARIMUYA FIGUEROA LIZETH ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00125285',
  'CHAVEZ GARCIA JUAN MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46434897',
  'GARCIA RAMIREZ SUSY GLENDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00079667',
  'CHAVEZ VASQUEZ ARTEMIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00096433',
  'TAPAYURI RENGIFO DE SANTANA MARIA ASUNCION',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46115236',
  'VALERO MALDONADO PABLO JHANCARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45643304',
  'GUERRA AREVALO JUAN BERNARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42565712',
  'RAMIREZ RESURRECCION MARIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '33951686',
  'HERNANDEZ NUÑEZ PEDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47146904',
  'SALIRROSAS DEL AGUILA BETSABE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75395873',
  'ANGULO VILLAVERDE BRAYAN JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42830391',
  'USHÑAHUA FLORES ANGELINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00108233',
  'LOPEZ RUIZ JUSTINO CESAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46866059',
  'TUANAMA VASQUEZ MIGUEL ANGEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47175675',
  'GRANDEZ CARDENAS SILVIA PAOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46779093',
  'SANCHEZ DE LA CRUZ EVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20972708',
  'ASTUCURI BARJA ROSA GENOVEVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46425138',
  'VILLAR ASTUCURI CECILIA MAGALI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71908161',
  'ALEJOS NAVARRETE LIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70745827',
  'PINCHI CASANOVA JHONATAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48794891',
  'HUAMAN MENDOZA NOEMI SANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70248659',
  'CASTRO ADRIANO DANIELA ISABEL',
  NULL,
  '932082228',
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44817532',
  'RAVINES TAMINCHI CYNTIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47187522',
  'VALLES RUIZ DIANA JULIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42723224',
  'CARDENAS MATEO JESUS ANTONIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45230467',
  'LAVI RUIZ MARIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46275143',
  'PINEDO VASQUEZ NELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44795025',
  'SILVA TORRES CILIA MAYRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42638847',
  'HERNANDEZ MORI JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41051777',
  'BARDALES BALAREZO OMAR MARCELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43737826',
  'CHAVEZ PALOMINO FLOR DE MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41334887',
  'SALDAÑA SOTO ERIKA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77793155',
  'FLORES DAVILA ARLINDO TEODORICO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47767526',
  'CURMAYARI PUGA JHAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42281251',
  'NOA ORBE JIM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74372167',
  'RUIZ CUMAPA NANCY ANAIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76041338',
  'FLORES ALAVA YESSY SOLANGE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21148229',
  'RAMIREZ MORI JOSE MILTON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41337511',
  'BECERRIL VARGAS ROBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70445640',
  'MERCADO ALVARADO PEDRO LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46363697',
  'RIOS RUIZ STEINER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '81074557',
  'GARCIA VASQUEZ GLORIA ESTEFANI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70201784',
  'CAYCHO CASTAGNE CECILIA NICOL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41677856',
  'SAJAMI SORIA DE OCON ROSA BEATRIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44828552',
  'HERNANDEZ PEREZ CARLOS RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23014221',
  'SABINO ROJAS JUANA PASCUALA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20690099',
  'BERNABE MENDOZA REYNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05866061',
  'ALAVA AREVALO ELMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '19988750',
  'BALBÍN QUISPE JUÁN RODRIGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75860912',
  'BALBÍN MEDRANO ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45084715',
  'GUDIEL PAREDES TESALIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41283782',
  'AZABACHE TAMINCHI LUIS JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45347325',
  'PEREZ MARTINEZ MILAGROS IRENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44883828',
  'JAVIER DEZA JUAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05631298',
  'INUMA VITIRI LISTER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42217751',
  'ROJAS CASO MAICOOL TOMAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00101370',
  'RIOJA DO SANTOS GROVER GENARO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80324508',
  'PICON SANCHEZ LITA MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00056272',
  'RUIZ CANAYO ANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45252803',
  'RIVA PICON YOHELIA ROCIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00096830',
  'MELENDEZ MORALES JUDITH ALDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20076195',
  'PIÑAS ALFARO CELSO IVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47573482',
  'DAVILA VASQUEZ DE ROMERO KATERINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74954543',
  'PADILLA OCAMPO ERIKA MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41876885',
  'CAYCHO TIBURCIO JUAN DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41715629',
  'PEREZ SORIA KARINA YRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80453657',
  'MURRIETA BANEO MAGALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10344423',
  'LAZARTE SALCEDO PATRICIA FABIOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76688700',
  'PINCHI CASANOVA GERARDO LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45464652',
  'MACEDO MELENDEZ MARIA CRISTINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00112734',
  'GIPA PEREZ MADITH GROFELI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71231447',
  'SANCHEZ RUIZ JORGE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73056174',
  'CORDOVA TRUJILLO KEYLA ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '06777073',
  'SALIS MAYLLE MIRIAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42474789',
  'PINCHI AGUIRRE FELIX',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40488519',
  'FASABI MENDEZ RUTH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76325970',
  'SARRIA LAVI KIARA MABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40374129',
  'SARRIA VENANCINO JORGE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47191441',
  'ARIRAMA TUANAMA HAVILA LUDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72532274',
  'CRUZATE CORDOVA ALISON SAHORI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70101778',
  'OCC ARIRAMA LIZBITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09594902',
  'LAZARTE SALCEDO SUSANA RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46576381',
  'SATALAYA MOZOMBITE JAMES FERNANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70145023',
  'ATAVILLOS GUERRA ROSMELY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41330816',
  'RODRIGUEZ CRUZ CESAR AUGUSTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61787537',
  'CANAYO RENGIFO RICHARD FRANK',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21143792',
  'DELGADO SOTO RICARDO JUSTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76847359',
  'SANGAMA VENANCINO KARIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22405145',
  'MUNGUIA FLORES CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40284786',
  'ZEVALLOS MORALES GRIMALDO FELIX',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74489049',
  'MANRIQUE MONTOYA MARIAN FERNANDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00066760',
  'ORNETA DELGADO MANUEL CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71603704',
  'ROJAS REVOREDO DIANA MARCIONILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41835601',
  'LOPEZ CHUJUTALLI LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76267849',
  'ORNETA PICON MANUEL CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60721416',
  'ALVAREZ TUCTO ANDERSON MOSHIAT',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80481248',
  'VASQUEZ HUAYNACARI ELVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76859683',
  'TUCTO ESPINOZA CESAR EDUARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75939020',
  'CHANCAHUAÑA CANANAHUAY ZOILA ESTHER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01080334',
  'ROJAS ALEGRIA ALEXANDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42093524',
  'GRANDEZ BARDALES JOEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00122064',
  'GONZALES TUANAMA ROSA ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48301284',
  'HIDALGO SEPULVEDA YASSET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47749706',
  'ARMAS NUÑEZ JOSERY GIOVANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44724268',
  'GARCIA ANDY SUR NORTE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43412622',
  'BARDALES MACUYAMA LEYSI DEL PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '81536189',
  'OCHANTES MURAYARI GENELY MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09533050',
  'CAYCHO GARCIA OLGA TERESA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75831312',
  'TELLO MORENO ROXANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44774561',
  'GONZALES SEGUNDO DIANA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00087766',
  'CABRERA RAMIREZ INES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76088199',
  'SOUZA RUIZ CESAR ALFONSO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62168278',
  'GALVEZ HUAMAN JEINER YOEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00031716',
  'PICON SANCHEZ LILIA ANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40783201',
  'VILLANUEVA RENGIFO CRISTHIAN FREDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47237819',
  'HIDALGO SILVA LORENZO HUMBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05929335',
  'HIDALGO PATTO JUAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46034169',
  'HUAMAN ARENAZA MONICA VIOLETA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70773497',
  'VASQUEZ ALVARADO OBED',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45121873',
  'MACURI GUERRA JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00093179',
  'RIOS DE REATEGUI LEVIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08677789',
  'PANDURO RIOS EULER ACIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47973044',
  'MAMOLADA GONZALES JUANA IRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42629947',
  'RENGIFO PAIMA CINTHYA ANITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '10475602779',
  'MOLINA MOZOMBITE YESSENIA DEL PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71043407',
  'SANTANA TAPAYURI LEANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00185832',
  'ACOSTA TINEO LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47793627',
  'VILLAR ASTUCURI JHOEL IVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00124381',
  'RIOS GAONA JOSE RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44574421',
  'PINEDO MATUTE VICTOR JHYN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48815832',
  'RAMIREZ RENGIFO JENNIFER ROSARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44804343',
  'ALZAMORA MERINO LLUDIT ZOILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00018366',
  'TIBURCIO ALVAREZ SOLEDAD',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47600784',
  'NUNTA HUAYTA ELVIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70798141',
  'AGUIRRE CASTREJON FREDDY ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45641682',
  'SANGAMA VENANCINO ZENITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61379623',
  'PINCHI OCHAVANO SAMUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41958562',
  'HIDALGO SILVA GEMIMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43086356',
  'MODESTO FIGUEROA LESLI SOFIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70338250',
  'ANGELES GUTIERREZ LAURA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '26461008',
  'TOVAR FLORES JOSE ANTONIO',
  'JR. LA MADERA Nª382',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '19489664',
  'LAURA CRISTINA MARIN FARIAS',
  'JR. LA MADERA Nª382',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21142463',
  'REATEGUI VELA VIRGINIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40896382',
  'FLORES SAAVEDRA LUCY GIOVANNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43887893',
  'BARDALES RUIZ MIGUEL ASENCIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48560964',
  'PIÑA CASTILLO JAIMITO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23151664',
  'CASTILLO DE PIÑA ALICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45243824',
  'PIÑA CASTILLO BERTINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08024077',
  'GUTIERREZ YALTA DE ANGELES LILIANA ROSARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77349246',
  'ESPINOZA RENGIFO JAZMIN MISHELL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22422219',
  'RUIZ AREVALO MARLITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48260425',
  'CARDENAS MATEO DAVID BOOZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00076146',
  'CARBAJAL VARGAS LUCY ESMITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '17607765',
  'SANTISTEBAN CUZO ROSA ESMILDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23018953',
  'SOTO PAJUELO MARIELA EVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45940792',
  'QUISPE HUARACCALLO WILBER CIRILO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46003325',
  'SABINO VENTURA WALDIR CRECENCIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00094859',
  'RAMIREZ TORRES JUAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42273981',
  'LA TORRE RODRIGUEZ JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41370520',
  'OCON LOAYZA RONALD CIRILO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00990403',
  'TENAZOA SATALAYA NORA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05868453',
  'MANANITA SILVANO LLERME',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00021420',
  'FLORES GARCIA LILY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42025996',
  'GOMEZ VELA VICTOR RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00114810',
  'NAVARRO VELA CLEVER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45993850',
  'AMBICHO SABINO TAIT VANESA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46489908',
  'RIVA PICON VICTOR MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40740344',
  'TUESTA ISLA BETTY ANGELICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08999564',
  'TUCTO SOLORZANO CARMEN EMILIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44332968',
  'SANCHEZ FERREYRA IVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43639085',
  'PAJUELO RAMIREZ WATSON HUGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61545637',
  'SOLIS NAVARRO MARJORY FIORELLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22315308',
  'MAIKOL ALEXANDER TOVAR FLORES',
  'JR.NLA MADERA Nº382',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70365409',
  'ANGELES GUTIERREZ SILVIA RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00122427',
  'GOMEZ ACHO SONIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76002512',
  'ROJAS BERNABE LORENA CINDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40297771',
  'HILARIO BERNABE HUBERT EDWIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00067466',
  'TANANTA VASQUEZ CHELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70831718',
  'ARI USUREAGA JOHN ROBERTH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48232553',
  'ROJAS CASO INGRID WENDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77468685',
  'INUMA HUAYTA AYDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00101707',
  'SABINO ROJAS LIBERATO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45495883',
  'AMARINGO BOCANEGRA PEDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41981160',
  'PEREZ MENDOZA LIDER AQUILES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00128352',
  'PEZO PICON DARWIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '16466795',
  'LOZANO BARBOZA JUAN ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08029887',
  'GUTIERREZ YALTA CONSUELO ESPERANZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46503939',
  'VILCAMICHE CUSI YANET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75323169',
  'PINCHI BENANCIO LINDA ELIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21064564',
  'REZZA SANTA CRUZ JUAN GUIULIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22514467',
  'VERGARA FLORES LILY JANINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40093916',
  'VERGARA FLORES VICTOR RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76206674',
  'ARI NALVARTE ROGER ALVARO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10118084',
  'NALVARTE CARDENAS ANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43881178',
  'FLORES RIOS JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75568202',
  'SALDAÑA TORRES GADY ABIGAIL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00104191',
  'MOZOMBITE TANCHIVA ZULMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47062710',
  'HUAROC CARDENAS MILI SARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40174146',
  'TORRES AMARINGO NANCY ELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48010392',
  'SALDAÑA TORRES ISAMAR LIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77280300',
  'HUANIO SATALAY JACK MILLER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80241521',
  'YALTA MANGIA CLESY LLANET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71821580',
  'YEPEZ RIMARI JOVITA SYBELL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80342961',
  'MARTINEZ BERTINETTY KENDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70944014',
  'TELLO HERNANDEZ JESSICA NICOL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44711707',
  'PACAYA PEZO LUIS HARRISON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42391453',
  'NALVARTE CARDENAS OLIVER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41498516',
  'HERNANDEZ MORI MERY ASUNTA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45080121',
  'GONZALES QUINTEROS ELVIS ANGEL MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09071876',
  'TAMINCHE SABOYA MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46233871',
  'ROJAS MARTINEZ ISIDORA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00088615',
  'HOYOS COLLAZOS BERITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '15643740',
  'EVA FLORES TOVAR',
  'JR: LAS MADERAS # 382',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73981652',
  'ABAD VELA JOSE MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44266957',
  'PAREDES SILVANO ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05343233',
  'BARDALES SILVANO NILSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74275704',
  'PEREZ MARTINEZ ROBERT ESTEBAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '79544593',
  'RUBIO SABOYA SHARON MARLENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00023317',
  'GONZALES CARDENAS JOSE ERNESTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '78200302',
  'ESPINOZA PEREZ MIRIAM ALEXANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41331182',
  'BADA AQUINO SANTOS MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75732868',
  'NUNTA CAHUAZA GILMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70893265',
  'ÑAHUINRIPA GASPAR RUBEN DIONISIO',
  'AV. PRIMAVERA MZN LT08',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00005782',
  'SANGAMA DE SATALAYA DOLIBE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41219936',
  'TELLO BARDALES LAVINIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45052954',
  'MORI HURTADO YAJAIRA BELIZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45370244',
  'TUANAMA TAPULLIMA ESTELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43630893',
  'ALEGRIA TENAZOA KESSELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48732153',
  'SANTILLAN CURICO DEOCLIDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40982073',
  'CASTAÑEDA FASABI ADELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76465274',
  'JORDAN GALVEZ EDWARDS WALTER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08299427',
  'ARI GIL SIMEON ALFREDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09329615',
  'ARI GIL PETER RUBEN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42878723',
  'BECERRIL CARDENAS NINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40571055',
  'ZEA ETENE NORA LISBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21142604',
  'CARITIMARI CHUQUIPIONDO DE LLERENA TANIA YBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80268796',
  'CAYETANO SANTA CRUZ FABIAN CONSTANTINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42398193',
  'COAGUILA MANERO FROILAN JESUS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42800905',
  'CHONG FLORES MARIO JOHAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70005676',
  'CAUPER FLORES LUIS ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76206675',
  'ARI NALVARTE KAREN NOEMI ANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62080387',
  'NALVARTE CORONADO JEIMY ANDERSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71049953',
  'VASQUEZ MOZOMBITE KATERIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42757511',
  'TOLENTINO MACURI ENDO EDGAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75456458',
  'HUILLCA LUJAN DIEGO JHOEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42269838',
  'GOMEZ NAVARRO PEDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80585511',
  'MAYLLE ORTIZ LINDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42492999',
  'GUEVARA PITA ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43937168',
  'ROJAS DIAZ LIZET VERONICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10128617',
  'CUTIPA CONDORI MIGUEL ANGEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05335664',
  'PINEDO NOLORBE NIDELSIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08390101',
  'GOMEZ QUISPE DE CARBAJAL JOSEFA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01004835',
  'NAVARRETE PEREZ AURELIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41710714',
  'ALVAREZ TUCTO VANESSA ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62035433',
  'HUANIO RENGIFO LIDIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04813564',
  'LUJERIO GARCIA LECARIO ABENCIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71055645',
  'HUAILLAS SEGOVIA RUTH NOEMI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00126141',
  'GOMEZ SOTO ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23006273',
  'FLORES VILLARAN LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00849060',
  'GUERRA JESUS GEORGE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08441565',
  'MOZOMBITE TANCHIVA LUZ ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45907714',
  'LAVERIANO ALEGRIA ISABEL DEBORA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76288944',
  'VILCAMICHE CUSI JAQUELIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40100385',
  'SUSANIBAR TARAZONA PABLO ADRIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48656145',
  'ORE LIZARRAGA DEYVI YEFERSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21144700',
  'FLORES CACHIQUE TEODORICO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40848438',
  'ARIMUYA FIGUEROA REMY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72159294',
  'HUERTA BILLINGHURST DALMA KATHERINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46349463',
  'DA SILVA OLIVEYRA SANDY FIORELLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25726165',
  'VALLE CHAVEZ LUISA PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44822400',
  'VELA SILVANO ROSA IRENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00087236',
  'RIOJA ALVA TONY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76519268',
  'INUMA BAZAN DANIXA LUCECITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00062220',
  'HUANSI PANDURO ROSA MERCEDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43318923',
  'DIAZ RODRIGUEZ OMAR JUNIOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09976459',
  'MAYLLE ORTIZ BETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43177271',
  'GRANIZO AGUILAR CARMEN CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21122372',
  'VENTOCILLA APOLINARIO RICHARD GINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10746732',
  'CHAMAN PANOCCA JUANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21143803',
  'RUIZ GONZALES OLGA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '17928939',
  'CALVANAPON VASQUEZ SEGUNDO SANTIAGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00840936',
  'VALLES BARRERA RUSBER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48082535',
  'PINEDO LINARES MARIO JOEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46510701',
  'ARI USUREAGA HENRY PETER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80679015',
  'ESPINOZA CHUMBES CRISTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40613395',
  'ARI GIL RUBEN SILVERIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46340675',
  'YUMBATO TAMANI CHRIS CHERIL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47498430',
  'MAGARIÑO CHAVEZ ENOC NOE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42163364',
  'VILLAR ASTUCURI MARILU JANETT',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10352152',
  'LOYOLA ESPINOZA ARILES AGUEDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45788382',
  'PINCHI MARTINEZ OFELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '24609316',
  'LUIYI ADRIAN ESCALONA RUIZ',
  'AV: TUPAC AMARU MZ.A LT.10',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41061720',
  'PEREZ MARTINEZ DARSY ADALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '30833967',
  'ASTOCAHUANA QUISPE SARA EDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48881550',
  'MUÑOZ DIAZ YOVANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04023203',
  'LUCCHINE CONDOR ELMER FRANCISCO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07386803',
  'BRAVO ROSAS HOMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40097070',
  'VILLACORTA MANIHUARI CILA OBDULIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72862361',
  'CHIPANA CABALLA JAKELIN FIORELLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '14345256',
  'EDUARDO ANDRES JIMENES PARRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73587497',
  'CHAVEZ VALERIO RUTH GETSABE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40720049',
  'GALAN BORIA PEDRO MARTIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08056438',
  'ALBORNOZ CHEPE DONATA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '15283654',
  'MORI VILLENA MAURO ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22470730',
  'AGUILAR DIAZ AMELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62289968',
  'FLORES BOCANEGRA BERTHA LUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10315026',
  'ROJAS PRADO FRAY ISAC',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10143789',
  'LIZARDO ZUMAETA SEGUNDO FELICIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20560825',
  'MONTAÑEZ RAMOS TOMAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22484836',
  'BURGOS HUERTA CATALINO LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22408278',
  'BURGOS HUERTA VICTOR FILIBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45153669',
  'BURGA BURGOS JACKELINE GIANNINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45572001',
  'CAMPOS ROMAINA JHULIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00121365',
  'MENDOZA RUIZ ROSA ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00130413',
  'CAMPOS ROMAINA BERTHA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00100633',
  'ARMAS SANCHEZ LILIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80108436',
  'NALVARTE CARDENAS MARDONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76847202',
  'MANRIQUE PILLPA ROXANA MIRIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05923438',
  'SILVANO TARICUARIMA NARGARITA ELENA',
  'AH PANCHITO PEZO MZ4 LT8',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47911682',
  'MUÑOZ FLORES REY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74880331',
  'GONZALES CASTAÑEDA CARLOS RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45640914',
  'CARBAJAL PAREDES RENZO JOFRE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05325865',
  'PINEDO RUIZ JULIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08358754',
  'GOMEZ QUISPE WALTER HUGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40943943',
  'MERA MORI HENRRY LEWES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73791209',
  'NAVARRETE SALCEDO JHEYSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46014471',
  'VASQUEZ RIOS WALTER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41826364',
  'CHAVEZ PALOMINO JUAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00081773',
  'GALAN TORRES NORVY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '31883324',
  'FALCON VEGA EMILIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09571284',
  'ARI GIL HECTOR BAYLON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41392209',
  'PORRAS SURICHAQUI MARCOS MARCELINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45145671',
  'AREVALO ARANCIBIA KATTY LUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40184990',
  'PINEDO VELA IRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43722348',
  'GONZALES DEZA YOSSY MARLENI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47270482',
  'PANDURO FLORES DENIS IRMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45972285',
  'JOYA ALVAREZ CHRISTIAN ALEXANDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80390886',
  'YAICATE PIZANGO LURDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71960278',
  'ROMERO VARGAS CRISTIAN EDUARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40740341',
  'MACEDO RODRIGUEZ ELOY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42511819',
  'SHUPINGAHUA PANDURO SULLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10687245',
  'NORIEGA RUIZ EMAFLOR PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04324480',
  'GUEVARA PERALTA VDA DE VEGA MARIA GRACIELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47791316',
  'CORI VEGA LESLY MISHEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44273643',
  'ROMERO AMARINGO ALEXANDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45709087',
  'ARENAS ZEVALLOS CLEYSER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43365926',
  'HUAMAN SILVA NARITA LIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00083781',
  'NORIEGA PAIMA MARCO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44408913',
  'VILLAR ASTUCURI JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09953640',
  'PILLPA BALDEON CARLOS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43635540',
  'ÑAHUINRIPA GASPAR LUIS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77472052',
  'MARZANO PEREZ DILA LILI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80024776',
  'MULLUHUARA ROSALES DALIA FLORA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76587165',
  'NUNTA SANCHEZ ROBERTH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73791210',
  'NAVARRETE SALCEDO ANTHONY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42811143',
  'MENDOZA LINARES CRISTIAN MARTIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45603937',
  'BANEO MORALES VICTORIA KATERINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80156770',
  'MORI VILLENA POLICARPO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00024973',
  'DEL AGUILA TRIGOSO JONAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42111882',
  'FLORES VILLARAN NINFA LUCILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21146813',
  'PINEDO VELA RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76445602',
  'VEGA LAURA ALDO LORENZO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46455938',
  'HUANIO PINEDO TANIA LUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80285668',
  'NORIEGA RUIZ DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00091005',
  'SHUPINGAHUA PANDURO SADITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00022002',
  'LA TORRE RUIZ CLEVER ADOLFO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41500509',
  'LA TORRE TORRES NINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42028857',
  'VEGA GUEVARA JOBSAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73311150',
  'JACHA VEGA JEHU RODOLFO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73311151',
  'JACHA VEGA JHIMY SAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76806296',
  'SIAS ZEGARRA CANDY ALEXANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48376993',
  'SANGAMA POQUIOMA OLGA CONSUELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80440219',
  'BENANCIO CARMEN LINDA NENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '19259585',
  'CUEVA CARRION FREDDY HENRY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00129205',
  'GUEVARA SANCHEZ CLARIZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48302178',
  'ROJAS BERNABE FRANK JHOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41568043',
  'CUTIPA NINA EUDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74557551',
  'LOMAS HUARANGA JUDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43554186',
  'ÑAHUINRIPA GASPAR DOMINGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44594564',
  'ESPINOZA MACEDO MICHAEL ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21327629',
  'JHONNY ALBERTO ESCALONA RUIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47551826',
  'CHAVEZ VALERIO ALEJANDRO CIRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72501864',
  'FALCON BORJA MONICA VICTORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42248353',
  'JAIMES NOBLEJAS CHAVELY LOIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75026173',
  'CABRERA RENDICH CLODOMIRO MACENIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80382936',
  'RENDICH SOTO LIZ VIVIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44706386',
  'BALVIN QUISPE RODRIGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46475642',
  'BALVIN QUISPE MARIVEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00127332',
  'ESPEZA SEDANO DALILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '19922653',
  'ESPEZA VIVANCO MARCELINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00015686',
  'ISLA PANDURO ROBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41683780',
  'PONCE AMBICHO MIRIAM GISELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25848779',
  'GALLESE USSEGLIO JUAN ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23151748',
  'CARPIO SOTO GRACIELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00004897',
  'DA SILVA BARBOZA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10183239',
  'PINCHI OCHAVANO INES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44161110',
  'DAVILA PACAYA VERONICA ROSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10643165',
  'PEZO IBARRA MITZI GIOVANNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00021084',
  'PEZO FLORES CESAR AUGUSTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04807495',
  'VILCA QUISPE DIONICIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00115113',
  'SALCEDO QUISPE MARIA CLEOFE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45629336',
  'CAUPER SOSA LYN ESTEFITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '78014177',
  'NAVARRETE SALCEDO JUANA IRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25710364',
  'LOPEZ GONZALES REYNALDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25723815',
  'GALAN PINEDO EULER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41369671',
  'GRANIZO AGUILAR ZENAIDA NANCY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40307671',
  'SALAZAR RAMOS SANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44974529',
  'DEL RIO SIPIRAN JANETH IRENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22429917',
  'NOBLEJAS NAUPAY NANCY EMMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45104426',
  'PINCHE ANCCO RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44165064',
  'MURAYARI CALAMPA GISELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41551397',
  'VASQUEZ DAVILA NINO ERICK',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46825614',
  'ZUMAETA YLDEFONSO MARILYN PIORINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43045963',
  'HUANIO PINEDO ROSAURA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71055493',
  'GIRALDO SHUPINGAHUA LESLIE STEFANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41017330',
  'LA TORRE TORRES SANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41494891',
  'MAMANI MENDOZA JAQUELINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04328044',
  'VEGA GUEVARA KETTY YESSICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42010880',
  'VEGA GUEVARA JOSE ABRAHAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76667998',
  'LARICO FLORES ELIZABETH BRILLYTH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47804141',
  'BALVIN QUISPE JORGE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40253702',
  'PEZO IBARRA JULIO CESAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41004930',
  'PEZO IBARRA CONSUELO MEDALITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00120544',
  'MENDOZA CAHUAZA LUZ ZOILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08593722',
  'CHAVEZ RUIZ FRANCISCA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73703954',
  'FLORES HOYOS ANTERO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70246818',
  'CANAYO AHUANARI LUCI CARMELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47035616',
  'CACHIQUE ALVA ZOILA YENZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46494190',
  'VELA SILVANO MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41950357',
  'RUIZ VARGAS LIZA MARYE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74280484',
  'SILVA DAHUA JOSHUA SEBASTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42421497',
  'RUIZ CHAVEZ KARINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25019501',
  'PARIONA CRESPO TULA CLARIZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09661241',
  'ALVARADO CANO WILIAM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43462513',
  'MAYLLE ORTIZ LISBET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40183309',
  'GUILLEN HUAMAN CELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45729912',
  'AMESQUITA MONTERO MARIA NELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07969547',
  'GARCIA GODOS NAVEDA CHRISTY AGATHA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45107597',
  'PEZO IBARRA DARLIN GERARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40723771',
  'ALTAMIRANO PEZO OSCAR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45635277',
  'DEL AGUILA HIDALGO LEVI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '18114204',
  'CASTILLO QUEZADA WILFREDO YVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44132536',
  'ALVAN RENGIFO KAREN ROXANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22485190',
  'SALIS MAYLLE CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44785081',
  'DEL CASTILLO ARIMUYA CESAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48420395',
  'URBANO GUEVARA LILIANA LIZETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00047466',
  'ORBE PEREZ AUGUSTA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43480371',
  'MENDOZA RUIZ ROBERTO CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44042545',
  'PALACIOS IGLESIAS DIANA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43203002',
  'SAENZ SAMAME JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73017199',
  'CACERES RUIZ MARIA ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22433319',
  'ROJAS LOPEZ CARLOS RAUL',
  'KM 19 INT. 3500',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00062705',
  'GUPIOC MELO AGUSTIN FRANCISCO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22408296',
  'BURGOS HUERTA JUAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72466998',
  'FALCON BORJA YULIÑO EMILIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46283923',
  'GARCIA ALENCAR JOHNY ANTONI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80324428',
  'FERREYRA DA SILVA MARIA ZENAIDE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00025997',
  'CANAYO AHUANARI OSCAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46513772',
  'ESPEZA SEDANO GLORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71944335',
  'GUTIERREZ QUISPE DORIS MARIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77434224',
  'PARIONA ESPINOZA JIMMY ANGELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77434225',
  'PARIONA ESPINOZA LYN MICHELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41472111',
  'ROMERO VELIZ OSCAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45351792',
  'HURTADO ARMAS MERCEDES NELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45534992',
  'ALIAGA DURAN YHONATAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20703081',
  'MUCHA SOTO GLADYS SONIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45397060',
  'SALAZAR RAMOS TULIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00097117',
  'GODEAU BASTOS LUIS ENRIQUE',
  'JR: HUANCAVELICA # 440 - CALLERIA - CORONEL PORTILLO - PUCALLPA - UCAYALI - PERU - SUR AMERICA - AMERICA - PLANETA TIERRA - SISTEMA SOLAR - UNIVERSO',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41894339',
  'RUIZ HERRERA ABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46891469',
  'CAHUAZA MENDOZA RIQUELMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75683994',
  'ECHEVARRIA HUARANGA BLANCA KAROL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46249567',
  'CARDENAS TENAZOA CARLOS ALFONSO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44941937',
  'MOISES SOTO MARISOL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22985329',
  'MUCHA MINAYA MERCEDES',
  'MARIANO DAMASO BERAUN- LAS PALMAS - TINGO MARIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45714490',
  'SAENZ SAMAME RUBEN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00010188',
  'LAUREL CASTAÑEDA JESUS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43229597',
  'CRUZ ALBORNOZ ROSSY CELINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76406396',
  'MUNAYCO HUANIO MAYORIE EDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44657125',
  'BALBIN QUISPE ROGELIO MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22468368',
  'MENDOZA ROMERO GUILLERMINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46867974',
  'BERROSPI RUIZ ERICK JACKSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40488521',
  'CHINCHAY FERNANDEZ RUSBER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41251216',
  'GUPIOC CONDORI ERICK GERSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40185603',
  'REATEGUI RENGIFO ELIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44867115',
  'FLORES ALDAMA NANCY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75321208',
  'TICLIAHUANCA TOCTO RODY JHOEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44241180',
  'MARIÑO MEZA JESUS NOE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43313036',
  'BERNUY CASMA DE PACHECO KELLY DEL ROSARIO',
  'JR. EL ANIS 4028 AP. V. NARANJAL LIMA-LIMA- INDEPENDENCIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10106756',
  'HUARANCAY ALCARRAZ JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10030575',
  'CCOILLO CUBA MARLENE MARIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00157168',
  'PERALES GOICOCHEA EPIFANIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71340397',
  'DAZA MORALES CAYO NEMIAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73510051',
  'ROJAS MEJIA CLARA LUCERO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '10465254845',
  'INFANTE UPIACHIHUA FRIDA GIANINA',
  'A.H LA GRAN VIA DE MANANTAY MZ 4 LT 11',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08104218',
  'RAMIREZ TANCHIVA JAIRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75520860',
  'RIVERA SULLCA SILVIA MARISOL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46785844',
  'VARA SOLIS ELSA DOMITILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80544499',
  'CUCHUYRUMI APANA LIDIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40434976',
  'FLORES VILLARAN ROSI MARINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42275549',
  'PASTOR RENGIFO LINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22520712',
  'ROJAS MACCHA JOSEFINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42896742',
  'MACEDO MELENDEZ DINA ESTHER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00011343',
  'VILLENA VDA.DE MORI ARMINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77475410',
  'SHUÑA CAMPOS KARINA LIZETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80154202',
  'CAMPOS ROMAINA MARILUZ ESTHER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41278041',
  'GALVEZ SALAZAR CLAUDIA VANESSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00042274',
  'SANCHEZ PAREDES DENINSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45059359',
  'FLORES HUAYTA KELLY BEATRIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00095607',
  'GALAN TORRES JOSE VIDAL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47096574',
  'CHAPIAMEN IPUSHIMA RITA EUGENIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40874634',
  'SANDOVAL ROMERO LISBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40121831',
  'VASQUEZ TAPULLIMA EDITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43324674',
  'BENAVIDES YABAR URSULA LLUDYT',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42995970',
  'SALAZAR RAMOS BALIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '01023719',
  'CABREJOS DELGADO MARCELINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47071581',
  'ARIAS ANTARA CALEB PEDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '33640912',
  'GUERRERO LLANOS DELICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00151737',
  'PERALES GOICOCHEA APOLONIO JOAQUIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46396258',
  'MEDINA RODRIGUEZ JHILBERT RAFAEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07309142',
  'RODRIGUEZ QUINTANA GRICELINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71047317',
  'NOMBRE DEL CLIENTE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71043317',
  'CHAVEZ PERDOMO NATALIN ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22504651',
  'ALBORNOZ CHEPE ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41972188',
  'SALAZAR LLERENA CLAUDIA PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00007882',
  'ARDILES CABALLERO MARIA ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '06204017',
  'SALAZAR AVALOS MATEO MARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46411457',
  'PEREZ DIAZ TEDDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42538304',
  'RONDON ROJAS ABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77048857',
  'BARRERA FLORES ELVA JANINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75823362',
  'ARTEAGA MURRIETA WENDY KAROL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44078408',
  'BERNUY CASMA ROSMERY ZOILA',
  'JR. EL ANIS 4028 EL NARANJAL LIMA-LIMA-SAN MARTIN DE PORRES',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41495405',
  'ALCANTARA ISLA JUAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75562649',
  'FLORES VIDEIRA KEVIN BRAULIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76433580',
  'FUENTES RODRIGUEZ KARLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21147296',
  'PICOTA VARGAS SOILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00025373',
  'DEL CASTILLO ROJAS JUANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00109106',
  'GONZALES PIZANGO WAGNER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42183407',
  'TAPULLIMA TUANAMA WANDERLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76963590',
  'UPIACHIHUA RICHARD JUNIOR JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48595119',
  'GONZALES CENEPO VICTOR ALFONSO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62911960',
  'PIMENTEL TUANAMA ABELARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45324993',
  'MOZOMBITE ALEGRIA LASIDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43919907',
  'RUIZ LOPEZ JORGE ALEJANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71472762',
  'LOZANO GONZALES KAREN MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '31883417',
  'BORJA SILVA PAULINA VICTORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70017225',
  'QUIO VASQUEZ YOSHIRO SANSEY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10727719',
  'CHURA LUCAR ADOLFO LUIS VICENTE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20884413',
  'BARRERA CORDOVA OSCAR ROLANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40298030',
  'VARELA MEZA DAVID JEREMIAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42297566',
  'ACHIC ESPINOZA CESAR RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21147764',
  'CULQUI VASQUEZ JENNY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05330882',
  'MURAYARI RICOPA ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22405724',
  'ZAMBRANO ESPINOZA HILARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22429927',
  'ALBORNOZ CHEPE CATALINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71340396',
  'DAZA MORALES MAYUMI ROXANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76514170',
  'RIOS RENGIFO MARY NEYSI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80480165',
  'ESPEZA SEDANO MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42814398',
  'PEZO IBARRA CARLOS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00094694',
  'PEZO IBARRA NEISER AUGUSTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00111248',
  'PEZO IBARRA JOSE RICARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80656478',
  'PLAZA PACAYA EYNE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00064405',
  'RUIZ PEZO ZOILA NERITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43192327',
  'VEGA CCANTO FELIPE SERAFIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04086235',
  'ESTRELLA VENTOCILLA ELIAS SANTIAGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80676408',
  'ABARCA NASHNATE ROCIO DEL PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73014585',
  'CHAPA VASQUEZ FRIDA STEFANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74587605',
  'GONZALES PANDURO RENZO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72501865',
  'FALCON BORJA YISELA IRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41780244',
  'BARDALES ARAUJO JAQUELINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48349201',
  'HUANIO GUERRA NANY ESTEFANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47615427',
  'JESUS PANDURO NEYDA HOFIR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '04055584',
  'MALPARTIDA FLORES HECTOR RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00043384',
  'RUIZ FIGUEREDO AYDE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43256505',
  'GARCIA LOPEZ LIM JAMES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80136460',
  'REYES HUAMAN RAUL MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40830402',
  'DAHUA GONZALEZ GIULIETA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07377743',
  'YABAR GONZALES YOLANDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41304836',
  'PASTOR RENGIFO MANUEL JESUS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44462543',
  'PINCHI SANDOVAL ISELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43877384',
  'ESPINOZA VILLAORDUÑA GILBERTO',
  'CALLE COMERCIO S/N',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45038205',
  'DIAZ HORNA CINDY GLAIDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25745251',
  'ELIAS TEJADA MARIA YSABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00962720',
  'RABANAL TORRES JENSENS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25827661',
  'AGUILAR MACEDO DOLORES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70120531',
  'MOISES SOTO DANIELA MARITZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09848085',
  'LUJAN MORALES EDGAR ROGER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10505377',
  'BARCO MONDRAGON EMMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40046665',
  'MAYLLE ORTIZ ADMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45459909',
  'PINCHI SANDOVAL AGUEDA MELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '27669565',
  'HORNA VELA YOLANDA EMPERATRIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '18028066',
  'HORNA VELA OMAR ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10604758',
  'MORENO PONCE EDUARDO NICANOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00087848',
  'RUIZ VASQUEZ PEDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75312711',
  'TICLIAHUANCA TOCTO TONY RODY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00130502',
  'TUTUSIMA CARBAJAL LUZ ESMIRNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44069784',
  'PEZO CHOTA RIVER TEDDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40192299',
  'MUÑANTE PEÑA ADELAYDA MARILIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42019101',
  'GRANADOS MESIAS JOSE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48121442',
  'GUILLEN HILARIO JESSICA MAYRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20610704574',
  'DISTRIBUIDORA MULTIPRODUCTS S.A.C.',
  'CAL. CALLE 03 MZA. K LOTE. 6 URB. VILLA DEL CONTADOR LA LIBERTAD TRUJILLO TRUJILLO',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20556188280',
  'FRENOS GUILLEN E.I.R.L.',
  'JR. RAYMONDI NRO. 428 LIMA LIMA LA VICTORIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47962341',
  'SUAREZ BARDALES HOMERO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43003572',
  'DEL AGUILA HIDALGO DELMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72358816',
  'PEREZ SOLSOL MARI DEL CARMEN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47761351',
  'AMARINGO MERA RUBEN ELISEO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23147874',
  'VALERA NUNTA MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42286727',
  'QUISPE CAMPOS VICTOR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40336938',
  'TAPULLIMA TUANAMA CORALITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41438657',
  'PRADO VELA EMILIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76519269',
  'INUMA BAZAN JULIZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48754695',
  'HUAMAN HOJANAMA MAIRA LICENIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22991623',
  'VASQUEZ RIOS NORMA GRACIELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09031387',
  'GONZALES MACEDO MIRZA NOEMI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05845332',
  'VELA JIMENEZ TELMO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45493182',
  'PEREYRA TUTUSIMA IGNACIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45571469',
  'LOPEZ VALERA EDINSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61951661',
  'MOZOMBITE ALEGRIA ANDI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46080180',
  'MATHEWS JARAMILLO GUSTAVO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20610563474',
  'ALIANZA SEGURA S.A.',
  'AV. HABILITACION URBANA MUNIC MZA. K4 LOTE. 19 UCAYALI CORONEL PORTILLO CALLERIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41207892',
  'GUTIERREZ ALLENDE LIDIA LIZETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76238529',
  'MACUYAMA RAMIREZ ROSA ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '81054545',
  'TORRES CAHUAZA ANTHONY KEVIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71535513',
  'COGORNO LAZARTE FAVIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71535520',
  'COGORNO LAZARTE FIORENZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72244788',
  'SEGURA RENGIFO FIORELLA KATIUSKA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48251729',
  'REVOLLEDO SHAPIAMA STEFANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80510262',
  'LOMAS SHAPIAMA JAIME',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40375159',
  'AREVALO HUAYABA ETHEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40316130',
  'SANGAMA MORI MARIA NANCY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70232343',
  'FASABI CACHIQUE ELIBES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44083469',
  'FASABI CACHIQUE ESDRAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61245882',
  'AREVALO HUAYABA BIANCA IVANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76368963',
  'VILLAR CARDENAS BRYAN DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76066013',
  'LOPEZ LABAN ALEXANDRA ROSSIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48430567',
  'RIOS RUIZ DIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40484035',
  'BITIRRE GONZALES RODNEY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44149675',
  'BARRIENTOS CANALES BRADY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08585303',
  'EUSTAQUIO JULCA ALICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76942027',
  'VASQUEZ TAMANI LUIS ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60886015',
  'CAHUANA TAMANI JANINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71340502',
  'TICLIAHUANCA CRUZ AMANDA DEL PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09503552',
  'OLIVOS ROMERO MADELEINE YOLANDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48522301',
  'ESCRIBA MENDEZ YANENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77269740',
  'MAYTA LUCANA BRENDA VIVIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61973202',
  'LOZANO LUCANA BRANDON RICO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74877145',
  'ORTIZ OLIVOS KEILA DANNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74877041',
  'ORTIZ OLIVOS LUZ KARLA STEFANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43084261',
  'PEREZ LANCHI CARMINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40632504',
  'ZEGARRA FARFAN LIZETH YOVANNA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00025459',
  'FARFAN VDA. DE BARRETO MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43122159',
  'SANCHEZ SANCHEZ JHERAN AVI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07049320',
  'OLIVOS ROMERO PAUL NEMESIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23172533',
  'LUCANA HUACCALSAICO FELIX',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43919921',
  'AREVALO TORRES KELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71722862',
  'FERNANDEZ RAMIREZ TONY FERNANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43657851',
  'CARRASCO RAMIREZ ADAN SEGUNDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71073634',
  'GUDIEL PAREDES ANALI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75127031',
  'PINEDO AVILA BRENDA LUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73963902',
  'TAPULLIMA SINARAHUA ELLER ANDREI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21141256',
  'CORDOVA LOPEZ GELMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47080158',
  'NACIMENTO CASTILLO FAVIOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75243628',
  'PINEDO TUCTO MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47520862',
  'DIAZ ZAMORA CARLOS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42625088',
  'POZO HUAMAN YANET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47755489',
  'RAMIREZ AREVALO RANDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40793885',
  'GARAY ACOSTA JOHN PAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77291011',
  'LOPEZ DE LA CRUZ CARLOS FERNANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '17633683',
  'ROQUE SANTAMARIA ALEXANDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75731867',
  'CERAS ROJAS ODILIA SOLEDAD',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45536921',
  'TORREJON CUMAPA OSCAR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46849405',
  'SAJAMI PANAIFO JENISE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60014244',
  'PEZO BANEO SCARLY MARISEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73811022',
  'PINCHI MENDOZA ANGEL ADRIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60755557',
  'PINCHI MENDOZA ABEL ANGEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41618239',
  'ARBILDO CAHUAZA KARIN DEL ROSARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47384201',
  'YUMBATO MENDOZA JHENY LUISA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46779104',
  'HUAMAN SILVA RUTH VANY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48244052',
  'PEÑA PIZANGO GRECIA VICTORIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20100154',
  'VELIZ MEZA JONAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '20050282',
  'VELIZ MEZA PRISCILIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70692103',
  'SINTI OCHAVANO EDWARD JOAO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70747258',
  'RIOS MENDOZA RAY JESUS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76355039',
  'TAPULLIMA SINARAHUA GILMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42584944',
  'VASQUEZ BOCANEGRA JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73789651',
  'LOBO SHAPIAMA JORGE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45749358',
  'HUAMAN SANTOS ARMANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46912288',
  'FERNANDEZ ALVAREZ ELVIS KEVIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22507575',
  'CASTAÑEDA FERNANDEZ JHON MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25738317',
  'MONCADA RUIZ DE MELGAREJO OLINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00046725',
  'RUIZ DE MONCADA ROSALVINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44879071',
  'HUERTA VELASQUEZ DENESSI LIZETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25763665',
  'MONCADA RUIZ SANDRA ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73372113',
  'COLLANTES MONCADA JORGE MIGUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44109878',
  'CHARI QUINCHOKER DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70932341',
  'LOPEZ MORENO HEULER NEYSER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70932041',
  'COLLADO ALVAREZ JAHAYRA ARACELI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00109749',
  'MONCADA RUIZ ALMA KARINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46288509',
  'RENGIFO ARIMUYA WILDER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21148077',
  'MOJALOTT DAVILA GERTRUDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09593784',
  'MORENO MENDEZ ROSA MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71821542',
  'CORDOVA TEJADA FLOR DE MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42865070',
  'SILVA PACAYA LUIS DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23682274',
  'ROJAS JACOBI CENAYDA ODILIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47291655',
  'CERAS ROJAS ALEXSANDERS EDWARD',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46726243',
  'ROJAS JACOBI ALFREDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10353693',
  'ROJAS JACOBI ABDON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46137007',
  'JARA HUAYNACARI MILUSKA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47684706',
  'BANDA ANGASPILCO MYRIAM DANIELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46202214',
  'DAVILA NOVOA ANTONY',
  'ALMENDRAS MZ D LT 01',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77037591',
  'SALAZAR LOYOLA CRISTHOFER DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22431753',
  'ROJAS ESPINOZA ANTONIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48111639',
  'TAPULLIMA SALAS MISAEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48478670',
  'UPIACHIHUA RICHARD GEYSI JASSMIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42878057',
  'LOPEZ ROMAYNA CHRISTOPHER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46399069',
  'VASQUEZ QUISPE LUIS ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  'ab74735c-ac6b-11f1-8ce6-3bee5f2b9482',
  '20601695333',
  'ASEM LOAMMY S.A.C.',
  'AV. HAB. URB. MUNICIPAL MZA. K4 LOTE. 19 UCAYALI CORONEL PORTILLO CALLERIA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45067473',
  'ALIAGA NAVARRO ANGEL JAMES WARNER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42255382',
  'AVENDAÑO VALDIVIA MARITZA JACKIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42575329',
  'PEZO VELA MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47015711',
  'SHAPIAMA RIOS DEIVY IVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72941905',
  'VALDEZ ESPINOZA JHONATAN MAURO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70775897',
  'SOLIS AREVALO YURIVAN SANEIRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71043378',
  'HUAPAYA RIVAS WINIFRED SYBERIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43467384',
  'TORRES BARBOZA ELMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45180500',
  'PADILLA ZUMAETA HORINSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00114946',
  'RIVAS RENGIFO ERIKA MAGALI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61787457',
  'RENGIFO SILVA CARLOS PAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45750214',
  'SHAPIAMA TUANAMA CUARTO FRANCISCO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76001430',
  'SHUPINGAHUA ROJAS SARA RAQUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46761201',
  'LEON PAUCAR BALTAZAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62898070',
  'SILVA SILVANO RITA MERCEDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73640445',
  'ANCHELIA DOMINGUEZ ZENON TORIBIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47396343',
  'GONZALES SATALAYA ANALI DELLANIRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75288779',
  'DAVILA PANDURO ZOILA ABIGAIL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41843546',
  'MOJALOTT CABALLERO FREDDY LENIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43438377',
  'TUESTA SAJAMI MESEDITA ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40774790',
  'QUIROZ DIAZ BERTHA MARLENE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44139571',
  'SANGAMA ROMERO MENCES',
  'AA. HH LAS BRISAS DE MANANTAY MZ 1 LT 2',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80324328',
  'GONZALES ZUÑIGA RENGIFO LUZ ESTELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48661128',
  'GARCIA ASPAJO XIOMY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42835662',
  'CARDENAS GARCIA ALAN JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74152033',
  'TORRES PINEDO ANTONY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76871153',
  'GUTIERREZ OJANAMA SAHIRA YERALDI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00043625',
  'DELGADO VELA LIGIA ANGELICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43991044',
  'DAMIAN DELGADO RONAL DEIVIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00023811',
  'DIAZ CHAVEZ DOLLI ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76477953',
  'GUTAPAÑA PERDOMO BEBERLY TREYSY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42514163',
  'VALDIVIA CURICO JOSE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00011365',
  'VASQUEZ GARCIA DINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80570903',
  'VASQUEZ GARCIA TEOFILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00100310',
  'VASQUEZ GARCIA BENJAMIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47294699',
  'SOSA AMASIFUEN FREDDY KEEN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '78271767',
  'DAVILA RENGIFO FRANK',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05866156',
  'RUCOBA PANDURO MARIBEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '90081518',
  'RECOBA CHAVEZ MARIA CRISTEL',
  'AA.HH LAS BRISAS DE MANANTAY MZ 1 LT 2',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44785121',
  'GOMEZ DIAZ MAIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76960314',
  'CASTILLO ALIPAZAGA DINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61659590',
  'IÑIPE TAPULLIMA MICHAEL MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00081936',
  'HIDALGO MENDOZA GUILLERMO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72650792',
  'SILVA DAHUA ARACELI YAMILE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72729947',
  'ROJAS ROJAS HILDA FLOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61245475',
  'PAREDES RUIZ LEYDI DAMARIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47360470',
  'MURAYARI RAMIREZ JUAN JOSE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09570701',
  'ROJAS JACOBI EUGENIA GENOVEVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42089860',
  'ESPINOZA YUPANQUI SIMON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00127647',
  'SEGOVIA QUISPITIRA JUANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10617893',
  'CASO PUENTE LUPE SUSY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72874693',
  'VICHARRA MONCADA ALMA ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75397993',
  'PEREZ GUILLEN JENNIFER ALEJANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41232534',
  'POZO HUAMAN IVAN IDNER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76581617',
  'ARCOS QUIROZ RENZO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44072562',
  'PINEDO JIMENEZ MAXIMO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76014478',
  'CARDENAS ALVARADO MONICA REGINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23014778',
  'CISNEROS MARTINEZ JUAN ARMANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48526183',
  'CHUQUIPIONDO GONZALES LINDA MARIANITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00026669',
  'RUIZ RIMACHI NEIDE MARGOLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71442873',
  'SAJAMI LOPEZ ALEX DELLYANE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05920676',
  'LOPEZ SILVA AMANDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05926222',
  'LOPEZ SILVA DE SAJAMI SANDRIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46108869',
  'CARDENAS MURAYARI MERCY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45263503',
  'LEON AGUILAR ROCIO ROXANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '70915028',
  'RAMIREZ CHAVEZ LUCY STEFANI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76150348',
  'RAMIREZ CHAVEZ JUAN CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60511857',
  'SOZA MONTOYA LINA ROSARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45581150',
  'LOPEZ HUANIO ELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00099257',
  'CHAVEZ MOZOMBITE OLGA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43197510',
  'PISCO VASQUEZ CANDELARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45986067',
  'CARDENAS ALMINAGORDA JHON CRISTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '78721375',
  'LLERENA ROJAS ELKY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42492853',
  'RAMOS PRINCIPE YENI ELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48516118',
  'AMARO GUERRA JORDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43675707',
  'CANTARO SABINO EDITH ROSAURA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40030561',
  'DE SOUZA MORENO JOHAN MARX',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00125327',
  'SORIA MACAHUACHI DORITA MILAGROSA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45591814',
  'SANCHEZ LOPEZ RICARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72637588',
  'SILVA DAHUA SAHARI NICOLE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76380778',
  'DE LA CRUZ FLORES ARAMIS MCKEY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45792366',
  'CARRERA LOPEZ DIANA CAROLINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62908323',
  'GONZALES VARGAS MARILIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73389252',
  'VILLACREZ RUIZ MELIDA REINERIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76545559',
  'DEL AGUILA RAMOS CLAUDIA FIORELLA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73389259',
  'SORIA RAMIREZ MARCO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48673473',
  'PAREDES OJANAMA JELSIN SADAMIR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43818230',
  'RAMOS PRINCIPE ALICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77816058',
  'GONZALES ROJAS JIN BERLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48095395',
  'PEZO GUERRA LANDY MIRELLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41088307',
  'LOPEZ SILVA VICTOR HUGO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '78108219',
  'SICCHA VEINTEMILLA GRACE MARGARITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41389990',
  'TAPULLIMA FONSECA DINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42819369',
  'TAPULLIMA FONSECA WILLER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42891634',
  'TORREJON CUMAPA JORGE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47464720',
  'GAMA VASQUEZ DENNIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00126790',
  'CAMACHO ESQUIVEL LUIS ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00080323',
  'DAVILA RAMIREZ LIZANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00106019',
  'VILLACORTA IHUARAQUI MIGDALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23147230',
  'CHAVEZ MOZOMBITE LISBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41712352',
  'RODRIGUEZ PEREYRA LEONARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76045223',
  'AGUILAR CARRILLO YELSTIN MAO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40254270',
  'AREVALO ROCHA MERY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76866736',
  'GUTIERREZ OJANAMA RICK PAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74876010',
  'BRAÑEZ LOPEZ LUIS ESTEFANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76237723',
  'GARCIA CUCHICHINARI KATHERINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47696793',
  'CHOTA UPARI ORFITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00101514',
  'ALIPAZAGA BARTRA DE CASTILLO SILVIA DORILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80506045',
  'CASTILLO MENDOZA ELIAS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44333923',
  'SAUCEDO VILLANUEVA JESSICA MILY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00112852',
  'RAMIREZ CASTRO LILY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46776631',
  'CACHA APOLINARIO ROSMEL JESUS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47607294',
  'SAAVEDRA PIEDRAS DE REATEGUI JEY ANDREA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42768543',
  'SABOYA DAVILA JHOVANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00967047',
  'JESUS MORIANO FELIX',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71777296',
  'CAPCHA ROMERO LUIS ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22516501',
  'ROJAS ESPINOZA BELSAIDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46239857',
  'CACHIQUE TRIVEÑO DE ROJAS JACKELINE PETRONILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46949658',
  'VASQUEZ RUIZ JUAN CRUICER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00117560',
  'CUEVA SILVANO LIZANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60566756',
  'DEL AGUILA HIDALGO JOILER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44273652',
  'DATOS DEL CLIENTE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45150656',
  'GARCIA PISCO ROSA ELVIRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00101501',
  'PINEDO MURRIETA MANASES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00063581',
  'PAREDES CARDENAS ALDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21857174',
  'FLORES ARAUJO JANINA BEATRIZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71468190',
  'BARCO ARIRAMA MARIETH CIELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62980101',
  'TAMANI ROJAS BRENDA DIANDRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42547598',
  'MOJALOTT CABALLERO JOSE ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41187645',
  'ISUIZA AMASIFUEN ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76869323',
  'MARAVI VALENCIA NOE SAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23003807',
  'MORI PINEDO MARIA TEODOLINDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00152270',
  'SAUCEDO CHAVEZ JOSE SANTOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41895431',
  'ROJAS ROJAS LIZ IVONE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73470608',
  'ARCA ORMEÑO JESUS MARTIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '25714474',
  'PEÑA URDIALES SANTOS HERNAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77693054',
  'HUAMANI CUEVA JORGE ARMANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76278314',
  'ROJAS CACHIQUE CAMILA MARICIELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76465275',
  'JORDAN GALVEZ CLAUDIA ANDREA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48784325',
  'LUNAREJO OJANAMA LINDA LOYDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '10673238',
  'COMETIVOS RAMIREZ ELVIS SANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45458418',
  'QUIROZ SHAPIAMA ROBERTO DEIVY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42041599',
  'GOMEZ DIAZ VICTOR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45829702',
  'PIZANGO PANDURO JOSE DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76368851',
  'PIZANGO PANDURO LUIS AMERICO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44904416',
  'SANTILLAN GARCIA DE GONZALES JUANA MADAI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09984925',
  'JAIMES ESQUIVEL EDITH NOYDE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76256957',
  'FONSECA RIOS YARITZA YUMIRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71223631',
  'HUAMAN VELA CARLA ESTEFANI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77322335',
  'FLORES VASQUEZ JHODERAY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42969556',
  'MORIN NINA DARWIN LESTER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46471887',
  'ZAGACETA ALEGRIA WENDY SUSAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43370034',
  'DONAYRE QUINTANA LUIS IVAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72350442',
  'GONZALES MENDOZA EVELYN LORENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72176182',
  'PANDURO SANCHEZ ANGELINA ISABEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47551554',
  'WONG CHAGUA RAISA YUSARA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21140726',
  'ARCOS VELASQUEZ VICTOR ALBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73624420',
  'LOPEZ DIAZ KEVIN JUAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00098249',
  'ALEMAN GONZALES CLARA LUCY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47710863',
  'ESPINOZA RUIZ RUTH NATALY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73603883',
  'GORMAS ARANDA GABI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75753479',
  'VARGAS GUERRA MILAGROS ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42646004',
  'MACUYAMA PUA ROSA ANGELICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '81318952',
  'CASTILLO ALIPAZAGA ULISES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48535881',
  'SAN MARTIN OJANAMA LUCERO SARAI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46398421',
  'ODICIO DEL AGUILA NEDA YULY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '32920248',
  'SICCHA RUIZ ROBER WILFREDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '06807604',
  'SOLANO ALEGRIA JADIER EDGARD',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44615648',
  'TAPULLIMA FONSECA ANGELA JOSEFA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47230675',
  'NUNTA SANCHEZ SADITH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00416093',
  'PICHIHUA PESUA CARMEN ELENA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41281498',
  'FLORES CAMPOS SHIRLEY LADY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41701278',
  'ROMERO MARIÑO ROSA LUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45950509',
  'NOBLEJAS SEDANO JOSE MARCELO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73903872',
  'SILVA REATEGUI JAMES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72877493',
  'URQUIA SEIJAS JOFSE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00089793',
  'RIOS CORDOVA SONIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75777329',
  'SANCHEZ CARRANZA MARIA ESPERANZA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71435249',
  'AMASIFUEN RIOS ATHAMAYCA ARELI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80325323',
  'PICON SANCHEZ JOSE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71347666',
  'PANDURO MACEDO PAULO CESAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71053090',
  'SAAVEDRA GUTIERREZ GUSTAVO ENRIQUE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00065950',
  'SALAS VASQUEZ ORLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40257850',
  'CCALLOCSA HUAMANI HIPOLITO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48854474',
  'CCACCALA MAYHUIRI ELIZABETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41788566',
  'ROJAS RAMOS CARLOS EDUARDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44724410',
  'JESUS GUERRA ANTHONY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40425201',
  'PADILLA SANGAMA PITER JHON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43276012',
  'HUAMANI HUAMANI HUGO PIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72120998',
  'RAMOS SABOYA GEYSON RAUL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76377193',
  'MACEDO ROJAS MAX MARCELINO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43682520',
  'CHOQUEHUANCA GUEVARA JHOANY MAGALI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07631472',
  'GUERRA PATRICIO PRIMITIVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '74844692',
  'MUÑOZ GUERRA CARLA JAQUELINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44354636',
  'YUMBATO MENDOZA HENRY RONEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05340761',
  'MENDOZA FLORES ESTEFITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80412184',
  'RIOS VALERA LEYNY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '09834417',
  'AQUINO CHUQUICHAICO WILMER MAXIMO',
  'MZ. A LT. 38 URB. COCHARCAS LA CAMPIÑA',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60637293',
  'SINACAY TARICUARIMA SEILITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44762180',
  'APONTE JAIMES MELISSA MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47273469',
  'SORIA VELA ELDITH JASMINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '05328573',
  'RUIZ SILVA MERCEDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61345525',
  'AMASIFUEN ZEGARRA EMELY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60148659',
  'CURO CHAHUA WILBER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23174171',
  'RAMIREZ AREVALO JUAN MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80142594',
  'PANDURO LOMAS CARMEN BEIVA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48773167',
  'RIOJA VIENA TANIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76642135',
  'LAPA UNOCC NINANDO ROGENDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42879169',
  'GONZALES MOZOMBITE MELITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60704146',
  'PAPAS PACOMPIA ELMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42690743',
  'CENTENO ARRATEA JERONIMO FRANKLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72303228',
  'SOLANO PORRAS JASSIRA PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00098178',
  'TAPULLIMA FONSECA PETRONILA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47821202',
  'MACUYAMA MANIHUARI SUSAN PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41088314',
  'RENGIFO RAMIREZ NILTON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43440381',
  'MACEDO ROJAS ROQUI ROOBLES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '73776957',
  'PAREDES GONZALES NATALI GERALDINE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40352349',
  'RIOS VALERA ANAHI',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48895027',
  'CASTILLO PALACIOS BONNET',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42142902',
  'AMASIFUEN GARCIA YRMA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72436778',
  'FLORES GUERRA YERALDI MIJAL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '71262949',
  'MENDOZA SALAZAR JORGE LUIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43398268',
  'RENGIFO PANAIFO LUZ HERLINDA',
  'URB. TRES HORIZONTES MZ A LT 18',
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45992157',
  'SALINAS VASQUEZ KATTIA MARICRUZ',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08999984',
  'ROJAS DOMINGUEZ EDITH MILAGROS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '49031505',
  'GONZALES VARGAS JOSELIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00104762',
  'DELGADO DE DE LA GALA ANA MARIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44631664',
  'ZEVALLOS BEDOYA ALICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48783133',
  'FLORIANO RUIZ JENS JAVIER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72859249',
  'ZUMAETA VIZCARRA DEUSSA SABINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42796039',
  'TUANAMA AMASIFUEN JESSICA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46721128',
  'PACAYA RAMOS OMAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42176435',
  'MEDINA SALAZAR JUAN ALEJANDRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48538656',
  'ROJAS VARGAS GISELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62030992',
  'SAAVEDRA CASTRO GUILLERMO MANUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00185779',
  'MAMANI LAURA LEONCIO BALERIANO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '43242679',
  'CHUQUIBALQUI RIVAS FRANKLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47820065',
  'ISUIZA PAPA FRANKLIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22716351',
  'ROMERO ORIZANO ANDRES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '33250257',
  'FLORES BERNUY TORIVIO CRESPIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '77083274',
  'PANAIFO FLORES SIXTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76915299',
  'PANAIFO FLORES MARCO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48734789',
  'ROJAS VARGAS DELLANIRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47424795',
  'CAHUACHI QUEVEDO ANA IRIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41776072',
  'FLORES GALVAN YENNYFER PAMELA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62589443',
  'EGOAVIL ASIPALI RUTH LEA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '08734575',
  'VASQUEZ CANTURIN FLORENTINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48717039',
  'RUIZ ENCINAS MIGUEL ANGEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42316826',
  'BARDALES DASILVA CRISTIAN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75721799',
  'RIOS LOPEZ USMAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22435311',
  'GARCIA BUSTAMANTE AIROPAGITA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44782740',
  'TUCTO GARCIA LOURDES HANINA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '07521903',
  'GAMARRA LOZANO HIPOLITO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41168823',
  'OCANA IJUMA DOLLY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45355746',
  'LOPEZ CACHIQUE JUAN BAUTISTA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22972013',
  'TRUJILLO ROMERO MARIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21145877',
  'TENAZOA AHUANARI DANIEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61246288',
  'MARTINEZ PIÑA ROBERTO CARLOS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00046623',
  'TRUJILLO ROJAS RAYDA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42394363',
  'CAYCHO TRUJILLO HENRY FELIPE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75772446',
  'MORENO POLAR ANGIE PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45495899',
  'TORRES DEL AGUILA ANDREA VIRGINIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '23148395',
  'TORRES SANCHEZ ROBERTO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76299291',
  'PACHECO JAIMES KERLY YAJAYRA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47866619',
  'ALVARADO JONES MARITZA THALIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61809939',
  'PANAIFO FLORES LUCY LIZBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42337507',
  'DE LA GALA DELGADO TANY BELL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72618989',
  'GOMEZ PEREYRA PAOLO JIM',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '40295118',
  'MENDOZA FLORES ROMEL JAIRO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44997549',
  'PANAYFO TANANTA ARNULFO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47189201',
  'TUCTO GARCIA LILI LOURDES',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00127397',
  'RAMIREZ RAMOS CARLO DARWIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48783410',
  'GONZALES VARGAS KATERIN',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48655700',
  'MURAYARI YAICATE JOSE FRANCISCO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00023246',
  'REATEGUI ARMAS RAUL MIGUEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75525971',
  'ACOSTA MELGAREJO YURICSA VERENICE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '80088950',
  'RIVERA MORI MIGUEL ANGEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '75550602',
  'HUAMANI FERNANDEZ HUGO FERNANDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '06688332',
  'ANDRADE OTOYA ARNALDO ANTONIO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '62589876',
  'NONATO ZEGARRA JUAN FRANK',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45510385',
  'SALAZAR CAICEDO ELMER',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '21426769',
  'MEGO DE LA CRUZ ELVIS FREDY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '76380565',
  'VELASQUEZ MANRRIQUE ONIL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '72022904',
  'TRISTAN GONZALES CRIS FRANCIS',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '46947900',
  'MARRACHE PINEDO EDINSON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42174729',
  'TUANAMA AMASIFUEN PATRICIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '47770579',
  'DAVILA VILLALBA GREGORY UBALDO',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '48647481',
  'ZEVALLOS RIOS BETSI LISBETH',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00152812',
  'ENCINA GONZALES CELIA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '44864845',
  'FLORES ESTRADA EBER ROSMEL',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '41587061',
  'IZQUIERDO HIDALGO LISBETH DEL PILAR',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '27081372',
  'COTRINA CONDOR DAVID',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '42839286',
  'SARMIENTO NOREÑA JAMER CASELY',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '61918124',
  'RAMIREZ AREVALO MILTON',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '45679522',
  'TAPULLIMA SINARAHUA PAUL DONALD',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '22716869',
  'MEZA FRANCISCO SEBASTIANA',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '00888785',
  'TAPULLIMA ISHUIZA FELIPE',
  NULL,
  NULL,
  NULL,
  1
);

INSERT INTO cliente (emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_direccion, cli_celular, cli_email, estado)
VALUES (
  '0471cf4c-ac6a-11f1-8aec-67000e264cb6',
  '72bc07ec-ac65-11f1-8ce2-c3eb66672310',
  '60568363',
  'TORRES CCACCALA LUCIANO',
  NULL,
  NULL,
  NULL,
  1
);

COMMIT;