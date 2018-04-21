require 'yousign_api/version'
require 'yousign_api/client/helpers'
require 'yousign_api/client/dsl'
require 'savon'
require 'digest/sha1'

module YousignApi
  class Client
    include Helpers
    include DSL

    wsdl "AuthenticationWS/AuthenticationWS?wsdl" do
      operation :connect, payload: false
    end

    wsdl "CosignWS/CosignWS?wsdl" do
      operation :init_cosign
      operation :get_cosigned_files_from_demand
      operation :get_infos_from_cosignature_demand
      operation :get_list_cosign
      operation :cancel_cosignature_demand
      operation :alert_cosigners
    end

    wsdl "ArchiveWS/ArchiveWS?wsdl" do
      operation :archive
      operation :get_archive
      operation :get_complete_archive
    end
  end
end
