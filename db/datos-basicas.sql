-- Volcado de tablas basicas

INSERT INTO public.heb412_gen_plantillahcm (id, ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (10, 'plantillas/listado_usuarios.ods', 'Pasos de Jesús', 'Dominio público de acuerdo a legislación colombiana', 'Usuario', 'Listado completo de usuarios', 4);
INSERT INTO public.heb412_gen_plantillahcm (id, ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (12, 'plantillas/listado_personas.ods', 'Pasos de Jesús', 'Dominio público de acuerdo a legislación colombiana', 'Persona', 'Listado completo de personas', 4);
INSERT INTO public.heb412_gen_plantillahcm (id, ruta, fuente, licencia, vista, nombremenu, filainicial) VALUES (13, 'plantillas/listado_organizacionessociales.ods', 'Pasos de Jesús', 'Dominio público de acuerdo a legislación colombiana', 'Orgsocial', 'Listado completo de organizaciones sociales', 4);


SELECT pg_catalog.setval('public.heb412_gen_plantillahcm_id_seq', 100, true);



INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (301, 10, 'id', 'A');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (302, 10, 'nusuario', 'B');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (303, 10, 'nombre', 'C');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (304, 10, 'descripcion', 'D');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (305, 10, 'rol', 'E');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (306, 10, 'correo', 'F');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (307, 10, 'idioma', 'G');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (308, 10, 'condensado_de_clave', 'H');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (309, 10, 'fechacreacion', 'I');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (310, 10, 'fechadeshabilitacion', 'J');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (311, 10, 'creacion', 'K');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (312, 10, 'actualizacion', 'L');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (121, 12, 'id', 'A');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (122, 12, 'nombres', 'B');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (123, 12, 'apellidos', 'C');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (124, 12, 'numerodocumento', 'E');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (125, 12, 'sexo', 'F');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (126, 12, 'pais', 'H');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (127, 12, 'departamento', 'I');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (128, 12, 'municipio', 'J');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (130, 12, 'clase', 'K');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (131, 12, 'nacionalde', 'L');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (132, 12, 'creado_en', 'M');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (133, 12, 'actualizado_en', 'N');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (134, 12, 'fechanac_localizada', 'G');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (135, 12, 'tdoc', 'D');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (140, 13, 'id', 'A');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (141, 13, 'nombre', 'B');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (142, 13, 'sectores', 'C');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (143, 13, 'pais', 'D');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (144, 13, 'direccion', 'E');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (145, 13, 'telefono', 'F');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (146, 13, 'fax', 'G');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (147, 13, 'web', 'H');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (148, 13, 'anotaciones', 'I');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (149, 13, 'creado_en', 'J');
INSERT INTO public.heb412_gen_campoplantillahcm (id, plantillahcm_id, nombrecampo, columna) VALUES (150, 13, 'actualizado_en', 'K');


SELECT pg_catalog.setval('public.heb412_gen_campoplantillahcm_id_seq', 10000, true);



INSERT INTO public.heb412_gen_plantillahcr (id, ruta, fuente, licencia, vista, nombremenu) VALUES (10, 'plantillas/reporte_usuario.ods', 'Pasos de Jesús', 'Dominio Público', 'Usuario', 'Reporte de un usuario en hoja de cálculo');
INSERT INTO public.heb412_gen_plantillahcr (id, ruta, fuente, licencia, vista, nombremenu) VALUES (7, 'plantillas/reporte_persona.ods', 'Pasos de Jesús', 'Dominio Público', 'Persona', 'Datos de persona');


SELECT pg_catalog.setval('public.heb412_gen_plantillahcr_id_seq', 101, true);



INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (320, 10, 'nusuario', 'B', 3);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (321, 10, 'id', 'D', 3);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (322, 10, 'nombre', 'B', 4);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (323, 10, 'descripcion', 'B', 5);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (324, 10, 'rol', 'B', 6);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (325, 10, 'idioma', 'B', 7);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (326, 10, 'fechacreacion', 'B', 8);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (327, 10, 'fechadeshabilitacion', 'D', 8);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (328, 10, 'creacion', 'B', 9);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (329, 10, 'actualizacion', 'D', 9);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (330, 10, 'correo', 'D', 6);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (331, 10, 'condensado_de_clave', 'D', 7);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (700, 7, 'id', 'B', 6);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (701, 7, 'nombres', 'B', 8);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (702, 7, 'apellidos', 'D', 8);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (703, 7, 'tdocumento', 'B', 9);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (704, 7, 'numerodocumento', 'D', 9);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (705, 7, 'fechanac_localizada', 'B', 10);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (706, 7, 'sexo', 'D', 10);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (707, 7, 'pais', 'B', 11);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (708, 7, 'departamento', 'D', 11);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (709, 7, 'municipio', 'B', 12);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (710, 7, 'centro_poblado', 'D', 12);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (711, 7, 'creado_en', 'B', 14);
INSERT INTO public.heb412_gen_campoplantillahcr (id, plantillahcr_id, nombrecampo, columna, fila) VALUES (712, 7, 'actualizado_en', 'D', 14);

SELECT pg_catalog.setval('public.heb412_gen_campoplantillahcr_id_seq', 10000, true);

