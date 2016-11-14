# encoding: UTF-8
module Heb412Gen
	class Ability  < Sip::Ability

    BASICAS_PROPIAS = []

    BASICAS_ID_NOAUTO = []
    # Hereda @@basicas_id_noauto de sip
   
    NOBASICAS_INDSEQID =  []
    # Hereda @@nobasicas_indice_seq_con_id de sip
   
    BASICAS_PRIO = []
    # Hereda @@tablasbasicas_prio de sip

    # Retornar acciones relacionadas con plantillas
    # En el ability principal debe definirse @@acciones_plantillas
    def self.acciones_plantillas
      @@acciones_plantillas
    end

	end
end
