# -*- encoding: utf-8 -*-
#
# Author:: Masashi Terui (<marcy9114@gmail.com>)
#
# Copyright (C) 2015, Masashi Terui
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'kitchen'
require 'azure'
require 'securerandom'
require 'kitchen/driver/azure_vm_image'

module Kitchen

  module Driver

    # Azure Virtual Machine driver for Kitchen.
    #
    # @author Masashi Terui <marcy9114@gmail.com>
    class AzureVm < Kitchen::Driver::SSHBase

      default_config :management_endpoint,     'https://management.core.windows.net'
      default_config :vm_user,                 'azureuser'
      default_config :location,                'West US'
      default_config :ssh_port,                22
      default_config :destroy_storage_account, true
      default_config :vm_size,                 'Small'
      default_config :vm_size,                 'Small'

      default_config :vm_image do |driver|
        driver.default_vm_image
      end

      def default_vm_image
        Kitchen::Driver::AzureVmImage.get(instance.platform.name)
      end

      required_config :management_certificate
      required_config :subscription_id
      required_config :private_key_file
      required_config :certificate_file

      def configure
        Azure.config.management_certificate = config[:management_certificate]
        Azure.config.subscription_id        = config[:subscription_id]
        Azure.config.management_endpoint    = config[:management_endpoint]
      end

      def vm_service
        configure
        Azure::VirtualMachineManagementService.new
      end

      def storage_account_service
        configure
        Azure::StorageManagementService.new
      end

      def params(state)
        {
          :vm_name  => state[:vm_name],
          :vm_user  => config[:username],
          :image    => config[:vm_image],
          :password => config[:password],
          :location => config[:location],
        }
      end

      def options(state)
        {
          :storage_account_name  => state[:storage_account_name],
          :winrm_transport       => config[:winrm_transport],
          :cloud_service_name    => config[:cloud_service_name],
          :deployment_name       => config[:deployment_name],
          :tcp_endpoints         => config[:tcp_endpoints],
          :private_key_file      => config[:private_key_file],
          :certificate_file      => config[:certificate_file],
          :ssh_port              => config[:ssh_port],
          :vm_size               => config[:vm_size],
          :affinity_group_name   => config[:affinity_group_name],
          :virtual_network_name  => config[:virtual_network_name],
          :subnet_name           => config[:subnet_name],
          :availability_set_name => config[:availability_set_name],
        }
      end

      def create(state)
        return if state[:vm_name]

        state[:vm_name] = gen_vm_name
        state[:storage_account_name] = "#{state[:vm_name]}storage"
        info("Creating VM <#{state[:vm_name]}>...")
        vm = vm_service.create_virtual_machine(params(state), options(state))
        info("VM <#{state[:vm_name]}> created!")
        state[:cloud_service_name] = vm.cloud_service_name
        state[:hostname] = vm.ipaddress
        wait_for_sshd(state[:hostname], config[:vm_user], {
          :ssh_timeout => config[:ssh_timeout],
          :ssh_retries => config[:ssh_retries],
          :port => config[:ssh_port],
        })
        info("VM <#{state[:vm_name]}> ready!")
      rescue Exception => e
        raise ActionFailed, e.message
      end

      def destroy(state)
        info("Deleting VM <#{state[:vm_name]}>...")
        vm = vm_service.delete_virtual_machine(state[:vm_name], state[:cloud_service_name])
        info("VM <#{state[:vm_name]}> deleted!")
        if config[:destroy_storage_account]
          delete_storage_account(state)
          info("Storage Account <#{state[:storage_account_name]}> deleted!")
        end
      rescue Exception => e
        raise ActionFailed, e.message
      end

      def gen_vm_name
        SecureRandom.hex(7)
      end

      def delete_storage_account(state)
        storage_account_service.delete_storage_account(state[:storage_account_name])
      end

      def build_ssh_args(state)
        combined = config.to_hash.merge(state)

        opts = Hash.new
        opts[:user_known_hosts_file] = "/dev/null"
        opts[:paranoid] = false
        opts[:keys_only] = true if combined[:ssh_key]
        opts[:password] = combined[:password] if combined[:password]
        opts[:forward_agent] = combined[:forward_agent] if combined.key? :forward_agent
        opts[:port] = combined[:port] if combined[:port]
        opts[:keys] = Array(combined[:private_key_file]) if combined[:private_key_file]
        opts[:logger] = logger

        [combined[:hostname], combined[:vm_user], opts]
      end

    end
  end
end
