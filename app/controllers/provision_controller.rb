require 'pp'

class ProvisionController < ApplicationController
  protect_from_forgery except: ['index']

  def index
    pp 'PROVISION REQUEST'
    p = params.require(:provision).permit!
    pp p
    pp '>>> AUTH', request.headers['Authorization']
    pp JsonWebToken.decode(request.headers['Authorization']);

#    p = params.require(:provision).permit(:uuid,  identity: [ :manufacturer, :model, :serial_number, :pin, ], ddcs: [ 'write-only': [], 'read-only': [], 'read-write': [] ])

    pp p[:identity]
    pp 'SERIAL ', p[:identity][:serial_number]
    pp 'DDCS ', p[:ddcs]
    pp p[:ddcs][:'write-only']

    args = { ip_address: request.remote_ip, status: :unanswered }.merge p
    if args["uuid"]
      puts "trying to find uuid #{args["uuid"]}"
      pr = ProvisionRequest.find args["uuid"]
    else
      puts "trying to find serial number #{args["serial_number"]} manufacturer #{args["manufacturer"]} model #{args["model"]}"
      pr = ProvisionRequest.find_by(serial_number: args["identity"]["serial_number"],
                                    manufacturer: args["manufacturer"]["manufacturer"],
                                    model: args["model"]["model"])
    end

    if pr
      if pr.accepted?
        password = pr.mosquitto_account.generate_password!

        devices = pr.devices.map { |device| device.slice(:id, :index) }
        devices.each { |device| device[:uuid] = device.delete(:id) }

        response = { uuid: pr.id,
                     status: 'provisioned',
                     mqtt_hostname: Socket.gethostname,
                     mqtt_port: 1883,
                     mqtt_username: pr.mosquitto_account.id,
                     mqtt_password: password,
                     devices: devices
                   }
      else
        response = { uuid: pr.id,
                     status: 'waiting',
                     retry_time: '60'
                   }
      end
    else
      pr = ProvisionRequest.create args
      pr.save

      if pr
        ma = pr.create_mosquitto_account(superuser: true, password: '')
        ma.generate_password!

        requested_devices.each do |device|
          dev = pr.devices.create device
        end
      end

      NotifyRequestMailer.with(provision_request: pr).new_provisioning_request.deliver_now

      response = { uuid: pr.id,
                   status: 'waiting',
                   retry_time: '60'
                 }
    end

    respond_to do |format|
      if pr
        pp response

        format.json { render json: response, status: :created }
      else
        format.json { render json: provision_request.errors, status: :unprocessable_entity }
      end
    end


  end

end
