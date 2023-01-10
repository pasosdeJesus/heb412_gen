# frozen_string_literal: true

Mime::Type.register("application/vnd.oasis.opendocument.text", :odt)
Mime::Type.register("application/vnd.oasis.opendocument.spreadsheet", :ods)
Mime::Type.register("application/vnd.oasis.opendocument.presentation", :odp)
Mime::Type.register("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx)
Mime::Type.register("application/vnd.openxmlformats-officedocument.wordprocessingml.document", :docx)
