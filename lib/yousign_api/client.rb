require 'yousign_api/version'
require 'savon'
require 'digest/sha1'

module YousignApi
  class Client
    attr_accessor :cliauth, :clisign, :cliarch

    def endpoint
      {
        'demo' => 'https://apidemo.yousign.fr:8181/',
        'prod' => 'https://api.yousign.fr:8181/'
      }.fetch(environment) { raise "The Yousign environment was set to #{environment}, but it should be either 'demo' or 'prod'" }
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
      }.fetch(environment) { raise "The Yousign environment was set to '#{environment}', but it should be either 'demo' or 'prod'" }
    end

    def headers
      {:username => username,
      :password => password,
      :apikey => apikey}
    end

    def clientauth
      @clientauth ||= Savon.client(:wsdl => self.urlauth,:soap_header => @headers,:ssl_verify_mode => :none)
    end

    def clientsign
      @clientsign ||= Savon.client(:wsdl => self.urlsign,:soap_header => @headers,:ssl_verify_mode => :none)
    end

    def clientarch
      @clientarch ||= Savon.client(:wsdl => self.urlarch,:soap_header => @headers,:ssl_verify_mode => :none)
    end

    def self.hashpassword(passw)
      Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(passw)+Digest::SHA1.hexdigest(passw))
    end

    def password
      @password ||= encrypt_password ? Client::hash_password(super) : super
    end

    def initialize
      raise "Yousign was not configured, please use `Yousign.setup` before using Yousign API client" unless configured?
    end

    def connection
      clientauth.call(:connect)
    end

    def signature_init (lstCosignedFile,
                        lstCosignerInfos,
                        message='',
                        title='',
                        initMailSubject=false,
                        initMail=false,
                        endMailSubject=false,
                        endMail=false,
                        language='FR',
                        mode='IFRAME',
                        archive=false)

      clientsign.call(:init_cosign, message:{ lstCosignedFile:lstCosignedFile,
                                              lstCosignerInfos:lstCosignerInfos,
                                              title:title,
                                              message:message,
                                              initMailSubject:initMailSubject,
                                              initMail:initMail,
                                              endMailSubject:endMailSubject,
                                              endMail:endMail,
                                              language:language,
                                              mode:mode,
                                              archive:archive})
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

    def signature_list(search = '', firstResult ='', count = 1000, status ='', dateBegin='', dateEnd='')
      clientsign.call(:get_list_cosign, message:{ search:search,
                                                  firstResult:firstResult,
                                                  count:count,
                                                  status:status,
                                                  dateBegin:dateBegin,
                                                  dateEnd:dateEnd})
    end

    def signature_cancel(idDemand, token='', idFile='')
      clientsign.call(:cancel_cosignature_demand, message:{ idDemand: idDemand,
                                                            token: token,
                                                            idFile: idFile})
    end

    def signature_alert(idDemand, mailSubject='', mail='', language='')
      @clientsign.call(:alert_cosigners, message:{idDemand:idDemand,
                                                  mailSubject:mailSubject,
                                                  mail:mail,
                                                  language:language})
    end

    def archive(file)
      @clientarch.call(:archive, message:{file:file})
    end

    def get_archive(iua)
      @clientarch.call(:get_archive, message:{iua:iua})
    end

    def get_complete_archive(iua)
      @clientarch.call(:get_complete_archive, message:{iua:iua})
    end
  end
end
