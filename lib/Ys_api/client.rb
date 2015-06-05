module YsApi
  require 'Ys_api/version'
  require 'savon'
  require 'inifile'
  require 'digest/sha1'


  class Client

    ENVIRONMENT = {'demo' => 'apidemo.yousign.fr:8181/','prod' => 'api.yousign.fr:8181/'}
    URL_IFRAME = {'demo' => 'https://demo.yousign.fr/','prod' => 'https://api.yousign.fr/'}

    def urlauth
      'https://'+@params[:environment]+'AuthenticationWS/AuthenticationWS?wsdl'
    end

    def urlsign
      'https://'+@params[:environment]+'CosignWS/CosignWS?wsdl'
    end

    def urlarch
      'https://'+@params[:environment]+'ArchiveWS/ArchiveWS?wsdl'
    end

    def environment
      @params[:environment]
    end
    def urliframe
      @params[:urliframe]
    end

    def headers
      createheaders(@params[:username], @params[:password], @params[:apikey])
    end

    def cliauth=(value)
      @clientauth=value
    end

    def clisign=(value)
      @clientsign=value
    end

    def cliarch=(value)
      @clientarch=value
    end

    def set_client
      @clientauth = Savon.client(:wsdl => self.urlauth,:soap_header => @headers,:ssl_verify_mode => :none)
      @clientsign = Savon.client(:wsdl => self.urlsign,:soap_header => @headers,:ssl_verify_mode => :none)
      @clientarch = Savon.client(:wsdl => self.urlarch,:soap_header => @headers,:ssl_verify_mode => :none)
    end

    def self.hashpassword(passw)
      begin
        Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(passw)+Digest::SHA1.hexdigest(passw))
      rescue TypeError
        puts 'Empty password'
      end
    end

    def createheaders (username, password, apikey)
      {:username => username,
      :password => password,
      :apikey => apikey}
    end

    def parseconf(configpath)
      myini = IniFile.load(configpath)

      @params[:username] = myini['client']['username']

      encrypt = myini['client']['isEncryptedPassword']
      @params[:password] =  encrypt  ?  myini['client']['password'] : Client::hashpassword(myini['client']['password'])

      @params[:apikey] = myini['client']['apikey']
      env_key = myini['client']['environment']
      @params[:environment]= ENVIRONMENT[env_key]
      @params[:urliframe] = URL_IFRAME[env_key]
    end

    def initialize(parameters = {})
      @params = {
        'conf' => nil,
        'username' => '',
        'password' => '',
        'apikey' => '',
        'environment' => 'demo'}

      # parameters.each{|k, v|
      #   k = k.to_s
      #   raise ArgumentError, "unknown property: #{k}" unless @params.key?(k)
      #   @params[k] = v
      # }

      if parameters[:conf] != nil && File.exist?(parameters[:conf])
        self.parseconf(parameters[:conf])
      else
        @params[:username] = parameters[:username]
        @params[:password]= parameters[:password]
        @params[:apikey]= parameters[:apikey]
        @params[:environment] = ENVIRONMENT[parameters[:environment]]
        @params[:urliframe] = URL_IFRAME[parameters[:environment]]
      end
      @headers = headers
      self.set_client
    end

    def connection
      @clientauth.call(:connect)
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

      @clientsign.call(:init_cosign, message:{lstCosignedFile:lstCosignedFile,
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

    def get_signed_files (idDemand, token='',idFile='')
      @clientsign.call(:get_cosigned_files_from_demand, message:{idDemand:idDemand,
                                                                 token:token,
                                                                 idFile:idFile})
    end

    def signature_details(idDemand, token='')
      @clientsign.call(:get_infos_from_cosignature_demand, message:{idDemand:idDemand,
                                                                    token:token})
    end

    def signature_list(search = '', firstResult ='', count = 1000, status ='', dateBegin='', dateEnd='')
      @clientsign.call(:get_list_cosign, message:{search:search,
                                                  firstResult:firstResult,
                                                  count:count,
                                                  status:status,
                                                  dateBegin:dateBegin,
                                                  dateEnd:dateEnd})
    end

    def signature_cancel(idDemand, token='', idFile='')
      @clientsign.call(:cancel_cosignature_demand, message:{idDemand:idDemand,
                                                            token:token,
                                                            idFile:idFile})
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
