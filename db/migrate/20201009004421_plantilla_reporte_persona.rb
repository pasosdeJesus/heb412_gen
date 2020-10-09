class PlantillaReportePersona < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      INSERT INTO public.heb412_gen_plantillahcr (id, ruta, fuente, licencia, vista, nombremenu) VALUES (7, 'plantillas/reporte_persona.ods', 'Pasos de Jesús', 'Dominio Público', 'Persona', 'Datos de persona');

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
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM heb412_gen_campoplantillahcr WHERE id>=700 AND id<=712;
      DELETE FROM heb412_gen_plantillahcr WHERE id=7;
    SQL
  end
end
