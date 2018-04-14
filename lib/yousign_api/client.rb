require 'yousign_api/version'
require 'savon'
require 'digest/sha1'

module YousignApi
  class Client
    def config
      YousignApi
    end

    def endpoint
      {
        'demo' => 'https://apidemo.yousign.fr:8181/',
        'prod' => 'https://api.yousign.fr:8181/'
      }.fetch(config.environment.to_s) { raise "The Yousign environment was set to #{config.environment}, but it should be either 'demo' or 'prod'" }
    end

    def urlauth
      "#{endpoint}/AuthenticationWS/AuthenticationWS?wsdl"
    end

    def urlsign
      "#{endpoint}CosignWS/CosignWS?wsdl"
    end

    def urlarch
      "#{endpoint}ArchiveWS/ArchiveWS?wsdl"
    end

    def urliframe
      {
        'demo' => 'https://demo.yousign.fr/',
        'prod' => 'https://api.yousign.fr/'
      }.fetch(config.environment.to_s) { raise "The Yousign environment was set to '#{config.environment}', but it should be either 'demo' or 'prod'" }
    end

    def headers
      {username: config.username,
       password: password,
       apikey: config.apikey}
    end

    def clientauth
      @clientauth ||= Savon.client(wsdl: urlauth, soap_header: headers, ssl_verify_mode: :none)
    end

    def clientsign
      @clientsign ||= Savon.client(wsdl: urlsign, soap_header: headers, ssl_verify_mode: :none)
    end

    def clientarch
      @clientarch ||= Savon.client(wsdl: urlarch, soap_header: headers, ssl_verify_mode: :none)
    end

    def self.hashpassword(passw)
      Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(passw)+Digest::SHA1.hexdigest(passw))
    end

    def password
      @password ||= config.encrypt_password ? Client::hashpassword(config.password) : config.password
    end

    def initialize
      raise "Yousign was not configured, please use `Yousign.setup` before using Yousign API client" unless config.configured?
    end

    def connect
      clientauth.call(:connect)
    end

    def signature_init(payload)
      clientsign.call(:init_cosign, message: payload.to_payload)
    end

    def get_signed_files(idDemand, token='',idFile='')
      clientsign.call(:get_cosigned_files_from_demand, message:{ idDemand:idDemand,
                                                                 token:token,
                                                                 idFile:idFile})
    end

    def signature_details(idDemand, token='')
      clientsign.call(:get_infos_from_cosignature_demand, message:{ idDemand:idDemand,
                                                                    token:token})
    end

    def signature_list(payload)
      clientsign.call(:get_list_cosign, message: payload.to_payload)
    end

    def signature_cancel(idDemand, token='', idFile='')
      clientsign.call(:cancel_cosignature_demand, message:{ idDemand: idDemand,
                                                            token: token,
                                                            idFile: idFile})
    end

    def signature_alert(idDemand, mailSubject='', mail='', language='')
      clientsign.call(:alert_cosigners, message:{idDemand:idDemand,
                                                  mailSubject:mailSubject,
                                                  mail:mail,
                                                  language:language})
    end

    def archive(file)
      clientarch.call(:archive, message:{file:file})
    end

    def get_archive(iua)
      clientarch.call(:get_archive, message:{iua:iua})
    end

    def get_complete_archive(iua)
      clientarch.call(:get_complete_archive, message:{iua:iua})
    end
  end
end
