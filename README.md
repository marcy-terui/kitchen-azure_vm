# <a name="title"></a> Kitchen::AzureVm

A Test Kitchen Driver for Azure Virtual Machine.

## <a name="requirements"></a> Requirements

- Test-Kitchen

## <a name="installation"></a> Installation and Setup

```sh
gem install kitchen-azure_vm
```

or put `Gemfile` in your project directory.

```ruby
source 'https://rubygems.org'

gem 'kitchen-azure_vm'
```

and

```sh
bundle
```

## <a name="config"></a> Configuration

At first, put your `.kithcen(.local).yml` like this.

```yml
---
driver:
  name: azure_vm
  management_certificate: /path/to/management_certificate.cer
  subscription_id: <%= ENV['AZURE_SUBSCRIPTION_ID'] %>
  private_key_file: /path/to/private.key
  certificate_file: /path/to/certificate.cer

platforms:
  - name: ubuntu-14.04
  - name: centos-6.6

suites:
  - name: default
    run_list:
    attributes:
```

### management_certificate

Path to the Management Certificate file.  
See also https://msdn.microsoft.com/en-us/library/azure/gg551722.aspx

Examples:

```yml
  management_certificate: /path/to/management_certificate.cer
```

### subscription_id

Your Azure Subscription ID.  

Examples:

```yml
  subscription_id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### private_key_file

Path to the SSH private key file.

Examples:

```yml
  private_key_file: /path/to/private.key
```

### private_key_file

Path to the x509 SSH certificate file.

Examples:

```yml
  certificate_file: /path/to/certificate.cer
```

### vm_user

Login user name on the VM.

The default value is `azureuser`.

Examples:

```yml
  vm_user: example-user
```

### location

Location(Region) of the VM.

The default value is `West US`.

Examples:

```yml
  location: Japan East
```

### ssh_port

Port number of SSH.

The default value is `22`.

Examples:

```yml
  ssh_port: 2222
```

### destroy_storage_account

Delete Storage Account when called `kitchen destroy`.

The default value is `true`.

Examples:

```yml
  destroy_storage_account: false
```

### vm_size

VM instance size.

The default value is `Small`.

Examples:

```yml
  vm_size: Large
```

### vm_image

VM boot image ID.

The default value get from public images by `platform.name`.

Examples:

```yml
  vm_size: Large
```

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## <a name="authors"></a> Authors

Created and maintained by [Masashi Terui][author] (<marcy9114@gmail.com>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])


[author]:           https://github.com/marcy-terui
[issues]:           https://github.com/marcy-terui/kitchen-azure_vm/issues
[license]:          https://github.com/marcy-terui/kitchen-azure_vm/blob/master/LICENSE
[repo]:             https://github.com/marcy-terui/kitchen-azure_vm
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.getchef.com/chef/install/
