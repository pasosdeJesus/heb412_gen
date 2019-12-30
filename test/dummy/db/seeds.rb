# encoding: UTF-8

conexion = ActiveRecord::Base.connection();

# De motores
motor = ['sip', 'mr519_gen', '../..', nil]
motor.each do |m|
    Sip::carga_semillas_sql(conexion, m, :cambios)
    Sip::carga_semillas_sql(conexion, m, :datos)
end

# Usuario para primer ingreso heb412, heb412
conexion.execute("INSERT INTO public.usuario 
	(nusuario, email, encrypted_password, password, 
  fechacreacion, created_at, updated_at, rol) 
	VALUES ('heb412', 'heb412@localhost', 
	'$2a$10$FdubMrU.LZmkqMCFIaVXWORiOIQAM8/AqRrlC3SlkKsiZNCV/mmpC',  
	'', '2014-08-14', '2014-08-14', '2014-08-14', 1);")

