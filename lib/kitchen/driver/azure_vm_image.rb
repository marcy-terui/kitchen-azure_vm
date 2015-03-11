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

module Kitchen
  
  module Driver

    # Azure Virtual Machine Image Helper.
    #
    # @author Masashi Terui <marcy9114@gmail.com>
    class AzureVmImage
      class << self
        @@list = {
          'centos-6.5' => '5112500ae3b842c8b9c604889f8753c3__OpenLogic-CentOS-65-20150128',
          'centos-6.6' => '5112500ae3b842c8b9c604889f8753c3__OpenLogic-CentOS-66-20150128',
          'centos-7.0' => '5112500ae3b842c8b9c604889f8753c3__OpenLogic-CentOS-70-20150128',
          'ubuntu-12.04' => 'b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-12_04_5-LTS-amd64-server-20150204-en-us-30GB',
          'ubuntu-12.10' => 'b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-12_04_2-LTS-amd64-server-20121218-en-us-30GB',
          'ubuntu-14.04' => 'b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_04_1-LTS-amd64-server-20150123-en-us-30GB',
          'ubuntu-14.10' => 'b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_10-amd64-server-20150202-en-us-30GB',
        }

        def get(platform)
          unless @@list.key?(platform)
            msg = "Image not found for #{platform}.\n[#{@@list.join(',')}] are available now."
            raise ActionFailed, msg
          end
          @@list[platform]
        end
      end
    end
  end
end
