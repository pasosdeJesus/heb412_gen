# frozen_string_literal: true

class ReportesUsuario < ActiveRecord::Migration[5.2]
  def up
    execute(<<-SQL)
      INSERT INTO heb412_gen_plantillahcm (id, ruta, fuente, licencia,#{" "}
        vista, nombremenu, filainicial) VALUES (10,#{" "}
        'plantillas/listado_usuarios.ods', 'Pasos de Jesús',#{" "}
        'Dominio público de acuerdo a legislación colombiana',#{" "}
        'Usuario', 'Listado completo de usuarios', 4);

      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (301, 10, 'id', 'A');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (302, 10, 'nusuario', 'B');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (303, 10, 'nombre', 'C');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (304, 10, 'descripcion', 'D');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (305, 10, 'rol', 'E');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (306, 10, 'correo', 'F');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (307, 10, 'idioma', 'G');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (308, 10, 'condensado_de_clave', 'H');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (309, 10, 'fechacreacion', 'I');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (310, 10, 'fechadeshabilitacion', 'J');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (311, 10, 'creacion', 'K');
      INSERT INTO heb412_gen_campoplantillahcm (id, plantillahcm_id,#{" "}
        nombrecampo, columna) VALUES (312, 10, 'actualizacion', 'L');


      INSERT INTO heb412_gen_plantillahcr (id, ruta, fuente, licencia,#{" "}
        vista, nombremenu) VALUES (10, 'plantillas/reporte_usuario.ods',#{" "}
        'Pasos de Jesús', 'Dominio Público', 'Usuario',#{" "}
        'Reporte de un usuario en hoja de cálculo');

      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (320, 10, 'nusuario', 'B', 3);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (321, 10, 'id', 'D', 3);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (322, 10, 'nombre', 'B', 4);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (323, 10, 'descripcion', 'B', 5);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (324, 10, 'rol', 'B', 6);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (325, 10, 'idioma', 'B', 7);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (326, 10, 'fechacreacion', 'B', 8);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (327, 10, 'fechadeshabilitacion',#{" "}
        'D', 8);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (328, 10, 'creacion', 'B', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (329, 10, 'actualizacion', 'D', 9);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (330, 10, 'correo', 'D', 6);
      INSERT INTO heb412_gen_campoplantillahcr (id, plantillahcr_id,#{" "}
        nombrecampo, columna, fila) VALUES (331, 10, 'condensado_de_clave',#{" "}
        'D', 7);


      INSERT INTO heb412_gen_plantilladoc (id, ruta, fuente, licencia,#{" "}
        vista, nombremenu) VALUES (10, 'plantillas/reporte_usuario.odt',#{" "}
        'Pasos de Jesús', 'Dominio Público', 'Usuario',#{" "}
        'Reporte de un usuario en documento');

    SQL
  end

  def down
    execute(<<-SQL)
      DELETE FROM heb412_gen_campoplantillahcm WHERE plantillahcm_id=10;
      DELETE FROM heb412_gen_plantillahcm WHERE id=10;

      DELETE FROM heb412_gen_campoplantillahcr WHERE plantillahcm_id=10;
      DELETE FROM heb412_gen_plantillahcr WHERE id=10;

      DELETE FROM heb412_gen_plantilladoc WHERE id=10;
    SQL
  end
end
